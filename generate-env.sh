#!/bin/bash
# Generate default .env file for QloApps database credentials
# This script creates a .env file with database settings that can be used by the installer

set -e

ENV_FILE="/var/www/html/.env"
SETTINGS_FILE="/var/www/html/config/settings.inc.php"

# Function to parse DATABASE_URL
parse_database_url() {
    local DB_URL="${DATABASE_URL#mysql://}"
    
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
        
        return 0
    fi
    return 1
}

# Try to get credentials from DATABASE_URL
if [ -n "$DATABASE_URL" ] && parse_database_url; then
    echo "Parsing DATABASE_URL to create .env file..."
else
    # Use default values if DATABASE_URL is not available
    echo "DATABASE_URL not found, using default values..."
    DB_HOST="${DB_HOST:-localhost}"
    DB_PORT="${DB_PORT:-3306}"
    DB_NAME="${DB_NAME:-qloapps_db}"
    DB_USER="${DB_USER:-root}"
    DB_PASSWORD="${DB_PASSWORD:-}"
fi

# Default database prefix
DB_PREFIX="${DB_PREFIX:-qlo_}"

# Create .env file with database credentials
cat > "$ENV_FILE" << EOF
# QloApps Database Configuration
# This file contains database credentials for the QloApps installer
# Generated automatically from DATABASE_URL or default values

DB_SERVER=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWD=${DB_PASSWORD}
DB_PREFIX=${DB_PREFIX}
MYSQL_ENGINE=InnoDB

# Additional QloApps settings
PS_CACHING_SYSTEM=CacheMemcache
PS_CACHE_ENABLED=0
EOF

# Set proper permissions
chown www-data:www-data "$ENV_FILE"
chmod 644 "$ENV_FILE"

echo ".env file created at: $ENV_FILE"
echo "  Host: ${DB_HOST}"
echo "  Port: ${DB_PORT}"
echo "  Database: ${DB_NAME}"
echo "  User: ${DB_USER}"
echo "  Prefix: ${DB_PREFIX}"

