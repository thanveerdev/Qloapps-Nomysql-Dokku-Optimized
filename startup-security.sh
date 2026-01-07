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
    
    # If no credentials from settings.inc.php, try to parse from DATABASE_URL
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
            DB_PREFIX="qlo_"
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

# Check if installation is actually complete by verifying database tables exist
# This is more reliable than just checking if settings.inc.php exists
# (since we create settings.inc.php from DATABASE_URL before installation)
if check_database_tables; then
    INSTALLATION_COMPLETE=true
    echo "Installation verified complete: Database tables found"
else
    # Don't use fallback check - settings.inc.php can exist from DATABASE_URL
    # before installation starts, so we must verify database tables exist
    INSTALLATION_COMPLETE=false
    echo "Installation not complete: Database tables not found or not accessible"
    
    # If settings.inc.php exists but tables don't, delete it so installer can run
    # This prevents the app from trying to use a database that isn't set up yet
    if [ -f "$SETTINGS_FILE" ]; then
        echo "Removing settings.inc.php to allow installer to run (database not yet installed)..."
        rm -f "$SETTINGS_FILE"
        echo "Settings file removed - installer will create it during installation"
    fi
fi

# Delete install folder logic:
# 1. Always delete if installation is complete (regardless of KEEP_INSTALL_FOLDER)
# 2. Keep install folder by default if installation is not complete (safer for new installations)
# 3. Delete only if KEEP_INSTALL_FOLDER is explicitly set to false AND installation is not complete
if [ -d "$INSTALL_DIR" ]; then
    if [ "$INSTALLATION_COMPLETE" = true ]; then
        echo "Installation detected as complete. Removing install folder for security..."
        rm -rf "$INSTALL_DIR"
        echo "Install folder removed successfully"
    elif [ "${KEEP_INSTALL_FOLDER:-true}" = "false" ]; then
        echo "Removing install folder for security (KEEP_INSTALL_FOLDER=false)..."
        rm -rf "$INSTALL_DIR"
        echo "Install folder removed successfully"
    else
        echo "Keeping install folder (installation not complete - set KEEP_INSTALL_FOLDER=false to remove)"
    fi
fi

# Start background cleanup daemon to automatically delete install folder after installation
# This runs in the background and checks periodically if installation is complete
# Only start if install folder exists and KEEP_INSTALL_FOLDER is not explicitly false
if [ -d "$INSTALL_DIR" ] && [ "${KEEP_INSTALL_FOLDER:-true}" != "false" ]; then
    echo "Starting install cleanup daemon to monitor installation completion..."
    /usr/local/bin/cleanup-install-daemon.sh &
    CLEANUP_PID=$!
    echo "Cleanup daemon started (PID: $CLEANUP_PID)"
fi

# Start Apache (original command)
exec apache2-foreground

