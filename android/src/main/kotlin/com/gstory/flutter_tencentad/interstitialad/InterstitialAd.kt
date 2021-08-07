package com.gstory.flutter_tencentad.interstitialad

import android.app.Activity
import android.content.Context
import com.gstory.flutter_tencentad.LogUtil
import com.gstory.flutter_tencentad.rewardvideoad.RewardVideoAd
import com.qq.e.ads.interstitial2.UnifiedInterstitialAD
import com.qq.e.ads.interstitial2.UnifiedInterstitialADListener
import com.qq.e.ads.rewardvideo.RewardVideoAD
import com.qq.e.comm.util.AdError

object InterstitialAd {
    private val TAG = "InterstitialAd"

    private lateinit var context: Activity
    private var unifiedInterstitialAD: UnifiedInterstitialAD? = null

    private var codeId: String? = null
    private var isFullScreen: Boolean? = false

    fun init(context: Activity, params: Map<*, *>) {
        this.context = context
        this.codeId = params["codeId"] as String
        this.isFullScreen = params["isFullScreen"] as Boolean
        loadInterstitialAD()
    }

    private fun loadInterstitialAD() {
        unifiedInterstitialAD = UnifiedInterstitialAD(
            context,
            codeId,
            interstitialADListener
        )
        if(isFullScreen!!){
            unifiedInterstitialAD?.loadFullScreenAD()
        }else{
            unifiedInterstitialAD?.loadAD()
        }
    }

    fun showAd(){
        if(unifiedInterstitialAD == null){
            return
        }
        if(isFullScreen!!){
            unifiedInterstitialAD?.showFullScreenAD(context)
        }else{
            unifiedInterstitialAD?.showAsPopupWindow()
        }
    }

    private var interstitialADListener = object : UnifiedInterstitialADListener{
        //插屏全屏视频广告加载完毕，此回调后才可以调用 show 方法
        override fun onADReceive() {
            LogUtil.e("$TAG  插屏全屏视频广告加载完毕")
        }

        //插屏全屏视频视频广告，视频素材下载完成
        override fun onVideoCached() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，视频素材下载完成")
        }

        //广告加载失败，error 对象包含了错误码和错误信息
        override fun onNoAD(p0: AdError?) {
            LogUtil.e("$TAG  插屏全屏视频视频广告，加载失败  ${p0?.errorCode}  ${p0?.errorMsg}")
        }

        //插屏全屏视频广告展开时回调
        override fun onADOpened() {
            LogUtil.e("$TAG  插屏全屏视频广告展开时回调")
        }

        //插屏全屏视频广告曝光时回调
        override fun onADExposure() {
            LogUtil.e("$TAG  插屏全屏视频广告曝光时回调")
        }

        //插屏全屏视频广告点击时回调
        override fun onADClicked() {
            LogUtil.e("$TAG  插屏全屏视频广告点击时回调")
        }

        override fun onADLeftApplication() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，渲染成功")
        }

        //插屏全屏视频广告关闭时回调
        override fun onADClosed() {
            LogUtil.e("$TAG  插屏全屏视频广告关闭时回调")
            unifiedInterstitialAD?.close()
            unifiedInterstitialAD?.destroy()
            unifiedInterstitialAD = null
        }

        //	插屏全屏视频视频广告，渲染成功
        override fun onRenderSuccess() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，渲染成功")
        }

        //插屏全屏视频视频广告，渲染失败
        override fun onRenderFail() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，渲染失败")
        }

    }

}