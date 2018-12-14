//
//  HPLocalNotiTool.h
//  HPShareApp
//
//  Created by HP on 2018/12/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPLocalNotiTool : NSObject<UNUserNotificationCenterDelegate>
//使用 UNNotification 本地通知

+ (void)registerNotification:(NSInteger )alertTime title:(NSString *)title body:(NSString *)body;
@end

NS_ASSUME_NONNULL_END
