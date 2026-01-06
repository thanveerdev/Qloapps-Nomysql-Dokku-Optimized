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
    
    # Check settings.inc.php first (where QloApps stores DB config)
    if [ -f "$SETTINGS_FILE" ]; then
        if grep -q "_DB_SERVER_\|define.*DB_SERVER" "$SETTINGS_FILE" 2>/dev/null; then
            INSTALLATION_COMPLETE=true
        fi
    fi
    
    # Fallback: check config.inc.php
    if [ "$INSTALLATION_COMPLETE" = false ] && [ -f "$CONFIG_FILE" ]; then
        if grep -q "_DB_SERVER_\|define.*DB_SERVER" "$CONFIG_FILE" 2>/dev/null; then
            INSTALLATION_COMPLETE=true
        fi
    fi
    
    # Additional check: verify install folder has installer files
    if [ "$INSTALLATION_COMPLETE" = false ] && [ -d "$INSTALL_DIR" ]; then
        # If install folder exists but has no installer files, assume installation completed
        if [ ! -f "$INSTALL_DIR/index.php" ] || [ ! -d "$INSTALL_DIR/controllers" ]; then
            INSTALLATION_COMPLETE=true
        fi
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

