# Optimized QloApps Dockerfile for Dokku
# Removes unnecessary components (MySQL, SSH, Supervisord)
# Connects to external MySQL via Dokku MySQL plugin

FROM php:8.1-apache

# Set environment variables
ENV APACHE_DOCUMENT_ROOT=/var/www/html \
    COMPOSER_ALLOW_SUPERUSER=1 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies and PHP extensions required by QloApps
RUN apt-get update && apt-get install -y --no-install-recommends \
    # System dependencies
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libicu-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libldap2-dev \
    libxslt-dev \
    libmagickwand-dev \
    unzip \
    git \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j"$(nproc)" \
    gd \
    intl \
    soap \
    zip \
    pdo_mysql \
    mysqli \
    mbstring \
    curl \
    opcache \
    bcmath \
    exif \
    xsl \
    ldap

# Install ImageMagick extension
RUN pecl install imagick && docker-php-ext-enable imagick

# Enable Apache modules
RUN a2enmod rewrite headers expires

# Configure PHP for QloApps (production settings)
RUN { \
    echo "upload_max_filesize = 200M"; \
    echo "post_max_size = 400M"; \
    echo "memory_limit = 512M"; \
    echo "max_execution_time = 500"; \
    echo "max_input_vars = 1500"; \
    echo "date.timezone = UTC"; \
    echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT"; \
    echo "display_errors = Off"; \
    echo "log_errors = On"; \
    echo "error_log = /var/log/apache2/php_errors.log"; \
    } > /usr/local/etc/php/conf.d/qloapps.ini

# Configure OPcache for better performance
RUN { \
    echo "opcache.enable=1"; \
    echo "opcache.memory_consumption=128"; \
    echo "opcache.interned_strings_buffer=8"; \
    echo "opcache.max_accelerated_files=10000"; \
    echo "opcache.revalidate_freq=2"; \
    echo "opcache.fast_shutdown=1"; \
    } > /usr/local/etc/php/conf.d/opcache.ini

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html

# Install PHP dependencies if composer.json exists
# Note: QloApps composer.json only checks extensions, not packages
# Skip if it fails (PHP version requirement is outdated)
RUN if [ -f composer.json ]; then \
    composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction || true; \
    fi

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Make cache, log, upload, img, and config directories writable
# Ensure cache/smarty/compile directory exists and create required index.php files
RUN mkdir -p /var/www/html/cache /var/www/html/log /var/www/html/upload \
    /var/www/html/img /var/www/html/cache/smarty/compile \
    /var/log \
    && chown -R www-data:www-data /var/www/html/cache \
    /var/www/html/log \
    /var/www/html/upload \
    /var/www/html/img \
    /var/www/html/config \
    && chmod -R 775 /var/www/html/cache \
    /var/www/html/log \
    /var/www/html/upload \
    /var/www/html/img \
    /var/www/html/config \
    && touch /var/log/install-cleanup.log \
    && chown www-data:www-data /var/log/install-cleanup.log \
    && chmod 644 /var/log/install-cleanup.log

# Create missing index.php files required by installer (AFTER all COPY operations)
# These files must exist for the installer's file integrity check
RUN mkdir -p /var/www/html/cache/smarty/compile /var/www/html/upload \
    && echo '<?php header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT"); header("Cache-Control: no-store, no-cache, must-revalidate"); header("Cache-Control: post-check=0, pre-check=0", false); header("Pragma: no-cache"); header("Location: ../"); exit;' > /var/www/html/cache/smarty/compile/index.php \
    && echo '<?php header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT"); header("Cache-Control: no-store, no-cache, must-revalidate"); header("Cache-Control: post-check=0, pre-check=0", false); header("Pragma: no-cache"); header("Location: ../"); exit;' > /var/www/html/upload/index.php \
    && chown www-data:www-data /var/www/html/cache/smarty/compile/index.php /var/www/html/upload/index.php \
    && chmod 644 /var/www/html/cache/smarty/compile/index.php /var/www/html/upload/index.php \
    && chmod 755 /var/www/html/cache/smarty/compile

# Configure Apache virtual host
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy startup security script
COPY startup-security.sh /usr/local/bin/startup-security.sh
RUN chmod +x /usr/local/bin/startup-security.sh

# Copy cleanup daemon script
COPY cleanup-install-daemon.sh /usr/local/bin/cleanup-install-daemon.sh
RUN chmod +x /usr/local/bin/cleanup-install-daemon.sh

# Copy generate-env script
COPY generate-env.sh /usr/local/bin/generate-env.sh
RUN chmod +x /usr/local/bin/generate-env.sh

# Backup essential files to a location that won't be mounted
# This allows us to restore them when persistent storage is empty
# CRITICAL: config/ directory must be backed up as it contains config.inc.php
RUN mkdir -p /usr/local/qloapps-backup/config \
    && mkdir -p /usr/local/qloapps-backup/img \
    && mkdir -p /usr/local/qloapps-backup/upload \
    && mkdir -p /usr/local/qloapps-backup/cache \
    && mkdir -p /usr/local/qloapps-backup/log \
    && if [ -d /var/www/html/config ] && [ -n "$(ls -A /var/www/html/config 2>/dev/null)" ]; then \
        cp -a /var/www/html/config/* /usr/local/qloapps-backup/config/; \
    fi \
    && if [ -d /var/www/html/img ] && [ -n "$(ls -A /var/www/html/img 2>/dev/null)" ]; then \
        cp -a /var/www/html/img/* /usr/local/qloapps-backup/img/; \
    fi \
    && if [ -d /var/www/html/upload ] && [ -n "$(ls -A /var/www/html/upload 2>/dev/null)" ]; then \
        cp -a /var/www/html/upload/* /usr/local/qloapps-backup/upload/; \
    fi \
    && if [ -d /var/www/html/cache ] && [ -n "$(ls -A /var/www/html/cache 2>/dev/null)" ]; then \
        cp -a /var/www/html/cache/* /usr/local/qloapps-backup/cache/; \
    fi \
    && if [ -d /var/www/html/log ] && [ -n "$(ls -A /var/www/html/log 2>/dev/null)" ]; then \
        cp -a /var/www/html/log/* /usr/local/qloapps-backup/log/; \
    fi \
    && chown -R www-data:www-data /usr/local/qloapps-backup \
    && chmod -R 755 /usr/local/qloapps-backup

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start with security script (renames admin folder and removes install folder)
CMD ["/usr/local/bin/startup-security.sh"]

