//
//  NativeAd.m
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import "NativeAd.h"
#import "GDTNativeExpressAd.h"
#import "LogUtil.h"
#import "UIViewController+getCurrentVC.h"
#import "LogUtil.h"
#import "GDTNativeExpressAdView.h"

#pragma mark - NaitveAdFactory

@implementation NaitveAdFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    NativeAd * nativeAd = [[NativeAd alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return nativeAd;
}
@end

@interface NativeAd()<GDTNativeExpressAdDelegete>

@property (nonatomic, strong) GDTNativeExpressAd *native;
@property(nonatomic,strong) UIView *container;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) NSInteger viewId;
@property(nonatomic,strong) FlutterMethodChannel *channel;
@property(nonatomic,strong) NSString *codeId;
@property(nonatomic,assign) NSInteger viewWidth;
@property(nonatomic,assign) NSInteger viewHeight;
@end

#pragma mark - NativeAd
@implementation NativeAd

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    [[LogUtil sharedInstance] print:@"111"];
    if ([super init]) {
        NSDictionary *dic = args;
        _frame = frame;
        _viewId = viewId;
        _codeId = dic[@"iosId"];
        _viewWidth =[dic[@"viewWidth"] intValue];
        _viewHeight =[dic[@"viewHeight"] intValue];
        NSString* channelName = [NSString stringWithFormat:@"com.gstory.flutter_tencentad/NativeExpressAdView_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        _container = [[UIView alloc] initWithFrame:frame];
        [self loadNativeAd];
    }
    return self;
}

- (UIView*)view{
    return  _container;
}

-(void)loadNativeAd{
    [_container removeFromSuperview];
    CGSize size = CGSizeMake(_viewWidth, _viewHeight);
    if(_native == nil){
        _native =[[GDTNativeExpressAd alloc] initWithPlacementId:_codeId adSize:size];
        _native.delegate = self;
    }
    [_native loadAd:1];
}

#pragma mark - 广告请求delegate
/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    [[LogUtil sharedInstance] print:@"拉取原生模板广告成功"];
    if (views.count) {
           [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
               expressView.controller = [UIViewController jsd_getCurrentViewController];
               [_container addSubview:expressView];
               [expressView render];
           }];
       }
//    if(views.count > 0){
//        [_container removeFromSuperview];
//        GDTNativeExpressAdView *gdtNativeExpressAdView = views[0];
//        gdtNativeExpressAdView.controller = [UIViewController jsd_getCurrentViewController];
//        [gdtNativeExpressAdView render];
//
//    }
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
    [[LogUtil sharedInstance] print:(@"拉取原生模板广告失败 %@",error.userInfo)];
//    NSDictionary *dictionary = @{@"code":@(-1),@"message":(@"%@",error)};
//    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}


/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"原生模板广告渲染成功"];
    [_channel invokeMethod:@"onShow" arguments:nil result:nil];
}


/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"原生模板广告渲染失败"];
    NSDictionary *dictionary = @{@"code":@(-1),@"message":@"原生模板广告渲染失败"};
    [_channel invokeMethod:@"onFail" arguments:dictionary result:nil];
}


/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"原生模板广告曝光回调"];
    [_channel invokeMethod:@"onExpose" arguments:nil result:nil];
}


/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"原生模板广告点击回调"];
    [_channel invokeMethod:@"onClick" arguments:nil result:nil];
}


/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"原生模板广告被关闭"];
    [_channel invokeMethod:@"onClose" arguments:nil result:nil];
}


/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"点击原生模板广告以后即将弹出全屏广告页"];
}


/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"点击原生模板广告以后弹出全屏广告页"];
}


/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewWillDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"全屏广告页将要关闭"];
}


/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewDidDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"全屏广告页将要关闭"];
}


/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"详解:当点击应用下载或者广告调用系统程序打开时调用"];
}


/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status{
    [[LogUtil sharedInstance] print:@"原生模板视频广告 player 播放状态更新回调"];
}


/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"原生视频模板详情页 WillPresent 回调"];
}


/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@"原生视频模板详情页 DidPresent 回调"];
}


/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{
    [[LogUtil sharedInstance] print:@" 原生视频模板详情页 WillDismiss 回调"];
}


/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView;{
    [[LogUtil sharedInstance] print:@"原生视频模板详情页 DidDismiss 回调"];
}


@end
