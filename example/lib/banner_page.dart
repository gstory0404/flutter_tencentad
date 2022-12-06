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
  FlutterTencentAdBiddingController _bidding =
      new FlutterTencentAdBiddingController();

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
            iosId: "5004358713683949",
            //广告宽 单位dp
            viewWidth: 640,
            //广告高  单位dp   宽高比应该为6.4:1
            viewHeight: 100,
            //下载二次确认弹窗 默认false
            downloadConfirm: true,
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
            iosId: "5004358713683949",
            //广告宽 单位dp
            viewWidth: 640,
            //广告高  单位dp   宽高比应该为6.4:1
            viewHeight: 60,
            //下载二次确认弹窗 默认false
            downloadConfirm: true,
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
          //竞价banner
          // FlutterTencentad.bannerAdView(
          //   //android广告id
          //   androidId: "3093291064428297",
          //   //ios广告id
          //   iosId: "3093291064428297",
          //   viewWidth: 500,
          //   viewHeight: 100,
          //   isBidding: true,
          //   bidding: _bidding,
          //   // 广告回调
          //   callBack: FlutterTencentadBannerCallBack(onShow: () {
          //     print("Banner广告显示");
          //   }, onFail: (code, message) {
          //     print("Banner广告错误 $code $message");
          //   }, onClose: () {
          //     print("Banner广告关闭");
          //   }, onExpose: () {
          //     print("Banner广告曝光");
          //   }, onClick: () {
          //     print("Banner广告点击");
          //   }, onECPM: (ecpmLevel, ecpm) {
          //     print("Banner广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
          //     //规则 自己根据业务处理
          //     if (ecpm > 0) {
          //       //竞胜出价，类型为Integer
          //       //最大竞败方出价，类型为Integer
          //       _bidding.biddingResult(
          //           FlutterTencentBiddingResult().success(ecpm, 0));
          //     } else {
          //       //竞胜方出价（单位：分），类型为Integer
          //       //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
          //       //竞胜方渠道ID FlutterTencentAdADNID
          //       _bidding.biddingResult(FlutterTencentBiddingResult().fail(
          //           1000,
          //           FlutterTencentAdBiddingLossReason.LOW_PRICE,
          //           FlutterTencentAdADNID.othoerADN));
          //     }
          //   }),
          // ),
        ],
      ),
    );
  }
}
