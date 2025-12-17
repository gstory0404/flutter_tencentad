import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { window } from '@kit.ArkUI';
import {
  GDTAdSDK,
  GDTAdLoadConfig,
  GDTAdLoadListener,
  GDTSplashAd,
  GDTInteractionListener,
  GDTError,
} from '@gdt/gdt-union-sdk';
import SplashView from "./SplashView";
import FlutterTencentadPlugin from "../FlutterTencentadPlugin";

@Component
export struct SplashNativeView {
  @Prop params: Params;
  splashView: SplashView = this.params.platformView as SplashView;
  @State splashAd?: GDTSplashAd = undefined;
  @State isClose: boolean = false;

  posId: string = '';
  viewWidth: number = 0;
  viewHeight: number = 0;
  fetchDelay: number = 5000;
  isBidding: boolean = false;

  build() {
    if (!this.isClose) {
      Column() {
        // 开屏广告使用 show 方法展示独立窗口，这里只是占位
        Text("").width('100%').height('100%')
      }
      .width('100%')
      .height('100%')
    }
  }

  aboutToAppear(): void {
    this.posId = this.splashView.getPosId();
    this.viewWidth = this.splashView.getViewWidth();
    this.viewHeight = this.splashView.getViewHeight();
    this.fetchDelay = this.splashView.getFetchDelay();
    this.isBidding = this.splashView.getIsBidding();
    this.loadAd();
  }

  private loadAd() {

    const config: GDTAdLoadConfig = {
      posId: this.posId,
      timeoutMillis: this.fetchDelay
    };

    const interactionListener: GDTInteractionListener = {
      onAdExposure: (): void => {
        this.splashView.sendMsg("onShow", "开屏广告展示成功");
        this.splashView.sendMsg("onExpose", "开屏广告曝光");
      },
      onAdClick: (): void => {
        this.splashView.sendMsg("onClick", "开屏广告点击");
      },
      onAdClose: (): void => {
        this.splashView.sendMsg("onClose", "开屏广告关闭");
        this.clearAd();
      },
      onError: (err: GDTError): void => {
        this.splashView.sendMsg("onFail", { "code": err.code, "message": err.message });
        this.isClose = true;
      }
    };

    const adLoadListener: GDTAdLoadListener<GDTSplashAd> = {
      onAdLoad: (ad: GDTSplashAd): void => {
        this.splashAd = ad;
        this.splashView.sendMsg("onLoad", "开屏广告加载成功");

        if (this.isBidding) {
          const ecpm: number = ad.getEcpm?.() ?? 0;
          this.splashView.sendMsg("onECPM", { "ecpmLevel": "", "ecpm": ecpm });
        }

        const currentWindowStage = FlutterTencentadPlugin.getWindowStage();
        if (!currentWindowStage) {
          this.splashView.sendMsg("onFail", { "code": -1, "message": "windowStage is null" });
          this.isClose = true;
          return;
        }

        ad.setInteractionListener(interactionListener);

        if (this.splashAd) {
            const ws = FlutterTencentadPlugin.getWindowStage();
            if (ws) {
              this.splashAd.show(ws);
            } else {
              this.splashView.sendMsg("onFail", { "code": -1, "message": "windowStage is null" });
            }
          }
      },
      onError: (err: GDTError): void => {
        this.splashView.sendMsg("onFail", { "code": err.code, "message": err.message });
        this.isClose = true;
      }
    };

    GDTAdSDK.getAdLoader().loadSplashAd(config, adLoadListener);
  }

  private clearAd(): void {
    this.isClose = true;
    this.splashAd = undefined;
  }

  aboutToDisappear(): void {
    this.clearAd();
  }
}

@Builder
export function SplashBuilder(params: Params) {
  SplashNativeView({
    params: params,
  })
}
