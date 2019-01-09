//
//  AppDelegate+Config.h
//  HPShareApp
//
//  Created by HP on 2018/12/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "Macro.h"
#import "AppDelegate.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (JPush)<JPUSHRegisterDelegate>

/**
JPush配置
 */
+ (void)setUpJPushConfigWithOptions:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
