package com.gstory.flutter_tencentad

import android.app.Activity
import com.gstory.flutter_tencentad.bannerad.BannerAdViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * @Description:
 * @Author: gstory0404@gmail
 * @CreateDate: 2021/8/7 11:38
 */

object FlutterTencentAdViewPlugin {
    fun registerWith(binding: FlutterPlugin.FlutterPluginBinding, activity : Activity) {
        //注册banner广告
        binding.platformViewRegistry.registerViewFactory(FlutterTencentAdConfig.bannerAdView, BannerAdViewFactory(binding.binaryMessenger,activity))
    }
}