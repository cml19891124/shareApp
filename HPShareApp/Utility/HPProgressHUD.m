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
    MBProgressHUD *hud = [MBProgressHUD HUDForView:currentView];
    
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
         [hud setRemoveFromSuperViewOnHide:YES];
    }
    
    if (isBottom) {
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    }
    else {
        hud.offset = CGPointMake(0.f, 0.f);
    }
    
    hud.mode = MBProgressHUDModeText;
    [hud.label setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [hud.label setTextColor:UIColor.whiteColor];
    hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
    [hud.bezelView.layer setCornerRadius:10.f];
    hud.label.text = msg;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)alertWithProgress:(double)progress text:(NSString *)text {
    UIView *currentView = [UIViewController getCurrentVC].view;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:currentView];
        
        if (!hud || hud.mode != MBProgressHUDModeAnnularDeterminate) {
            hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
            [hud setRemoveFromSuperViewOnHide:YES];
        }
        
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.contentColor = UIColor.whiteColor;
        [hud.label setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
        hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
        [hud.bezelView.layer setCornerRadius:10.f];
        hud.progress = progress;
        hud.label.text = text;
    });
}

+ (void)alertWithImage:(UIImage *)image text:(NSString *)text {
    UIView *currentView = [UIViewController getCurrentVC].view;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:currentView];
    
    if (!hud || hud.mode == MBProgressHUDModeText) {
        hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
        [hud setRemoveFromSuperViewOnHide:YES];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    [hud.label setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [hud.label setTextColor:UIColor.whiteColor];
    hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
    [hud.bezelView.layer setCornerRadius:10.f];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1.0];
}

+ (void)alertWithFinishText:(NSString *)text {
    [HPProgressHUD alertWithImage:[UIImage imageNamed:@"Checkmark"] text:text];
}

@end
