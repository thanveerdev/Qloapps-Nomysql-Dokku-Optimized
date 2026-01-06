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

# Make cache, log, upload, and config directories writable
# Ensure cache/smarty/compile directory exists and create required index.php files
RUN mkdir -p /var/www/html/cache /var/www/html/log /var/www/html/upload \
    /var/www/html/cache/smarty/compile \
    && chown -R www-data:www-data /var/www/html/cache \
    /var/www/html/log \
    /var/www/html/upload \
    /var/www/html/config \
    && chmod -R 775 /var/www/html/cache \
    /var/www/html/log \
    /var/www/html/upload \
    /var/www/html/config

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

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start Apache in foreground
CMD ["apache2-foreground"]

