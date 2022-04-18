## 1.1.7
* 修复与flutter_pangrowth文件冲突问题

## 1.1.6
* 降低andorid编译版本

## 1.1.5
*Android sdk升级4.460.1330
*iOS sdk升级4.13.62

## 1.1.4
* android sdk升级4.441.1311聚合
* ios sdk升级4.13.41聚合

## 1.1.3
* 优化插屏激励广告

## 1.1.2
* 修复参数异常

## 1.1.1

* android sdk升级4.440.1310
* ios sdk升级4.13.40
* FlutterTencentad.register新增参数
```
  channelId 渠道id [FlutterTencentadChannel]
  personalized 是否开启个性化广告 [FlutterTencentadPersonalized]
```
* FlutterTencentadInteractionCallBack插屏广告回调新增激励奖励凭证id回调
```dart
FlutterTencentadInteractionCallBack(
    onVerify: (transId,rewardName,rewardAmount){
      print("广告奖励凭证id  $transId");
    }
),
```

## 1.1.0

* 1、ios部分使用OC重写
* 2、android sdk升级4.431.1301
* 3、ios sdk升级4.13.32

## 1.0.5

* 1、升级sdk版本


## 1.0.4

* 1、修复ios激励广告穿透参数


## 1.0.3

* 1、优化api
* 2、升级sdk版本


## 1.0.2

* 1、优化api
* 2、fix bug


## 1.0.1

* 1、新增激励广告扩展参数
* 2、fix bug

## 1.0.0

* 1、增加ios端广告
* 2、优化api

## 0.0.6

* 1、优化API

## 0.0.5

* 1、优化API

## 0.0.4

* 1、优化动态信息流/横幅/视频贴片广告加载方式

## 0.0.3

* 1、fix bug


## 0.0.2

* 1、完善android 激励广告、开屏广告、banner广告、动态信息流/横幅/视频贴片广告

## 0.0.1

* Describe initial release.