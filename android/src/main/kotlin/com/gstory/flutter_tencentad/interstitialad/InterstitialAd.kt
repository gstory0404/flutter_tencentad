package com.gstory.flutter_tencentad.interstitialad

import android.annotation.SuppressLint
import android.app.Activity
import com.gstory.flutter_tencentad.DownloadApkConfirmDialog
import com.gstory.flutter_tencentad.DownloadConfirmHelper
import com.gstory.flutter_tencentad.LogUtil
import com.qq.e.ads.interstitial2.UnifiedInterstitialAD
import com.qq.e.ads.interstitial2.UnifiedInterstitialADListener
import com.gstory.flutter_unionad.FlutterTencentAdEventPlugin
import com.qq.e.ads.interstitial2.ADRewardListener
import com.qq.e.comm.pi.IBidding
import com.qq.e.comm.util.AdError

@SuppressLint("StaticFieldLeak")
object InterstitialAd {
    private val TAG = "InterstitialAd"

    private lateinit var context: Activity
    private var unifiedInterstitialAD: UnifiedInterstitialAD? = null

    private var codeId: String? = null
    private var isFullScreen: Boolean? = false
    private var downloadConfirm: Boolean = false

    //是否开启竞价
    private var isBidding: Boolean = false

    fun init(context: Activity, params: Map<*, *>) {
        this.context = context
        this.codeId = params["androidId"] as String
        this.isFullScreen = params["isFullScreen"] as Boolean
        this.downloadConfirm = params["downloadConfirm"] as Boolean
        this.isBidding = params["isBidding"] as Boolean
        loadInterstitialAD()
    }

    private fun loadInterstitialAD() {
        unifiedInterstitialAD = UnifiedInterstitialAD(
            context,
            codeId,
            interstitialADListener
        )
        if (isFullScreen!!) {
            unifiedInterstitialAD?.setRewardListener(adRewardListener)
            unifiedInterstitialAD?.loadFullScreenAD()
        } else {
            unifiedInterstitialAD?.loadAD()
        }
    }

    fun showAd(params: Map<*, *>) {
        if (unifiedInterstitialAD == null) {
            var map: MutableMap<String, Any?> =
                mutableMapOf("adType" to "interactAd", "onAdMethod" to "onUnReady")
            FlutterTencentAdEventPlugin.sendContent(map)
            LogUtil.e("$TAG  插屏全屏视频广告显示失败，无广告")
            return
        }
        //	广告是否有效，无效广告将无法展示
        if (!unifiedInterstitialAD?.isValid!!) {
            var map: MutableMap<String, Any?> = mutableMapOf(
                "adType" to "interactAd",
                "onAdMethod" to "onFail",
                "code" to 1,
                "message" to "插屏全屏视频视频广告显示失败，无效广告"
            )
            FlutterTencentAdEventPlugin.sendContent(map)
            LogUtil.e("$TAG  插屏全屏视频广告显示失败，无效广告")
            unifiedInterstitialAD?.close()
            unifiedInterstitialAD?.destroy()
            unifiedInterstitialAD = null
            return
        }
        //是否为竞价模式
        if (isBidding) {
            var isSuccess: Boolean = params["isSuccess"] as Boolean
            //是否成功
            if (isSuccess) {
                unifiedInterstitialAD?.sendWinNotification(
                    mutableMapOf(
                        //对应值为竞胜出价，类型为Integer
                        IBidding.EXPECT_COST_PRICE to params["expectCostPrice"],
                        //对应值为最大竞败方出价，类型为Integer
                        IBidding.HIGHEST_LOSS_PRICE to params["highestLossPrice"],
                    )
                )
                if (isFullScreen!!) {
                    unifiedInterstitialAD?.showFullScreenAD(context)
                } else {
                    unifiedInterstitialAD?.showAsPopupWindow()
                }
            } else {
                unifiedInterstitialAD?.sendLossNotification(
                    mutableMapOf(
                        //值为本次竞胜方出价（单位：分），类型为Integer。选填
                        IBidding.WIN_PRICE to params["winPrice"],
                        //值为优量汇广告竞败原因，类型为Integer。必填
                        IBidding.LOSS_REASON to params["lossReason"],
                        //值为本次竞胜方渠道ID，类型为Integer。必填。
                        IBidding.ADN_ID to params["adnId"],
                    )
                )
            }
        } else {
            if (isFullScreen!!) {
                unifiedInterstitialAD?.showFullScreenAD(context)
            } else {
                unifiedInterstitialAD?.showAsPopupWindow()
            }
        }
    }

    private var interstitialADListener = object : UnifiedInterstitialADListener {
        //插屏全屏视频广告加载完毕，此回调后才可以调用 show 方法
        override fun onADReceive() {
            LogUtil.e("$TAG  插屏全屏视频广告加载完毕  $downloadConfirm")
            if (downloadConfirm) {
                unifiedInterstitialAD?.setDownloadConfirmListener(DownloadConfirmHelper.DOWNLOAD_CONFIRM_LISTENER)
            }
        }

        //插屏全屏视频视频广告，视频素材下载完成
        override fun onVideoCached() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，视频素材下载完成")
        }

        //广告加载失败，error 对象包含了错误码和错误信息
        override fun onNoAD(p0: AdError?) {
            LogUtil.e("$TAG  插屏全屏视频视频广告，加载失败  ${p0?.errorCode}  ${p0?.errorMsg}")
            var map: MutableMap<String, Any?> = mutableMapOf(
                "adType" to "interactAd",
                "onAdMethod" to "onFail",
                "code" to p0?.errorCode,
                "message" to p0?.errorMsg
            )
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        //插屏全屏视频广告展开时回调
        override fun onADOpened() {
            LogUtil.e("$TAG  插屏全屏视频广告展开时回调")
            var map: MutableMap<String, Any?> =
                mutableMapOf("adType" to "interactAd", "onAdMethod" to "onShow")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        //插屏全屏视频广告曝光时回调
        override fun onADExposure() {
            LogUtil.e("$TAG  插屏全屏视频广告曝光时回调")
            var map: MutableMap<String, Any?> =
                mutableMapOf("adType" to "interactAd", "onAdMethod" to "onExpose")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        //插屏全屏视频广告点击时回调
        override fun onADClicked() {
            LogUtil.e("$TAG  插屏全屏视频广告点击时回调")
            var map: MutableMap<String, Any?> =
                mutableMapOf("adType" to "interactAd", "onAdMethod" to "onClick")
            FlutterTencentAdEventPlugin.sendContent(map)
        }

        override fun onADLeftApplication() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，渲染成功")
        }

        //插屏全屏视频广告关闭时回调
        override fun onADClosed() {
            LogUtil.e("$TAG  插屏全屏视频广告关闭时回调")
            var map: MutableMap<String, Any?> =
                mutableMapOf("adType" to "interactAd", "onAdMethod" to "onClose")
            FlutterTencentAdEventPlugin.sendContent(map)
            unifiedInterstitialAD?.close()
            unifiedInterstitialAD?.destroy()
            unifiedInterstitialAD = null
        }

        //	插屏全屏视频视频广告，渲染成功
        override fun onRenderSuccess() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，渲染成功")
            if (isBidding) {
                var map: MutableMap<String, Any?> =
                    mutableMapOf(
                        "adType" to "interactAd",
                        "onAdMethod" to "onECPM",
                        "ecpmLevel" to unifiedInterstitialAD?.ecpmLevel,
                        "ecpm" to unifiedInterstitialAD?.ecpm
                    )
                FlutterTencentAdEventPlugin.sendContent(map)
            } else {
                var map: MutableMap<String, Any?> =
                    mutableMapOf("adType" to "interactAd", "onAdMethod" to "onReady")
                FlutterTencentAdEventPlugin.sendContent(map)
            }
        }

        //插屏全屏视频视频广告，渲染失败
        override fun onRenderFail() {
            LogUtil.e("$TAG  插屏全屏视频视频广告，渲染失败")
            var map: MutableMap<String, Any?> = mutableMapOf(
                "adType" to "interactAd",
                "onAdMethod" to "onFail",
                "code" to 0,
                "message" to "插屏全屏视频视频广告渲染失败"
            )
            FlutterTencentAdEventPlugin.sendContent(map)
            unifiedInterstitialAD?.close()
            unifiedInterstitialAD?.destroy()
            unifiedInterstitialAD = null
        }

    }


    private var adRewardListener = object : ADRewardListener {
        override fun onReward(p0: MutableMap<String, Any>?) {
            LogUtil.e("$TAG  激励奖励 $p0")
            var map: MutableMap<String, Any?> = mutableMapOf(
                "adType" to "interactAd",
                "onAdMethod" to "onVerify",
                "transId" to p0!!["transId"]
            )
            FlutterTencentAdEventPlugin.sendContent(map)
        }

    }
}