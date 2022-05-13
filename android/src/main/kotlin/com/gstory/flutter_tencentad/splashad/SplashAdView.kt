package com.gstory.flutter_tencentad.splashad

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.gstory.flutter_tencentad.DownloadApkConfirmDialog
import com.gstory.flutter_tencentad.DownloadConfirmHelper
import com.gstory.flutter_tencentad.FlutterTencentAdConfig
import com.gstory.flutter_tencentad.LogUtil
import com.qq.e.ads.splash.SplashAD
import com.qq.e.ads.splash.SplashADListener
import com.qq.e.comm.util.AdError
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


internal class SplashAdView(
        var activity: Activity,
        messenger: BinaryMessenger,
        id: Int,
        params: Map<String?, Any?>
) :
        PlatformView, SplashADListener {

    private var mContainer: FrameLayout? = null
    private var channel: MethodChannel?

    private var splashAD: SplashAD? = null

    //广告所需参数
    private var codeId: String = params["androidId"] as String
    private var fetchDelay: Int = params["fetchDelay"] as Int
    private var downloadConfirm: Boolean = params["downloadConfirm"] as Boolean

    init {
        mContainer = FrameLayout(activity)
        mContainer?.layoutParams?.width = ViewGroup.LayoutParams.WRAP_CONTENT
        mContainer?.layoutParams?.height = ViewGroup.LayoutParams.WRAP_CONTENT
        channel = MethodChannel(messenger, FlutterTencentAdConfig.splashAdView + "_" + id)
        loadSplashAd()
    }

    private fun loadSplashAd() {
        splashAD = SplashAD(activity, codeId, this, fetchDelay)
        mContainer?.removeAllViews()
        splashAD?.fetchAndShowIn(mContainer)
    }


    override fun getView(): View {
        return mContainer!!
    }

    /*************开屏广告回调******************/
//广告关闭时调用，可能是用户关闭或者展示时间到。此时一般需要跳过开屏的 Activity，进入应用内容页面
    override fun onADDismissed() {
        LogUtil.e("开屏广告关闭")
        channel?.invokeMethod("onClose", "")
    }

    //广告加载失败，error 对象包含了错误码和错误信息，错误码的详细内容可以参考文档第5章
    override fun onNoAD(p0: AdError?) {
        LogUtil.e("开屏广告加载失败  ${p0?.errorCode}  ${p0?.errorMsg}")
        var map: MutableMap<String, Any?> = mutableMapOf("code" to p0?.errorCode, "message" to p0?.errorMsg)
        channel?.invokeMethod("onFail", map)
    }

    //广告成功展示时调用，成功展示不等于有效展示（比如广告容器高度不够）
    override fun onADPresent() {
        LogUtil.e("开屏广告成功展示")
        channel?.invokeMethod("onShow", "")
    }

    //广告被点击时调用，不代表满足计费条件（如点击时网络异常）
    override fun onADClicked() {
        LogUtil.e("开屏广告被点击")
        channel?.invokeMethod("onClick", "")
    }

    //倒计时回调，返回广告还将被展示的剩余时间，单位是 ms
    override fun onADTick(p0: Long) {
        LogUtil.e("开屏广告倒计时回调 $p0")
        channel?.invokeMethod("onADTick", p0)
    }

    //广告曝光时调用
    override fun onADExposure() {
        LogUtil.e("开屏广告曝光")
        channel?.invokeMethod("onExpose", "")
    }

    //广告加载成功的回调，在fetchAdOnly的情况下，
    // 表示广告拉取成功可以显示了。广告需要在SystemClock.elapsedRealtime <expireTimestamp前展示，
    // 否则在showAd时会返回广告超时错误。
    override fun onADLoaded(p0: Long) {
        LogUtil.e("开屏广告加载成功 $p0")
        if(downloadConfirm){
            splashAD?.setDownloadConfirmListener(DownloadConfirmHelper.DOWNLOAD_CONFIRM_LISTENER)
        }
    }


    override fun dispose() {
        mContainer?.removeAllViews()
        mContainer = null
    }
}