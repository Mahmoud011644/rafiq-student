# 🚀 دليل البناء والتشغيل الكامل لتطبيق رفيق الطالب

## 📱 نظرة عامة
تطبيق رفيق الطالب هو تطبيق تعليمي شامل يقدم دورات في الحاسوب والبرمجة والبرمجيات والكهرباء.

## 📋 المتطلبات

### الحد الأدنى من المتطلبات:
- **Flutter SDK** (إصدار ثابت أو أحدث)
- **Java JDK 11+** (يفضل 17)
- **Android SDK** (API Level 21+)
- **Android Studio** أو محاكي Android
- **Xcode** (اختياري - لـ iOS)

### فحص المتطلبات:
```bash
flutter doctor
```

## 🔧 خطوات التثبيت الأولى

### 1. استنساخ المشروع
```bash
git clone https://github.com/Mahmoud011644/rafiq-student.git
cd rafiq-student
```

### 2. تحميل المكتبات
```bash
flutter pub get
```

### 3. فحص الكود
```bash
flutter analyze
```

## 🏗️ بناء التطبيق

### الطريقة 1: استخدام السكريبت التلقائي

#### على Linux/Mac:
```bash
chmod +x build.sh
./build.sh
```

#### على Windows:
```cmd
build.bat
```

### الطريقة 2: الأوامر اليدوية

#### تنظيف الملفات القديمة:
```bash
flutter clean
```

#### بناء APK للتطوير (Debug):
```bash
flutter build apk --debug
```

#### بناء APK للإصدار النهائي (Release):
```bash
flutter build apk --release
```

#### بناء App Bundle لـ Google Play:
```bash
flutter build appbundle --release
```

### الطريقة 3: البناء التلقائي عبر GitHub Actions

عند دفع التغييرات إلى `main`:
1. يتم تشغيل Workflow تلقائياً
2. البناء يتم على خوادم GitHub
3. الملفات الناتجة متاحة في:
   - **Artifacts**: للتحميل المباشر
   - **Releases**: نسخة منشورة رسمية

## 📲 تثبيت على الهاتف

### عبر ADB (Android Debug Bridge):
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### عبر File Transfer:
1. انقل الملف APK إلى الهاتف
2. افتح الملف مباشرة
3. اضغط "تثبيت"

### عبر Google Play:
1. استخدم ملف AAB (App Bundle)
2. قم بنشره على Google Play Console
3. سيتم توزيعه تلقائياً

## 📁 هيكل المشروع

```
rafiq-student/
├── .github/
│   └── workflows/
│       ├── build-apk.yml          # Workflow البناء الرئيسي
│       └── daily-build.yml         # بناء يومي
├── lib/
│   ├── main.dart                   # نقطة الدخول
│   ├── screens/                    # الشاشات الرئيسية
│   ├── widgets/                    # المكونات القابلة لإعادة الاستخدام
│   ├── models/                     # نماذج البيانات
│   ├── services/                   # الخدمات والمنطق
│   ├── data/                       # البيانات الثابتة
│   └── theme/                      # إعدادات المظهر
├── pubspec.yaml                    # المكتبات والمتعلقات
├── build.sh                        # سكريبت البناء (Linux/Mac)
├── build.bat                       # سكريبت البناء (Windows)
└── README.md                       # هذا الملف

```

## 🔍 الميزات الرئيسية

✅ **التطبيق يحتوي على:**
- 🎓 دورات تعليمية شاملة
- 📊 نظام تتبع التقدم
- ❤️ نظام المفضلة
- 🧪 اختبارات تفاعلية
- 🔐 نظام الإدارة
- 🌍 واجهة عربية كاملة
- 📱 تصميم استجابي

## ⚙️ إعدادات البناء

### ملف `pubspec.yaml`:
```yaml
name: rafiq_student
version: 1.0.0+1
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  sqflite: ^2.3.0
  path: ^1.8.3
  intl: ^0.19.0
  crypto: ^3.0.3
```

## 🔄 سير العمل (Workflow) التلقائي

### عند كل Push إلى main:
1. ✅ فحص الكود (checkout)
2. ✅ تثبيت Java و Flutter
3. ✅ تحميل المكتبات
4. ✅ تحليل الكود
5. ✅ تشغيل الاختبارات
6. ✅ بناء APK Debug و Release
7. ✅ بناء App Bundle
8. ✅ رفع الملفات كـ Artifacts
9. ✅ إنشاء Release جديد

### عرض النتائج:
- **Artifacts**: https://github.com/Mahmoud011644/rafiq-student/actions
- **Releases**: https://github.com/Mahmoud011644/rafiq-student/releases

## 📦 أحجام الملفات النموذجية

| الملف | الحجم | الوصف |
|------|------|--------|
| Debug APK | ~50-70 MB | للاختبار والتطوير |
| Release APK | ~25-35 MB | للنشر والاستخدام |
| App Bundle | ~20-30 MB | لنشر Google Play |

## 🔧 استكشاف الأخطاء

### مشكلة: فشل البناء
```bash
# الحل:
flutter clean
flutter pub get
flutter pub cache repair
flutter build apk --release
```

### مشكلة: أخطاء Java
```bash
# تحقق من إصدار Java:
java -version

# قم بتحديث JAVA_HOME إن لزم الأمر
```

### مشكلة: عدم وجود Android SDK
```bash
# قم بتشغيل:
flutter doctor --android-licenses
```

## 📚 الموارد المفيدة

- 📖 [توثيق Flutter الرسمية](https://flutter.dev/docs)
- 🔨 [دليل البناء](https://flutter.dev/docs/deployment/android)
- 🎯 [Google Play Publishing](https://play.google.com/console)
- 💻 [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🤝 المساهمة

1. اعمل على فرع جديد
2. قم بالتغييرات المطلوبة
3. اضغط PR (Pull Request)
4. انتظر المراجعة والموافقة

## 📞 الدعم والمساعدة

- 🐛 [أبلغ عن الأخطاء](https://github.com/Mahmoud011644/rafiq-student/issues)
- 💬 [النقاشات](https://github.com/Mahmoud011644/rafiq-student/discussions)
- 📧 البريد: mahmoud1164450@gmail.com

## 📄 الترخيص

هذا المشروع مرخص تحت MIT License

---

## 🎯 الخطوات السريعة

### للبناء الفوري:
```bash
# 1. استنساخ وتحضير
git clone https://github.com/Mahmoud011644/rafiq-student.git
cd rafiq-student

# 2. تحميل المكتبات
flutter pub get

# 3. بناء APK
flutter build apk --release

# 4. الملف النهائي
# build/app/outputs/flutter-apk/app-release.apk
```

## ✨ تم بنجاح!

تطبيقك الآن جاهز للتثبيت والاستخدام! 🎉

---

**آخر تحديث**: 30 سبتمبر 2026  
**الإصدار**: 1.0.0  
**الحالة**: ✅ جاهز للإنتاج
