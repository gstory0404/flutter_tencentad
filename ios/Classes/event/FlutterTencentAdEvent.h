//
//  FlutterTencentAdEvent.h
//  flutter_tencentad
//
//  Created by 郭维佳 on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterTencentAdEvent : NSObject
+ (instancetype)sharedInstance;
- (void)initEvent:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)sentEvent:(NSDictionary*)arguments;
@end

NS_ASSUME_NONNULL_END
