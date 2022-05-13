package com.gstory.flutter_tencentad.bannerad

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * @Description: 描述
 * @Author: gstory
 * @CreateDate: 2021/8/7 17:42
 **/

internal class BannerAdViewFactory(private val messenger: BinaryMessenger, private val activity: Activity) : PlatformViewFactory(
    StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<String?, Any?>
        return BannerAdView(activity,messenger, viewId, params)
    }
}