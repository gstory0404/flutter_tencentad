export 'flutter_tencentad_stream.dart';
export 'flutter_tencentad_code.dart.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencentad/banner/banner_ad_view.dart';
import 'package:flutter_tencentad/splash/splash_ad_view.dart';
import 'flutter_tencentad_code.dart.dart';

import 'express/express_ad_view.dart';

part 'flutter_tencentad_callback.dart';

class FlutterTencentad {
  static const MethodChannel _channel =
      const MethodChannel('flutter_tencentad');

  ///
  /// # SDK注册初始化
  ///
  /// [androidId] androidId 必填
  ///
  /// [iosId] iosId 必填
  ///
  /// [channelId] channelId 渠道id [FlutterTencentadChannel]
  ///
  /// [personalized] personalized 是否开启个性化广告 [FlutterTencentadPersonalized]
  ///
  static Future<bool> register({
    required String androidId,
    required String iosId,
    int? personalized,
    bool? debug,
    int? channelId,
  }) async {
    return await _channel.invokeMethod("register", {
      "androidId": androidId,
      "iosId": iosId,
      "debug": debug ?? false,
      "channelId": channelId ?? FlutterTencentadChannel.other,
      "personalized": personalized ?? FlutterTencentadPersonalized.show,
    });
  }

  ///
  /// # 获取SDK版本号
  ///
  static Future<String> getSDKVersion() async {
    return await _channel.invokeMethod("getSDKVersion");
  }

  ///
  /// # 激励视频广告预加载
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  /// [rewardName] 奖励名称
  ///
  /// [rewardAmount] 奖励金额
  ///
  /// [userID] 用户id
  ///
  /// [customData] 扩展参数，服务器回调使用
  ///
  static Future<bool> loadRewardVideoAd({
    required String androidId,
    required String iosId,
    required String rewardName,
    required int rewardAmount,
    required String userID,
    String? customData,
  }) async {
    return await _channel.invokeMethod("loadRewardVideoAd", {
      "androidId": androidId,
      "iosId": iosId,
      "rewardName": rewardName,
      "rewardAmount": rewardAmount,
      "userID": userID,
      "customData": customData ?? "",
    });
  }

  ///
  /// # 显示激励广告
  ///
  static Future<bool> showRewardVideoAd() async {
    return await _channel.invokeMethod("showRewardVideoAd", {});
  }

  ///
  /// # 预加载插屏广告
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  ///  [isFullScreen] 是否全屏
  ///
  static Future<bool> loadUnifiedInterstitialAD({
    required String androidId,
    required String iosId,
    required bool isFullScreen,
  }) async {
    return await _channel.invokeMethod("loadInterstitialAD", {
      "androidId": androidId,
      "iosId": iosId,
      "isFullScreen": isFullScreen,
    });
  }

  ///
  /// # 显示新模板渲染插屏
  ///
  static Future<bool> showUnifiedInterstitialAD() async {
    return await _channel.invokeMethod("showInterstitialAD", {});
  }

  ///
  /// # banner广告
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  /// [viewWidth] 广告宽 单位dp
  ///
  /// [viewHeight] 广告高  单位dp   宽高比应该为6.4:1
  ///
  /// [FlutterTencentAdBannerCallBack]  广告回调
  ///
  static Widget bannerAdView(
      { required String androidId,
        required String iosId,
      required double viewWidth,
      required double viewHeight,
      FlutterTencentadBannerCallBack? callBack}) {
    return BannerAdView(
      androidId: androidId,
      iosId: iosId,
      viewWidth: viewWidth,
      viewHeight: viewHeight,
      callBack: callBack,
    );
  }

  ///
  /// # 开屏广告
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  /// [fetchDelay] 设置开屏广告从请求到展示所花的最大时长（并不是指广告曝光时长），
  /// 取值范围为[1500, 5000]ms。如果需要使用默认值，可以调用上一个构造方法，
  /// 或者给 fetchDelay 设为0。
  ///
  /// [FlutterTencentAdSplashCallBack] 广告回调
  ///
  static Widget splashAdView(
      {required String androidId,
        required String iosId,
      required int fetchDelay,
      FlutterTencentadSplashCallBack? callBack}) {
    return SplashAdView(
      androidId: androidId,
      iosId: iosId,
      fetchDelay: fetchDelay,
      callBack: callBack,
    );
  }

  ///
  /// # 动态信息流/横幅/视频贴片广告
  ///
  /// [androidId] android广告ID
  ///
  /// [iosId] ios广告ID
  ///
  /// [viewWidth] 广告宽 单位dp
  ///
  /// [viewHeight] 广告高  单位dp
  ///
  /// [FlutterTencentAdExpressCallBack] 回调事件
  ///
  static Widget expressAdView(
      {required String androidId,
        required String iosId,
      required int viewWidth,
      required int viewHeight,
      FlutterTencentadExpressCallBack? callBack}) {
    return ExpressAdView(
      androidId: androidId,
      iosId: iosId,
      viewWidth: viewWidth,
      viewHeight: viewHeight,
      callBack: callBack,
    );
  }
}
