//
//  FlutterTencentadViewPlugin.swift
//  flutter_tencentad
//
//  Created by gstory on 2021/9/1.
//

import Foundation
import Flutter

class FlutterTencentadViewPlugin{
    static func register(viewRegistrar : FlutterPluginRegistrar){
       //banner广告
        let bannerAdViewFactory = BannerAdViewFactory(messenger: viewRegistrar.messenger())
        viewRegistrar.register(bannerAdViewFactory, withId: FlutterTencentadConfig.view.bannerAdView)
        //spalsh广告
        let splashAdViewFactory = SplashAdViewFactory(messenger: viewRegistrar.messenger())
        viewRegistrar.register(splashAdViewFactory, withId: FlutterTencentadConfig.view.splashAdView)
        //信息流广告
        let nativeAdviewFactory = NativeExpressAdViewFactory(messenger: viewRegistrar.messenger())
        viewRegistrar.register(nativeAdviewFactory, withId: FlutterTencentadConfig.view.nativeAdView)
    }
}
