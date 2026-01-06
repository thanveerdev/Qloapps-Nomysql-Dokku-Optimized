# QloApps - No MySQL Docker Image for Dokku

Optimized QloApps Docker image designed for Dokku deployment without MySQL, SSH, or Supervisord. This is a lightweight, production-ready container that connects to external MySQL services via Dokku's MySQL plugin.

**🐳 Docker Hub**: Available on Docker Hub  
**📦 GitHub**: Available on GitHub

## 🚀 Features

- ✅ **Lightweight**: ~500-600MB (vs 1.36GB for webkul/qloapps_docker)
- ✅ **No MySQL**: Uses external Dokku MySQL plugin (best practice)
- ✅ **No SSH/Supervisord**: Minimal attack surface, better security
- ✅ **Production-ready**: PHP 8.1, OPcache enabled, optimized settings
- ✅ **All required files**: Includes all 22 files needed for installer
- ✅ **Dokku optimized**: Designed specifically for Dokku deployment
- ✅ **Auto-security**: Install folder automatically deleted after installation completes

## 📋 Requirements

- Dokku installed and configured
- Dokku MySQL plugin installed
- Git repository access
- Docker Hub account (optional, for image distribution)

## 🛠️ Installation on Dokku

### 1. Create the Dokku App

```bash
dokku apps:create qloapps
```

### 2. Create MySQL Service

```bash
# Create MySQL service
dokku mysql:create qloapps-db

# Link MySQL to your app
dokku mysql:link qloapps-db qloapps
```

This automatically sets the `DATABASE_URL` environment variable.

### 3. Configure Domain

```bash
dokku domains:set qloapps yourdomain.com
```

### 4. Set Environment Variables

```bash
dokku config:set qloapps \
  APP_ENV=prod \
  PS_DEV_MODE=0 \
  PS_HOST_MODE=0 \
  PS_INSTALL_AUTO=0 \
  KEEP_INSTALL_FOLDER=true
```

**Note:** Set `KEEP_INSTALL_FOLDER=true` to keep the install folder available during installation. It will be automatically removed after installation is complete.

### 5. Deploy the Application

#### Option A: Deploy from Git Repository

```bash
# Add Dokku remote
git remote add dokku dokku@your-server:qloapps

# Deploy
git push dokku master
```

#### Option B: Deploy from Docker Hub

```bash
# Pull and deploy the image
dokku git:from-image qloapps your-dockerhub-username/qloapps-nomysql-dokku-optimized:latest
```

### 6. Enable SSL (Let's Encrypt)

```bash
# Set email for Let's Encrypt
dokku letsencrypt:set qloapps email your-email@example.com

# Enable SSL
dokku letsencrypt:enable qloapps
```

### 7. Complete QloApps Installation

1. Visit `https://yourdomain.com/install/`
2. Follow the installation wizard through the steps:
   - Choose your language
   - Accept license agreements
   - System compatibility check (should pass all checks)
   - Website information
   - **System configuration** (Database setup - see below)
   - QloApps installation

#### Database Configuration in Installation Wizard

**✅ Automatic Detection (Recommended):**

The installer **automatically detects and pre-fills** database credentials from the `DATABASE_URL` environment variable that Dokku sets when you link a MySQL service. When you reach the "System configuration" step, the database form will be pre-filled with the correct values.

**Important:** All database fields are **fully editable**. You can modify any of the pre-filled values if you need to use different database credentials, a different database name, or customize the table prefix. The automatic detection is just a convenience feature to save time - you're not locked into using those values.

**Manual Configuration (if needed):**

If automatic detection doesn't work, you can manually fill the database configuration form:

| Field | Value | Notes |
|-------|-------|-------|
| **Database server address** | `dokku-mysql-APP-NAME-db` | Replace `APP-NAME` with your Dokku app name (e.g., `dokku-mysql-qloapps-db`) |
| **Database name** | `qloapps_db` | Or as configured in your MySQL service |
| **Database login** | `mysql` | Default user from Dokku MySQL plugin |
| **Database password** | `[from DATABASE_URL]` | Extract from `dokku config:show APP-NAME \| grep DATABASE_URL` |
| **Tables prefix** | `qlo_` | Default prefix (can be changed) |

**Quick Way to Get Database Credentials:**

```bash
# View all environment variables including DATABASE_URL
dokku config:show qloapps

# The DATABASE_URL format is:
# mysql://USER:PASSWORD@HOST:3306/DATABASE
```

**Example DATABASE_URL:**
```
mysql://mysql:YOUR_PASSWORD@dokku-mysql-qloapps-db:3306/qloapps_db
```

Breaking it down:
- **Host**: `dokku-mysql-qloapps-db` (use this in "Database server address")
- **Database**: `qloapps_db` (use this in "Database name")
- **User**: `mysql` (use this in "Database login")
- **Password**: Extract from your `DATABASE_URL` (use this in "Database password")

**How Automatic Detection Works:**

1. On container startup, `startup-security.sh` parses `DATABASE_URL` and creates a template `config/settings.inc.php` if it doesn't exist
2. The installer reads `settings.inc.php` and pre-fills the database form with those values
3. If `settings.inc.php` has default values (localhost, qloapps, root), the installer checks `DATABASE_URL` as a fallback
4. **You can edit any field** in the database configuration form before proceeding - the pre-filled values are just suggestions

**Note:** If you want to use completely different database settings, simply edit the form fields. The installer will use whatever values you enter, not the pre-filled ones.

## 🐳 Docker Hub Usage

### Pull the Image

```bash
docker pull your-dockerhub-username/qloapps-nomysql-dokku-optimized:latest
```

### Run Locally (for testing)

```bash
docker run -d -p 8080:80 \
  -e DATABASE_URL="mysql://user:password@host:3306/database" \
  your-dockerhub-username/qloapps-nomysql-dokku-optimized:latest
```

## 📦 What's Included

### PHP Extensions
- gd, intl, soap, zip, pdo_mysql, mysqli, mbstring, curl
- opcache, bcmath, exif, xsl, ldap, imagick

### Apache Modules
- rewrite, headers, expires

### PHP Configuration
- `upload_max_filesize = 200M`
- `post_max_size = 400M`
- `memory_limit = 512M`
- `max_execution_time = 500`
- `max_input_vars = 1500`
- OPcache enabled for performance

## 🔧 Maintenance

### Updating QloApps

1. **Update source code:**
   ```bash
   cd /path/to/qloapps-repo
   # Update QloApps files from official repository
   # Copy updated files to this directory
   git add .
   git commit -m "Update QloApps to version X.X.X"
   git push origin main
   ```

2. **Rebuild and deploy:**
   ```bash
   # On Dokku server
   cd /path/to/qloapps-repo
   git push dokku main
   ```

3. **Or rebuild from Docker Hub:**
   ```bash
   dokku ps:rebuild qloapps
   ```

### Updating Docker Image

1. **Build new image:**
   ```bash
   docker build -t your-dockerhub-username/qloapps-nomysql-dokku-optimized:latest .
   docker build -t your-dockerhub-username/qloapps-nomysql-dokku-optimized:v1.0.0 .
   ```

2. **Push to Docker Hub:**
   ```bash
   docker login
   docker push your-dockerhub-username/qloapps-nomysql-dokku-optimized:latest
   docker push your-dockerhub-username/qloapps-nomysql-dokku-optimized:v1.0.0
   ```

### Database Backups

```bash
# Backup MySQL database
dokku mysql:export qloapps-db > backup-$(date +%Y%m%d).sql

# Restore from backup
dokku mysql:import qloapps-db < backup-20260106.sql
```

### Viewing Logs

```bash
# Application logs
dokku logs qloapps

# MySQL logs
dokku mysql:logs qloapps-db
```

### Checking Status

```bash
# App status
dokku ps:report qloapps

# MySQL status
dokku mysql:info qloapps-db

# Environment variables
dokku config:show qloapps
```

## 🔍 Troubleshooting

### Database Connection Issues

```bash
# Verify DATABASE_URL is set
dokku config:show qloapps | grep DATABASE_URL

# Test MySQL connection
dokku mysql:connect qloapps-db

# Check MySQL service status
dokku mysql:info qloapps-db
```

### File Permission Issues

```bash
# Enter container
dokku enter qloapps

# Check permissions
ls -la /var/www/html/cache
ls -la /var/www/html/upload
ls -la /var/www/html/config

# Fix if needed (shouldn't be necessary)
chown -R www-data:www-data /var/www/html/cache /var/www/html/upload /var/www/html/config
chmod -R 775 /var/www/html/cache /var/www/html/upload /var/www/html/config
```

### Installer File Check Failing

The Dockerfile automatically creates all required files. If you see "Not all files were successfully uploaded":

1. Ensure `KEEP_INSTALL_FOLDER=true` is set: `dokku config:set qloapps KEEP_INSTALL_FOLDER=true`
2. Restart the app: `dokku ps:restart qloapps`
3. Clear browser cache (Ctrl+Shift+R)
4. Restart installer: `https://yourdomain.com/install/index.php?step=welcome`
5. Verify files exist:
   ```bash
   dokku enter qloapps web
   ls -la /var/www/html/cache/smarty/compile/index.php
   ls -la /var/www/html/upload/index.php
   ls -la /var/www/html/install/
   ```

### Install Folder Missing

If you see "install directory is missing" error:

1. **Set the environment variable:**
   ```bash
   dokku config:set qloapps KEEP_INSTALL_FOLDER=true
   ```

2. **Restart the app:**
   ```bash
   dokku ps:restart qloapps
   ```

3. **Access the installer:**
   Visit `https://yourdomain.com/install/`

**Note:** The install folder will be automatically removed after installation is complete. You don't need to manually remove it.

### Performance Issues

```bash
# Check OPcache status
dokku enter qloapps
php -i | grep opcache

# Check PHP memory usage
php -i | grep memory_limit

# Monitor resource usage
dokku ps:report qloapps
```

## 📊 Comparison with webkul/qloapps_docker

| Feature | This Image | webkul/qloapps_docker |
|---------|-----------|----------------------|
| Image Size | ~500-600MB | ~1.36GB |
| MySQL Included | ❌ No | ✅ Yes (unused) |
| SSH Included | ❌ No | ✅ Yes |
| Supervisord | ❌ No | ✅ Yes |
| Security | ✅ Better | ⚠️ More attack surface |
| Resource Usage | ✅ Lower | ⚠️ Higher |
| Best Practice | ✅ Yes | ⚠️ No |

## 🏗️ Building from Source

### Prerequisites

- Docker installed
- QloApps source code
- Basic knowledge of Docker

### Build Steps

```bash
# Clone this repository
git clone https://github.com/your-username/Qloapps-Nomysql-Dokku-Optimized.git
cd Qloapps-Nomysql-Dokku-Optimized

# Build the image
docker build -t qloapps-optimized:latest .

# Test locally
docker run -d -p 8080:80 \
  -e DATABASE_URL="mysql://user:pass@host:3306/db" \
  qloapps-optimized:latest
```

## 📝 File Structure

```
.
├── Dockerfile              # Main Dockerfile
├── .dockerignore          # Files to exclude from build
├── README.md              # This file
├── cache/                 # Cache directory (created at runtime)
├── config/                # Configuration files
├── install/               # Installer files
├── modules/               # QloApps modules
├── themes/                # Themes
└── ...                    # Other QloApps files
```

## 🔐 Security Notes

- No SSH server in container (use `dokku enter` instead)
- No MySQL in container (use external service)
- Production error handling (errors not displayed)
- Proper file permissions set
- OPcache enabled for performance
- **Automatic security hardening**: 
  - Admin folder is automatically renamed to `qlo-admin` on container startup (like WordPress's `wp-admin`)
  - Install folder is automatically removed after installation is complete
  - To use a custom admin folder name, set: `dokku config:set APP_NAME ADMIN_FOLDER_NAME=your-custom-name`

### Install Folder Auto-Deletion

The install folder is automatically deleted after installation is complete for security. The system uses a background cleanup daemon that monitors installation completion and deletes the folder automatically.

**How It Works:**
- A background daemon runs continuously and checks every 30 seconds if installation is complete
- The system detects installation completion by checking for database configuration in `config/settings.inc.php` (or `config/config.inc.php` as fallback)
- Once installation is detected as complete, the install folder is automatically removed within 30 seconds
- The daemon exits automatically after successful deletion

**During Installation:**
- To keep the install folder available during installation, set: `dokku config:set APP_NAME KEEP_INSTALL_FOLDER=true`
- The install folder will remain accessible until installation is complete
- The cleanup daemon will automatically start monitoring when `KEEP_INSTALL_FOLDER=true` is set

**After Installation:**
- Once installation is detected as complete, the install folder is automatically removed within 30 seconds (no restart needed)
- This happens automatically even if `KEEP_INSTALL_FOLDER=true` was set
- No manual intervention needed - the system handles it automatically
- You can monitor the cleanup process via logs: `dokku enter APP_NAME web cat /var/log/install-cleanup.log`

## 📚 Additional Resources

- [QloApps Documentation](https://qloapps.com/documentation/)
- [Dokku Documentation](https://dokku.com/docs/)
- [Dokku MySQL Plugin](https://github.com/dokku/dokku-mysql)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This Docker image is based on QloApps, which is licensed under OSL-3.0.

## ⚠️ Important Notes

- **Always backup your database** before deploying updates
- **Test in staging** before production deployment
- **Keep Dokku and plugins updated** for security
- **Monitor resource usage** especially with multiple instances
- **Use separate MySQL services** for each QloApps instance (best practice)

## 🆘 Support

For issues related to:
- **QloApps**: Visit [QloApps Forum](https://forums.qloapps.com/)
- **Dokku**: Visit [Dokku Documentation](https://dokku.com/docs/)
- **This Image**: Open an issue on GitHub

---

**Last Updated**: January 2026  
**QloApps Version**: 1.7.0.0  
**Docker Image**: Available on Docker Hub
