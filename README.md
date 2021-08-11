# 腾讯优量汇广告 Flutter版本

<p>
<a href="https://pub.flutter-io.cn/packages/flutter_tencentad"><img src=https://img.shields.io/badge/flutter_tencentad-v0.0.3-success></a>
</p>

## 简介
flutter_tencentad是一款集成了腾讯优量汇广告Android和iOSSDK的Flutter插件,方便直接调用优量汇广告SDK方法快速开发

由于优量汇需要上架应用才能使用广告，所以demo不能直接运行，[体验demo](https://www.pgyer.com/j7YB)

## 官方文档
* [Android](https://developers.adnet.qq.com/doc/android/access_doc)
* [IOS](https://developers.adnet.qq.com/doc/ios/guide)

## 本地环境
```
[✓] Flutter (Channel stable, 2.2.3, on macOS 11.5.1 20G80 darwin-x64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 30.0.2)
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio (version 2020.3)
[✓] VS Code (version 1.56.2)
[✓] Connected device (2 available)

```

## 集成步骤
#### 1、pubspec.yaml
```Dart
flutter_tencentad: ^0.0.3
```
引入
```Dart
import 'package:flutter_tencentad/flutter_tencentad.dart';
```
#### 2、Android
SDK(4.380.1250)已配置插件中无需额外配置，只需要在android目录中AndroidManifest.xml配置
```Java
<manifest ···
    xmlns:tools="http://schemas.android.com/tools"
    ···>
  <application
        tools:replace="android:label">
```

#### 3、IOS

开发中

## 使用

#### 1、SDK初始化
```Dart
await FlutterTencentad.register(
  appId: "1200009850", //appid
  debug: true, //是否显示日志log
);
```
#### 2、获取SDK版本
```Dart
await FlutterTencentad.getSDKVersion();
```

#### 3、开屏广告
```Dart
FlutterTencentad.splashAdView(
    //广告id
    codeId: "4052216802299999",
    ////设置开屏广告从请求到展示所花的最大时长（并不是指广告曝光时长），取值范围为[1500, 5000]ms
    fetchDelay: 3000,
    //广告回调
    callBack: SplashAdCallBack(
    onShow: () {
      print("开屏广告显示");
    },
    onADTick: (time) {
      print("开屏广告倒计时剩余时间 $time");
    },
    onClick: () {
      print("开屏广告点击");
    },
    onClose: () {
      print("开屏广告关闭");
      Navigator.pop(context);
    },
      onExpose: () {
      print("开屏广告曝光");
    },
      onFail: (code, message) {
      print("开屏广告失败  $code $message");
},
),
),
```
#### 4、banner广告
```Dart
FlutterTencentad.bannerAdView(
    //广告id
    codeId: "8042711873318113",
    //广告宽 单位dp
    viewWidth: 500,
    //广告高  单位dp   宽高比应该为6.4:1
    viewHeight: 100,
    // 广告回调
    callBack: BannerAdCallBack(
        onShow: () {
          print("Banner广告显示");
        },
        onFail: (code, message) {
          print("Banner广告错误 $code $message");
        },
        onClose: () {
          print("Banner广告关闭");
        },
        onExpose: () {
          print("Banner广告曝光");
        },
        onClick: () {
          print("Banner广告点击");
        },
    ),
),
```

#### 5、动态信息流/横幅/视频贴片广告
```
FlutterTencentad.expressAdView(
              //广告id
              codeId: "4072918853903023",
              //广告宽 单位dp
              viewWidth: 400,
              //广告高  单位dp
              viewHeight: 300,
              //回调事件
              callBack: ExpressAdCallBack(
                onShow: () {
                  print("动态信息流广告显示");
                },
                onFail: (code, message) {
                  print("动态信息流广告错误 $code $message");
                },
                onClose: () {
                  print("动态信息流广告关闭");
                },
                onExpose: () {
                  print("动态信息流广告曝光");
                },
                onClick: () {
                  print("动态信息流广告点击");
                },
              )
            ),
```

#### 6、激励视频广告
预加载激励视频广告
```Dart
await FlutterTencentad.loadRewardVideoAd(
    //广告id
    codeId: "5042816813706194",
);
```
显示激励视频广告
```dart
  await FlutterTencentad.showRewardVideoAd();
```
监听激励视频结果

```Dart
 FlutterTencentAdStream.initAdStream(
      //激励广告
      rewardAdCallBack: RewardAdCallBack(
        onShow: () {
          print("激励广告显示");
        },
        onClick: () {
          print("激励广告点击");
        },
        onFail: (code, message) {
          print("激励广告失败 $code $message");
        },
        onClose: () {
          print("激励广告关闭");
        },
        onReady: () async {
          print("激励广告预加载准备就绪");
          await FlutterTencentad.showRewardVideoAd();
        },
        onUnReady: () {
          print("激励广告预加载未准备就绪");
        },
        onVerify: (transId) {
          print("激励广告奖励  $transId");
        },
      ),
    );
```
#### 7、插屏广告
预加载插屏广告
```dart
await FlutterTencentad.loadUnifiedInterstitialAD(
    //广告id
    codeId: "9062813863614416",
    //是否全屏
    isFullScreen: false,
);
```

显示插屏广告
```dart
  await FlutterTencentad.showUnifiedInterstitialAD();
```

插屏广告结果监听
```dart
FlutterTencentAdStream.initAdStream(
  interactionAdCallBack: InteractionAdCallBack(
        onShow: () {
          print("插屏广告显示");
        },
        onClick: () {
          print("插屏广告点击");
        },
        onFail: (code, message) {
          print("插屏广告失败 $code $message");
        },
        onClose: () {
          print("插屏广告关闭");
        },
        onReady: () async {
          print("插屏广告预加载准备就绪");
          await FlutterTencentad.showUnifiedInterstitialAD();
        },
        onUnReady: () {
          print("插屏广告预加载未准备就绪");
        },
  ),
);
```

## 版本更新

[更新日志](https://github.com/gstory0404/flutter_tencentad/blob/master/CHANGELOG.md)


## 联系方式
* Email: gstory0404@gmail.com

* QQ群: <a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=4j2_yF1-pMl58y16zvLCFFT2HEmLf6vQ&jump_from=webapi"><img border="0" src="//pub.idqqimg.com/wpa/images/group.png" alt="649574038" title="flutter交流"></a>
