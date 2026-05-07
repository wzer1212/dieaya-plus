# 📌 مرجع سريع - الملفات الأساسية والعمليات

## 📂 الملفات الأساسية

### التوثيق (اقرأ بهذا الترتيب)
1. **`FINAL_SUMMARY.md`** ⭐ ابدأ هنا - ملخص شامل لكل شيء
2. **`DEPLOYMENT_README.md`** - دليل سريع
3. **`DEPLOYMENT_CHECKLIST.md`** - قائمة التحقق للنشر
4. **`DEPLOYMENT_GUIDE_AR.md`** - دليل تفصيلي بالعربية
5. **`DEPLOYMENT_GUIDE_EN.md`** - دليل تفصيلي بالإنجليزية

### التكوين والأدوات
- `nginx.conf` - إعدادات Nginx (للسيرفر)
- `build_apps.bat` - بناء آلي (Windows)
- `build_apps.sh` - بناء آلي (Linux/Mac)

### الكود المُعدّل
- `lib/ui/widgets/global_widgets/global_web_header.dart` ✏️
- `userapp/lib/ui/widgets/global_widgets/global_web_header.dart` ✏️

---

## 🚀 العمليات الرئيسية

### 1️⃣ البناء المحلي (Your Machine)

#### Windows
```batch
cd C:\Projects\dieaya-plus
build_apps.bat
```

#### Linux/Mac
```bash
cd ~/Projects/dieaya-plus
chmod +x build_apps.sh
./build_apps.sh
```

### 2️⃣ الرفع إلى GitHub
```bash
git add .
git commit -m "Deploy dual Flutter Web apps"
git push origin main
```

### 3️⃣ النشر على السيرفر
```bash
cd /www/wwwroot/dieaya-plus
git pull origin main
cp -r build/web/* /www/wwwroot/dieaya-plus/app/
cp -r businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/
sudo cp nginx.conf /etc/nginx/sites-available/site.tcore.site
sudo nginx -t
sudo systemctl reload nginx
```

---

## 🎯 الروابط النهائية

| التطبيق | الرابط |
|--------|--------|
| 👥 تطبيق المستخدم | `https://site.tcore.site/app` |
| 🏢 تطبيق الأعمال | `https://site.tcore.site/businessapp` |

---

## ✅ المهام المكتملة

- [x] بناء تطبيق المستخدم ✅
- [x] بناء تطبيق الأعمال ✅
- [x] تفعيل زر الانتقال ✅
- [x] إعدادات Nginx ✅
- [x] سكريبتات البناء ✅
- [x] التوثيق الكاملة ✅
- [x] قائمة التحقق ✅

---

## 🆘 حل سريع للمشاكل الشائعة

### شاشة بيضاء؟
→ تحقق من `<base href=` في index.html

### أخطاء 404 للـ Assets؟
→ تأكد من نسخ الملفات إلى المسار الصحيح

### خطأ Nginx؟
→ شغّل: `sudo nginx -t`

---

## 📞 الدعم السريع

**أسئلة متكررة؟** اقرأ:
- `DEPLOYMENT_GUIDE_AR.md` - القسم: استكشاف الأخطاء

**تريد التفاصيل؟**
- `DEPLOYMENT_GUIDE_EN.md` - نسخة إنجليزية شاملة

**مستعجل؟**
- `DEPLOYMENT_CHECKLIST.md` - قائمة خطوة بخطوة

---

## 📊 ملخص الحل

```
المشكلة:     ❌ تطبيقات Flutter لا تعمل في subfolders
الحل:        ✅ استخدام base-href صحيح
النتيجة:     ✅ تطبيقين يعملان بكفاءة على نفس الدومين
الحالة:      ✅ جاهز للنشر الفوري
```

---

**🎉 كل شيء جاهز! ابدأ بـ `FINAL_SUMMARY.md` الآن**
