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

# Check if installation is complete by looking for config/config.inc.php
CONFIG_FILE="/var/www/html/config/config.inc.php"
INSTALLATION_COMPLETE=false

if [ -f "$CONFIG_FILE" ]; then
    # Check if config file has database connection (installation completed)
    if grep -q "_DB_SERVER_\|define.*DB_SERVER" "$CONFIG_FILE" 2>/dev/null; then
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

# Start Apache (original command)
exec apache2-foreground

