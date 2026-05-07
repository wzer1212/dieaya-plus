# 🚀 Quick Deployment Checklist - Dieaya Plus

**Last Updated:** May 7, 2026
**Apps:** User App (/app) + Business App (/businessapp)
**Domain:** site.tcore.site

---

## ✅ Phase 1: Local Build (Your Machine)

### Prerequisites
- [ ] Flutter installed and updated
- [ ] Git configured
- [ ] Internet connection
- [ ] At least 5GB free disk space

### Build Process
- [ ] Navigate to project: `cd C:\Projects\dieaya-plus`
- [ ] Run build script: `build_apps.bat` (Windows) or `./build_apps.sh` (Linux/Mac)
- [ ] Wait for builds to complete (~3-5 minutes each)

### Verification
- [ ] User App build successful (check for `build/web/index.html`)
- [ ] Business App build successful (check for `businessapp/build/web/index.html`)
- [ ] User App index.html contains: `<base href="/app/">`
- [ ] Business App index.html contains: `<base href="/businessapp/">`
- [ ] No error messages in console

### Git Operations
- [ ] Review changes: `git status`
- [ ] Stage changes: `git add .`
- [ ] Commit: `git commit -m "Build both apps - User /app, Business /businessapp"`
- [ ] Push: `git push origin main`
- [ ] Verify on GitHub

---

## ✅ Phase 2: Server Preparation

### SSH into Server
```bash
ssh user@site.tcore.site
# or
ssh -i path/to/key user@site.tcore.site
```

### Backup Current Files (Optional but Recommended)
```bash
cd /www/wwwroot/dieaya-plus
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz app/ businessapp/
```

### Pull Latest Changes
- [ ] Navigate to project: `cd /www/wwwroot/dieaya-plus`
- [ ] Pull: `git pull origin main`
- [ ] Verify no conflicts

---

## ✅ Phase 3: File Deployment

### Create App Directories
```bash
mkdir -p /www/wwwroot/dieaya-plus/app
mkdir -p /www/wwwroot/dieaya-plus/businessapp
```

### Copy User App Files
```bash
cp -r build/web/* /www/wwwroot/dieaya-plus/app/
```
- [ ] Files copied successfully
- [ ] Check: `ls -la /www/wwwroot/dieaya-plus/app/index.html`

### Copy Business App Files
```bash
cp -r businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/
```
- [ ] Files copied successfully
- [ ] Check: `ls -la /www/wwwroot/dieaya-plus/businessapp/index.html`

### Verify File Structure
```bash
# Check User App assets
ls -la /www/wwwroot/dieaya-plus/app/main.dart.js
ls -la /www/wwwroot/dieaya-plus/app/assets/

# Check Business App assets
ls -la /www/wwwroot/dieaya-plus/businessapp/main.dart.js
ls -la /www/wwwroot/dieaya-plus/businessapp/assets/
```
- [ ] main.dart.js exists in `/app/`
- [ ] main.dart.js exists in `/businessapp/`
- [ ] assets folder exists in both directories
- [ ] File sizes are reasonable (> 1MB each for main.dart.js)

---

## ✅ Phase 4: Nginx Configuration

### Update Nginx Config
```bash
# Backup current config
sudo cp /etc/nginx/sites-available/site.tcore.site /etc/nginx/sites-available/site.tcore.site.bak

# Copy new config (from project)
sudo cp nginx.conf /etc/nginx/sites-available/site.tcore.site
```
- [ ] Config file copied

### Test Nginx Syntax
```bash
sudo nginx -t
```
- [ ] Expected output: `syntax is ok` and `test is successful`
- [ ] If error, restore backup: `sudo cp /etc/nginx/sites-available/site.tcore.site.bak /etc/nginx/sites-available/site.tcore.site`

### Reload Nginx
```bash
sudo systemctl reload nginx
# or
sudo systemctl restart nginx
```
- [ ] Command executed without errors
- [ ] Check status: `sudo systemctl status nginx` (should show "active")

---

## ✅ Phase 5: Verification

### Test URLs with curl
```bash
# User App
curl -I https://site.tcore.site/app/
curl -I https://site.tcore.site/app/main.dart.js
curl -I https://site.tcore.site/app/index.html

# Business App
curl -I https://site.tcore.site/businessapp/
curl -I https://site.tcore.site/businessapp/main.dart.js
curl -I https://site.tcore.site/businessapp/index.html
```
- [ ] All requests return HTTP 200 (not 404 or 500)
- [ ] Content-Length is reasonable (> 1MB for .js files)

### Browser Testing
- [ ] Open `https://site.tcore.site/app/` (User App should load)
- [ ] Open `https://site.tcore.site/businessapp/` (Business App should load)
- [ ] No white screen
- [ ] No console errors (F12 → Console)
- [ ] All images/fonts load (F12 → Network)

### Navigation Testing
- [ ] Click "دعاية بلس أعمال" button in User App header
- [ ] Should navigate to Business App
- [ ] Verify URL changes to `/businessapp/`

### Advanced Testing
- [ ] Test on mobile device/responsive view
- [ ] Try offline mode (if service worker enabled)
- [ ] Check dark mode (if applicable)
- [ ] Verify API calls work (if applicable)
- [ ] Test all main features in each app

---

## ✅ Phase 6: Logging & Monitoring

### Check Nginx Access Logs
```bash
sudo tail -20 /var/log/nginx/site.tcore.site_access.log
```
- [ ] Requests appear in log
- [ ] Status codes are 200, 304 (not errors)

### Check Nginx Error Logs
```bash
sudo tail -20 /var/log/nginx/site.tcore.site_error.log
```
- [ ] No error entries (should be empty or very few)

### Monitor Real-time Traffic (Optional)
```bash
sudo tail -f /var/log/nginx/site.tcore.site_access.log
# Ctrl+C to stop
```

---

## 🆘 Troubleshooting If Needed

### White Screen
1. [ ] Verify `<base href="/app/">` in index.html
2. [ ] Check if `main.dart.js` loaded (Network tab)
3. [ ] Check error logs: `sudo tail -50 /var/log/nginx/error.log`
4. [ ] Clear browser cache (Ctrl+Shift+Delete)

### 404 Errors
1. [ ] Verify files copied: `ls -la /www/wwwroot/dieaya-plus/app/assets/`
2. [ ] Check file permissions: `sudo chown -R www-data:www-data /www/wwwroot/dieaya-plus`
3. [ ] Re-copy files if needed: `cp -r build/web/* /www/wwwroot/dieaya-plus/app/`

### 500 Errors
1. [ ] Test Nginx: `sudo nginx -t`
2. [ ] Check error logs: `sudo tail -50 /var/log/nginx/error.log`
3. [ ] Verify permissions: `sudo chmod -R 755 /www/wwwroot/dieaya-plus`

### Apps Load Separately but Navigation Fails
1. [ ] Verify Business button code in `global_web_header.dart`
2. [ ] Check browser console for JavaScript errors
3. [ ] Verify Nginx routing for `/businessapp` path

---

## 📊 Post-Deployment Checks

### Performance
- [ ] App loads in < 3 seconds
- [ ] Navigation between apps smooth
- [ ] No UI freezing or lag

### Functionality
- [ ] All buttons work
- [ ] All links work
- [ ] Form submissions work (if any)
- [ ] API calls succeed (if any)

### Compatibility
- [ ] Desktop browsers (Chrome, Firefox, Safari)
- [ ] Mobile browsers (iOS Safari, Chrome)
- [ ] Tablet view

### Security
- [ ] HTTPS working (green lock icon)
- [ ] No mixed content warnings
- [ ] No CORS errors
- [ ] Security headers present (F12 → Network → Response Headers)

---

## 🔄 Rollback Plan (If Issues Occur)

### If Deployment Fails
```bash
# Restore from backup
sudo cp /etc/nginx/sites-available/site.tcore.site.bak /etc/nginx/sites-available/site.tcore.site
sudo systemctl reload nginx

# Or restore files
tar -xzf backup_YYYYMMDD_HHMMSS.tar.gz
```

### If Git Needs Revert
```bash
git revert HEAD
git push origin main
# Then rebuild and redeploy
```

---

## ✨ Sign-Off

- [ ] All checks completed
- [ ] All tests passed
- [ ] Users notified of deployment
- [ ] Documentation updated
- [ ] Monitoring in place

**Deployment Status:** ✅ COMPLETE

---

## 📝 Notes & Additional Info

**Deployed By:** _________________
**Date:** _________________
**Time:** _________________
**Issues Encountered:** None / [List if any]
**Resolution:** _________________
**Next Review Date:** _________________

---

## 📞 Quick Reference

| Item | Value |
|------|-------|
| **Domain** | site.tcore.site |
| **User App URL** | https://site.tcore.site/app |
| **Business App URL** | https://site.tcore.site/businessapp |
| **Server Path** | /www/wwwroot/dieaya-plus |
| **Nginx Config** | /etc/nginx/sites-available/site.tcore.site |
| **Access Log** | /var/log/nginx/site.tcore.site_access.log |
| **Error Log** | /var/log/nginx/site.tcore.site_error.log |

---

**Good luck with deployment! 🚀**
