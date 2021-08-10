package com.gstory.flutter_tencentad

import android.app.Activity
import com.gstory.flutter_tencentad.bannerad.BannerAdViewFactory
import com.gstory.flutter_tencentad.expressad.NativeExpressAdViewFactory
import com.gstory.flutter_tencentad.splashad.SplashAdViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * @Description:
 * @Author: gstory0404@gmail
 * @CreateDate: 2021/8/7 11:38
 */

object FlutterTencentAdViewPlugin {
    fun registerWith(binding: FlutterPlugin.FlutterPluginBinding, activity: Activity) {
        //注册banner广告
        binding.platformViewRegistry.registerViewFactory(FlutterTencentAdConfig.bannerAdView, BannerAdViewFactory(binding.binaryMessenger, activity))
        //注册splash广告
        binding.platformViewRegistry.registerViewFactory(FlutterTencentAdConfig.splashAdView, SplashAdViewFactory(binding.binaryMessenger,activity))
        //注册Express广告
        binding.platformViewRegistry.registerViewFactory(FlutterTencentAdConfig.nativeExpressAdView, NativeExpressAdViewFactory(binding.binaryMessenger,activity))
    }
}