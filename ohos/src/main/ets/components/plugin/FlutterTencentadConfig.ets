interface ViewConfig {
  splashAdView: string;
  bannerAdView: string;
  nativeExpressAdView: string;
}

export default class FlutterTencentadConfig {
  public static readonly adevent = "com.gstory.flutter_tencentad/adevent";

  public static readonly view: ViewConfig = {
    splashAdView: "com.gstory.flutter_tencentad/SplashAdView",
    bannerAdView: "com.gstory.flutter_tencentad/BannerAdView",
    nativeExpressAdView: "com.gstory.flutter_tencentad/NativeExpressAdView"
  };
}
