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
      {RewardAdCallBack? rewardAdCallBack,
      InteractionAdCallBack? interactionAdCallBack}) {
    StreamSubscription _adStream =
        adEventEvent.receiveBroadcastStream().listen((data) {
      switch (data[AdType.adType]) {

        ///激励广告
        case AdType.rewardAd:
          switch (data[OnAdMethod.onAdMethod]) {
            case OnAdMethod.onShow:
              rewardAdCallBack?.onShow!();
              break;
            case OnAdMethod.onClose:
              rewardAdCallBack?.onClose!();
              break;
            case OnAdMethod.onFail:
              rewardAdCallBack?.onFail!(data["code"], data["message"]);
              break;
            case OnAdMethod.onClick:
              rewardAdCallBack?.onClick!();
              break;
            case OnAdMethod.onVerify:
              rewardAdCallBack?.onVerify!(data["transId"]);
              break;
            case OnAdMethod.onFinish:
              rewardAdCallBack?.onFinish!();
              break;
            case OnAdMethod.onReady:
              rewardAdCallBack?.onReady!();
              break;
            case OnAdMethod.onUnReady:
              rewardAdCallBack?.onUnReady!();
              break;
          }
          break;
          ///插屏广告
        case AdType.interactAd:
          switch (data[OnAdMethod.onAdMethod]) {
            case OnAdMethod.onShow:
              interactionAdCallBack?.onShow!();
              break;
            case OnAdMethod.onClose:
              interactionAdCallBack?.onClose!();
              break;
            case OnAdMethod.onFail:
              interactionAdCallBack?.onFail!(data["code"], data["message"]);
              break;
            case OnAdMethod.onClick:
              interactionAdCallBack?.onClick!();
              break;
            case OnAdMethod.onReady:
              interactionAdCallBack?.onReady!();
              break;
            case OnAdMethod.onUnReady:
              interactionAdCallBack?.onUnReady!();
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
