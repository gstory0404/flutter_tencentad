package com.gstory.flutter_tencentad.rewardvideoad

import android.content.Context
import com.gstory.flutter_tencentad.LogUtil
import com.qq.e.ads.rewardvideo.RewardVideoAD
import com.qq.e.ads.rewardvideo.RewardVideoADListener
import com.qq.e.comm.util.AdError


object RewardVideoAd{
    private val TAG = "RewardVideoAd"

    private lateinit var context: Context
    private lateinit var rewardVideoAD: RewardVideoAD

    private var codeId: String? = null

    fun init(context: Context, params: Map<*, *>) {
        this.context = context
        this.codeId = params["codeId"] as String
        loadRewardVideoAd()
    }

    private fun loadRewardVideoAd() {
        rewardVideoAD = RewardVideoAD(context, codeId, rewardVideoADListener) // 有声播放
        rewardVideoAD.loadAD()
    }

    public fun showAd(){
        rewardVideoAD.showAD()
    }

    private var rewardVideoADListener = object : RewardVideoADListener {
        override fun onADLoad() {
            LogUtil.e("激励广告加载成功")
        }

        override fun onVideoCached() {
            LogUtil.e("激励广告视频素材缓存成功")
            showAd()
        }

        override fun onADShow() {
            LogUtil.e("激励视频广告页面展示")

        }

        override fun onADExpose() {
            LogUtil.e("激励视频广告曝光")
        }

        override fun onReward(p0: MutableMap<String, Any>?) {
            LogUtil.e("激励视频广告激励发放 $p0")
        }

        override fun onADClick() {
            LogUtil.e("激励视频广告被点击")
        }

        override fun onVideoComplete() {
            LogUtil.e("激励视频广告视频素材播放完毕")
        }

        override fun onADClose() {
            LogUtil.e("激励视频广告被关闭")
        }

        override fun onError(p0: AdError?) {
            LogUtil.e("广告流程出错 ${p0?.errorCode} ${p0?.errorMsg}")
        }

    }
}