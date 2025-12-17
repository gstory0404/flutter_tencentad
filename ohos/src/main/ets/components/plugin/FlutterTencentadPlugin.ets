import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import {
  GDTAdSDK,
  GDTAdSDKStartResult,
  GDTAdLoadConfig,
  GDTAdLoadListener,
  GDTRewardAd,
  GDTInterstitialAd,
  GDTInteractionListener,
  GDTVideoStateListener,
  GDTError,
} from '@gdt/gdt-union-sdk';
import FlutterTencentadEventPlugin from './FlutterTencentadEventPlugin';
import FlutterTencentadViewPlugin from './FlutterTencentadViewPlugin';

/** FlutterTencentadPlugin **/
export default class FlutterTencentadPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private channel: MethodChannel | null = null;
  private applicationContext: Context | null = null;
  private uiAbility: UIAbility | null = null;
  private flutterPluginBinding: FlutterPluginBinding | null = null;

  // 静态实例，用于其他组件获取 windowStage
  private static instance: FlutterTencentadPlugin | null = null;

  // 激励视频广告
  private rewardAd: GDTRewardAd | null = null;
  private rewardAdConfig: Map<string, string | number | boolean> = new Map();

  // 插屏广告
  private interstitialAd: GDTInterstitialAd | null = null;
  private interstitialAdConfig: Map<string, string | number | boolean> = new Map();

  constructor() {
    FlutterTencentadPlugin.instance = this;
  }

  // 静态方法获取当前 windowStage
  static getWindowStage(): window.WindowStage | null {
    return FlutterTencentadPlugin.instance?.uiAbility?.context?.windowStage ?? null;
  }

  getUniqueClassName(): string {
    return "FlutterTencentadPlugin";
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    console.info("FlutterTencentadPlugin onAttachedToEngine");
    this.flutterPluginBinding = binding;
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_tencentad");
    this.channel.setMethodCallHandler(this);
    this.applicationContext = binding.getApplicationContext();
    new FlutterTencentadEventPlugin().onAttachedToEngine(binding);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
    }
    this.flutterPluginBinding = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    console.info("FlutterTencentadPlugin onAttachedToAbility");
    this.uiAbility = binding.getAbility();
    if (this.flutterPluginBinding) {
      FlutterTencentadViewPlugin.register(this.flutterPluginBinding, this.uiAbility);
    }
  }

  onDetachedFromAbility(): void {
    this.uiAbility = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "register":
        this.register(call, result);
        break;
      case "getSDKVersion":
        result.success(GDTAdSDK.getSDKVersion());
        break;
      case "loadRewardVideoAd":
        this.loadRewardVideoAd(call, result);
        break;
      case "showRewardVideoAd":
        this.showRewardVideoAd(call, result);
        break;
      case "loadInterstitialAD":
        this.loadInterstitialAd(call, result);
        break;
      case "showInterstitialAD":
        this.showInterstitialAd(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  // SDK 初始化
  private register(call: MethodCall, result: MethodResult): void {
    const ohosId: string = call.args.get("ohosId");
    const debug: boolean = call.args.get("debug") ?? false;

    console.info(`FlutterTencentadPlugin register appId: ${ohosId}, debug: ${debug}`);

    GDTAdSDK.init(this.uiAbility?.context, {
      appId: ohosId
    });

    GDTAdSDK.start()
      .then((res: GDTAdSDKStartResult) => {
        console.info("FlutterTencentadPlugin SDK初始化成功");
        result.success(true);
      })
      .catch((err: Error) => {
        console.error(`FlutterTencentadPlugin SDK初始化失败: ${err.message}`);
        result.success(false);
      });
  }

  // 加载激励视频广告
  private loadRewardVideoAd(call: MethodCall, result: MethodResult): void {
    const ohosId: string = call.args.get("ohosId");
    const userID: string = call.args.get("userID") ?? "";
    const rewardName: string = call.args.get("rewardName") ?? "";
    const rewardAmount: number = call.args.get("rewardAmount") ?? 0;
    const isBidding: boolean = call.args.get("isBidding") ?? false;

    this.rewardAdConfig.set("userID", userID);
    this.rewardAdConfig.set("rewardName", rewardName);
    this.rewardAdConfig.set("rewardAmount", rewardAmount);
    this.rewardAdConfig.set("isBidding", isBidding);

    const config: GDTAdLoadConfig = {
      posId: ohosId
    };

    console.info(`FlutterTencentadPlugin loadRewardVideoAd posId: ${ohosId}`);

    const adLoadListener: GDTAdLoadListener<GDTRewardAd> = {
      onAdLoad: (ad: GDTRewardAd): void => {
        console.info("FlutterTencentadPlugin 激励广告加载成功");
        console.info(`FlutterTencentadPlugin 广告是否有效: ${ad.isValid()}`);
        this.rewardAd = ad;

        if (isBidding) {
          // 竞价模式，返回 ecpm
          const ecpm: number = ad.getEcpm?.() ?? 0;
          const ecpmLevel: string = "";
          const map: Record<string, string | number> = {
            "adType": "rewardAd",
            "onAdMethod": "onECPM",
            "ecpmLevel": ecpmLevel,
            "ecpm": ecpm
          };
          FlutterTencentadEventPlugin.sendContent(map);
        } else {
          const map: Record<string, string | number> = {
            "adType": "rewardAd",
            "onAdMethod": "onReady"
          };
          FlutterTencentadEventPlugin.sendContent(map);
        }
      },
      onError: (err: GDTError): void => {
        console.error(`FlutterTencentadPlugin 激励广告加载失败: ${err.code}, ${err.message}`);
        const map: Record<string, string | number> = {
          "adType": "rewardAd",
          "onAdMethod": "onFail",
          "code": err.code,
          "message": err.message
        };
        FlutterTencentadEventPlugin.sendContent(map);
      }
    };

    GDTAdSDK.getAdLoader().loadRewardAd(config, adLoadListener);
    result.success(true);
  }

  // 显示激励视频广告
  private showRewardVideoAd(call: MethodCall, result: MethodResult): void {
    console.info("FlutterTencentadPlugin showRewardVideoAd called");

    if (!this.rewardAd) {
      console.error("FlutterTencentadPlugin 激励广告未加载");
      const map: Record<string, string | number> = {
        "adType": "rewardAd",
        "onAdMethod": "onUnReady"
      };
      FlutterTencentadEventPlugin.sendContent(map);
      result.success(false);
      return;
    }

    // 实时获取 windowStage
    const currentWindowStage = this.uiAbility?.context?.windowStage;
    console.info(`FlutterTencentadPlugin currentWindowStage: ${currentWindowStage}`);

    if (!currentWindowStage) {
      console.error("FlutterTencentadPlugin windowStage 为空");
      const map: Record<string, string | number> = {
        "adType": "rewardAd",
        "onAdMethod": "onFail",
        "code": -1,
        "message": "windowStage is null"
      };
      FlutterTencentadEventPlugin.sendContent(map);
      result.success(false);
      return;
    }

    // 检查广告是否有效
    if (!this.rewardAd.isValid()) {
      console.error("FlutterTencentadPlugin 激励广告已失效");
      const map: Record<string, string | number> = {
        "adType": "rewardAd",
        "onAdMethod": "onFail",
        "code": -2,
        "message": "广告已失效，请重新加载"
      };
      FlutterTencentadEventPlugin.sendContent(map);
      this.rewardAd = null;
      result.success(false);
      return;
    }

    const rewardName = this.rewardAdConfig.get("rewardName") as string ?? "";
    const rewardAmount = this.rewardAdConfig.get("rewardAmount") as number ?? 0;

    const interactionListener: GDTInteractionListener = {
      onAdExposure: (): void => {
        console.info("FlutterTencentadPlugin 激励广告曝光");
        const map: Record<string, string | number> = {
          "adType": "rewardAd",
          "onAdMethod": "onShow"
        };
        FlutterTencentadEventPlugin.sendContent(map);
      },
      onAdClick: (): void => {
        console.info("FlutterTencentadPlugin 激励广告点击");
        const map: Record<string, string | number> = {
          "adType": "rewardAd",
          "onAdMethod": "onClick"
        };
        FlutterTencentadEventPlugin.sendContent(map);
      },
      onAdClose: (): void => {
        console.info("FlutterTencentadPlugin 激励广告关闭");
        const map: Record<string, string | number> = {
          "adType": "rewardAd",
          "onAdMethod": "onClose"
        };
        FlutterTencentadEventPlugin.sendContent(map);
        this.rewardAd = null;
      },
      onError: (err: GDTError): void => {
        console.error(`FlutterTencentadPlugin 激励广告错误: ${err.code}, ${err.message}`);
        const map: Record<string, string | number> = {
          "adType": "rewardAd",
          "onAdMethod": "onFail",
          "code": err.code,
          "message": err.message
        };
        FlutterTencentadEventPlugin.sendContent(map);
      },
      onReward: (rewardMap: Map<string, string>): void => {
        console.info("FlutterTencentadPlugin 激励广告奖励验证");
        const map: Record<string, string | number> = {
          "adType": "rewardAd",
          "onAdMethod": "onVerify",
          "transId": rewardMap?.get("transId") ?? "",
          "rewardName": rewardName,
          "rewardAmount": rewardAmount
        };
        FlutterTencentadEventPlugin.sendContent(map);
      }
    };

    const videoStateListener: GDTVideoStateListener = {
      onVideoReady: (): void => {
        console.info("FlutterTencentadPlugin 激励广告视频准备就绪");
      },
      onVideoStart: (): void => {
        console.info("FlutterTencentadPlugin 激励广告视频开始播放");
      },
      onVideoPause: (): void => {
        console.info("FlutterTencentadPlugin 激励广告视频暂停");
      },
      onVideoResume: (): void => {
        console.info("FlutterTencentadPlugin 激励广告视频恢复");
      },
      onVideoComplete: (): void => {
        console.info("FlutterTencentadPlugin 激励广告视频播放完成");
        const map: Record<string, string | number> = {
          "adType": "rewardAd",
          "onAdMethod": "onFinish"
        };
        FlutterTencentadEventPlugin.sendContent(map);
      },
      onVideoError: (err: GDTError): void => {
        console.error(`FlutterTencentadPlugin 激励广告视频错误: ${err.code}, ${err.message}`);
      }
    };

    this.rewardAd.setInteractionListener(interactionListener);
    this.rewardAd.setVideoStateListener(videoStateListener);
    this.rewardAd.setVideoOptions({ autoPlayMuted: false });

    console.info("FlutterTencentadPlugin 开始展示激励广告");
    this.rewardAd.show(currentWindowStage);
    console.info("FlutterTencentadPlugin 激励广告 show 方法已调用");
    result.success(true);
  }

  // 加载插屏广告
  private loadInterstitialAd(call: MethodCall, result: MethodResult): void {
    const ohosId: string = call.args.get("ohosId");
    const isFullScreen: boolean = call.args.get("isFullScreen") ?? false;
    const isBidding: boolean = call.args.get("isBidding") ?? false;

    this.interstitialAdConfig.set("isFullScreen", isFullScreen);
    this.interstitialAdConfig.set("isBidding", isBidding);

    const config: GDTAdLoadConfig = {
      posId: ohosId
    };

    console.info(`FlutterTencentadPlugin loadInterstitialAd posId: ${ohosId}`);

    const adLoadListener: GDTAdLoadListener<GDTInterstitialAd> = {
      onAdLoad: (ad: GDTInterstitialAd): void => {
        console.info("FlutterTencentadPlugin 插屏广告加载成功");
        console.info(`FlutterTencentadPlugin 广告是否有效: ${ad.isValid()}`);
        this.interstitialAd = ad;

        if (isBidding) {
          const ecpm: number = ad.getEcpm?.() ?? 0;
          const ecpmLevel: string = "";
          const map: Record<string, string | number> = {
            "adType": "interactAd",
            "onAdMethod": "onECPM",
            "ecpmLevel": ecpmLevel,
            "ecpm": ecpm
          };
          FlutterTencentadEventPlugin.sendContent(map);
        } else {
          const map: Record<string, string | number> = {
            "adType": "interactAd",
            "onAdMethod": "onReady"
          };
          FlutterTencentadEventPlugin.sendContent(map);
        }
      },
      onError: (err: GDTError): void => {
        console.error(`FlutterTencentadPlugin 插屏广告加载失败: ${err.code}, ${err.message}`);
        const map: Record<string, string | number> = {
          "adType": "interactAd",
          "onAdMethod": "onFail",
          "code": err.code,
          "message": err.message
        };
        FlutterTencentadEventPlugin.sendContent(map);
      }
    };

    GDTAdSDK.getAdLoader().loadInterstitialAd(config, adLoadListener);
    result.success(true);
  }

  // 显示插屏广告
  private showInterstitialAd(call: MethodCall, result: MethodResult): void {
    console.info("FlutterTencentadPlugin showInterstitialAd called");

    if (!this.interstitialAd) {
      console.error("FlutterTencentadPlugin 插屏广告未加载");
      const map: Record<string, string | number> = {
        "adType": "interactAd",
        "onAdMethod": "onUnReady"
      };
      FlutterTencentadEventPlugin.sendContent(map);
      result.success(false);
      return;
    }

    // 实时获取 windowStage
    const currentWindowStage = this.uiAbility?.context?.windowStage;
    console.info(`FlutterTencentadPlugin currentWindowStage: ${currentWindowStage}`);

    if (!currentWindowStage) {
      console.error("FlutterTencentadPlugin windowStage 为空");
      const map: Record<string, string | number> = {
        "adType": "interactAd",
        "onAdMethod": "onFail",
        "code": -1,
        "message": "windowStage is null"
      };
      FlutterTencentadEventPlugin.sendContent(map);
      result.success(false);
      return;
    }

    // 检查广告是否有效
    if (!this.interstitialAd.isValid()) {
      console.error("FlutterTencentadPlugin 插屏广告已失效");
      const map: Record<string, string | number> = {
        "adType": "interactAd",
        "onAdMethod": "onFail",
        "code": -2,
        "message": "广告已失效，请重新加载"
      };
      FlutterTencentadEventPlugin.sendContent(map);
      this.interstitialAd = null;
      result.success(false);
      return;
    }

    const interactionListener: GDTInteractionListener = {
      onAdExposure: (): void => {
        console.info("FlutterTencentadPlugin 插屏广告曝光");
        const map: Record<string, string | number> = {
          "adType": "interactAd",
          "onAdMethod": "onShow"
        };
        FlutterTencentadEventPlugin.sendContent(map);
      },
      onAdClick: (): void => {
        console.info("FlutterTencentadPlugin 插屏广告点击");
        const map: Record<string, string | number> = {
          "adType": "interactAd",
          "onAdMethod": "onClick"
        };
        FlutterTencentadEventPlugin.sendContent(map);
      },
      onAdClose: (): void => {
        console.info("FlutterTencentadPlugin 插屏广告关闭");
        const map: Record<string, string | number> = {
          "adType": "interactAd",
          "onAdMethod": "onClose"
        };
        FlutterTencentadEventPlugin.sendContent(map);
        this.interstitialAd = null;
      },
      onError: (err: GDTError): void => {
        console.error(`FlutterTencentadPlugin 插屏广告错误: ${err.code}, ${err.message}`);
        const map: Record<string, string | number> = {
          "adType": "interactAd",
          "onAdMethod": "onFail",
          "code": err.code,
          "message": err.message
        };
        FlutterTencentadEventPlugin.sendContent(map);
      }
    };

    const videoStateListener: GDTVideoStateListener = {
      onVideoReady: (): void => {},
      onVideoStart: (): void => {},
      onVideoPause: (): void => {},
      onVideoResume: (): void => {},
      onVideoComplete: (): void => {
        const map: Record<string, string | number> = {
          "adType": "interactAd",
          "onAdMethod": "onFinish"
        };
        FlutterTencentadEventPlugin.sendContent(map);
      },
      onVideoError: (err: GDTError): void => {}
    };

    this.interstitialAd.setInteractionListener(interactionListener);
    this.interstitialAd.setVideoStateListener(videoStateListener);
    this.interstitialAd.setVideoOptions({ autoPlayMuted: true });

    console.info("FlutterTencentadPlugin 开始展示插屏广告");
    this.interstitialAd.show(currentWindowStage);
    console.info("FlutterTencentadPlugin 插屏广告 show 方法已调用");
    result.success(true);
  }
}
