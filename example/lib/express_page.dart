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
  FlutterTencentAdBiddingController _bidding =
      new FlutterTencentAdBiddingController();

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
                iosId: "3014655729431161",
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
            //视频贴片
            Text("视频贴片"),
            FlutterTencentad.expressAdView(
              //android广告id
              androidId: "9013670915436201",
              //ios广告id
              iosId: "3074950769039285",
              viewWidth: 400,
              viewHeight: 300,
              //下载二次确认弹窗 默认false
              downloadConfirm: true,
            ),
            //竞价信息流
            Text("动态信息流（竞价）"),
            FlutterTencentad.expressAdView(
              //android广告id
              androidId: "4033498034524284",
              //ios广告id
              iosId: "4033278955532222",
              viewWidth: 400,
              viewHeight: 300,
              //下载二次确认弹窗 默认false
              downloadConfirm: true,
              //是否开启竞价模式
              isBidding: true,
              bidding: _bidding,
              //回调事件
              callBack: FlutterTencentadExpressCallBack(onShow: () {
                print("动态信息流广告显示");
              }, onFail: (code, message) {
                print("动态信息流广告错误 $code $message");
              }, onClose: () {
                print("动态信息流广告关闭");
              }, onExpose: () {
                print("动态信息流广告曝光");
              }, onClick: () {
                print("动态信息流广告点击");
              }, onECPM: (ecpmLevel, ecpm) {
                print("动态信息流广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
                //规则 自己根据业务处理
                if (ecpm > 0) {
                  //竞胜出价，类型为Integer
                  //最大竞败方出价，类型为Integer
                  _bidding.biddingResult(
                      FlutterTencentBiddingResult().success(ecpm, 0));
                } else {
                  //竞胜方出价（单位：分），类型为Integer
                  //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
                  //竞胜方渠道ID FlutterTencentAdADNID
                  _bidding.biddingResult(FlutterTencentBiddingResult().fail(
                      1000,
                      FlutterTencentAdBiddingLossReason.LOW_PRICE,
                      FlutterTencentAdADNID.othoerADN));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
