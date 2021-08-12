import 'dart:async';

import 'package:flutter/services.dart';

import 'flutter_tencentad.dart';

/// @Author: gstory
/// @CreateDate: 2021/8/9 9:30 下午
/// @Description: dart类作用描述

const EventChannel adEventEvent =
    EventChannel("com.gstory.flutter_tencentad/adevent");

class FlutterTencentAdStream {
  ///
  /// # 注册stream监听原生返回的信息
  ///
  /// [rewardAdCallBack] 激励广告回调
  ///
  /// [interactionAdCallBack] 插屏广告回调
  ///
  static StreamSubscription initAdStream(
      {FlutterTencentadRewardCallBack? flutterTencentadRewardCallBack,
        FlutterTencentadInteractionCallBack? flutterTencentadInteractionCallBack}) {
    StreamSubscription _adStream =
        adEventEvent.receiveBroadcastStream().listen((data) {
      switch (data[FlutterTencentadType.adType]) {

        ///激励广告
        case FlutterTencentadType.rewardAd:
          switch (data[FlutterTencentadMethod.onAdMethod]) {
            case FlutterTencentadMethod.onShow:
              flutterTencentadRewardCallBack?.onShow!();
              break;
            case FlutterTencentadMethod.onClose:
              flutterTencentadRewardCallBack?.onClose!();
              break;
            case FlutterTencentadMethod.onFail:
              flutterTencentadRewardCallBack?.onFail!(data["code"], data["message"]);
              break;
            case FlutterTencentadMethod.onClick:
              flutterTencentadRewardCallBack?.onClick!();
              break;
            case FlutterTencentadMethod.onVerify:
              flutterTencentadRewardCallBack?.onVerify!(data["transId"]);
              break;
            case FlutterTencentadMethod.onFinish:
              flutterTencentadRewardCallBack?.onFinish!();
              break;
            case FlutterTencentadMethod.onReady:
              flutterTencentadRewardCallBack?.onReady!();
              break;
            case FlutterTencentadMethod.onUnReady:
              flutterTencentadRewardCallBack?.onUnReady!();
              break;
          }
          break;
          ///插屏广告
        case FlutterTencentadType.interactAd:
          switch (data[FlutterTencentadMethod.onAdMethod]) {
            case FlutterTencentadMethod.onShow:
              flutterTencentadInteractionCallBack?.onShow!();
              break;
            case FlutterTencentadMethod.onClose:
              flutterTencentadInteractionCallBack?.onClose!();
              break;
            case FlutterTencentadMethod.onFail:
              flutterTencentadInteractionCallBack?.onFail!(data["code"], data["message"]);
              break;
            case FlutterTencentadMethod.onClick:
              flutterTencentadInteractionCallBack?.onClick!();
              break;
            case FlutterTencentadMethod.onReady:
              flutterTencentadInteractionCallBack?.onReady!();
              break;
            case FlutterTencentadMethod.onUnReady:
              flutterTencentadInteractionCallBack?.onUnReady!();
              break;
          }
          break;
      }
    });
    return _adStream;
  }

  static void deleteAdStream(StreamSubscription stream) {
    stream.cancel();
  }
}
