import 'package:flutter/material.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';

///
/// Description: 描述
/// Author: Gstory
/// Email: gstory0404@gmail.com
/// CreateDate: 2021/8/7 18:09
///

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banner广告（平台模板）"),
      ),
      body: Column(
        children: [
          FlutterTencentad.bannerAdView(
            //android广告id
            androidId: "8042711873318113",
            //ios广告id
            iosId: "6062430096832369",
            //广告宽 单位dp
            viewWidth: 500,
            //广告高  单位dp   宽高比应该为6.4:1
            viewHeight: 100,
            // 广告回调
            callBack: FlutterTencentadBannerCallBack(
              onShow: () {
                print("Banner广告显示");
              },
              onFail: (code, message) {
                print("Banner广告错误 $code $message");
              },
              onClose: () {
                print("Banner广告关闭");
              },
              onExpose: () {
                print("Banner广告曝光");
              },
              onClick: () {
                print("Banner广告点击");
              },
            ),
          ),
          FlutterTencentad.bannerAdView(
              //android广告id
              androidId: "8042711873318113",
              //ios广告id
              iosId: "6062430096832369",
              viewWidth: 500,
              viewHeight: 200),
        ],
      ),
    );
  }
}
