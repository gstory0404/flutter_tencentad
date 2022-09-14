part of 'flutter_tencentad.dart';

/// @Author: gstory
/// @CreateDate: 2021/5/24 6:47 下午
/// @Description: dart类作用描述

///显示
typedef TOnShow = void Function();

///曝光
typedef TOnExpose = void Function();

///失败
typedef TOnFail = void Function(int code, dynamic message);

///点击
typedef TOnClick = void Function();

///视频播放
typedef TOnVideoPlay = void Function();

///视频暂停
typedef TOnVideoPause = void Function();

///视频播放结束
typedef TOnVideoStop = void Function();

///跳过
typedef TOnSkip = void Function();

///倒计时结束
typedef TOnFinish = void Function();

///加载超时
typedef TOnTimeOut = void Function();

///关闭
typedef TOnClose = void Function();

///广告预加载完成
typedef TOnReady = void Function();

///广告预加载未完成
typedef TOnUnReady = void Function();

///广告奖励验证
typedef TOnVerify = void Function(
    String transId, String rewardName, int rewardAmount);

///倒计时
typedef TOnADTick = void Function(int time);

///竞价回调
typedef TOnECPM = void Function(String ecpmLevel, int ecpm);

///banner广告回调
class FlutterTencentadBannerCallBack {
  TOnShow? onShow;
  TOnFail? onFail;
  TOnClick? onClick;
  TOnExpose? onExpose;
  TOnClose? onClose;
  TOnECPM? onECPM;

  FlutterTencentadBannerCallBack(
      {this.onShow,
      this.onFail,
      this.onClick,
      this.onExpose,
      this.onClose,
      this.onECPM});
}

///动态信息流/横幅/视频贴片广告回调
class FlutterTencentadExpressCallBack {
  TOnShow? onShow;
  TOnFail? onFail;
  TOnClick? onClick;
  TOnExpose? onExpose;
  TOnClose? onClose;
  TOnECPM? onECPM;

  FlutterTencentadExpressCallBack(
      {this.onShow,
      this.onFail,
      this.onClick,
      this.onExpose,
      this.onClose,
      this.onECPM});
}

///开屏广告回调
class FlutterTencentadSplashCallBack {
  TOnClose? onClose;
  TOnShow? onShow;
  TOnFail? onFail;
  TOnClick? onClick;
  TOnExpose? onExpose;
  TOnADTick? onADTick;
  TOnECPM? onECPM;

  FlutterTencentadSplashCallBack(
      {this.onShow,
      this.onFail,
      this.onClick,
      this.onClose,
      this.onExpose,
      this.onADTick,
      this.onECPM});
}

///插屏广告回调
class FlutterTencentadInteractionCallBack {
  TOnShow? onShow;
  TOnClick? onClick;
  TOnClose? onClose;
  TOnFail? onFail;
  TOnReady? onReady;
  TOnUnReady? onUnReady;
  TOnExpose? onExpose;
  TOnVerify? onVerify;
  TOnECPM? onECPM;

  FlutterTencentadInteractionCallBack(
      {this.onShow,
      this.onClick,
      this.onClose,
      this.onFail,
      this.onExpose,
      this.onReady,
      this.onUnReady,
      this.onVerify,
      this.onECPM});
}

///激励广告回调
class FlutterTencentadRewardCallBack {
  TOnShow? onShow;
  TOnClose? onClose;
  TOnExpose? onExpose;
  TOnFail? onFail;
  TOnClick? onClick;
  TOnVerify? onVerify;
  TOnReady? onReady;
  TOnFinish? onFinish;
  TOnUnReady? onUnReady;
  TOnECPM? onECPM;

  FlutterTencentadRewardCallBack(
      {this.onShow,
      this.onClick,
      this.onExpose,
      this.onClose,
      this.onFail,
      this.onVerify,
      this.onReady,
      this.onFinish,
      this.onUnReady,
      this.onECPM});
}
