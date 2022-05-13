package com.gstory.flutter_tencentad.splashad

import android.app.Activity
import android.content.Context
import com.gstory.flutter_tencentad.bannerad.BannerAdView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class SplashAdViewFactory (private val messenger: BinaryMessenger, private val activity: Activity) : PlatformViewFactory(
        StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<String?, Any?>
        return SplashAdView(activity,messenger, viewId, params)
    }
}