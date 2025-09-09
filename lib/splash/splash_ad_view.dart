import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';

///
/// Description: 描述
/// Author: Gstory
/// Email: gstory0404@gmail.com
/// CreateDate: 2021/8/7 17:33
///
class SplashAdView extends StatefulWidget {
  final String androidId;
  final String iosId;
  final int fetchDelay;
  final FlutterTencentadSplashCallBack? callBack;
  final bool downloadConfirm;
  final bool isBidding;
  final FlutterTencentAdBiddingController? bidding;

  const SplashAdView({
    Key? key,
    required this.androidId,
    required this.iosId,
    required this.fetchDelay,
    this.callBack,
    required this.downloadConfirm,
    required this.isBidding,
    this.bidding,
  }) : super(key: key);

  @override
  _SplashAdViewState createState() => _SplashAdViewState();
}

class _SplashAdViewState extends State<SplashAdView> {
  String _viewType = "com.gstory.flutter_tencentad/SplashAdView";

  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;

  @override
  void initState() {
    super.initState();
    _isShowAd = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "androidId": widget.androidId,
            "fetchDelay": widget.fetchDelay,
            "downloadConfirm": widget.downloadConfirm,
            "isBidding": widget.isBidding,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "iosId": widget.iosId,
            "fetchDelay": widget.fetchDelay,
            "isBidding": widget.isBidding,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else {
      return Container();
    }
  }

  //注册cannel
  void _registerChannel(int id) {
    _channel = MethodChannel("${_viewType}_$id");
    _channel?.setMethodCallHandler(_platformCallHandler);
    widget.bidding?.init(_channel);
  }

  //监听原生view传值
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    print("${call.method} : ${call.arguments}");
    switch (call.method) {
      //显示广告
      case FlutterTencentadMethod.onShow:
        widget.callBack?.onShow!();
        if (mounted) {
          setState(() {
            _isShowAd = true;
          });
        }
        break;
      //关闭
      case FlutterTencentadMethod.onClose:
        widget.callBack?.onClose!();
        break;
      //广告加载失败
      case FlutterTencentadMethod.onFail:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        Map map = call.arguments;
        widget.callBack?.onFail!(map["code"], map["message"]);
        break;
      //点击
      case FlutterTencentadMethod.onClick:
        widget.callBack?.onClick!();
        break;
      //曝光
      case FlutterTencentadMethod.onExpose:
        widget.callBack?.onExpose!();
        break;
      //倒计时
      case FlutterTencentadMethod.onADTick:
        widget.callBack?.onADTick!(call.arguments);
        break;
      //竞价
      case FlutterTencentadMethod.onECPM:
        Map map = call.arguments;
        widget.callBack?.onECPM!(map["ecpmLevel"], map["ecpm"]);
        break;
    }
  }
}
