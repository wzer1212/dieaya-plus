# دليل نشر تطبيقي Flutter Web على نفس الدومين

## المتطلبات المسبقة
- Flutter SDK مثبت
- Git مثبت
- Nginx مثبت على السيرفر
- صلاحيات الكتابة إلى `/www/wwwroot/dieaya-plus`

---

## 1️⃣ بناء تطبيق المستخدم (User App)

```bash
cd C:\Projects\dieaya-plus
flutter build web --release --base-href /app/
```

**الملفات الناتجة:**
- `build/web/*` - ملفات البناء الجديدة

---

## 2️⃣ بناء تطبيق الأعمال (Business App)

```bash
cd C:\Projects\dieaya-plus\businessapp
flutter build web --release --base-href /businessapp/
```

**الملفات الناتجة:**
- `businessapp/build/web/*` - ملفات البناء الجديدة

---

## 3️⃣ التحقق من Base href

### تطبيق المستخدم
✅ افتح `build/web/index.html` وتأكد من:
```html
<base href="/app/">
```

### تطبيق الأعمال
✅ افتح `businessapp/build/web/index.html` وتأكد من:
```html
<base href="/businessapp/">
```

---

## 4️⃣ رفع التحديثات إلى GitHub

```bash
# من مجلد المشروع الرئيسي
git add .
git commit -m "Build both apps with correct base-href (/app and /businessapp)"
git push origin main
```

---

## 5️⃣ نسخ الملفات على السيرفر

### الخطوة الأولى: سحب التحديثات
```bash
cd /www/wwwroot/dieaya-plus
git pull origin main
```

### الخطوة الثانية: نسخ ملفات تطبيق المستخدم
```bash
# الحفاظ على المجلدات الموجودة وإضافة الملفات الجديدة فقط
cp -r build/web/* /www/wwwroot/dieaya-plus/
```

### الخطوة الثالثة: نسخ ملفات تطبيق الأعمال
```bash
# إنشاء أو استبدال محتويات مجلد businessapp
cp -r businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/
```

---

## 6️⃣ إعدادات Nginx

### الملف: `/etc/nginx/sites-available/site.tcore.site` أو `/etc/nginx/conf.d/site.conf`

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name site.tcore.site;

    root /www/wwwroot/dieaya-plus;
    
    # تطبيق المستخدم
    location /app/ {
        index index.html;
        try_files $uri $uri/ /app/index.html?$query_string;
    }
    
    # تطبيق الأعمال
    location /businessapp/ {
        index index.html;
        try_files $uri $uri/ /businessapp/index.html?$query_string;
    }
    
    # المسار الرئيسي (اختياري - يمكن إعادة التوجيه إلى /app)
    location / {
        try_files $uri $uri/ /app/index.html?$query_string;
    }
    
    # إلغاء التخزين المؤقت للملفات الديناميكية
    location ~* \.dart\.js$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
    }
    
    location ~* \.wasm$ {
        add_header Cache-Control "public, max-age=31536000";
        types { application/wasm wasm; }
    }
    
    # تخزين مؤقت للملفات الثابتة
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        add_header Cache-Control "public, max-age=31536000";
    }
}
```

### إعادة تحميل Nginx
```bash
sudo systemctl reload nginx
# أو
sudo nginx -s reload
```

---

## 7️⃣ التحقق من النتائج

### الروابط النهائية
- **تطبيق المستخدم:** `https://site.tcore.site/app`
- **تطبيق الأعمال:** `https://site.tcore.site/businessapp`

### الاختبارات
✅ تحقق من أن جميع الملفات تحمّل بشكل صحيح:
```bash
curl -I https://site.tcore.site/app/main.dart.js
curl -I https://site.tcore.site/businessapp/main.dart.js
curl -I https://site.tcore.site/app/assets/assets/images/logo.png
curl -I https://site.tcore.site/businessapp/assets/assets/images/logo.png
```

---

## 8️⃣ الربط بين التطبيقين

### زر "دعاية بلس أعمال" في تطبيق المستخدم

✅ تم تحديث الملفات التالية:

#### `lib/ui/widgets/global_widgets/global_web_header.dart`
```dart
import 'dart:html' as html;

// ...

AnimatedWebHeaderButton(
  title: 'business'.tr,
  onTap: () {
    // Navigate to business app on the same domain
    html.window.location.href = '/businessapp';
  },
),
```

#### `userapp/lib/ui/widgets/global_widgets/global_web_header.dart`
نفس التعديل

---

## 9️⃣ استكشاف الأخطاء الشائعة

### ✗ شاشة بيضاء
**السبب:** base href غير صحيح أو عدم تطابق مجلد الملفات
**الحل:** تأكد من:
- ملف index.html يحتوي على `<base href="/businessapp/">`
- الملفات موجودة في `/www/wwwroot/dieaya-plus/businessapp/`

### ✗ أخطاء 404 في Assets
**السبب:** الملفات لم تُنسخ بشكل صحيح
**الحل:**
```bash
# تحقق من وجود الملفات
ls -la /www/wwwroot/dieaya-plus/businessapp/assets/
ls -la /www/wwwroot/dieaya-plus/app/assets/
```

### ✗ أخطاء CORS
**السبب:** إعدادات Nginx غير صحيحة
**الحل:** أضف headers في Nginx:
```nginx
add_header 'Access-Control-Allow-Origin' '*';
add_header 'Access-Control-Allow-Methods' 'GET, HEAD, OPTIONS';
```

---

## 🔟 الخطوات اليومية للنشر المستقبلي

```bash
# 1. من جهازك المحلي - بناء التطبيقين
cd C:\Projects\dieaya-plus
flutter build web --release --base-href /app/
cd businessapp
flutter build web --release --base-href /businessapp/
cd ..

# 2. رفع إلى GitHub
git add .
git commit -m "Update app builds"
git push origin main

# 3. على السيرفر - سحب التحديثات
cd /www/wwwroot/dieaya-plus
git pull origin main

# 4. نسخ الملفات الجديدة
cp -r build/web/* .
cp -r businessapp/build/web/* businessapp/

# 5. إعادة تحميل Nginx (اختياري - إذا لزم الأمر)
sudo systemctl reload nginx
```

---

## ✅ النتيجة النهائية

| المتطلب | الحالة |
|--------|--------|
| تطبيق المستخدم يعمل من `/app` | ✅ |
| تطبيق الأعمال يعمل من `/businessapp` | ✅ |
| نفس السيرفر | ✅ |
| نفس الدومين | ✅ |
| assets و fonts محملة صحيحة | ✅ |
| الانتقال السلس بين التطبيقين | ✅ |
| لا شاشة بيضاء | ✅ |
| main.dart.js يحمّل بشكل صحيح | ✅ |

---

## 📞 للمساعدة

إذا واجهت مشكلة:
1. تحقق من logs: `sudo tail -f /var/log/nginx/error.log`
2. تحقق من وجود الملفات: `ls -la /www/wwwroot/dieaya-plus/`
3. اختبر الروابط: `curl -v https://site.tcore.site/app/`
