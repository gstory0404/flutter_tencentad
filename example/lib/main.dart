import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';
import 'package:flutter_tencentad_example/banner_page.dart';
import 'package:flutter_tencentad_example/express_page.dart';
import 'package:flutter_tencentad_example/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isRegister = false;
  String _sdkVersion = "";

  StreamSubscription? _adViewStream;

  @override
  void initState() {
    super.initState();
    _register();
    _adViewStream = FlutterTencentAdStream.initAdStream(
      //激励广告
      flutterTencentadRewardCallBack: FlutterTencentadRewardCallBack(
        onShow: () {
          print("激励广告显示");
        },
        onClick: () {
          print("激励广告点击");
        },
        onFail: (code, message) {
          print("激励广告失败 $code $message");
        },
        onClose: () {
          print("激励广告关闭");
        },
        onReady: () async {
          print("激励广告预加载准备就绪");
          await FlutterTencentad.showRewardVideoAd();
        },
        onUnReady: () {
          print("激励广告预加载未准备就绪");
        },
        onVerify: (transId, rewardName, rewardAmount) {
          print("激励广告奖励  $transId   $rewardName   $rewardAmount");
        },
        onExpose: () {
          print("激励广告曝光");
        },
        onFinish: () {
          print("激励广告完成");
        },
        onECPM: (ecpmLevel, ecpm) async {
          print("激励广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
          //规则 自己根据业务处理
          if (ecpm > 0) {
            //竞胜出价，类型为Integer
            //最大竞败方出价，类型为Integer
            await FlutterTencentad.showRewardVideoAd(
                result: FlutterTencentBiddingResult().success(ecpm, 0));
          } else {
            //竞胜方出价（单位：分），类型为Integer
            //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
            //竞胜方渠道ID FlutterTencentAdADNID
            await FlutterTencentad.showRewardVideoAd(
                result: FlutterTencentBiddingResult().fail(
                    1000,
                    FlutterTencentAdBiddingLossReason.LOW_PRICE,
                    FlutterTencentAdADNID.othoerADN));
          }
        },
      ),
      flutterTencentadInteractionCallBack: FlutterTencentadInteractionCallBack(
        onShow: () {
          print("插屏广告显示");
        },
        onClick: () {
          print("插屏广告点击");
        },
        onFail: (code, message) {
          print("插屏广告失败 $code $message");
        },
        onClose: () {
          print("插屏广告关闭");
        },
        onExpose: () {
          print("插屏广告曝光");
        },
        onReady: () async {
          print("插屏广告预加载准备就绪");
          await FlutterTencentad.showUnifiedInterstitialAD();
        },
        onUnReady: () {
          print("插屏广告预加载未准备就绪");
        },
        onVerify: (transId, rewardName, rewardAmount) {
          print("插屏广告奖励凭证id  $transId");
        },
        onECPM: (ecpmLevel, ecpm) async {
          print("插屏广告竞价  ecpmLevel=$ecpmLevel  ecpm=$ecpm");
          //规则 自己根据业务处理
          if (ecpm > 0) {
            //竞胜出价，类型为Integer
            //最大竞败方出价，类型为Integer
            await FlutterTencentad.showUnifiedInterstitialAD(
                result: FlutterTencentBiddingResult().success(ecpm, 0));
          } else {
            //竞胜方出价（单位：分），类型为Integer
            //优量汇广告竞败原因 FlutterTencentAdBiddingLossReason
            //竞胜方渠道ID FlutterTencentAdADNID
            await FlutterTencentad.showUnifiedInterstitialAD(
                result: FlutterTencentBiddingResult().fail(
                    1000,
                    FlutterTencentAdBiddingLossReason.LOW_PRICE,
                    FlutterTencentAdADNID.othoerADN));
          }
        },
      ),
    );
  }

  ///初始化
  Future<void> _register() async {
    _isRegister = await FlutterTencentad.register(
        //androidId
        androidId: "1211169508",
        //iosId
        iosId: "1211169509",
        //是否显示日志log
        debug: true,
        //是否显示个性化推荐广告
        personalized: FlutterTencentadPersonalized.show,
        //渠道id
        channelId: FlutterTencentadChannel.other,
        enableCollectAppInstallStatus: false,
        //安卓隐私合规 是否开启收集应用安装状态
        //安卓隐私设置
        androidPrivacy: {
          //false为关闭粗略地理位置获取，不设置或者设置为true为获取
          "cell_id": false,
          //优量汇SDK将不采集mac地址
          "mac_address": false,
          //false为关闭device_id获取，不设置或者设置为true为获取
          "device_id": false,
          //false为关闭android_id获取，不设置或者设置为true为获取
          "android_id": false,
          //false为关闭移动网络状态下获取IP地址，不设置或者设置为true为获取
          "mipaddr": false,
          //false为关闭WIFI状态下获取IP地址，不设置或者设置为true为获取
          "wipaddr": false,
          //禁用taid获取
          "taid": false,
          //禁用oaid获取
          "oaid": false
        },
        convOptimizelnfo: {
          //关闭应用安装监听状态
          "hieib": false
        });
    _sdkVersion = await FlutterTencentad.getSDKVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_tencentad'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('优量汇SDK初始化: $_isRegister\n'),
            Text('SDK版本: $_sdkVersion\n'),
            //激励广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('激励广告'),
              onPressed: () async {
                await FlutterTencentad.loadRewardVideoAd(
                  //android广告id
                  androidId: "8260663462736446",
                  //ios广告id
                  iosId: "2250968442134762",
                  //用户id
                  userID: "123",
                  //奖励
                  rewardName: "100金币",
                  //奖励数
                  rewardAmount: 100,
                  //扩展参数 服务器回调使用
                  customData: "",
                  //下载二次确认弹窗 默认false
                  downloadConfirm: true,
                  //是否静音播放 默认false
                  videoMuted: true,
                );
              },
            ),
            //激励广告 竞价
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('激励广告（竞价）'),
              onPressed: () async {
                await FlutterTencentad.loadRewardVideoAd(
                    //android广告id
                    androidId: "8260663462736446",
                    //ios广告id
                    iosId: "2250968442134762",
                    //用户id
                    userID: "123",
                    //奖励
                    rewardName: "100金币",
                    //奖励数
                    rewardAmount: 100,
                    //扩展参数 服务器回调使用
                    customData: "",
                    //下载二次确认弹窗 默认false
                    downloadConfirm: true,
                    //开启竞价
                    isBidding: true);
              },
            ),
            //插屏广告（半屏）
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('插屏广告（半屏）'),
              onPressed: () async {
                await FlutterTencentad.loadUnifiedInterstitialAD(
                  //android广告id
                  androidId: "6270368452032577",
                  //ios广告id
                  iosId: "8200166492635708",
                  //是否全屏
                  isFullScreen: false,
                  //下载二次确认弹窗 默认false
                  downloadConfirm: true,
                );
              },
            ),
            //插屏广告（全屏）
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('插屏广告（全屏）'),
              onPressed: () async {
                await FlutterTencentad.loadUnifiedInterstitialAD(
                  //android广告id
                  androidId: "6270368452032577",
                  //ios广告id
                  iosId: "8200166492635708",
                  isFullScreen: true,
                  //下载二次确认弹窗 默认false
                  downloadConfirm: true,
                );
              },
            ),
            //插屏广告（全屏）激励奖励
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('插屏广告（全屏）激励奖励'),
              onPressed: () async {
                await FlutterTencentad.loadUnifiedInterstitialAD(
                  //android广告id
                  androidId: "6270368452032577",
                  //ios广告id
                  iosId: "8200166492635708",
                  isFullScreen: true,
                  //下载二次确认弹窗 默认false
                  downloadConfirm: true,
                );
              },
            ),
            //插屏广告（半屏竞价）
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('插屏广告（半屏竞价）'),
              onPressed: () async {
                await FlutterTencentad.loadUnifiedInterstitialAD(
                  //android广告id
                  androidId: "4082654735526092",
                  //ios广告id
                  iosId: "6025576861231867",
                  isFullScreen: false,
                  //下载二次确认弹窗 默认false
                  downloadConfirm: true,
                  //是否开启竞价
                  isBidding: true,
                );
              },
            ),
            //Banner广告（平台模板）
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('Banner广告（平台模板）'),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return new BannerPage();
                }));
              },
            ),
            //开屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('开屏广告'),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return new SplashPage(
                      isBidding: false,
                      androidId: "7240264412639400",
                      iosId: "4210763402133659");
                }));
              },
            ),
            //开屏广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('开屏广告(竞价)'),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return new SplashPage(
                      //是否开启竞价
                      isBidding: true,
                      androidId: "7240264412639400",
                      iosId: "4210763402133659");
                }));
              },
            ),
            //动态信息流/横幅/视频贴片广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('动态信息流/横幅/视频贴片广告'),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return new ExpressPage();
                }));
              },
            ),
            //动态信息流/横幅/视频贴片广告
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('app下载列表'),
              onPressed: () async {
                await FlutterTencentad.enterAPPDownloadListPage();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _adViewStream?.cancel();
    super.dispose();
  }
}
