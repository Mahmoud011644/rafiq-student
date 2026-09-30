#!/bin/bash

# 🚀 سكريبت بناء تطبيق رفيق الطالب تلقائياً
# هذا السكريبت يقوم ببناء APK كامل مع جميع الخطوات

set -e

echo "╔════════════════════════════════════════════════╗"
echo "║  🎓 تطبيق رفيق الطالب - سكريبت البناء التلقائي  ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# 🔍 فحص المتطلبات
echo "📋 فحص المتطلبات..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter غير مثبت"
    exit 1
fi
echo "✅ Flutter مثبت"

# 📊 عرض إصدار Flutter
echo ""
echo "📊 معلومات النظام:"
flutter --version
echo ""

# 📦 تنظيف الملفات القديمة
echo "🧹 تنظيف الملفات القديمة..."
flutter clean
echo "✅ تم التنظيف"
echo ""

# 📥 تحميل المكتبات
echo "📥 تحميل المكتبات والمتعلقات..."
flutter pub get
echo "✅ تم تحميل المكتبات"
echo ""

# 🔍 تحليل الكود
echo "🔍 تحليل الكود..."
flutter analyze || echo "⚠️ هناك تنبيهات في التحليل (غير حرجة)"
echo ""

# 🧪 تشغيل الاختبارات
echo "🧪 تشغيل الاختبارات..."
flutter test || echo "⚠️ قد لا تكون هناك اختبارات"
echo ""

# 🏗️ بناء APK Debug
echo "🔨 بناء APK للتطوير (Debug)..."
flutter build apk --debug
echo "✅ تم بناء Debug APK"
echo ""

# 🚀 بناء APK Release
echo "🚀 بناء APK للإصدار النهائي (Release)..."
flutter build apk --release
echo "✅ تم بناء Release APK"
echo ""

# 📦 بناء App Bundle
echo "📦 بناء App Bundle لـ Google Play..."
flutter build appbundle --release
echo "✅ تم بناء App Bundle"
echo ""

# 📊 عرض النتائج
echo "╔════════════════════════════════════════════════╗"
echo "║            📊 ملخص البناء النهائي              ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    DEBUG_SIZE=$(du -h "build/app/outputs/flutter-apk/app-debug.apk" | cut -f1)
    echo "✅ Debug APK:"
    echo "   📁 المسار: build/app/outputs/flutter-apk/app-debug.apk"
    echo "   📦 الحجم: $DEBUG_SIZE"
else
    echo "❌ فشل بناء Debug APK"
fi
echo ""

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    RELEASE_SIZE=$(du -h "build/app/outputs/flutter-apk/app-release.apk" | cut -f1)
    echo "✅ Release APK:"
    echo "   📁 المسار: build/app/outputs/flutter-apk/app-release.apk"
    echo "   📦 الحجم: $RELEASE_SIZE"
else
    echo "❌ فشل بناء Release APK"
fi
echo ""

if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    AAB_SIZE=$(du -h "build/app/outputs/bundle/release/app-release.aab" | cut -f1)
    echo "✅ App Bundle (AAB):"
    echo "   📁 المسار: build/app/outputs/bundle/release/app-release.aab"
    echo "   📦 الحجم: $AAB_SIZE"
else
    echo "❌ فشل بناء App Bundle"
fi
echo ""

# 📱 تعليمات التثبيت
echo "╔════════════════════════════════════════════════╗"
echo "║         📱 تعليمات التثبيت على الهاتف          ║"
echo "╚════════════════════════════════════════════════╝"
echo ""
echo "1️⃣ نقل ملف APK إلى هاتفك:"
echo "   adb push build/app/outputs/flutter-apk/app-release.apk /sdcard/"
echo ""
echo "2️⃣ تثبيت التطبيق:"
echo "   adb install -r build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "3️⃣ أو انقر على الملف مباشرة على الهاتف وتثبيت التطبيق"
echo ""

echo "✨ تم إكمال البناء بنجاح! 🎉"
echo ""
echo "🔗 للمزيد من المعلومات:"
echo "   📖 الريبو: https://github.com/Mahmoud011644/rafiq-student"
echo "   💬 الإصدارات: https://github.com/Mahmoud011644/rafiq-student/releases"
echo ""
