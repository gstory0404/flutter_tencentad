package com.gstory.flutter_tencentad

import android.content.Context
import androidx.annotation.NonNull
import com.gstory.flutter_tencentad.rewardvideoad.RewardVideoAd
import com.qq.e.comm.managers.GDTADManager
import com.qq.e.comm.managers.status.SDKStatus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterTencentadPlugin */
class FlutterTencentadPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private var applicationContext: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_tencentad")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        //注册初始化
        if (call.method == "register") {
            val appId = call.argument<String>("appId")
            val debug = call.argument<Boolean>("debug")
            GDTADManager.getInstance().initWith(applicationContext, appId)
            LogUtil.setAppName("flutter_tencentad")
            LogUtil.setShow(debug!!)
            result.success(GDTADManager.getInstance().isInitialized)
            //获取sdk版本
        } else if (call.method == "getSDKVersion") {
            result.success("${SDKStatus.getSDKVersion()}.${GDTADManager.getInstance().pm.pluginVersion}")
        } else if (call.method == "loadRewardVideoAd") {
            RewardVideoAd.init(applicationContext!!,call.arguments as Map<*, *>)
            result.success(true)
        } else if (call.method == "showRewardVideoAd") {
            RewardVideoAd.showAd()
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
