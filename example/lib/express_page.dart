import 'package:flutter/material.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';

///
/// Description: 描述
/// Author: Gstory
/// Email: gstory0404@gmail.com
/// CreateDate: 2021/8/7 18:09
///

class ExpressPage extends StatefulWidget {
  const ExpressPage({Key? key}) : super(key: key);

  @override
  _ExpressPageState createState() => _ExpressPageState();
}

class _ExpressPageState extends State<ExpressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动态信息流/横幅/视频贴片广告"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //动态信息流-原生-平台模板2.0
            Text("动态信息流/横幅/视频贴片广告"),
            FlutterTencentad.expressAdView(
              //广告id
              codeId: "4072918853903023",
              //广告宽 单位dp
              viewWidth: 400,
              //广告高  单位dp
              viewHeight: 300,
              //回调事件
              callBack: FlutterTencentadExpressCallBack(
                onShow: () {
                  print("动态信息流广告显示");
                },
                onFail: (code, message) {
                  print("动态信息流广告错误 $code $message");
                },
                onClose: () {
                  print("动态信息流广告关闭");
                },
                onExpose: () {
                  print("动态信息流广告曝光");
                },
                onClick: () {
                  print("动态信息流广告点击");
                },
              )
            ),
            //横幅-平台模板2.0
            Text("横幅-平台模板2.0"),
            FlutterTencentad.expressAdView(
              codeId: "4052216802299999",
              viewWidth: 228,
              viewHeight: 150,
            ),
            //视频贴片
            Text("视频贴片"),
            FlutterTencentad.expressAdView(
              codeId: "3062711883122271",
              viewWidth: 400,
              viewHeight: 300,
            ),
          ],
        ),
      ),
    );
  }
}
