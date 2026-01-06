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

