package com.gstory.flutter_tencentad.rewardvideoad

import android.content.Context
import android.content.ServiceConnection
import com.gstory.flutter_tencentad.LogUtil
import com.gstory.flutter_tencentad.interstitialad.InterstitialAd
import com.gstory.flutter_unionad.FlutterTencentAdEventPlugin
import com.qq.e.ads.rewardvideo.RewardVideoAD
import com.qq.e.ads.rewardvideo.RewardVideoADListener
import com.qq.e.ads.rewardvideo.ServerSideVerificationOptions
import com.qq.e.comm.util.AdError


object RewardVideoAd {
    private val TAG = "RewardVideoAd"

    private lateinit var context: Context
    private var rewardVideoAD: RewardVideoAD? = null

    private var codeId: String? = null
    private var userID: String = ""
    private var rewardName: String = ""
    private var rewardAmount: Int = 0
    private var customData: String = ""

    fun init(context: Context, params: Map<*, *>) {
        this.context = context
        this.codeId = params["codeId"] as String
        this.userID = params["userID"] as String
        this.rewardName = params["rewardName"] as String
        this.rewardAmount = params["rewardAmount"] as Int
        this.customData = params["customData"] as String
        loadRewardVideoAd()
    }

    private fun loadRewardVideoAd() {
        rewardVideoAD = RewardVideoAD(context, codeId, rewardVideoADListener) // 有声播放
        rewardVideoAD?.setServerSideVerificationOptions(ServerSideVerificationOptions.Builder().setUserId(this.userID).setCustomData(customData).build())
        rewardVideoAD?.loadAD()
    }

    fun showAd() {
        if (rewardVideoAD == null) {
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onUnReady")
            FlutterTencentAdEventPlugin.sendContent(map)
            return
        }
        rewardVideoAD?.showAD()
    }

    private var rewardVideoADListener = object : RewardVideoADListener {
        override fun onADLoad() {
            LogUtil.e("$TAG  激励广告加载成功")
        }

        override fun onVideoCached() {
            LogUtil.e("$TAG  激励广告视频素材缓存成功")
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onReady")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        override fun onADShow() {
            LogUtil.e("$TAG  激励视频广告页面展示")
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onShow")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        override fun onADExpose() {
            LogUtil.e("$TAG  激励视频广告曝光")
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onExpose")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        override fun onReward(p0: MutableMap<String, Any>?) {
            LogUtil.e("$TAG  激励视频广告激励发放 $p0")

            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onVerify", "transId" to p0!!["transId"], "rewardName" to rewardName, "rewardAmount" to rewardAmount)
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        override fun onADClick() {
            LogUtil.e("$TAG  激励视频广告被点击")
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onClick")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        override fun onVideoComplete() {
            LogUtil.e("$TAG  激励视频广告视频素材播放完毕")
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onFinish")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        override fun onADClose() {
            LogUtil.e("$TAG  激励视频广告被关闭")
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onClose")
            FlutterTencentAdEventPlugin.sendContent(map)
            rewardVideoAD = null
        }

        override fun onError(p0: AdError?) {
            LogUtil.e("$TAG  广告流程出错 ${p0?.errorCode} ${p0?.errorMsg}")
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onFail", "code" to p0?.errorCode, "message" to p0?.errorMsg)
            FlutterTencentAdEventPlugin.sendContent(map)
        }

    }
}