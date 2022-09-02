/// 描述：
/// @author guozi
/// @e-mail gstory0404@gmail.com
/// @time   2020/3/11

///数据类型
class FlutterTencentadType {
  static const String adType = "adType";

  ///激励广告
  static const String rewardAd = "rewardAd";

  ///插屏广告
  static const String interactAd = "interactAd";
}

class FlutterTencentadMethod {
  ///stream中 广告方法
  static const String onAdMethod = "onAdMethod";

  ///广告加载状态 view使用
  ///显示view
  static const String onShow = "onShow";

  ///广告曝光
  static const String onExpose = "onExpose";

  ///加载失败
  static const String onFail = "onFail";

  ///点击
  static const String onClick = "onClick";

  ///视频播放
  static const String onVideoPlay = "onVideoPlay";

  ///视频暂停
  static const String onVideoPause = "onVideoPause";

  ///视频结束
  static const String onVideoStop = "onVideoStop";

  ///倒计时结束
  static const String onFinish = "onFinish";

  ///加载超时
  static const String onTimeOut = "onTimeOut";

  ///广告关闭
  static const String onClose = "onClose";

  ///广告奖励校验
  static const String onVerify = "onVerify";

  ///广告预加载完成
  static const String onReady = "onReady";

  ///广告未预加载
  static const String onUnReady = "onUnReady";

  ///倒计时
  static const String onADTick = "onADTick";
  ///竞价
  static const String onECPM = "onECPM";
}

///渠道id
class FlutterTencentadChannel {
  ///百度
  static const int baidu = 1;
  ///头条
  static const int toutiao = 2;
  ///优量汇
  static const int tencent = 3;
  ///搜狗
  static const int sougou = 4;
  ///其他网盟
  static const int otherAd = 5;
  ///oppe
  static const int oppo = 6;
  ///vivo
  static const int vivo = 7;
  ///huawei
  static const int huawei = 8;
  ///应用宝
  static const int yinyongbao = 9;
  ///小米
  static const int xiaomi = 10;
  ///金立
  static const int jinli = 11;
  ///百度手机助手
  static const int baiduMobile = 12;
  ///魅族
  static const int meizu = 13;
  ///App Store
  static const int AppStore = 14;
  ///其他
  static const int other = 999;
}

///个性化广告
class FlutterTencentadPersonalized {
  ///屏蔽个性化推荐广告
  static const int close = 1;

  ///不屏蔽个性化推荐广告
  static const int show = 0;
}


///竞价失败原因
class FlutterTencentAdBiddingLossReason {
  /// 竞争力不足，如优量汇不是本次竞价的最高出价方，可上报此竞败原因
  static const int LOW_PRICE = 1;
  /// 返回超时，如优量汇在本次竞价中未返回广告，可上报此竞败原因
  static const int TIME_OUT = 2;
  ///其他
  static const int OTHER = 10001;
}

///本次竞胜方渠道ID
class FlutterTencentAdADNID {
  ///1 - 输给优量汇其它广告，当优量汇目标价报价为本次竞价的最高报价时，可上报此值，仅对混合比价类型的开发者适用
  static const String tencentADN = "1";
  /// 2 - 输给第三方ADN，当其它ADN报价为本次竞价的最高报价时，可上报此值，您无需回传具体竞胜方渠道；
  static const String othoerADN = "2";
  ///  3 - 输给自售广告主，当自售广告源报价为本次竞价的最高报价时，可上报此值，仅对有自售广告源的开发者使用
  static const String appADN = "3";
}
