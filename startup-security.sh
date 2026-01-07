#!/bin/bash
# QloApps Security Startup Script
# This script runs on container startup to ensure security requirements are met

# Don't exit on error for permission fixes (they may fail if directories don't exist yet)
set -e

ADMIN_DIR="/var/www/html/admin"
# Use environment variable ADMIN_FOLDER_NAME or default to qlo-admin
ADMIN_FOLDER_NAME="${ADMIN_FOLDER_NAME:-qlo-admin}"
RENAMED_ADMIN_DIR="/var/www/html/${ADMIN_FOLDER_NAME}"
INSTALL_DIR="/var/www/html/install"

# Ensure required directories exist and have correct permissions
# This is especially important when persistent storage is mounted
# as it may have different ownership/permissions
echo "Ensuring required directories exist with correct permissions..."
mkdir -p /var/www/html/cache /var/www/html/log /var/www/html/upload \
    /var/www/html/img /var/www/html/cache/smarty/compile \
    /var/www/html/config

# Fix permissions for directories that need to be writable by www-data
# This handles cases where persistent storage is mounted with different permissions
chown -R www-data:www-data /var/www/html/cache \
    /var/www/html/log \
    /var/www/html/upload \
    /var/www/html/img \
    /var/www/html/config 2>/dev/null || true

chmod -R 775 /var/www/html/cache \
    /var/www/html/log \
    /var/www/html/upload \
    /var/www/html/img \
    /var/www/html/config 2>/dev/null || true

# Ensure index.php files exist in required directories (for installer file check)
if [ ! -f /var/www/html/cache/smarty/compile/index.php ]; then
    echo '<?php header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT"); header("Cache-Control: no-store, no-cache, must-revalidate"); header("Cache-Control: post-check=0, pre-check=0", false); header("Pragma: no-cache"); header("Location: ../"); exit;' > /var/www/html/cache/smarty/compile/index.php
    chown www-data:www-data /var/www/html/cache/smarty/compile/index.php
    chmod 644 /var/www/html/cache/smarty/compile/index.php
fi

if [ ! -f /var/www/html/upload/index.php ]; then
    echo '<?php header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT"); header("Cache-Control: no-store, no-cache, must-revalidate"); header("Cache-Control: post-check=0, pre-check=0", false); header("Pragma: no-cache"); header("Location: ../"); exit;' > /var/www/html/upload/index.php
    chown www-data:www-data /var/www/html/upload/index.php
    chmod 644 /var/www/html/upload/index.php
fi

# Rename admin folder if it exists and renamed folder doesn't exist
if [ -d "$ADMIN_DIR" ] && [ ! -d "$RENAMED_ADMIN_DIR" ]; then
    echo "Renaming admin folder to ${ADMIN_FOLDER_NAME} for security..."
    mv "$ADMIN_DIR" "$RENAMED_ADMIN_DIR"
    echo "Admin folder renamed to: ${ADMIN_FOLDER_NAME}"
    echo "Access admin panel at: /${ADMIN_FOLDER_NAME}/"
fi

# Check if installation is complete by looking for database configuration
# QloApps stores database config in settings.inc.php, not config.inc.php
SETTINGS_FILE="/var/www/html/config/settings.inc.php"
CONFIG_FILE="/var/www/html/config/config.inc.php"
INSTALLATION_COMPLETE=false

# Function to create settings.inc.php from DATABASE_URL (recovery mechanism)
create_settings_from_database_url() {
    if [ -z "$DATABASE_URL" ]; then
        return 1
    fi
    
    echo "Recovery: Creating settings.inc.php from DATABASE_URL..."
    
    # Parse DATABASE_URL format: mysql://user:password@host:port/database
    DB_URL="${DATABASE_URL#mysql://}"
    
    # Extract user:password@host:port/database
    if [[ "$DB_URL" =~ ^([^:]+):([^@]+)@([^/]+)/(.+)$ ]]; then
        DB_USER="${BASH_REMATCH[1]}"
        DB_PASSWORD="${BASH_REMATCH[2]}"
        DB_HOST_PORT="${BASH_REMATCH[3]}"
        DB_NAME="${BASH_REMATCH[4]}"
        
        # Extract host and port
        if [[ "$DB_HOST_PORT" =~ ^([^:]+):(.+)$ ]]; then
            DB_HOST="${BASH_REMATCH[1]}"
            DB_PORT="${BASH_REMATCH[2]}"
        else
            DB_HOST="$DB_HOST_PORT"
            DB_PORT="3306"
        fi
        
        # Generate cookie keys (simple random strings - installer will regenerate proper ones)
        COOKIE_KEY=$(openssl rand -hex 28 2>/dev/null || head -c 56 /dev/urandom | base64 | tr -d '\n' | head -c 56)
        COOKIE_IV=$(openssl rand -hex 4 2>/dev/null || head -c 8 /dev/urandom | base64 | tr -d '\n' | head -c 8)
        NEW_COOKIE_KEY=$(openssl rand -hex 32 2>/dev/null || head -c 64 /dev/urandom | base64 | tr -d '\n' | head -c 64)
        
        # Create settings.inc.php
        cat > "$SETTINGS_FILE" << EOF
<?php
define('_DB_SERVER_', '${DB_HOST}');
define('_DB_NAME_', '${DB_NAME}');
define('_DB_USER_', '${DB_USER}');
define('_DB_PASSWD_', '${DB_PASSWORD}');
define('_DB_PREFIX_', 'qlo_');
define('_MYSQL_ENGINE_', 'InnoDB');
define('_PS_CACHING_SYSTEM_', 'CacheMemcache');
define('_PS_CACHE_ENABLED_', '0');
define('_COOKIE_KEY_', '${COOKIE_KEY}');
define('_COOKIE_IV_', '${COOKIE_IV}');
define('_NEW_COOKIE_KEY_', 'def00000${NEW_COOKIE_KEY}');
define('_PS_CREATION_DATE_', '$(date +%Y-%m-%d)');
if (!defined('_PS_VERSION_'))
	define('_PS_VERSION_', '1.6.1.23');
define('_QLOAPPS_VERSION_', '1.7.0.0');
EOF
        
        # Set proper permissions
        chown www-data:www-data "$SETTINGS_FILE"
        chmod 644 "$SETTINGS_FILE"
        
        echo "Settings file recreated from DATABASE_URL"
        return 0
    else
        echo "Warning: Could not parse DATABASE_URL format. Expected: mysql://user:password@host:port/database"
        return 1
    fi
}

# Function to check if installation is truly complete (not just started)
# Installation is complete when:
# 1. Database tables exist (qlo_shop, qlo_configuration)
# 2. Configuration values are set (PS_INSTALL_VERSION)
# 3. Modules are installed (qlo_module table has entries)
check_database_tables() {
    local DB_HOST DB_NAME DB_USER DB_PASSWORD DB_PREFIX
    
    # Try to get database credentials from settings.inc.php first
    if [ -f "$SETTINGS_FILE" ]; then
        DB_HOST=$(grep "_DB_SERVER_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_NAME=$(grep "_DB_NAME_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_USER=$(grep "_DB_USER_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_PASSWORD=$(grep "_DB_PASSWD_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_PREFIX=$(grep "_DB_PREFIX_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
    fi
    
    # Fallback: Try to get credentials from DATABASE_URL if settings.inc.php is missing
    if [ -z "$DB_HOST" ] && [ -n "$DATABASE_URL" ]; then
        DB_URL="${DATABASE_URL#mysql://}"
        if [[ "$DB_URL" =~ ^([^:]+):([^@]+)@([^/]+)/(.+)$ ]]; then
            DB_USER="${BASH_REMATCH[1]}"
            DB_PASSWORD="${BASH_REMATCH[2]}"
            DB_HOST_PORT="${BASH_REMATCH[3]}"
            DB_NAME="${BASH_REMATCH[4]}"
            
            if [[ "$DB_HOST_PORT" =~ ^([^:]+):(.+)$ ]]; then
                DB_HOST="${BASH_REMATCH[1]}"
            else
                DB_HOST="$DB_HOST_PORT"
            fi
            # Default prefix if not found
            DB_PREFIX="${DB_PREFIX:-qlo_}"
        fi
    fi
    
    # If we have credentials, check multiple indicators of FULL installation completion
    if [ -n "$DB_HOST" ] && [ -n "$DB_NAME" ] && [ -n "$DB_USER" ]; then
        # Use PHP to check multiple conditions (more reliable in container)
        php -r "
        try {
            \$pdo = new PDO('mysql:host=${DB_HOST};dbname=${DB_NAME}', '${DB_USER}', '${DB_PASSWORD}');
            
            // Check 1: Shop table exists (early indicator)
            \$stmt = \$pdo->query('SHOW TABLES LIKE \"${DB_PREFIX}shop\"');
            \$has_shop = \$stmt->rowCount() > 0;
            
            // Check 2: Configuration table exists and has PS_INSTALL_VERSION (mid indicator)
            \$stmt = \$pdo->query('SHOW TABLES LIKE \"${DB_PREFIX}configuration\"');
            \$has_config = \$stmt->rowCount() > 0;
            \$has_install_version = false;
            if (\$has_config) {
                \$stmt = \$pdo->query('SELECT COUNT(*) as cnt FROM ${DB_PREFIX}configuration WHERE name = \"PS_INSTALL_VERSION\" AND value IS NOT NULL AND value != \"\"');
                \$row = \$stmt->fetch(PDO::FETCH_ASSOC);
                \$has_install_version = (\$row && \$row['cnt'] > 0);
            }
            
            // Check 3: Module table exists and has entries (late indicator - modules installed)
            \$stmt = \$pdo->query('SHOW TABLES LIKE \"${DB_PREFIX}module\"');
            \$has_module_table = \$stmt->rowCount() > 0;
            \$has_modules = false;
            if (\$has_module_table) {
                \$stmt = \$pdo->query('SELECT COUNT(*) as cnt FROM ${DB_PREFIX}module');
                \$row = \$stmt->fetch(PDO::FETCH_ASSOC);
                \$has_modules = (\$row && \$row['cnt'] > 0);
            }
            
            // Installation is complete only if ALL indicators are true
            // This ensures we don't delete install folder during installation
            if (\$has_shop && \$has_config && \$has_install_version && \$has_module_table && \$has_modules) {
                exit(0); // Installation complete
            }
            exit(1); // Installation not complete
        } catch (Exception \$e) {
            exit(1);
        }
        " 2>/dev/null && return 0
    fi
    return 1
}

# Check if installation is actually complete by verifying database tables exist
# Note: Installer reads DATABASE_URL directly from environment variables for pre-filling
# No template file is needed - the installer handles this automatically
if check_database_tables; then
    INSTALLATION_COMPLETE=true
    echo "Installation verified complete: Database tables found"
    
    # Recovery: If settings.inc.php is missing but installation is complete,
    # recreate it from DATABASE_URL to prevent "install directory is missing" errors
    if [ ! -f "$SETTINGS_FILE" ] && [ -n "$DATABASE_URL" ]; then
        echo "Recovery: settings.inc.php is missing but installation is complete."
        echo "Recreating settings.inc.php from DATABASE_URL to restore functionality..."
        create_settings_from_database_url
    fi
else
    INSTALLATION_COMPLETE=false
    echo "Installation not complete: Database tables not found or not accessible"
fi

# Delete install folder logic:
# CRITICAL: Only delete install folder if settings.inc.php exists AND installation is complete
# This prevents the "install directory is missing" error when settings.inc.php is missing on restart
# 1. Always delete if installation is complete AND settings.inc.php exists (regardless of KEEP_INSTALL_FOLDER)
# 2. Delete if KEEP_INSTALL_FOLDER is not set to true AND settings.inc.php exists
# 3. Keep install folder if settings.inc.php is missing (needed for installer to run)
# 4. Keep if KEEP_INSTALL_FOLDER=true AND installation is not complete
if [ -d "$INSTALL_DIR" ]; then
    # Safety check: Don't delete install folder if settings.inc.php is missing
    # This prevents the error where app tries to redirect to /install/ but folder is gone
    if [ ! -f "$SETTINGS_FILE" ]; then
        echo "Warning: settings.inc.php is missing. Keeping install folder to allow installation/recovery."
        echo "If installation was already complete, settings.inc.php should be recreated from DATABASE_URL on next restart."
    elif [ "$INSTALLATION_COMPLETE" = true ]; then
        echo "Installation detected as complete. Removing install folder for security..."
        rm -rf "$INSTALL_DIR"
        echo "Install folder removed successfully"
    elif [ "${KEEP_INSTALL_FOLDER:-false}" != "true" ]; then
        # Only delete if settings.inc.php exists (safety check)
        if [ -f "$SETTINGS_FILE" ]; then
            echo "Removing install folder for security (KEEP_INSTALL_FOLDER not set to true)..."
            rm -rf "$INSTALL_DIR"
            echo "Install folder removed successfully"
        else
            echo "Keeping install folder (settings.inc.php missing, needed for installer)"
        fi
    else
        echo "Keeping install folder (KEEP_INSTALL_FOLDER=true is set and installation not complete)"
    fi
fi

# Start background cleanup daemon to automatically delete install folder after installation
# This runs in the background and checks periodically if installation is complete
if [ -d "$INSTALL_DIR" ] && [ "${KEEP_INSTALL_FOLDER:-false}" = "true" ]; then
    echo "Starting install cleanup daemon to monitor installation completion..."
    /usr/local/bin/cleanup-install-daemon.sh &
    CLEANUP_PID=$!
    echo "Cleanup daemon started (PID: $CLEANUP_PID)"
fi

# Start Apache (original command)
exec apache2-foreground
