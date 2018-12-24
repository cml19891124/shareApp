//
//  HPProgressHUD.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "UIViewController+Helper.h"
#import "Macro.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPProgressHUD : NSObject

+ (void)alertMessage:(NSString *)msg;

+ (void)alertAtBottomMessage:(NSString *)msg;

+ (void)alertMessage:(NSString *)msg hideAfterDelay:(NSTimeInterval)delay AtBottom:(BOOL)isBottom;

+ (void)alertWithProgress:(double)progress text:(NSString *)text;

+ (void)alertWithImage:(UIImage *)image text:(NSString *)text;

+ (void)alertWithFinishText:(NSString *)text;

+ (void)alertWithLoadingText:(NSString *)text;

+ (void)hideHud;

@end

NS_ASSUME_NONNULL_END
