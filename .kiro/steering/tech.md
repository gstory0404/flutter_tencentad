# Tech Stack

## Framework
- Flutter plugin (Dart + native platform code)
- Dart SDK: >=2.12.0 <4.0.0
- Flutter: >=1.20.0

## Native SDKs
- Android: Tencent GDT SDK `com.qq.e.union:union:4.650.1520`
- iOS: GDTMobSDK `4.15.50` (via CocoaPods)
- OHOS: GDT Union SDK `@gdt/gdt-union-sdk` (via HAR)

## Languages
- Dart (Flutter API layer)
- Kotlin (Android native implementation)
- Objective-C (iOS native implementation)
- ArkTS/ETS (OHOS native implementation)

## Build System
- Flutter/Dart: pubspec.yaml
- Android: Gradle 7.1.2, Kotlin 1.6.10, compileSdkVersion 31
- iOS: CocoaPods, minimum iOS 9.0

## Key Dependencies
- flutter_lints (analysis)
- cupertino_icons (example app)

## Communication Pattern
- MethodChannel: `flutter_tencentad` for method calls
- EventChannel: `com.gstory.flutter_tencentad/adevent` for ad event streams
- PlatformViews for native ad rendering (Banner, Splash, Native Express)

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run example app
cd example && flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

# Build Android
cd example && flutter build apk

# Build iOS
cd example && flutter build ios
```

## Android Configuration
Requires manual permission setup in AndroidManifest.xml (INTERNET, ACCESS_NETWORK_STATE, etc.)

## iOS Configuration
Requires `io.flutter.embedded_views_preview` in Info.plist for PlatformView support.

- 全程中文交流