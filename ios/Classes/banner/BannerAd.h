//
//  BannerAd.h
//  flutter_tencentad
//
//  Created by 郭维佳 on 2021/12/1.
//

#import <Foundation/Foundation.h>

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN
@interface BannerAdFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;

@end

@interface BannerAd : NSObject<FlutterPlatformView>

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
