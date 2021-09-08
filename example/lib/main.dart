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
        onVerify: (transId,rewardName,rewardAmount) {
          print("激励广告奖励  $transId   $rewardName   $rewardAmount");
        },
        onExpose: () {
          print("激励广告曝光");
        },
        onFinish: (){
          print("激励广告完成");
        }
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
      ),
    );
  }

  ///初始化
  Future<void> _register() async {
    _isRegister = await FlutterTencentad.register(
      androidId: "1200009850",//androidId
      iosId: "1200082163", //iosId
      debug: true, //是否显示日志log
    );
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
                  androidId: "5042816813706194",
                  //ios广告id
                  iosId: "8062535056034159",
                  //用户id
                  userID: "123",
                  //奖励
                  rewardName: "100金币",
                  //奖励数
                  rewardAmount: 100,
                  //扩展参数 服务器回调使用
                  customData: ""
                );
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
                  androidId: "9062813863614416",
                  //ios广告id
                  iosId: "1052938046031440",
                  //是否全屏
                  isFullScreen: false,
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
                    androidId: "5022012853615967",
                    //ios广告id
                    iosId: "1082430066438422",
                    isFullScreen: true);
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
                  return new SplashPage();
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
