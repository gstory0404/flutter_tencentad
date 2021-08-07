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
    return Column(
      children: [
        FlutterTencentad.bannerAdView(codeId: "3092815749779875", viewWidth: 500, viewHeight: 100)
      ],
    );
  }
}
