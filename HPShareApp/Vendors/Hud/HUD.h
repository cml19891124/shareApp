//
//  HUD.h
//  GlassEbuy
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 艾磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUD : NSObject

//屏幕提示文本，用当前的控制显示
+ (void)HUDWithString:(NSString *)message;
//屏幕提示文本，用根视图片控制器显示
+ (void)HUDRootViewWithStr:(NSString *)message;

+ (void)HUDKeyWindowWithStr:(NSString *)message;

+ (void)HUDWithString:(NSString *)message Delay:(NSInteger)delay;


+ (void)HUDNotHidden:(NSString *)message;
+ (void)HUDHidden;
@end


