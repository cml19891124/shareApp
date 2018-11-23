//
//  HPProgressHUD.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPProgressHUD.h"

@implementation HPProgressHUD

+ (void)alertMessage:(NSString *)msg {
    [self alertMessage:msg hideAfterDelay:1.0 AtBottom:NO];
}

+ (void)alertAtBottomMessage:(NSString *)msg {
    [self alertMessage:msg hideAfterDelay:1.0 AtBottom:YES];
}

+ (void)alertMessage:(NSString *)msg hideAfterDelay:(NSTimeInterval)delay AtBottom:(BOOL)isBottom {
    UIView *currentView = [UIViewController getCurrentVC].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (isBottom) {
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    }
    hud.label.text = msg;
    [hud.label setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [hud.label setTextColor:UIColor.whiteColor];
    hud.bezelView.backgroundColor = COLOR_BLACK_TRANS_1111119b;
    [hud hideAnimated:YES afterDelay:delay];
}

@end
