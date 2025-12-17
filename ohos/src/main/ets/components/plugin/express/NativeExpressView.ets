import { Any, BinaryMessenger, MethodChannel, PlatformView } from "@ohos/flutter_ohos";
import { common, UIAbility } from "@kit.AbilityKit";
import { HashMap } from "@kit.ArkTS";
import { window } from "@kit.ArkUI";
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import FlutterTencentadConfig from "../FlutterTencentadConfig";
import { NativeExpressBuilder } from "./NativeExpressNativeView";

export default class NativeExpressView extends PlatformView {
  private posId: string = "";
  private viewWidth: number = 0;
  private viewHeight: number = 0;
  private isBidding: boolean = false;
  private channel: MethodChannel;
  private windowStage?: window.WindowStage;

  constructor(
    context: common.Context,
    viewId: number,
    params: HashMap<string, Any>,
    messenger: BinaryMessenger,
    uIAbility: UIAbility
  ) {
    super();
    this.posId = params.get("ohosId") as string;
    this.viewWidth = params.get("viewWidth") as number ?? 0;
    this.viewHeight = params.get("viewHeight") as number ?? 0;
    this.isBidding = params.get("isBidding") as boolean ?? false;
    this.channel = new MethodChannel(messenger, FlutterTencentadConfig.view.nativeExpressAdView + "_" + viewId);
    this.windowStage = uIAbility.context.windowStage;
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(NativeExpressBuilder);
  }

  getPosId(): string {
    return this.posId;
  }

  getViewWidth(): number {
    return this.viewWidth;
  }

  getViewHeight(): number {
    return this.viewHeight;
  }

  getIsBidding(): boolean {
    return this.isBidding;
  }

  getChannel(): MethodChannel {
    return this.channel;
  }

  getWindowStage(): window.WindowStage {
    return this.windowStage!;
  }

  sendMsg(key: string, msg: Any) {
    this.channel.invokeMethod(key, msg);
  }

  dispose(): void {
  }
}
