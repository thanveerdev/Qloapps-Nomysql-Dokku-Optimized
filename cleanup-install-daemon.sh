#!/bin/bash
# Background daemon to automatically delete install folder after installation completes
# This runs continuously and checks every 30 seconds if installation is complete

INSTALL_DIR="/var/www/html/install"
SETTINGS_FILE="/var/www/html/config/settings.inc.php"
CONFIG_FILE="/var/www/html/config/config.inc.php"
CHECK_INTERVAL=30  # Check every 30 seconds
LOG_FILE="/var/log/install-cleanup.log"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

check_installation_complete() {
    local INSTALLATION_COMPLETE=false
    local DB_HOST DB_NAME DB_USER DB_PASSWORD DB_PREFIX
    
    # Check if database has QloApps tables (actual installation completion)
    if [ -f "$SETTINGS_FILE" ]; then
        DB_HOST=$(grep "_DB_SERVER_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_NAME=$(grep "_DB_NAME_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_USER=$(grep "_DB_USER_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_PASSWORD=$(grep "_DB_PASSWD_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        DB_PREFIX=$(grep "_DB_PREFIX_" "$SETTINGS_FILE" | sed "s/.*'\(.*\)'.*/\1/" | head -1)
        
        # Check multiple indicators of FULL installation completion
        # This ensures we don't delete install folder during installation process
        if [ -n "$DB_HOST" ] && [ -n "$DB_NAME" ] && [ -n "$DB_USER" ]; then
            # Use PHP to check multiple conditions (more reliable in container)
            if php -r "
            require '$SETTINGS_FILE';
            try {
                \$pdo = new PDO('mysql:host='._DB_SERVER_.';dbname='._DB_NAME_, _DB_USER_, _DB_PASSWD_);
                
                // Check 1: Shop table exists (early indicator)
                \$stmt = \$pdo->query('SHOW TABLES LIKE \''._DB_PREFIX_.'shop\'');
                \$has_shop = \$stmt->rowCount() > 0;
                
                // Check 2: Configuration table exists and has PS_INSTALL_VERSION (mid indicator)
                \$stmt = \$pdo->query('SHOW TABLES LIKE \''._DB_PREFIX_.'configuration\'');
                \$has_config = \$stmt->rowCount() > 0;
                \$has_install_version = false;
                if (\$has_config) {
                    \$stmt = \$pdo->query('SELECT COUNT(*) as cnt FROM '._DB_PREFIX_.'configuration WHERE name = \"PS_INSTALL_VERSION\" AND value IS NOT NULL AND value != \"\"');
                    \$row = \$stmt->fetch(PDO::FETCH_ASSOC);
                    \$has_install_version = (\$row && \$row['cnt'] > 0);
                }
                
                // Check 3: Module table exists and has entries (late indicator - modules installed)
                \$stmt = \$pdo->query('SHOW TABLES LIKE \''._DB_PREFIX_.'module\'');
                \$has_module_table = \$stmt->rowCount() > 0;
                \$has_modules = false;
                if (\$has_module_table) {
                    \$stmt = \$pdo->query('SELECT COUNT(*) as cnt FROM '._DB_PREFIX_.'module');
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
            " 2>/dev/null; then
                INSTALLATION_COMPLETE=true
            fi
        fi
    fi
    
    # Fallback: if install folder doesn't exist, assume installation completed
    if [ "$INSTALLATION_COMPLETE" = false ] && [ ! -d "$INSTALL_DIR" ]; then
        INSTALLATION_COMPLETE=true
    fi
    
    echo "$INSTALLATION_COMPLETE"
}

# Main loop
log_message "Install cleanup daemon started"

while true; do
    if [ -d "$INSTALL_DIR" ]; then
        if [ "$(check_installation_complete)" = "true" ]; then
            log_message "Installation detected as complete. Removing install folder..."
            rm -rf "$INSTALL_DIR"
            if [ ! -d "$INSTALL_DIR" ]; then
                log_message "Install folder removed successfully"
                # Exit daemon after successful deletion
                log_message "Cleanup daemon exiting (task complete)"
                exit 0
            else
                log_message "ERROR: Failed to remove install folder"
            fi
        else
            # Installation not complete yet, keep checking
            log_message "Installation not complete yet, will check again in ${CHECK_INTERVAL}s"
        fi
    else
        # Install folder doesn't exist, exit daemon
        log_message "Install folder not found, cleanup daemon exiting"
        exit 0
    fi
    
    sleep "$CHECK_INTERVAL"
done

