#!/bin/bash
# Automated Deployment Script for QloApps on Dokku
# This script automates MySQL service creation, linking, and persistent storage setup

set -e

APP_NAME="${1:-qloapps-pro9}"
DB_SERVICE_NAME="${APP_NAME}-db"
DOMAIN="${2:-}"

echo "=========================================="
echo "QloApps Automated Deployment Script"
echo "=========================================="
echo "App Name: $APP_NAME"
echo "Database Service: $DB_SERVICE_NAME"
echo "Domain: ${DOMAIN:-Not set}"
echo "=========================================="
echo ""

# Step 1: Check if Dokku is available
if ! command -v dokku &> /dev/null; then
    echo "❌ Error: Dokku is not installed or not in PATH"
    exit 1
fi

# Step 2: Create Dokku app if it doesn't exist
echo "📦 Step 1: Creating Dokku app..."
if dokku apps:exists "$APP_NAME" &> /dev/null; then
    echo "   ✓ App '$APP_NAME' already exists"
else
    dokku apps:create "$APP_NAME"
    echo "   ✓ App '$APP_NAME' created"
fi

# Step 3: Create MySQL service if it doesn't exist
echo ""
echo "🗄️  Step 2: Setting up MySQL service..."
if dokku mysql:list | grep -q "^${DB_SERVICE_NAME}$"; then
    echo "   ✓ MySQL service '$DB_SERVICE_NAME' already exists"
else
    echo "   Creating MySQL service '$DB_SERVICE_NAME'..."
    dokku mysql:create "$DB_SERVICE_NAME"
    echo "   ✓ MySQL service '$DB_SERVICE_NAME' created"
fi

# Step 4: Link MySQL service to app
echo ""
echo "🔗 Step 3: Linking MySQL service to app..."
if dokku config:show "$APP_NAME" | grep -q "DATABASE_URL"; then
    echo "   ✓ MySQL service already linked"
else
    dokku mysql:link "$DB_SERVICE_NAME" "$APP_NAME"
    echo "   ✓ MySQL service linked to app"
fi

# Get database credentials
DB_INFO=$(dokku mysql:info "$DB_SERVICE_NAME" 2>/dev/null | grep "Dsn:" | sed 's/.*Dsn:[[:space:]]*//')
echo "   Database DSN: $DB_INFO"

# Step 5: Set up persistent storage
echo ""
echo "💾 Step 4: Setting up persistent storage..."

# Create storage directories
STORAGE_BASE="/var/lib/dokku/data/storage/$APP_NAME"
mkdir -p "$STORAGE_BASE"/{img,upload,cache,log,config}

# Set proper permissions (Dokku uses UID 32767)
chown -R 32767:32767 "$STORAGE_BASE" 2>/dev/null || chown -R www-data:www-data "$STORAGE_BASE" 2>/dev/null || true

echo "   ✓ Storage directories created at: $STORAGE_BASE"

# Mount persistent storage
echo ""
echo "   Mounting persistent storage volumes..."

# Check if storage is already mounted
CURRENT_MOUNTS=$(dokku storage:report "$APP_NAME" 2>/dev/null | grep "Storage run mounts:" | sed 's/.*Storage run mounts:[[:space:]]*//')

if echo "$CURRENT_MOUNTS" | grep -q "img"; then
    echo "   ✓ img directory already mounted"
else
    dokku storage:mount "$APP_NAME" "$STORAGE_BASE/img:/var/www/html/img"
    echo "   ✓ img directory mounted"
fi

if echo "$CURRENT_MOUNTS" | grep -q "upload"; then
    echo "   ✓ upload directory already mounted"
else
    dokku storage:mount "$APP_NAME" "$STORAGE_BASE/upload:/var/www/html/upload"
    echo "   ✓ upload directory mounted"
fi

if echo "$CURRENT_MOUNTS" | grep -q "cache"; then
    echo "   ✓ cache directory already mounted"
else
    dokku storage:mount "$APP_NAME" "$STORAGE_BASE/cache:/var/www/html/cache"
    echo "   ✓ cache directory mounted"
fi

if echo "$CURRENT_MOUNTS" | grep -q "log"; then
    echo "   ✓ log directory already mounted"
else
    dokku storage:mount "$APP_NAME" "$STORAGE_BASE/log:/var/www/html/log"
    echo "   ✓ log directory mounted"
fi

if echo "$CURRENT_MOUNTS" | grep -q "config"; then
    echo "   ✓ config directory already mounted"
else
    dokku storage:mount "$APP_NAME" "$STORAGE_BASE/config:/var/www/html/config"
    echo "   ✓ config directory mounted"
fi

# IMPORTANT: Individual directory mounts are safe because:
# - They only persist data directories (config, img, upload, cache, log)
# - Application files (index.php, classes/, controllers/, etc.) remain in the image
# - This prevents HTTP 500 errors from empty mounts
# 
# If you need to mount entire /var/www/html, you MUST copy files first:
# 1. Deploy app without mount
# 2. Copy files: docker cp $(dokku enter $APP_NAME web echo $HOSTNAME | xargs docker ps -q -f name=):/var/www/html $STORAGE_BASE/html
# 3. Then mount: dokku storage:mount $APP_NAME $STORAGE_BASE/html:/var/www/html

# Step 6: Configure domain if provided
if [ -n "$DOMAIN" ]; then
    echo ""
    echo "🌐 Step 5: Configuring domain..."
    dokku domains:set "$APP_NAME" "$DOMAIN"
    echo "   ✓ Domain '$DOMAIN' configured"
fi

# Step 7: Display summary
echo ""
echo "=========================================="
echo "✅ Deployment Setup Complete!"
echo "=========================================="
echo ""
echo "App Information:"
echo "  App Name: $APP_NAME"
echo "  Database Service: $DB_SERVICE_NAME"
echo "  Database DSN: $DB_INFO"
if [ -n "$DOMAIN" ]; then
    echo "  Domain: $DOMAIN"
fi
echo ""
echo "Storage Locations:"
echo "  Base: $STORAGE_BASE"
echo "  - Images: $STORAGE_BASE/img"
echo "  - Uploads: $STORAGE_BASE/upload"
echo "  - Cache: $STORAGE_BASE/cache"
echo "  - Logs: $STORAGE_BASE/log"
echo "  - Config: $STORAGE_BASE/config"
echo ""
echo "Next Steps:"
echo "  1. Deploy your application:"
echo "     cd /path/to/qloapps-pro9-repo"
echo "     git push dokku main"
echo ""
echo "  2. Complete the QloApps installation wizard at:"
if [ -n "$DOMAIN" ]; then
    echo "     http://$DOMAIN/install/"
else
    echo "     http://$(dokku domains:report $APP_NAME | grep 'Domains app vhosts' | awk '{print $4}')/install/"
fi
echo ""
echo "  3. Database credentials are automatically configured via DATABASE_URL"
echo "     The installer will auto-detect and pre-fill the database form"
echo ""

