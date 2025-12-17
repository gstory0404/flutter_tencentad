import { Any, FlutterPluginBinding, PlatformView, PlatformViewFactory, StandardMessageCodec } from '@ohos/flutter_ohos';
import { common, UIAbility } from '@kit.AbilityKit';
import SplashView from './SplashView';

export default class SplashAdViewFactory extends PlatformViewFactory {
  binding?: FlutterPluginBinding;
  uIAbility?: UIAbility;

  constructor(binding: FlutterPluginBinding, uIAbility: UIAbility) {
    super(StandardMessageCodec.INSTANCE);
    this.binding = binding;
    this.uIAbility = uIAbility;
  }

  public create(context: common.Context, viewId: number, args: Any): PlatformView {
    return new SplashView(context, viewId, args, this.binding?.getBinaryMessenger()!, this.uIAbility!);
  }
}
