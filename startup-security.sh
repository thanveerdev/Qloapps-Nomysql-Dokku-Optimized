#!/bin/bash
# QloApps Security Startup Script
# This script runs on container startup to ensure security requirements are met

set -e

ADMIN_DIR="/var/www/html/admin"
# Use environment variable ADMIN_FOLDER_NAME or default to qlo-admin
ADMIN_FOLDER_NAME="${ADMIN_FOLDER_NAME:-qlo-admin}"
RENAMED_ADMIN_DIR="/var/www/html/${ADMIN_FOLDER_NAME}"
INSTALL_DIR="/var/www/html/install"

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

# Parse DATABASE_URL from environment and create settings.inc.php template if needed
# This allows the installer to auto-detect database credentials from Dokku
if [ -n "$DATABASE_URL" ] && [ ! -f "$SETTINGS_FILE" ]; then
    echo "DATABASE_URL detected. Parsing and creating settings.inc.php template..."
    
    # Parse DATABASE_URL format: mysql://user:password@host:port/database
    # Remove mysql:// prefix
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
        
        # Generate cookie keys (simple random strings for template)
        COOKIE_KEY=$(openssl rand -hex 28 2>/dev/null || head -c 56 /dev/urandom | base64 | tr -d '\n' | head -c 56)
        COOKIE_IV=$(openssl rand -hex 4 2>/dev/null || head -c 8 /dev/urandom | base64 | tr -d '\n' | head -c 8)
        NEW_COOKIE_KEY=$(openssl rand -hex 32 2>/dev/null || head -c 64 /dev/urandom | base64 | tr -d '\n' | head -c 64)
        
        # Create settings.inc.php template
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
        
        echo "Settings file created from DATABASE_URL:"
        echo "  Host: ${DB_HOST}"
        echo "  Database: ${DB_NAME}"
        echo "  User: ${DB_USER}"
        echo "  Port: ${DB_PORT}"
    else
        echo "Warning: Could not parse DATABASE_URL format. Expected: mysql://user:password@host:port/database"
    fi
fi

# Check settings.inc.php first (where QloApps stores DB config)
if [ -f "$SETTINGS_FILE" ]; then
    # Check if settings file has database connection (installation completed)
    if grep -q "_DB_SERVER_\|define.*DB_SERVER" "$SETTINGS_FILE" 2>/dev/null; then
        INSTALLATION_COMPLETE=true
    fi
fi

# Fallback: check config.inc.php (for other PrestaShop-based apps or if settings.inc.php doesn't exist)
if [ "$INSTALLATION_COMPLETE" = false ] && [ -f "$CONFIG_FILE" ]; then
    # Check if config file has database connection (installation completed)
    if grep -q "_DB_SERVER_\|define.*DB_SERVER" "$CONFIG_FILE" 2>/dev/null; then
        INSTALLATION_COMPLETE=true
    fi
fi

# Additional check: if install folder doesn't have index.php or installer files, installation likely completed
# This is a fallback for cases where config files might not have the expected format
if [ "$INSTALLATION_COMPLETE" = false ] && [ -d "$INSTALL_DIR" ]; then
    # If install folder exists but has no installer files, assume installation completed
    if [ ! -f "$INSTALL_DIR/index.php" ] || [ ! -d "$INSTALL_DIR/controllers" ]; then
        INSTALLATION_COMPLETE=true
    fi
fi

# Delete install folder logic:
# 1. Always delete if installation is complete (regardless of KEEP_INSTALL_FOLDER)
# 2. Delete if KEEP_INSTALL_FOLDER is not set to true
# 3. Keep only if KEEP_INSTALL_FOLDER=true AND installation is not complete
if [ -d "$INSTALL_DIR" ]; then
    if [ "$INSTALLATION_COMPLETE" = true ]; then
        echo "Installation detected as complete. Removing install folder for security..."
        rm -rf "$INSTALL_DIR"
        echo "Install folder removed successfully"
    elif [ "${KEEP_INSTALL_FOLDER:-false}" != "true" ]; then
        echo "Removing install folder for security..."
        rm -rf "$INSTALL_DIR"
        echo "Install folder removed successfully"
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

