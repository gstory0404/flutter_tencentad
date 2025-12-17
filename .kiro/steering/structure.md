# Project Structure

## Root Layout
```
├── lib/                    # Dart API layer
├── android/                # Android native implementation
├── ios/                    # iOS native implementation
├── ohos/                   # OHOS (HarmonyOS) native implementation
├── example/                # Demo Flutter app
├── test/                   # Dart unit tests
└── images/                 # Documentation assets
```

## Dart Layer (`lib/`)
```
lib/
├── flutter_tencentad.dart              # Main entry point, exports public API
├── flutter_tencentad_callback.dart     # Callback type definitions (part file)
├── flutter_tencentad_bidding_controller.dart  # Bidding result controller (part file)
├── flutter_tencentad_stream.dart       # EventChannel stream handling
├── flutter_tencentad_code.dart.dart    # Constants and enums
├── banner/                             # Banner ad widget
├── express/                            # Native express ad widget
└── splash/                             # Splash ad widget
```

## Android Native (`android/src/main/kotlin/com/gstory/flutter_tencentad/`)
```
├── FlutterTencentadPlugin.kt           # Main plugin entry, MethodChannel handler
├── FlutterTencentAdEventPlugin.kt      # EventChannel for ad events
├── FlutterTencentAdViewPlugin.kt       # PlatformView registration
├── FlutterTencentAdConfig.kt           # Configuration holder
├── LogUtil.kt, UIUtils.kt              # Utilities
├── bannerad/                           # Banner PlatformView
├── expressad/                          # Native express PlatformView
├── splashad/                           # Splash PlatformView
├── rewardvideoad/                      # Reward video (non-view)
└── interstitialad/                     # Interstitial (non-view)
```

## iOS Native (`ios/Classes/`)
```
├── FlutterTencentadPlugin.h/m          # Main plugin entry
├── event/                              # EventChannel handling
├── utils/                              # Logging, ViewController utilities
├── banner/                             # Banner ad view
├── native/                             # Native express ad view
├── splash/                             # Splash ad view
├── reward/                             # Reward video ad
└── insert/                             # Interstitial ad
```

## Architecture Pattern
- View-based ads (Banner, Splash, Express): Use PlatformView factories
- Full-screen ads (Reward, Interstitial): Use preload/show pattern via MethodChannel
- Events flow from native → Dart via EventChannel stream
- Bidding results flow from Dart → native via controller pattern


## OHOS Native (`ohos/src/main/ets/components/plugin/`)
```
├── FlutterTencentadPlugin.ets          # Main plugin entry, MethodChannel handler
├── FlutterTencentadEventPlugin.ets     # EventChannel for ad events
├── FlutterTencentadViewPlugin.ets      # PlatformView registration
├── FlutterTencentadConfig.ets          # Configuration holder (channel names, view types)
├── banner/                             # Banner PlatformView
│   ├── BannerAdViewFactory.ets
│   ├── BannerView.ets
│   └── BannerNativeView.ets
├── express/                            # Native express PlatformView
│   ├── NativeExpressAdViewFactory.ets
│   ├── NativeExpressView.ets
│   └── NativeExpressNativeView.ets
└── splash/                             # Splash PlatformView
    ├── SplashAdViewFactory.ets
    ├── SplashView.ets
    └── SplashNativeView.ets
```
