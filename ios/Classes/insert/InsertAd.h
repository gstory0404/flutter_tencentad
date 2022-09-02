//
//  InsertAd.h
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InsertAd : NSObject
+ (instancetype)sharedInstance;
- (void)initAd:(NSDictionary *)arguments;
- (void)showAd:(NSDictionary *)arguments;
@end

NS_ASSUME_NONNULL_END
