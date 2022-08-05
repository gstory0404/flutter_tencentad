# 腾讯优量汇(广点通)广告 Flutter版本

<p>
<a href="https://pub.flutter-io.cn/packages/flutter_tencentad"><img src=https://img.shields.io/badge/flutter_tencentad-v1.2.2-success></a>
</p>

## 简介
flutter_tencentad是一款集成了腾讯优量汇广告(广点通)Android和iOS SDK的Flutter插件,方便直接调用优量汇(广点通)广告SDK方法快速开发,[体验demo](https://www.pgyer.com/j7YB)

<img src="https://github.com/gstory0404/flutter_tencentad/blob/master/images/tencentad.gif" width="30%">


## 官方文档
* [Android](https://developers.adnet.qq.com/doc/android/access_doc)
* [IOS](https://developers.adnet.qq.com/doc/ios/guide)

## 版本更新

[更新日志](https://github.com/gstory0404/flutter_tencentad/blob/master/CHANGELOG.md)

## 本地环境
```
[✓] Flutter (Channel stable, 3.0.1, on macOS 12.4 21F79 darwin-x64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0-rc1)
[✓] Xcode - develop for iOS and macOS (Xcode 13.4)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.2)
[✓] IntelliJ IDEA Ultimate Edition (version 2022.1.1)
[✓] VS Code (version 1.67.1)
[✓] Connected device (4 available)
[✓] HTTP Host Availability
```

## 集成步骤
#### 1、pubspec.yaml
```Dart
flutter_tencentad: ^1.2.2
```
引入
```Dart
import 'package:flutter_tencentad/flutter_tencentad.dart';
```
#### 2、Android
SDK(4.482.1352)已配置插件中无需额外配置，只需要在android目录中AndroidManifest.xml配置

⚠️插件1.1.4以后不再默认集成权限，需手动配置
```Java
<manifest ···
    xmlns:tools="http://schemas.android.com/tools"
    ···>
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <application
        tools:replace="android:label">
```

#### 3、IOS

SDK(4.13.81)已配置插件中，其余根据文档配置。因为使用PlatformView，在Info.plist加入
```
 <key>io.flutter.embedded_views_preview</key>
    <true/>
```

## 使用

#### 1、SDK初始化
```Dart
await FlutterTencentad.register(
    androidId: "1200009850",//androidId
    iosId: "1200082163", //iosId
    debug: true, //是否显示日志log
    personalized: FlutterTencentadPersonalized.show,//是否显示个性化推荐广告
    channelId: FlutterTencentadChannel.other,//渠道id
);
```
#### 2、获取SDK版本
```Dart
await FlutterTencentad.getSDKVersion();
```

#### 3、开屏广告
```Dart
FlutterTencentad.splashAdView(
    //android广告id
    androidId: "4052216802299999",
    //ios广告id
    iosId: "8012030096434021",
    ////设置开屏广告从请求到展示所花的最大时长（并不是指广告曝光时长），取值范围为[1500, 5000]ms
    fetchDelay: 3000,
    //下载二次确认弹窗 默认false
    downloadConfirm: true,
    //广告回调
    callBack: FlutterTencentadSplashCallBack(
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
    //android广告id
    androidId: "8042711873318113",
    //ios广告id
    iosId: "6062430096832369",
    //广告宽 单位dp
    viewWidth: 500,
    //广告高  单位dp   宽高比应该为6.4:1
    viewHeight: 100,
    //下载二次确认弹窗 默认false
    downloadConfirm: true,
    // 广告回调
    callBack: FlutterTencentadBannerCallBack(
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
⚠️ android端信息流广告曝光异常
```
FlutterTencentad.expressAdView(
              //android广告id
              androidId: "3062711883122271",
              //ios广告id
              iosId: "4032136066438475",
              //广告宽 单位dp
              viewWidth: 400,
              //广告高  单位dp
              viewHeight: 300,
              //下载二次确认弹窗 默认false
               downloadConfirm: true,
              //回调事件
              callBack: FlutterTencentadExpressCallBack(
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
    //android广告id
    androidId: "5042816813706194",
    //ios广告id
    iosId: "8062535056034159",
    //用户id
    userID: "123",
    //奖励
    rewardName: "100金币",
    //奖励数
    rewardAmount: 100,
    //扩展参数 服务器回调使用
    customData: ""
    //下载二次确认弹窗 默认false
    downloadConfirm: true,
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
    flutterTencentadRewardCallBack: FlutterTencentadRewardCallBack(
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
         onVerify: (transId,rewardName,rewardAmount) {
          print("激励广告奖励  $transId   $rewardName   $rewardAmount");
        },
        onFinish: (){
          print("激励广告完成");
        }
      ),
    );
```
#### 7、插屏广告
预加载插屏广告
```dart
await FlutterTencentad.loadUnifiedInterstitialAD(
    //android广告id
    androidId: "9062813863614416",
    //ios广告id
    iosId: "1052938046031440",
    //是否全屏
    isFullScreen: false,
    //下载二次确认弹窗 默认false
    downloadConfirm: true,
);
```

显示插屏广告
```dart
  await FlutterTencentad.showUnifiedInterstitialAD();
```

插屏广告结果监听
```dart
FlutterTencentAdStream.initAdStream(
    flutterTencentadInteractionCallBack: FlutterTencentadInteractionCallBack(
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
        onVerify: (transId,rewardName,rewardAmount){
          print("广告奖励凭证id  $transId");
        },
  ),
);
```

#### 8、进入APP下载列表（仅android）
```dart
await FlutterTencentad.enterAPPDownloadListPage();
```

## 错误码

- [错误码1](https://developers.adnet.qq.com/doc/android/union/union_debug#sdk%20%E9%94%99%E8%AF%AF%E7%A0%81)
- [错误码2](https://developers.adnet.qq.com/backend/error_code.html)

## 插件链接

|插件|地址|
|:----|:----|
|穿山甲广告插件|[flutter_unionad](https://github.com/gstory0404/flutter_unionad)|
|腾讯优量汇广告插件|[flutter_tencentad](https://github.com/gstory0404/flutter_tencentad)|
|聚合广告插件|[flutter_universalad](https://github.com/gstory0404/flutter_universalad)|
|百度百青藤广告插件|[flutter_baiduad](https://github.com/gstory0404/flutter_baiduad)|
|字节穿山甲内容合作插件|[flutter_pangrowth](https://github.com/gstory0404/flutter_pangrowth)|
|文档预览插件|[file_preview](https://github.com/gstory0404/file_preview)|
|滤镜|[gpu_image](https://github.com/gstory0404/gpu_image)|

## 联系方式
* Email: gstory0404@gmail.com
* Blog：https://www.gstory.cn/

* QQ群: <a target="_blank" href="https://qm.qq.com/cgi-bin/qm/qr?k=4j2_yF1-pMl58y16zvLCFFT2HEmLf6vQ&jump_from=webapi"><img border="0" src="//pub.idqqimg.com/wpa/images/group.png" alt="649574038" title="flutter交流"></a>
