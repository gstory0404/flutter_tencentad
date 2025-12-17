import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { window, NodeController } from '@kit.ArkUI';
import {
  GDTAdSDK,
  GDTAdLoadConfig,
  GDTAdLoadListener,
  GDTNativeAd,
  GDTRenderListener,
  GDTInteractionListener,
  GDTVideoStateListener,
  GDTAdSize,
  GDTError,
} from '@gdt/gdt-union-sdk';
import NativeExpressView from "./NativeExpressView";

@Component
export struct NativeExpressNativeView {
  @Prop params: Params;
  nativeExpressView: NativeExpressView = this.params.platformView as NativeExpressView;
  @State nativeAd?: GDTNativeAd = undefined;
  @State adComponent?: NodeController = undefined;
  @State isShowAd: boolean = false;
  @State adWidth: number = 0;
  @State adHeight: number = 0;

  posId: string = '';
  viewWidth: number = 0;
  viewHeight: number = 0;
  isBidding: boolean = false;
  windowStage?: window.WindowStage;

  build() {
    Column() {
      if (this.adComponent && this.isShowAd) {
        NodeContainer(this.adComponent)
          .width(this.adWidth > 0 ? this.adWidth : this.viewWidth)
          .height(this.adHeight > 0 ? this.adHeight : this.viewHeight);
      }
    }
    .width(this.viewWidth)
    .height(this.viewHeight)
  }

  aboutToAppear(): void {
    this.posId = this.nativeExpressView.getPosId();
    this.viewWidth = this.nativeExpressView.getViewWidth();
    this.viewHeight = this.nativeExpressView.getViewHeight();
    this.isBidding = this.nativeExpressView.getIsBidding();
    this.windowStage = this.nativeExpressView.getWindowStage();

    this.loadAd();
  }

  private loadAd() {
    const config: GDTAdLoadConfig = {
      posId: this.posId,
      adSize: new GDTAdSize(this.viewWidth, this.viewHeight)
    };

    const renderListener: GDTRenderListener = {
      onRenderSuccess: (): void => {
        console.info("NativeExpressNativeView 信息流广告渲染成功");
        this.adComponent = this.nativeAd?.getAdComponent();
        this.isShowAd = true;

        const width = this.viewWidth;
        const height = this.viewHeight;
        this.adWidth = width;
        this.adHeight = height;

        this.nativeExpressView.sendMsg("onShow", { "width": width, "height": height });
      },
      onRenderFail: (err: GDTError): void => {
        console.error(`NativeExpressNativeView 信息流广告渲染失败: ${err?.code}, ${err?.message}`);
        this.nativeExpressView.sendMsg("onFail", { "code": err?.code ?? -1, "message": err?.message ?? "渲染失败" });
        this.isShowAd = false;
      }
    };

    const interactionListener: GDTInteractionListener = {
      onAdExposure: (): void => {
        console.info("NativeExpressNativeView 信息流广告曝光");
        this.nativeExpressView.sendMsg("onExpose", "信息流广告曝光");
      },
      onAdClick: (): void => {
        console.info("NativeExpressNativeView 信息流广告点击");
        this.nativeExpressView.sendMsg("onClick", "信息流广告点击");
      },
      onAdClose: (): void => {
        console.info("NativeExpressNativeView 信息流广告关闭");
        this.nativeExpressView.sendMsg("onClose", "信息流广告关闭");
        this.clearAd();
      },
      onError: (err: GDTError): void => {
        console.error(`NativeExpressNativeView 信息流广告错误: ${err.code}, ${err.message}`);
        this.nativeExpressView.sendMsg("onFail", { "code": err.code, "message": err.message });
      }
    };

    const videoStateListener: GDTVideoStateListener = {
      onVideoReady: (): void => {},
      onVideoStart: (): void => {
        this.nativeExpressView.sendMsg("onVideoPlay", "视频开始播放");
      },
      onVideoPause: (): void => {
        this.nativeExpressView.sendMsg("onVideoPause", "视频暂停");
      },
      onVideoResume: (): void => {},
      onVideoComplete: (): void => {
        this.nativeExpressView.sendMsg("onVideoStop", "视频播放完成");
      },
      onVideoError: (err: GDTError): void => {
        console.error(`NativeExpressNativeView 视频错误: ${err.code}, ${err.message}`);
      }
    };

    GDTAdSDK.getAdLoader().loadNativeAd(config, {
      onAdLoad: (ads: Array<GDTNativeAd>): void => {
        console.info("NativeExpressNativeView 信息流广告加载成功");
        if (ads && ads.length > 0) {
          this.nativeAd = ads[0];

          if (this.isBidding) {
            const ecpm: number = this.nativeAd.getEcpm?.() ?? 0;
            const ecpmLevel: string = "";
            this.nativeExpressView.sendMsg("onECPM", { "ecpmLevel": ecpmLevel, "ecpm": ecpm });
          }

          // 设置监听器
          this.nativeAd.setRenderListener(renderListener);
          this.nativeAd.setInteractionListener(interactionListener);
          this.nativeAd.setVideoStateListener(videoStateListener);
          this.nativeAd.setVideoOptions({ autoPlayMuted: true });

          // 渲染广告
          this.nativeAd.render(this.windowStage, this.getUIContext());
        }
      },
      onError: (err: GDTError): void => {
        console.error(`NativeExpressNativeView 信息流广告加载失败: ${err.code}, ${err.message}`);
        this.nativeExpressView.sendMsg("onFail", { "code": err.code, "message": err.message });
      }
    });
  }

  private clearAd() {
    this.isShowAd = false;
    this.adComponent = undefined;
    this.nativeAd?.destroy();
    this.nativeAd = undefined;
  }

  aboutToDisappear(): void {
    this.clearAd();
  }
}

@Builder
export function NativeExpressBuilder(params: Params) {
  NativeExpressNativeView({
    params: params,
  })
}
