part of 'flutter_tencentad.dart';

/// @Author: gstory
/// @CreateDate: 2021/5/24 6:47 下午
/// @Description: dart类作用描述

///显示
typedef OnShow = void Function();

///曝光
typedef OnExpose = void Function();

///失败
typedef OnFail = void Function(int code, dynamic message);

///点击
typedef OnClick = void Function();

///视频播放
typedef OnVideoPlay = void Function();

///视频暂停
typedef OnVideoPause = void Function();

///视频播放结束
typedef OnVideoStop = void Function();

///跳过
typedef OnSkip = void Function();

///倒计时结束
typedef OnFinish = void Function();

///加载超时
typedef OnTimeOut = void Function();

///关闭
typedef OnClose = void Function();

///广告预加载完成
typedef OnReady = void Function();

///广告预加载未完成
typedef OnUnReady = void Function();

///广告奖励验证
typedef OnVerify = void Function(String transId);

///倒计时
typedef OnADTick = void Function(int time);

///banner广告回调
class BannerAdCallBack {
  OnShow? onShow;
  OnFail? onFail;
  OnClick? onClick;
  OnExpose? onExpose;
  OnClose? onClose;

  BannerAdCallBack(
      {this.onShow, this.onFail, this.onClick, this.onExpose, this.onClose});
}

///动态信息流/横幅/视频贴片广告回调
class ExpressAdCallBack {
  OnShow? onShow;
  OnFail? onFail;
  OnClick? onClick;
  OnExpose? onExpose;
  OnClose? onClose;

  ExpressAdCallBack(
      {this.onShow, this.onFail, this.onClick, this.onExpose, this.onClose});
}

///开屏广告回调
class SplashAdCallBack {
  OnClose? onClose;
  OnShow? onShow;
  OnFail? onFail;
  OnClick? onClick;
  OnExpose? onExpose;
  OnADTick? onADTick;

  SplashAdCallBack(
      {this.onShow,
      this.onFail,
      this.onClick,
      this.onClose,
      this.onExpose,
      this.onADTick});
}

///插屏广告回调
class InteractionAdCallBack {
  OnShow? onShow;
  OnClick? onClick;
  OnClose? onClose;
  OnFail? onFail;
  OnReady? onReady;
  OnUnReady? onUnReady;
  OnExpose? onExpose;

  InteractionAdCallBack(
      {this.onShow,
      this.onClick,
      this.onClose,
      this.onFail,
      this.onExpose,
      this.onReady,
      this.onUnReady});
}

///激励广告回调
class RewardAdCallBack {
  OnShow? onShow;
  OnClose? onClose;
  OnExpose? onExpose;
  OnFail? onFail;
  OnClick? onClick;
  OnVerify? onVerify;
  OnReady? onReady;
  OnFinish? onFinish;
  OnUnReady? onUnReady;

  RewardAdCallBack(
      {this.onShow,
      this.onClick,
      this.onExpose,
      this.onClose,
      this.onFail,
      this.onVerify,
      this.onReady,
      this.onFinish,
      this.onUnReady});
}
