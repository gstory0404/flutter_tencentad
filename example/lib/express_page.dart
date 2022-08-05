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
                //android广告id
                androidId: "4072918853903023",
                //ios广告id
                iosId: "6023578995600715",
                //广告宽 单位dp
                viewWidth: 400,
                //广告高  单位dp
                viewHeight: 300,
                //下载二次确认弹窗 默认false
                downloadConfirm: true,
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
                )),
            //横幅-平台模板2.0
            Text("横幅-平台模板2.0"),
            FlutterTencentad.expressAdView(
              //android广告id
              androidId: "4072918853903023",
              //ios广告id
              iosId: "6023578995600715",
              viewWidth: 228,
              viewHeight: 150,
              //下载二次确认弹窗 默认false
              downloadConfirm: true,
            ),
            //视频贴片
            Text("视频贴片"),
            FlutterTencentad.expressAdView(
              //android广告id
              androidId: "9013670915436201",
              //ios广告id
              iosId: "4033278955532222",
              viewWidth: 400,
              viewHeight: 300,
              //下载二次确认弹窗 默认false
              downloadConfirm: true,
            ),
          ],
        ),
      ),
    );
  }
}
