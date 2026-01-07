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

# Function to check if a directory is on persistent storage (mounted volume)
# This checks if the directory is a mount point or on a different filesystem
is_persistent_storage() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        return 1
    fi
    
    # Check if directory is a mount point
    if mountpoint -q "$dir" 2>/dev/null; then
        return 0
    fi
    
    # Check if parent directory is a mount point (for subdirectories)
    local parent_dir=$(dirname "$dir")
    if mountpoint -q "$parent_dir" 2>/dev/null; then
        return 0
    fi
    
    # Check if /var/www/html is a mount point (entire app directory)
    if mountpoint -q "/var/www/html" 2>/dev/null; then
        return 0
    fi
    
    return 1
}

# Validate persistent storage configuration
# CRITICAL: Persistent storage is required for production deployments
echo "Validating persistent storage configuration..."
PERSISTENT_STORAGE_WARNINGS=0

# Check critical directories that MUST be persisted
CRITICAL_DIRS=(
    "/var/www/html/config:CRITICAL - settings.inc.php will be lost without this"
    "/var/www/html/img:CRITICAL - uploaded images will be lost without this"
    "/var/www/html/upload:CRITICAL - uploaded files will be lost without this"
)

for dir_info in "${CRITICAL_DIRS[@]}"; do
    IFS=':' read -r dir message <<< "$dir_info"
    if ! is_persistent_storage "$dir"; then
        echo "⚠️  WARNING: $dir is NOT on persistent storage"
        echo "   $message"
        PERSISTENT_STORAGE_WARNINGS=$((PERSISTENT_STORAGE_WARNINGS + 1))
    fi
done

# Check admin folder persistence (important for security rename)
if [ -d "$RENAMED_ADMIN_DIR" ]; then
    if ! is_persistent_storage "$RENAMED_ADMIN_DIR"; then
        echo "⚠️  WARNING: Admin folder ($RENAMED_ADMIN_DIR) is NOT on persistent storage"
        echo "   Admin folder rename will be lost on container restart"
        echo "   Recommendation: Mount persistent storage for admin folder or entire /var/www/html"
        PERSISTENT_STORAGE_WARNINGS=$((PERSISTENT_STORAGE_WARNINGS + 1))
    fi
fi

if [ $PERSISTENT_STORAGE_WARNINGS -gt 0 ]; then
    echo ""
    echo "❌ PERSISTENT STORAGE NOT PROPERLY CONFIGURED!"
    echo "   This deployment is NOT production-ready."
    echo ""
    echo "   To fix, run these commands:"
    echo ""
    echo "   Option 1: Mount individual directories (recommended):"
    echo "   dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/config:/var/www/html/config"
    echo "   dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/img:/var/www/html/img"
    echo "   dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/upload:/var/www/html/upload"
    echo "   dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/cache:/var/www/html/cache"
    echo "   dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/log:/var/www/html/log"
    echo ""
    echo "   Option 2: Mount entire /var/www/html (simpler, ensures admin folder persists):"
    echo "   dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/html:/var/www/html"
    echo ""
    echo "   Or use the automated deploy.sh script which sets this up automatically."
    echo ""
else
    echo "✅ Persistent storage validation passed - all critical directories are persisted"
fi
echo ""

# Handle empty persistent storage on first mount
# When persistent storage is mounted for the first time, directories are empty
# We need to initialize them with files from the image
echo "Checking for empty persistent storage directories..."

# Function to initialize empty persistent storage directory
# This copies files from image backup to persistent storage if directory is empty
initialize_persistent_dir() {
    local target_dir="$1"
    local backup_dir="/usr/local/qloapps-backup/$2"
    
    # Only initialize if directory is mounted and empty
    if mountpoint -q "$target_dir" 2>/dev/null; then
        # Check if directory is empty (only . and ..)
        if [ -d "$target_dir" ] && [ -z "$(ls -A "$target_dir" 2>/dev/null)" ]; then
            echo "Initializing empty persistent storage: $target_dir"
            # Copy from backup location if it exists
            if [ -d "$backup_dir" ] && [ -n "$(ls -A "$backup_dir" 2>/dev/null)" ]; then
                cp -a "$backup_dir"/* "$target_dir"/ 2>/dev/null || true
                # Ensure proper permissions
                chown -R www-data:www-data "$target_dir" 2>/dev/null || true
                chmod -R 755 "$target_dir" 2>/dev/null || true
                echo "   ✓ Copied files to $target_dir"
            else
                echo "   ⚠️  Warning: Backup directory $backup_dir is empty or missing"
            fi
        fi
    fi
}

# Backup location for essential files (created during Docker build)
# These files are copied to /usr/local/qloapps-backup/ during image build
# so they're available even when persistent storage is mounted and empty
BACKUP_BASE="/usr/local/qloapps-backup"

# Initialize persistent storage directories if empty
# Note: This handles the case where persistent storage is mounted but empty
initialize_persistent_dir "/var/www/html/config" "config"
initialize_persistent_dir "/var/www/html/img" "img"
initialize_persistent_dir "/var/www/html/upload" "upload"
initialize_persistent_dir "/var/www/html/cache" "cache"
initialize_persistent_dir "/var/www/html/log" "log"

# Check if entire /var/www/html is mounted and empty (critical case)
# This is the most common cause of HTTP 500 errors
if mountpoint -q "/var/www/html" 2>/dev/null; then
    if [ ! -f "/var/www/html/index.php" ]; then
        echo ""
        echo "❌ CRITICAL ERROR: /var/www/html is mounted but EMPTY!"
        echo "   This will cause HTTP 500 errors because all application files are missing."
        echo ""
        echo "   SOLUTION:"
        echo "   1. Unmount the empty storage:"
        echo "      dokku storage:unmount APP_NAME /var/www/html"
        echo ""
        echo "   2. Copy files from a running container to storage:"
        echo "      # Start container without mount first"
        echo "      # Copy files: docker cp CONTAINER_ID:/var/www/html /var/lib/dokku/data/storage/APP_NAME/"
        echo ""
        echo "   3. Remount:"
        echo "      dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/html:/var/www/html"
        echo ""
        echo "   OR use individual directory mounts (recommended):"
        echo "      dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/config:/var/www/html/config"
        echo "      dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/img:/var/www/html/img"
        echo "      dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/upload:/var/www/html/upload"
        echo "      dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/cache:/var/www/html/cache"
        echo "      dokku storage:mount APP_NAME /var/lib/dokku/data/storage/APP_NAME/log:/var/www/html/log"
        echo ""
        echo "   Individual mounts are safer - they only persist data, not application files."
        echo ""
        echo "   ⚠️  Container will continue but application will not work until fixed."
        echo ""
    fi
fi

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

# Function to create index.php security file in a directory
create_index_php() {
    local dir="$1"
    local file="${dir}/index.php"
    if [ ! -f "$file" ]; then
        mkdir -p "$dir"
        echo '<?php header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT"); header("Cache-Control: no-store, no-cache, must-revalidate"); header("Cache-Control: post-check=0, pre-check=0", false); header("Pragma: no-cache"); header("Location: ../"); exit;' > "$file"
        chown www-data:www-data "$file" 2>/dev/null || true
        chmod 644 "$file"
    fi
}

# Ensure index.php files exist in required directories (for installer file check)
# These directories are checked by the installer's ConfigurationTest::test_files()
echo "Ensuring required index.php security files exist..."
create_index_php "/var/www/html/cache/smarty/compile"
create_index_php "/var/www/html/upload"
create_index_php "/var/www/html/classes/log"
create_index_php "/var/www/html/classes/cache"
create_index_php "/var/www/html/config"
create_index_php "/var/www/html/css"
create_index_php "/var/www/html/download"
create_index_php "/var/www/html/mails"
create_index_php "/var/www/html/modules"
create_index_php "/var/www/html/override/controllers/front"
create_index_php "/var/www/html/translations/export"

# Rename admin folder if it exists and renamed folder doesn't exist
# This handles both fresh containers and restarts:
# - Fresh container: /admin exists from image, /qlo-admin doesn't exist → rename
# - Restart with persistent storage: /qlo-admin exists, /admin doesn't exist → no action needed
# - Restart without persistent storage: /admin recreated from image, /qlo-admin doesn't exist → rename again
if [ -d "$ADMIN_DIR" ] && [ ! -d "$RENAMED_ADMIN_DIR" ]; then
    echo "Renaming admin folder to ${ADMIN_FOLDER_NAME} for security..."
    mv "$ADMIN_DIR" "$RENAMED_ADMIN_DIR"
    echo "Admin folder renamed to: ${ADMIN_FOLDER_NAME}"
    echo "Access admin panel at: /${ADMIN_FOLDER_NAME}/"
elif [ -d "$RENAMED_ADMIN_DIR" ]; then
    # Renamed folder already exists (from previous run or persistent storage)
    echo "Admin folder already renamed to: ${ADMIN_FOLDER_NAME}"
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
# Installation is complete when ALL of the following are true:
# 1. Database tables exist (qlo_shop, qlo_configuration, qlo_module, qlo_employee)
# 2. Configuration values are set (PS_INSTALL_VERSION)
# 3. Modules are installed (qlo_module table has entries)
# 4. Shop is configured (shop table has active shops)
# 5. Admin user is created (employee table has active users)
# This ensures ALL installation steps are finished before deleting install folder
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
            
            // Check 4: Shop has actual data (not just table exists) - ensures shop is configured
            \$has_shop_data = false;
            if (\$has_shop) {
                \$stmt = \$pdo->query('SELECT COUNT(*) as cnt FROM ${DB_PREFIX}shop WHERE active = 1');
                \$row = \$stmt->fetch(PDO::FETCH_ASSOC);
                \$has_shop_data = (\$row && \$row['cnt'] > 0);
            }
            
            // Check 5: Employee/admin user exists - ensures admin account is created
            \$has_employee = false;
            \$stmt = \$pdo->query('SHOW TABLES LIKE \"${DB_PREFIX}employee\"');
            if (\$stmt->rowCount() > 0) {
                \$stmt = \$pdo->query('SELECT COUNT(*) as cnt FROM ${DB_PREFIX}employee WHERE active = 1');
                \$row = \$stmt->fetch(PDO::FETCH_ASSOC);
                \$has_employee = (\$row && \$row['cnt'] > 0);
            }
            
            // Installation is complete only if ALL indicators are true
            // This ensures we don't delete install folder during installation
            // All steps must be finished: tables created, config set, modules installed, shop configured, admin created
            if (\$has_shop && \$has_shop_data && \$has_config && \$has_install_version && \$has_module_table && \$has_modules && \$has_employee) {
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
        echo "Installation detected as complete (all steps finished). Removing install folder for security..."
        rm -rf "$INSTALL_DIR"
        echo "Install folder removed successfully"
        
        # Automatically set KEEP_INSTALL_FOLDER=false for future restarts
        # This ensures install folder won't be kept on next restart
        # Note: This writes to a file that can be sourced, but Dokku env vars need to be set via dokku config
        # For now, we'll create a marker file that indicates installation is complete
        INSTALL_COMPLETE_MARKER="/var/www/html/.installation_complete"
        touch "$INSTALL_COMPLETE_MARKER"
        chown www-data:www-data "$INSTALL_COMPLETE_MARKER" 2>/dev/null || true
        chmod 644 "$INSTALL_COMPLETE_MARKER"
        echo "Installation completion marker created. Set KEEP_INSTALL_FOLDER=false for future restarts."
    elif [ "${KEEP_INSTALL_FOLDER:-false}" != "true" ]; then
        # Only delete if settings.inc.php exists (safety check)
        if [ -f "$SETTINGS_FILE" ]; then
            # Check if installation completion marker exists (from previous successful completion)
            INSTALL_COMPLETE_MARKER="/var/www/html/.installation_complete"
            if [ -f "$INSTALL_COMPLETE_MARKER" ]; then
                echo "Installation was previously completed. Removing install folder for security..."
                rm -rf "$INSTALL_DIR"
                echo "Install folder removed successfully"
            else
                echo "Keeping install folder (installation may still be in progress, no completion marker found)"
            fi
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
