package com.gstory.flutter_tencentad

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.gstory.flutter_tencentad.interstitialad.InterstitialAd
import com.gstory.flutter_tencentad.rewardvideoad.RewardVideoAd
import com.gstory.flutter_unionad.FlutterTencentAdEventPlugin
import com.qq.e.comm.DownloadService
import com.qq.e.comm.managers.GDTAdSdk
import com.qq.e.comm.managers.setting.GlobalSetting
import com.qq.e.comm.managers.status.SDKStatus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception

/** FlutterTencentadPlugin */
class FlutterTencentadPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var applicationContext: Context? = null
    private var mActivity: Activity? = null
    private var mFlutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
//        Log.e("FlutterUnionadPlugin->","onAttachedToActivity")
        FlutterTencentAdViewPlugin.registerWith(mFlutterPluginBinding!!, mActivity!!)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity
//        Log.e("FlutterUnionadPlugin->","onReattachedToActivityForConfigChanges")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mActivity = null
//        Log.e("FlutterUnionadPlugin->","onDetachedFromActivityForConfigChanges")
    }

    override fun onDetachedFromActivity() {
        mActivity = null
//        Log.e("FlutterUnionadPlugin->","onDetachedFromActivity")
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_tencentad")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
        mFlutterPluginBinding = flutterPluginBinding
        FlutterTencentAdEventPlugin().onAttachedToEngine(flutterPluginBinding)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        //注册初始化
        if (call.method == "register") {
            val appId = call.argument<String>("androidId")
            val debug = call.argument<Boolean>("debug")
            val channelId = call.argument<Int>("channelId")
            val personalized = call.argument<Int>("personalized")
            //日志
            LogUtil.setAppName("flutter_tencentad")
            LogUtil.setShow(debug!!)
            //是否开启个性化
            GlobalSetting.setPersonalizedState(personalized!!)
            //设置渠道id
            GlobalSetting.setChannel(channelId!!)
            GDTAdSdk.initWithoutStart(applicationContext, appId)
            GDTAdSdk.start(object : GDTAdSdk.OnStartListener {
                override fun onStartSuccess() {
                    result.success(true)
                }

                override fun onStartFailed(p0: Exception?) {
                    result.success(false)
                }

            })
            //获取sdk版本
        } else if (call.method == "getSDKVersion") {
            result.success(SDKStatus.getIntegrationSDKVersion())
            //预加载激励广告
        } else if (call.method == "loadRewardVideoAd") {
            RewardVideoAd.init(applicationContext!!, call.arguments as Map<*, *>)
            result.success(true)
            //展示激励广告
        } else if (call.method == "showRewardVideoAd") {
            RewardVideoAd.showAd(call.arguments as Map<*, *>)
            result.success(true)
            //预加载插屏广告
        } else if (call.method == "loadInterstitialAD") {
            InterstitialAd.init(mActivity!!, call.arguments as Map<*, *>)
            result.success(true)
            //展示插屏广告
        } else if (call.method == "showInterstitialAD") {
            InterstitialAd.showAd(call.arguments as Map<*, *>)
            result.success(true)
            //进入下载列表
        } else if (call.method == "enterAPPDownloadListPage") {
            DownloadService.enterAPPDownloadListPage(mActivity)
            result.success(true)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
