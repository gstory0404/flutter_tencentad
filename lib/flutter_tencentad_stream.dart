import 'dart:async';
import 'package:flutter/services.dart';
import 'flutter_tencentad.dart';

/// @Author: gstory
/// @CreateDate: 2021/8/9 9:30 下午
/// @Description: dart类作用描述

const EventChannel tencentAdEventEvent =
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
      FlutterTencentadInteractionCallBack?
          flutterTencentadInteractionCallBack}) {
    StreamSubscription _adStream =
        tencentAdEventEvent.receiveBroadcastStream().listen((data) {
      print("$data");
      switch (data[FlutterTencentadType.adType]) {
        ///激励广告
        case FlutterTencentadType.rewardAd:
          switch (data[FlutterTencentadMethod.onAdMethod]) {
            case FlutterTencentadMethod.onShow:
              if (flutterTencentadRewardCallBack?.onShow != null) {
                flutterTencentadRewardCallBack?.onShow!();
              }
              break;
            case FlutterTencentadMethod.onClose:
              if (flutterTencentadRewardCallBack?.onClose != null) {
                flutterTencentadRewardCallBack?.onClose!();
              }
              break;
            case FlutterTencentadMethod.onFail:
              if (flutterTencentadRewardCallBack?.onFail != null) {
                flutterTencentadRewardCallBack?.onFail!(
                    data["code"], data["message"]);
              }
              break;
            case FlutterTencentadMethod.onClick:
              if (flutterTencentadRewardCallBack?.onClick != null) {
                flutterTencentadRewardCallBack?.onClick!();
              }
              break;
            case FlutterTencentadMethod.onVerify:
              if (flutterTencentadRewardCallBack?.onVerify != null) {
                flutterTencentadRewardCallBack?.onVerify!(
                    data["transId"], data["rewardName"], data["rewardAmount"]);
              }
              break;
            case FlutterTencentadMethod.onFinish:
              if (flutterTencentadRewardCallBack?.onFinish != null) {
                flutterTencentadRewardCallBack?.onFinish!();
              }
              break;
            case FlutterTencentadMethod.onReady:
              if (flutterTencentadRewardCallBack?.onReady != null) {
                flutterTencentadRewardCallBack?.onReady!();
              }
              break;
            case FlutterTencentadMethod.onUnReady:
              if (flutterTencentadRewardCallBack?.onUnReady != null) {
                flutterTencentadRewardCallBack?.onUnReady!();
              }
              break;
            case FlutterTencentadMethod.onExpose:
              if (flutterTencentadRewardCallBack?.onExpose != null) {
                flutterTencentadRewardCallBack?.onExpose!();
              }
              break;
            case FlutterTencentadMethod.onECPM:
              if (flutterTencentadRewardCallBack?.onECPM != null) {
                flutterTencentadRewardCallBack?.onECPM!(
                    data["ecpmLevel"], data["ecpm"]);
              }
              break;
          }
          break;

        ///插屏广告
        case FlutterTencentadType.interactAd:
          switch (data[FlutterTencentadMethod.onAdMethod]) {
            case FlutterTencentadMethod.onShow:
              if (flutterTencentadInteractionCallBack?.onShow != null) {
                flutterTencentadInteractionCallBack?.onShow!();
              }
              break;
            case FlutterTencentadMethod.onClose:
              if (flutterTencentadInteractionCallBack?.onClose != null) {
                flutterTencentadInteractionCallBack?.onClose!();
              }
              break;
            case FlutterTencentadMethod.onFail:
              if (flutterTencentadInteractionCallBack?.onFail != null) {
                flutterTencentadInteractionCallBack?.onFail!(
                    data["code"], data["message"]);
              }
              break;
            case FlutterTencentadMethod.onClick:
              if (flutterTencentadInteractionCallBack?.onClick != null) {
                flutterTencentadInteractionCallBack?.onClick!();
              }
              break;
            case FlutterTencentadMethod.onExpose:
              if (flutterTencentadInteractionCallBack?.onExpose != null) {
                flutterTencentadInteractionCallBack?.onExpose!();
              }
              break;
            case FlutterTencentadMethod.onReady:
              if (flutterTencentadInteractionCallBack?.onReady != null) {
                flutterTencentadInteractionCallBack?.onReady!();
              }
              break;
            case FlutterTencentadMethod.onUnReady:
              if (flutterTencentadInteractionCallBack?.onUnReady != null) {
                flutterTencentadInteractionCallBack?.onUnReady!();
              }
              break;
            case FlutterTencentadMethod.onVerify:
              if (flutterTencentadInteractionCallBack?.onVerify != null) {
                flutterTencentadInteractionCallBack?.onVerify!(
                    data["transId"], "", 0);
              }
              break;
            case FlutterTencentadMethod.onECPM:
              if (flutterTencentadInteractionCallBack?.onECPM != null) {
                flutterTencentadInteractionCallBack?.onECPM!(
                    data["ecpmLevel"], data["ecpm"]);
              }
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
