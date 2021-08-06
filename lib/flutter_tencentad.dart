import 'dart:async';

import 'package:flutter/services.dart';

class FlutterTencentad {
  static const MethodChannel _channel =
      const MethodChannel('flutter_tencentad');

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

  /// # 获取SDK版本号
  static Future<String> getSDKVersion() async {
    return await _channel.invokeMethod("getSDKVersion");
  }

  /// # 激励视频广告预加载
  ///
  /// [codeId] 广告ID
  ///
  static  Future<bool> loadRewardVideoAd({
    required String codeId,
  }) async {
    return await _channel.invokeMethod("loadRewardVideoAd", {"codeId": codeId});
  }

  ///显示激励广告
  static Future<bool> showRewardVideoAd() async {
    return await _channel.invokeMethod("showRewardVideoAd", {});
  }
}
