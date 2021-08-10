export 'flutter_tencentad_stream.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencentad/banner/banner_ad_view.dart';
import 'package:flutter_tencentad/splash/splash_ad_view.dart';

import 'express/express_ad_view.dart';

part 'flutter_tencentad_callback.dart';

part 'flutter_tencentad_code.dart.dart';

class FlutterTencentad {
  static const MethodChannel _channel =
      const MethodChannel('flutter_tencentad');

  ///
  /// # SDK注册初始化
  ///
  /// [appId] appId 必填
  ///
  static Future<bool> register({
    required String appId,
    bool? debug,
  }) async {
    return await _channel
        .invokeMethod("register", {"appId": appId, "debug": debug});
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
  /// [codeId] 广告ID
  ///
  static Future<bool> loadRewardVideoAd({
    required String codeId,
  }) async {
    return await _channel.invokeMethod("loadRewardVideoAd", {"codeId": codeId});
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
  /// [codeId] 广告ID
  ///
  ///  [isFullScreen] 是否全屏
  ///
  static Future<bool> loadUnifiedInterstitialAD(
      {required String codeId, required bool isFullScreen}) async {
    return await _channel.invokeMethod("loadUnifiedInterstitialAD", {
      "codeId": codeId,
      "isFullScreen": isFullScreen,
    });
  }

  ///
  /// # 显示新模板渲染插屏
  ///
  static Future<bool> showUnifiedInterstitialAD() async {
    return await _channel.invokeMethod("showUnifiedInterstitialAD", {});
  }

  ///
  /// # banner广告
  ///
  /// [codeId] banner广告id
  ///
  /// [viewWidth] 广告宽 单位dp
  ///
  /// [viewHeight] 广告高  单位dp   宽高比应该为6.4:1
  ///
  /// [callBack]  广告回调
  ///
  static Widget bannerAdView(
      {required String codeId,
      required double viewWidth,
      required double viewHeight,
      BannerAdCallBack? callBack}) {
    return BannerAdView(
      codeId: codeId,
      viewWidth: viewWidth,
      viewHeight: viewHeight,
      callBack: callBack,
    );
  }

  ///
  /// # 开屏广告
  ///
  /// [codeId] 开屏广告id
  ///
  /// [fetchDelay] 设置开屏广告从请求到展示所花的最大时长（并不是指广告曝光时长），
  /// 取值范围为[1500, 5000]ms。如果需要使用默认值，可以调用上一个构造方法，
  /// 或者给 fetchDelay 设为0。
  ///
  /// [callBack] 广告回调
  ///
  static Widget splashAdView(
      {required String codeId,
      required int fetchDelay,
      SplashAdCallBack? callBack}) {
    return SplashAdView(
      codeId: codeId,
      fetchDelay: fetchDelay,
      callBack: callBack,
    );
  }

  ///
  /// # 动态信息流/横幅/视频贴片广告
  ///
  /// [codeId] 广告id
  ///
  /// [viewWidth] 广告宽 单位dp
  ///
  /// [viewHeight] 广告高  单位dp
  ///
  /// [callBack] 回调事件
  ///
  static Widget expressAdView(
      {required String codeId,
      required int viewWidth,
      required int viewHeight,
      ExpressAdCallBack? callBack}) {
    return ExpressAdView(
      codeId: codeId,
      viewWidth: viewWidth,
      viewHeight: viewHeight,
      callBack: callBack,
    );
  }
}
