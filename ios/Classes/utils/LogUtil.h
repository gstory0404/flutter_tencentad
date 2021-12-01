//
//  LogUtil.h
//  flutter_tencentad
//
//  Created by gstory on 2021/12/1.
//

#ifdef DEBUG
#define GLog(...) NSLog(@"%s\n %@\n\n", __func__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define GLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LogUtil : NSObject
+ (instancetype)sharedInstance;
- (void)debug:(BOOL)isDebug;
- (void)print:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
