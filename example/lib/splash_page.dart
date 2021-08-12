import 'package:flutter/material.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';

///
/// Description: 描述
/// Author: Gstory
/// Email: gstory0404@gmail.com
/// CreateDate: 2021/8/7 18:09
///

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlutterTencentad.splashAdView(
          //广告id
          codeId: "4052216802299999",
          ////设置开屏广告从请求到展示所花的最大时长（并不是指广告曝光时长），取值范围为[1500, 5000]ms
          fetchDelay: 3000,
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
      ),
    );
  }
}
