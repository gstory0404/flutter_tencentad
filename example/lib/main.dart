import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tencentad/flutter_tencentad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRegister = false;
  String _sdkVersion = "";

  @override
  void initState() {
    super.initState();
    _register();
  }

  ///初始化
  Future<void> _register() async {
    _isRegister =
        await FlutterTencentad.register(appId: "1200021532", debug: true);
    _sdkVersion = await FlutterTencentad.getSDKVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('优量汇SDK初始化: $_isRegister\n'),
              Text('SDK版本: $_sdkVersion\n'),
              //开屏广告
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('激励广告'),
                onPressed: () async {
                  await FlutterTencentad.loadRewardVideoAd(
                      codeId: "8002118728021979");
                },
              ),
              //插屏广告（半屏）
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('插屏广告（半屏）'),
                onPressed: () async {
                  await FlutterTencentad.loadUnifiedInterstitialAD(
                      codeId: "5062710728123927", isFullScreen: false);
                },
              ),
              //插屏广告（全屏）
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('插屏广告（全屏）'),
                onPressed: () async {
                  await FlutterTencentad.loadUnifiedInterstitialAD(
                      codeId: "6012914718424906", isFullScreen: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
