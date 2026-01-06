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

# Delete install folder if it exists (unless KEEP_INSTALL_FOLDER is set)
if [ -d "$INSTALL_DIR" ] && [ "${KEEP_INSTALL_FOLDER:-false}" != "true" ]; then
    echo "Removing install folder for security..."
    rm -rf "$INSTALL_DIR"
    echo "Install folder removed successfully"
elif [ -d "$INSTALL_DIR" ] && [ "${KEEP_INSTALL_FOLDER}" == "true" ]; then
    echo "Keeping install folder (KEEP_INSTALL_FOLDER=true is set)"
fi

# Start Apache (original command)
exec apache2-foreground

