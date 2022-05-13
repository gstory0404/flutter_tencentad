package com.gstory.flutter_tencentad.expressad

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.gstory.flutter_tencentad.*
import com.qq.e.ads.cfg.DownAPPConfirmPolicy
import com.qq.e.ads.cfg.VideoOption
import com.qq.e.ads.nativ.ADSize
import com.qq.e.ads.nativ.NativeExpressAD
import com.qq.e.ads.nativ.NativeExpressADView
import com.qq.e.ads.nativ.NativeExpressMediaListener
import com.qq.e.comm.compliance.DownloadConfirmCallBack
import com.qq.e.comm.compliance.DownloadConfirmListener
import com.qq.e.comm.constants.AdPatternType
import com.qq.e.comm.util.AdError
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * @Description: 平台模板NativeExpressAdView广告
 * @Author: gstory
 * @CreateDate: 2021/8/7 17:43
 **/

internal class NativeExpressAdView(
    var activity: Activity,
    messenger: BinaryMessenger,
    id: Int,
    params: Map<String?, Any?>
) :
    PlatformView, NativeExpressAD.NativeExpressADListener, NativeExpressMediaListener {

    private var mContainer: FrameLayout? = null

    //广告所需参数
    private var codeId: String = params["androidId"] as String
    private var viewWidth: Int = params["viewWidth"] as Int
    private var viewHeight: Int = params["viewHeight"] as Int
    private var downloadConfirm: Boolean = params["downloadConfirm"] as Boolean

    private var nativeExpressAD: NativeExpressAD? = null
    private var nativeExpressAdView: NativeExpressADView? = null

    private var channel: MethodChannel?


    init {
        mContainer = FrameLayout(activity)
        mContainer?.layoutParams?.width = ViewGroup.LayoutParams.WRAP_CONTENT
        mContainer?.layoutParams?.height = ViewGroup.LayoutParams.WRAP_CONTENT
        channel = MethodChannel(messenger, FlutterTencentAdConfig.nativeAdView + "_" + id)
        loadExpressAd()
    }

    private fun loadExpressAd() {
        val adSize: ADSize = when {
            viewWidth == 0 -> {
                ADSize(ADSize.FULL_WIDTH, viewHeight)
            }
            viewHeight == 0 -> {
                ADSize(viewWidth, ADSize.AUTO_HEIGHT)
            }
            else -> {
                ADSize(viewWidth, viewHeight)
            }
        }
        nativeExpressAD = NativeExpressAD(activity, adSize, codeId, this)
        nativeExpressAD?.setVideoOption(
            VideoOption.Builder()
                .setAutoPlayPolicy(VideoOption.AutoPlayPolicy.ALWAYS)
                .setAutoPlayMuted(true)
                .build()
        )
        nativeExpressAD?.setDownAPPConfirmPolicy(DownAPPConfirmPolicy.Default)
        nativeExpressAD?.loadAD(1)
    }

    override fun getView(): View {
        return mContainer!!
    }

    /**************平台模板广告加载、渲染、点击状态的回调。****************/

    //无广告填充
    override fun onNoAD(p0: AdError?) {
        LogUtil.e("广告加载失败  ${p0?.errorCode}  ${p0?.errorMsg}")
        val map: MutableMap<String, Any?> =
            mutableMapOf("code" to p0?.errorCode, "message" to p0?.errorMsg)
        channel?.invokeMethod("onFail", map)
    }

    //广告数据加载成功，返回了可以用来展示广告的 NativeExpressADView，
    // 但是想让广告曝光还需要调用 NativeExpressADView 的 render 方法
    override fun onADLoaded(p0: MutableList<NativeExpressADView>?) {
        // 释放前一个 NativeExpressADView 的资源
        if (nativeExpressAdView != null) {
            nativeExpressAdView?.destroy()
            nativeExpressAdView = null
        }
        if (p0?.size == 0) {
            LogUtil.e("未拉取到广告")
            val map: MutableMap<String, Any?> = mutableMapOf("code" to 0, "message" to "未拉取到广告")
            channel?.invokeMethod("onFail", map)
        }
        LogUtil.e("广告数据加载成功")
        nativeExpressAdView = p0!![0]
        if (nativeExpressAdView?.boundData?.adPatternType == AdPatternType.NATIVE_VIDEO) {
            nativeExpressAdView?.setMediaListener(this)
        }
        if (downloadConfirm) {
            nativeExpressAdView?.setDownloadConfirmListener(DownloadConfirmHelper.DOWNLOAD_CONFIRM_LISTENER)
        }
        LogUtil.e(
            "数据加载成功 ${
                UIUtils.px2dip(
                    activity,
                    nativeExpressAdView?.width!!.toFloat()
                )
            }  ${UIUtils.px2dip(activity, nativeExpressAdView?.height!!.toFloat())}"
        )
        if (nativeExpressAdView != null) {
            if (mContainer?.childCount!! > 0) {
                mContainer?.removeAllViews()
            }
            mContainer?.addView(nativeExpressAdView!!.rootView)
            nativeExpressAdView!!.render()
        }
    }

    //NativeExpressADView 渲染广告失败
    override fun onRenderFail(p0: NativeExpressADView?) {
        LogUtil.e("渲染广告失败")
        val map: MutableMap<String, Any?> = mutableMapOf("code" to 0, "message" to "渲染广告失败")
        channel?.invokeMethod("onFail", map)
        nativeExpressAdView?.destroy()
    }

    //NativeExpressADView 渲染广告成功
    override fun onRenderSuccess(p0: NativeExpressADView?) {
        val map: MutableMap<String, Any?> = mutableMapOf(
            "width" to UIUtils.px2dip(activity, p0?.width!!.toFloat()),
            "height" to UIUtils.px2dip(activity, p0?.height!!.toFloat())
        )
        channel?.invokeMethod("onShow", map)
    }

    //广告曝光
    override fun onADExposure(p0: NativeExpressADView?) {
        LogUtil.e("广告曝光")
        channel?.invokeMethod("onExpose", "")
    }

    //广告点击
    override fun onADClicked(p0: NativeExpressADView?) {
        LogUtil.e("广告点击")
        channel?.invokeMethod("onClick", "")
    }

    //广告被关闭，将不再显示广告，此时广告对象已经释放资源，不可以再次用来展示了
    override fun onADClosed(p0: NativeExpressADView?) {
        LogUtil.e("广告被关闭")
        channel?.invokeMethod("onClose", "")
        p0?.destroy()
    }

    //因为广告点击等原因离开当前 app 时调用
    override fun onADLeftApplication(p0: NativeExpressADView?) {
        LogUtil.e("因为广告点击等原因离开当前 app")
    }

    /*****************平台模板视频广告播放状态回调接口，专用于带有视频素材的广告对象**************/

    //视频播放 View 初始化完成
    override fun onVideoInit(p0: NativeExpressADView?) {
        LogUtil.e("视频播放 View 初始化完成")
    }

    //视频下载中
    override fun onVideoLoading(p0: NativeExpressADView?) {
        LogUtil.e("视频下载中")
    }

    //视频下载完成
    override fun onVideoCached(p0: NativeExpressADView?) {
        LogUtil.e("视频下载完成")
//        nativeExpressAdView?.
    }

    //视频播放器初始化完成，准备好可以播放了，videoDuration 是视频素材的时间长度，单位为 ms
    override fun onVideoReady(p0: NativeExpressADView?, p1: Long) {
        LogUtil.e("视频播放器初始化完成")
//        nativeExpressAdView?
    }

    //视频开始播放
    override fun onVideoStart(p0: NativeExpressADView?) {
        LogUtil.e("视频开始播放")
    }

    //视频暂停
    override fun onVideoPause(p0: NativeExpressADView?) {
        LogUtil.e("视频暂停")
    }

    //视频播放结束，手动调用 stop 或者自然播放到达最后一帧时都会触发
    override fun onVideoComplete(p0: NativeExpressADView?) {
        LogUtil.e("视频播放结束")
    }

    //视频播放时出现错误，error 对象包含了错误码和错误信息，错误码的详细内容可以参考文档第5章
    override fun onVideoError(p0: NativeExpressADView?, p1: AdError?) {
        LogUtil.e("视频播放时出现错误 ${p1?.errorCode}  ${p1?.errorMsg}")
    }

    //进入视频落地页
    override fun onVideoPageOpen(p0: NativeExpressADView?) {
        LogUtil.e("进入视频落地页")
    }

    //退出视频落地页
    override fun onVideoPageClose(p0: NativeExpressADView?) {
        LogUtil.e("退出视频落地页")

    }

    override fun dispose() {
        nativeExpressAdView?.destroy()
        mContainer?.removeAllViews()
    }

}