# 🧪 دليل اختبار Flutter Web - خطوات عملية

## 📋 قبل البدء

```bash
# تأكد من وجود Chrome أو Edge
flutter devices  # يجب أن ترى "chrome" في القائمة

# إذا لم ترى Chrome:
flutter config --enable-web
```

---

## 🚀 الخطوة 1: تشغيل التطبيق

### الطريقة الأولى - تشغيل بسيط:
```bash
cd c:\Projects\dieaya-plus
flutter run -d chrome
```

### الطريقة الثانية - مع مراقبة:
```bash
flutter run -d chrome --verbose
```

### الطريقة الثالثة - باستخدام Edge:
```bash
flutter run -d edge
```

---

## 🔍 الخطوة 2: فحص Console في DevTools

### فتح DevTools:
```
F12  أو  Ctrl+Shift+I
```

### ابحث عن الرسائل:
```
✅ [MAIN] Initializing app...
🔥 [FIREBASE] Initializing Firebase...
✅ [FIREBASE] Firebase initialized successfully
💾 [STORAGE] Initializing storage...
✅ [STORAGE] Storage initialized
🔌 [CONTROLLERS] Initializing controllers...
✅ [CONTROLLERS] Controllers initialized
🌐 [DEEPLINK] Web platform detected, skipping native deep linking
✅ [MAIN] App initialization complete, running app...
🎨 [BUILD] Building MyApp...
```

### إذا رأيت أخطاء:
```
❌ [FIREBASE] Firebase initialization failed: ...
❌ [STORAGE] Storage initialization failed: ...
❌ [CONTROLLERS] Controller initialization failed: ...
```

**اكتب الخطأ الكامل وابحث عن الحل.**

---

## 📊 الخطوة 3: فحص Network

### في DevTools، افتح tab "Network"

#### تحقق من تحميل الملفات:

| الملف | الحالة المتوقعة | الحجم |
|------|------------------|--------|
| `flutter_bootstrap.js` | ✅ 200 OK | ~1-2 KB |
| `flutter.js` | ✅ 200 OK | ~10-20 KB |
| `main.dart.js` | ✅ 200 OK | 📦 كبير (500+ KB) |
| `canvaskit.wasm` | ✅ 200 OK (optional) | ~8-10 MB |
| `canvaskit.js` | ✅ 200 OK (optional) | ~500 KB |

#### إذا رأيت أخطاء 404:
```
❌ 404 flutter.js - يعني مشكلة في مجلد build
❌ 404 canvaskit.wasm - قد تكون مشكلة، لكن ليست حتمية
```

**الحل:**
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

---

## 🎨 الخطوة 4: فحص DOM

### في DevTools، افتح tab "Elements" (أو Inspector)

#### ابحث عن العناصر التالية:

```javascript
// في DevTools Console، اكتب:

// 1️⃣ تحقق من وجود Flutter
console.log('Flutter app container:');
console.log(document.querySelector('flt-glass-pane'));

// 2️⃣ تحقق من loader
console.log('Loading element:');
console.log(document.getElementById('loading'));

// 3️⃣ تحقق من وجود Canvas
console.log('Canvas elements:');
console.log(document.querySelectorAll('canvas'));

// 4️⃣ تحقق من أي أخطاء مسجلة
console.log('Errors:');
console.log(window.flutterErrors);
```

#### النتائج المتوقعة:
```javascript
✅ flt-glass-pane - يجب أن يكون موجوداً
✅ loading element - قد يكون invisible بعد التحميل
✅ canvas elements - يجب أن يكون موجوداً واحد على الأقل
✅ window.flutterErrors - يجب أن يكون array فارغ []
```

---

## 🔧 الخطوة 5: اختبر البيانات

### تحقق من تحميل الترجمات:
```javascript
// في DevTools Console:
console.log(Get.translations);
```

**النتيجة المتوقعة:**
```javascript
{
  'en': { 'key1': 'value1', ... },
  'ar': { 'key1': 'قيمة1', ... }
}
```

### تحقق من الـ Theme:
```javascript
// في DevTools Console:
console.log(Get.find('ThemeController'));
```

**النتيجة المتوقعة:**
```
✅ Object { ... }  // controller موجود
❌ undefined  // مشكلة في التهيئة
```

---

## 📱 الخطوة 6: اختبار الأداء

### فتح Performance tab:

```bash
# اضغط F12
# انقر على Performance
# اضغط Record (الدائرة الحمراء)
# انتظر 3-5 ثوانٍ
# اضغط Stop
```

### ابحث عن:
```
✅ Task Duration < 1000ms (1 ثانية)
✅ No Red Bars = لا توجد أخطاء
✅ Smooth rendering
```

---

## 🐛 الخطوة 7: استكشاف الأخطاء الشائعة

### ❌ المشكلة: صفحة بيضاء ولا توجد رسائل

**السبب**: قد يكون هناك exception صامتة

**الحل**:
```javascript
// في DevTools Console:
window.addEventListener('error', e => {
  console.error('CAUGHT ERROR:', e);
});

window.addEventListener('unhandledrejection', e => {
  console.error('CAUGHT REJECTION:', e);
});

// أعد تحميل الصفحة
location.reload();
```

---

### ❌ المشكلة: "Cannot find module" أو "undefined is not a function"

**السبب**: مشكلة في build أو module resolution

**الحل**:
```bash
flutter clean
flutter pub cache clean
flutter pub get
flutter run -d chrome
```

---

### ❌ المشكلة: "Firebase initialization failed"

**السبب**: مشكلة في Firebase config أو CORS

**الحل**:
```dart
// في main.dart أو main_dev.dart
print("Firebase options:");
print("apiKey: ${options.apiKey}");
print("projectId: ${options.projectId}");
// تحقق من أن القيم صحيحة
```

---

### ❌ المشكلة: "ThemeController not found"

**السبب**: ThemeController لم يتم تهيئته

**الحل**:
```dart
// في main.dart، تأكد من:
Get.put(ThemeController());  // موجود
Get.put(LanguageController());  // موجود

// ثم في build():
final themeController = Get.find<ThemeController>();  // استخدم find بدل put
```

---

## ✨ اختبار سريع - الحد الأدنى

إذا أردت اختبار سريع فقط:

```bash
# 1. شغل التطبيق
flutter run -d chrome

# 2. افتح Console (F12)

# 3. تحقق من وجود هذا الرسالة:
"✅ [MAIN] App initialization complete"

# 4. تحقق من عدم وجود أحمر في console

# ✅ تم! التطبيق يعمل
```

---

## 🎯 نقاط الفحص النهائية

- [ ] لا توجد أخطاء حمراء في Console
- [ ] تظهر صفحة "✅ MyApp وصل بنجاح"
- [ ] Flutter bootstrap messages ظاهرة
- [ ] Network requests ناجحة (200 OK)
- [ ] DOM يحتوي على `flt-glass-pane`
- [ ] `window.flutterErrors` فارغ
- [ ] الترجمات محملة بشكل صحيح

---

## 📞 إذا استمرت المشكلة

1. **اجمع معلومات**:
   - لقطة من Console errors
   - Network tab results
   - Flutter run -v output
   - Browser version

2. **شارك المعلومات**:
   - قم بـ paste الأخطاء كاملة
   - حدد المتصفح المستخدم
   - اذكر الخطوات التي حاولتها

---

**ملاحظة**: إذا رأيت "جاري تحميل التطبيق..." لمدة أكثر من 10 ثوانٍ، قد يكون هناك مشكلة في build.

