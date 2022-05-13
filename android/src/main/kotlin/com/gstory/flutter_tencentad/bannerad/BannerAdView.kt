package com.gstory.flutter_tencentad.bannerad

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.gstory.flutter_tencentad.DownloadApkConfirmDialog
import com.gstory.flutter_tencentad.DownloadConfirmHelper
import com.gstory.flutter_tencentad.FlutterTencentAdConfig
import com.gstory.flutter_tencentad.LogUtil
import com.qq.e.ads.banner2.UnifiedBannerADListener
import com.qq.e.ads.banner2.UnifiedBannerView
import com.qq.e.comm.util.AdError
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * @Description: 平台模板Banner广告
 * @Author: gstory
 * @CreateDate: 2021/8/7 17:43
 **/

internal class BannerAdView(
    var activity: Activity,
    messenger: BinaryMessenger,
    id: Int,
    params: Map<String?, Any?>
) :
    PlatformView, UnifiedBannerADListener {

    private val TAG = "BannerAdView"

    private var mContainer: FrameLayout? = null

    //广告所需参数
    private var codeId: String
    private var viewWidth: Float
    private var viewHeight: Float

    private var unifiedBannerView: UnifiedBannerView? = null

    private var channel: MethodChannel?

    private var downloadConfirm: Boolean


    init {
        codeId = params["androidId"] as String
        var width = params["viewWidth"] as Double
        var height = params["viewHeight"] as Double
        downloadConfirm = params["downloadConfirm"] as Boolean
        viewWidth = width.toFloat()
        viewHeight = height.toFloat()
        mContainer = FrameLayout(activity)
        mContainer?.layoutParams?.width = ViewGroup.LayoutParams.WRAP_CONTENT
        mContainer?.layoutParams?.height = ViewGroup.LayoutParams.WRAP_CONTENT
        channel = MethodChannel(messenger, FlutterTencentAdConfig.bannerAdView + "_" + id)
        loadBannerAd()
    }

    private fun loadBannerAd() {
        unifiedBannerView = UnifiedBannerView(activity, codeId, this)
        unifiedBannerView?.loadAD()
    }

    override fun getView(): View {
        return mContainer!!
    }


    //广告加载失败，error 对象包含了错误码和错误信息
    override fun onNoAD(p0: AdError?) {
        LogUtil.e("$TAG  Banner广告加载失败  ${p0?.errorCode}  ${p0?.errorMsg}")
        var map: MutableMap<String, Any?> =
            mutableMapOf("code" to p0?.errorCode, "message" to p0?.errorMsg)
        channel?.invokeMethod("onFail", map)
    }

    //广告加载成功回调，表示广告相关的资源已经加载完毕，Ready To Show
    override fun onADReceive() {
        mContainer?.removeAllViews()
        if (unifiedBannerView == null) {
            LogUtil.e("$TAG  Banner广告加载失败 unifiedBannerView不存在或已销毁")
            var map: MutableMap<String, Any?> =
                mutableMapOf("code" to 0, "message" to "BannerView不存在或已销毁")
            channel?.invokeMethod("onFail", map)
            return
        }
        if (downloadConfirm) {
            unifiedBannerView?.setDownloadConfirmListener(DownloadConfirmHelper.DOWNLOAD_CONFIRM_LISTENER)
        }
        mContainer?.addView(unifiedBannerView)
        LogUtil.e("$TAG  Banner广告加载成功回调")
        channel?.invokeMethod("onShow", "")
    }

    //当广告曝光时发起的回调
    override fun onADExposure() {
        LogUtil.e("$TAG  Banner广告曝光")
        channel?.invokeMethod("onExpose", "")
    }

    //当广告关闭时调用
    override fun onADClosed() {
        LogUtil.e("$TAG  Banner广告关闭")
        channel?.invokeMethod("onClose", "")
    }

    //当广告点击时发起的回调，由于点击去重等原因可能和平台最终的统计数据有差异
    override fun onADClicked() {
        LogUtil.e("$TAG  Banner广告点击")
        channel?.invokeMethod("onClick", "")
    }

    //由于广告点击离开 APP 时调用
    override fun onADLeftApplication() {
        LogUtil.e("$TAG  Banner广告点击离开 APP")
    }

    override fun dispose() {
        unifiedBannerView?.destroy()
        unifiedBannerView = null
    }

}