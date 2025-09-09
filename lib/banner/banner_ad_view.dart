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
class BannerAdView extends StatefulWidget {
  final String androidId;
  final String iosId;
  final double viewWidth;
  final double viewHeight;
  final FlutterTencentadBannerCallBack? callBack;
  final bool downloadConfirm;
  final bool isBidding;
  final FlutterTencentAdBiddingController? bidding;

  const BannerAdView({
    Key? key,
    required this.androidId,
    required this.iosId,
    required this.viewWidth,
    required this.viewHeight,
    this.callBack,
    required this.downloadConfirm,
    required this.isBidding,
    this.bidding,
  }) : super(key: key);

  @override
  _BannerAdViewState createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAdView> {
  String _viewType = "com.gstory.flutter_tencentad/BannerAdView";

  MethodChannel? _channel;

  //广告是否显示
  bool _isShowAd = true;

  double _width = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _width = widget.viewWidth;
    _height = widget.viewHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShowAd) {
      return Container();
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        width: _width,
        height: _height,
        child: AndroidView(
          viewType: _viewType,
          creationParams: {
            "androidId": widget.androidId,
            "viewWidth": widget.viewWidth,
            "viewHeight": widget.viewHeight,
            "downloadConfirm": widget.downloadConfirm,
            "isBidding": widget.isBidding,
          },
          onPlatformViewCreated: _registerChannel,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Container(
        width: _width,
        height: _height,
        child: UiKitView(
          viewType: _viewType,
          creationParams: {
            "iosId": widget.iosId,
            "viewWidth": widget.viewWidth,
            "viewHeight": widget.viewHeight,
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
        Map map = call.arguments;
        if (mounted) {
          setState(() {
            _width = map["width"];
            _height = map["height"];
            _isShowAd = true;
          });
        }
        widget.callBack?.onShow!();
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
      //关闭
      case FlutterTencentadMethod.onClose:
        if (mounted) {
          setState(() {
            _isShowAd = false;
          });
        }
        widget.callBack?.onClose!();
        break;
      //竞价
      case FlutterTencentadMethod.onECPM:
        Map map = call.arguments;
        widget.callBack?.onECPM!(map["ecpmLevel"], map["ecpm"]);
        break;
    }
  }
}
