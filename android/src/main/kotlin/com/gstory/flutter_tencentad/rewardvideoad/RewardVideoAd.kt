package com.gstory.flutter_tencentad.rewardvideoad

import android.annotation.SuppressLint
import android.content.Context
import com.gstory.flutter_tencentad.DownloadApkConfirmDialog
import com.gstory.flutter_tencentad.DownloadConfirmHelper
import com.gstory.flutter_tencentad.LogUtil
import com.gstory.flutter_tencentad.interstitialad.InterstitialAd
import com.gstory.flutter_unionad.FlutterTencentAdEventPlugin
import com.qq.e.ads.rewardvideo.RewardVideoAD
import com.qq.e.ads.rewardvideo.RewardVideoADListener
import com.qq.e.ads.rewardvideo.ServerSideVerificationOptions
import com.qq.e.comm.pi.IBidding
import com.qq.e.comm.util.AdError


@SuppressLint("StaticFieldLeak")
object RewardVideoAd {
    private val TAG = "RewardVideoAd"

    private lateinit var context: Context
    private var rewardVideoAD: RewardVideoAD? = null

    private var codeId: String? = null
    private var userID: String = ""
    private var rewardName: String = ""
    private var rewardAmount: Int = 0
    private var customData: String = ""
    private var downloadConfirm: Boolean = false
    //是否开启竞价
    private var isBidding: Boolean = false

    fun init(context: Context, params: Map<*, *>) {
        this.context = context
        this.codeId = params["androidId"] as String
        this.userID = params["userID"] as String
        this.rewardName = params["rewardName"] as String
        this.rewardAmount = params["rewardAmount"] as Int
        this.customData = params["customData"] as String
        this.downloadConfirm = params["downloadConfirm"] as Boolean
        this.isBidding = params["isBidding"] as Boolean
        loadRewardVideoAd()
    }

    private fun loadRewardVideoAd() {
        rewardVideoAD = RewardVideoAD(context, codeId, rewardVideoADListener) // 有声播放
        rewardVideoAD?.setServerSideVerificationOptions(ServerSideVerificationOptions.Builder().setUserId(this.userID).setCustomData(customData).build())
        rewardVideoAD?.loadAD()
    }

    fun showAd(params: Map<*, *>) {
        if (rewardVideoAD == null) {
            var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onUnReady")
            FlutterTencentAdEventPlugin.sendContent(map)
            return
        }
        //是否为竞价模式
        if(isBidding){
            var isSuccess: Boolean = params["isSuccess"] as Boolean
            //是否成功
            if(isSuccess){
                rewardVideoAD?.sendWinNotification(mutableMapOf(
                    //对应值为竞胜出价，类型为Integer
                    IBidding.EXPECT_COST_PRICE to params["expectCostPrice"],
                    //对应值为最大竞败方出价，类型为Integer
                    IBidding.HIGHEST_LOSS_PRICE to params["highestLossPrice"],
                ))
                rewardVideoAD?.showAD()
            }else{
                rewardVideoAD?.sendLossNotification(mutableMapOf(
                    //值为本次竞胜方出价（单位：分），类型为Integer。选填
                    IBidding.WIN_PRICE to params["winPrice"],
                    //值为优量汇广告竞败原因，类型为Integer。必填
                    IBidding.LOSS_REASON to params["lossReason"],
                    //值为本次竞胜方渠道ID，类型为Integer。必填。
                    IBidding.ADN_ID to params["adnId"],
                ))
            }
        }else{
            rewardVideoAD?.showAD()
        }

    }

    private var rewardVideoADListener = object : RewardVideoADListener {
        override fun onADLoad() {
            LogUtil.e("$TAG  激励广告加载成功")
            if(downloadConfirm){
                rewardVideoAD?.setDownloadConfirmListener(DownloadConfirmHelper.DOWNLOAD_CONFIRM_LISTENER)
            }
        }

        override fun onVideoCached() {
            LogUtil.e("$TAG  激励广告视频素材缓存成功")
            if (isBidding) {
                var map: MutableMap<String, Any?> =
                    mutableMapOf(
                        "adType" to "rewardAd",
                        "onAdMethod" to "onECPM",
                        "ecpmLevel" to rewardVideoAD?.ecpmLevel,
                        "ecpm" to rewardVideoAD?.ecpm
                    )
                FlutterTencentAdEventPlugin.sendContent(map)
            } else {
                var map: MutableMap<String, Any?> = mutableMapOf("adType" to "rewardAd", "onAdMethod" to "onReady")
                FlutterTencentAdEventPlugin.sendContent(map)
            }
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