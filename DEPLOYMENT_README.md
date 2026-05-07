# Dieaya Plus - Dual Flutter Web Apps Deployment

🎯 **Mission:** Deploy two Flutter Web applications on the same domain and enable seamless navigation between them.

---

## ✅ What's Been Done

### 1. Built Apps with Correct base-href
- ✅ **User App:** Built with `--base-href /app/`
- ✅ **Business App:** Built with `--base-href /businessapp/`
- ✅ Both apps properly reference assets, fonts, and JavaScript from their respective paths

### 2. Updated Navigation
- ✅ Added button in User App to navigate to Business App
- ✅ Business button in header now opens `https://site.tcore.site/businessapp`
- ✅ Updated in both `lib/ui/widgets/global_widgets/global_web_header.dart` files

### 3. Created Deployment Files
- ✅ `nginx.conf` - Production-ready Nginx configuration
- ✅ `DEPLOYMENT_GUIDE_AR.md` - Arabic deployment guide
- ✅ `DEPLOYMENT_GUIDE_EN.md` - English deployment guide
- ✅ `build_apps.bat` - Windows build script
- ✅ `build_apps.sh` - Linux/Mac build script

---

## 🚀 Quick Start Deployment

### 1. Build Apps (Local Machine)

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

### 2. Push to GitHub
```bash
git add .
git commit -m "Build both apps with correct base-href"
git push origin main
```

### 3. Deploy to Server
```bash
cd /www/wwwroot/dieaya-plus

# Pull latest changes
git pull origin main

# Copy files to correct directories
cp -r build/web/* /www/wwwroot/dieaya-plus/app/ 2>/dev/null || mkdir -p /www/wwwroot/dieaya-plus/app && cp -r build/web/* /www/wwwroot/dieaya-plus/app/
cp -r businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/ 2>/dev/null || mkdir -p /www/wwwroot/dieaya-plus/businessapp && cp -r businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/
```

### 4. Configure Nginx
```bash
# Copy Nginx configuration
sudo cp nginx.conf /etc/nginx/sites-available/site.tcore.site
sudo ln -sf /etc/nginx/sites-available/site.tcore.site /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

---

## 📍 Final URLs

| App | URL | Base HREF |
|-----|-----|-----------|
| User App | `https://site.tcore.site/app` | `/app/` |
| Business App | `https://site.tcore.site/businessapp` | `/businessapp/` |

---

## 🔧 Configuration Details

### Base HREF Configuration
Both apps are built with specific base-href values:

```bash
# User App
flutter build web --release --base-href /app/

# Business App  
flutter build web --release --base-href /businessapp/
```

This ensures all relative paths (assets, fonts, JS) are resolved correctly.

### Nginx Configuration
Key Nginx settings:

- `location /app/` - Routes User App
- `location /businessapp/` - Routes Business App
- `try_files $uri $uri/ /app/index.html` - SPA routing for User App
- `try_files $uri $uri/ /businessapp/index.html` - SPA routing for Business App
- Cache headers optimized for Flutter Web assets

### Navigation Between Apps
In User App (`global_web_header.dart`):
```dart
import 'dart:html' as html;

// Business button
onTap: () {
  html.window.location.href = '/businessapp';
}
```

---

## 📁 Project Structure

```
/www/wwwroot/dieaya-plus/
├── app/                          # User App (Flutter Web build)
│   ├── index.html
│   ├── main.dart.js
│   ├── assets/
│   └── ...
├── businessapp/                  # Business App (Flutter Web build)
│   ├── index.html
│   ├── main.dart.js
│   ├── assets/
│   └── ...
└── [other project files]
```

---

## 🐛 Troubleshooting

### White Screen on Load
→ Check `base href` in index.html and verify files are in correct directories

### 404 Errors for Assets
→ Ensure `build/web` files are copied to correct path

### Nginx 500 Errors
→ Run `sudo nginx -t` to check configuration syntax

### Service Worker Issues
→ Clear browser cache and restart

For detailed troubleshooting, see [DEPLOYMENT_GUIDE_EN.md](DEPLOYMENT_GUIDE_EN.md)

---

## 📚 Documentation

- **Arabic Guide:** [DEPLOYMENT_GUIDE_AR.md](DEPLOYMENT_GUIDE_AR.md)
- **English Guide:** [DEPLOYMENT_GUIDE_EN.md](DEPLOYMENT_GUIDE_EN.md)
- **Nginx Config:** [nginx.conf](nginx.conf)

---

## 🔄 Deployment Checklist

Before each deployment:

- [ ] Run build script to create new builds
- [ ] Verify `base href` in both index.html files
- [ ] Test apps locally (if possible)
- [ ] Commit and push to GitHub
- [ ] Pull on server
- [ ] Copy files to correct directories
- [ ] Test Nginx configuration
- [ ] Reload Nginx
- [ ] Verify both apps load without errors
- [ ] Test navigation between apps

---

## ⚙️ Automated Build Scripts

### Windows Build Script
```bash
build_apps.bat
```
Builds both apps, verifies base-href, and provides deployment instructions

### Linux/Mac Build Script
```bash
./build_apps.sh
```
Same as Windows batch, but for Unix-like systems

---

## 🎓 Key Changes Made

1. ✅ Added `import 'dart:html' as html;` to global_web_header.dart
2. ✅ Updated Business button to navigate: `html.window.location.href = '/businessapp'`
3. ✅ Created Nginx configuration for dual app routing
4. ✅ Generated build scripts for automated builds
5. ✅ Created comprehensive deployment guides

---

## 📞 Support

For issues or questions:
1. Check the detailed troubleshooting section in deployment guides
2. Review Nginx error logs: `sudo tail -f /var/log/nginx/error.log`
3. Verify file structure: `ls -la /www/wwwroot/dieaya-plus/`

---

## 🎉 Summary

Everything is now configured for:
- ✅ Two Flutter Web apps on same domain
- ✅ Proper asset/font loading
- ✅ Seamless navigation between apps
- ✅ Production-ready Nginx configuration
- ✅ Automated build process
- ✅ Comprehensive documentation

Ready for deployment! 🚀
