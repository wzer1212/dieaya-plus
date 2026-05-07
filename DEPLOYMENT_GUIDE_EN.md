# Flutter Web Deployment Guide - Two Apps on Same Domain

## Project Overview

This project contains two Flutter Web applications hosted on the same domain:

1. **User App (dieaya_user)** - Main consumer application
   - Route: `/app`
   - Location: `/www/wwwroot/dieaya-plus`

2. **Business App (dieaya_market)** - Merchant/business application
   - Route: `/businessapp`
   - Location: `/www/wwwroot/dieaya-plus/businessapp`

---

## Prerequisites

- Flutter SDK (3.5.3 or higher)
- Git
- Nginx web server
- Write access to `/www/wwwroot/dieaya-plus`

---

## Building Apps Locally

### Option 1: Automated Build Script

#### Windows
```bash
cd C:\Projects\dieaya-plus
build_apps.bat
```

#### Linux/Mac
```bash
cd ~/Projects/dieaya-plus
chmod +x build_apps.sh
./build_apps.sh
```

### Option 2: Manual Build

#### Build User App
```bash
cd C:\Projects\dieaya-plus
flutter clean
flutter pub get
flutter build web --release --base-href /app/
```

**Output:** `build/web/*`

#### Build Business App
```bash
cd C:\Projects\dieaya-plus\businessapp
flutter clean
flutter pub get
flutter build web --release --base-href /businessapp/
```

**Output:** `businessapp/build/web/*`

---

## Verification Checklist

Before deployment, verify:

- ✅ `build/web/index.html` contains `<base href="/app/">`
- ✅ `businessapp/build/web/index.html` contains `<base href="/businessapp/">`
- ✅ `build/web/main.dart.js` exists
- ✅ `businessapp/build/web/main.dart.js` exists
- ✅ Assets folder exists in both builds
- ✅ No TypeScript/compilation errors

---

## Pushing to GitHub

```bash
# Stage all changes
git add .

# Commit with descriptive message
git commit -m "Build both Flutter Web apps with correct base-href"

# Push to main branch
git push origin main
```

---

## Server Deployment Steps

### Step 1: Pull Latest Changes
```bash
cd /www/wwwroot/dieaya-plus
git pull origin main
```

### Step 2: Copy User App Files
```bash
# Create app directory if it doesn't exist
mkdir -p /www/wwwroot/dieaya-plus/app

# Copy all build files to app directory
cp -r /www/wwwroot/dieaya-plus/build/web/* /www/wwwroot/dieaya-plus/app/
```

### Step 3: Copy Business App Files
```bash
# Create businessapp directory if it doesn't exist
mkdir -p /www/wwwroot/dieaya-plus/businessapp

# Copy all build files to businessapp directory
cp -r /www/wwwroot/dieaya-plus/businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/
```

### Step 4: Verify File Structure
```bash
# Check User App
ls -la /www/wwwroot/dieaya-plus/app/index.html
ls -la /www/wwwroot/dieaya-plus/app/main.dart.js

# Check Business App
ls -la /www/wwwroot/dieaya-plus/businessapp/index.html
ls -la /www/wwwroot/dieaya-plus/businessapp/main.dart.js
```

### Step 5: Update Nginx Configuration

Copy the provided `nginx.conf` to one of these locations:

#### Option A: Using sites-available (Debian/Ubuntu)
```bash
sudo cp nginx.conf /etc/nginx/sites-available/site.tcore.site
sudo ln -sf /etc/nginx/sites-available/site.tcore.site /etc/nginx/sites-enabled/
```

#### Option B: Using conf.d (Other Linux distributions)
```bash
sudo cp nginx.conf /etc/nginx/conf.d/site.tcore.site.conf
```

### Step 6: Test Nginx Configuration
```bash
sudo nginx -t
```

Expected output:
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### Step 7: Reload Nginx
```bash
sudo systemctl reload nginx
# or
sudo service nginx reload
```

---

## Accessing the Applications

After deployment:

- **User App:** https://site.tcore.site/app
- **Business App:** https://site.tcore.site/businessapp
- **Business Button:** Click "دعاية بلس أعمال" in User App to navigate to Business App

---

## Troubleshooting

### 1. White Screen on Load

**Symptoms:** Page loads but shows blank/white screen

**Causes:**
- Incorrect base-href in index.html
- Files not copied to correct directory
- main.dart.js failed to load

**Solutions:**
```bash
# Verify base-href
grep '<base href=' /www/wwwroot/dieaya-plus/app/index.html
grep '<base href=' /www/wwwroot/dieaya-plus/businessapp/index.html

# Check if main.dart.js exists
ls -lh /www/wwwroot/dieaya-plus/app/main.dart.js
ls -lh /www/wwwroot/dieaya-plus/businessapp/main.dart.js

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log
```

### 2. 404 Errors for Static Files

**Symptoms:** Console shows 404 errors for images, fonts, CSS

**Causes:**
- Assets not copied to correct directory
- Incorrect asset path in code

**Solutions:**
```bash
# Verify assets exist
ls -la /www/wwwroot/dieaya-plus/app/assets/
ls -la /www/wwwroot/dieaya-plus/businessapp/assets/

# Re-copy files
cp -r /www/wwwroot/dieaya-plus/build/web/* /www/wwwroot/dieaya-plus/app/
cp -r /www/wwwroot/dieaya-plus/businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/
```

### 3. 500 Errors

**Symptoms:** HTTP 500 errors in browser/logs

**Causes:**
- Nginx configuration syntax error
- Permission issues
- Missing files

**Solutions:**
```bash
# Check Nginx syntax
sudo nginx -t

# Check file permissions
sudo chown -R www-data:www-data /www/wwwroot/dieaya-plus
sudo chmod -R 755 /www/wwwroot/dieaya-plus

# Check Nginx error log
sudo tail -50 /var/log/nginx/error.log
```

### 4. Service Worker Issues

**Symptoms:** Offline functionality not working

**Causes:**
- Service worker not loaded correctly
- Browser cache issues

**Solutions:**
```bash
# Clear browser cache (Ctrl+Shift+Delete or Cmd+Shift+Delete)
# or use Nginx to force cache bypass
curl -I -H "Cache-Control: no-cache" https://site.tcore.site/app/service_worker.js
```

### 5. Font Issues

**Symptoms:** Text displays with wrong font

**Causes:**
- Font files not loaded from correct path
- CSS @font-face path incorrect

**Solutions:**
```bash
# Verify font files
ls -la /www/wwwroot/dieaya-plus/app/assets/fonts/
ls -la /www/wwwroot/dieaya-plus/businessapp/assets/fonts/

# Check if they're being served
curl -I https://site.tcore.site/app/assets/fonts/your-font.woff2
```

---

## Performance Optimization

### Enable Compression
Already configured in Nginx - serves gzip-compressed files

### Cache Strategy

Static files are cached based on type:
- `main.dart.js`: No cache (Flutter updates this frequently)
- Images: 30 days
- Fonts/CSS: 1 year (safe with hash in filename)
- index.html: No cache (always fetch latest)

### Check Cache Headers
```bash
# Check User App cache headers
curl -I https://site.tcore.site/app/main.dart.js | grep -i cache
curl -I https://site.tcore.site/app/index.html | grep -i cache

# Check Business App cache headers
curl -I https://site.tcore.site/businessapp/main.dart.js | grep -i cache
```

---

## SSL/HTTPS Setup

If not already configured, set up SSL with Let's Encrypt:

```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --nginx -d site.tcore.site

# Update Nginx config - uncomment SSL sections in nginx.conf
# Then restart Nginx
sudo systemctl restart nginx
```

---

## Monitoring & Logging

### Check Access Logs
```bash
# Real-time logs
sudo tail -f /var/log/nginx/site.tcore.site_access.log

# Last 50 requests
sudo tail -50 /var/log/nginx/site.tcore.site_access.log
```

### Check Error Logs
```bash
# Real-time errors
sudo tail -f /var/log/nginx/site.tcore.site_error.log

# Last 50 errors
sudo tail -50 /var/log/nginx/site.tcore.site_error.log
```

### Monitor Disk Usage
```bash
# Check size of deployed apps
du -sh /www/wwwroot/dieaya-plus/app/
du -sh /www/wwwroot/dieaya-plus/businessapp/

# Check available disk space
df -h /www/wwwroot/
```

---

## Maintenance Tasks

### Weekly
```bash
# Check Nginx status
sudo systemctl status nginx

# Monitor error logs
sudo grep -i error /var/log/nginx/site.tcore.site_error.log
```

### Monthly
```bash
# Review access patterns
sudo awk '{print $1}' /var/log/nginx/site.tcore.site_access.log | sort | uniq -c | sort -rn | head -20

# Clear old logs (optional)
sudo logrotate -f /etc/logrotate.d/nginx
```

---

## Rollback Procedure

If deployment causes issues:

```bash
# Check previous git commits
git log --oneline -10

# Revert to previous version
git revert HEAD

# Rebuild apps
flutter clean
flutter pub get
flutter build web --release --base-href /app/
cd businessapp
flutter clean
flutter pub get
flutter build web --release --base-href /businessapp/

# Redeploy
git push origin main
# Then repeat deployment steps on server
```

---

## Integration Testing Checklist

After deployment, verify:

- [ ] User App loads at `/app` without errors
- [ ] Business App loads at `/businessapp` without errors
- [ ] All assets load correctly (images, fonts, CSS)
- [ ] Navigation between apps works (Business button in User App)
- [ ] No console errors (F12 → Console)
- [ ] No network 404 errors (F12 → Network)
- [ ] Service Worker loads (F12 → Application → Service Workers)
- [ ] Responsive design works (test on mobile)
- [ ] Dark mode works (if implemented)
- [ ] All buttons/links work correctly
- [ ] API calls work (if applicable)
- [ ] localStorage/sessionStorage work
- [ ] Offline functionality works (if implemented)

---

## Support & Documentation

- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Flutter Web Base Href](https://docs.flutter.dev/deployment/web#use-base_href-in-pubspecyaml)

---

## Notes

- This setup uses relative paths for assets, making it work on any domain
- Each app runs in its own isolated environment
- Navigation between apps happens via full page navigation (not within Flutter)
- State is NOT shared between apps (intentional separation)
- Both apps can have independent deployments
