import { FlutterPluginBinding } from '@ohos/flutter_ohos';
import { UIAbility } from '@kit.AbilityKit';
import FlutterTencentadConfig from './FlutterTencentadConfig';
import SplashAdViewFactory from './splash/SplashAdViewFactory';
import BannerAdViewFactory from './banner/BannerAdViewFactory';
import NativeExpressAdViewFactory from './express/NativeExpressAdViewFactory';

export default class FlutterTencentadViewPlugin {
  static register(binding: FlutterPluginBinding, uIAbility: UIAbility) {
    binding.getPlatformViewRegistry().registerViewFactory(
      FlutterTencentadConfig.view.splashAdView,
      new SplashAdViewFactory(binding, uIAbility)
    );
    binding.getPlatformViewRegistry().registerViewFactory(
      FlutterTencentadConfig.view.bannerAdView,
      new BannerAdViewFactory(binding, uIAbility)
    );
    binding.getPlatformViewRegistry().registerViewFactory(
      FlutterTencentadConfig.view.nativeExpressAdView,
      new NativeExpressAdViewFactory(binding, uIAbility)
    );
  }
}
