//
//  HUD.m
//  GlassEbuy
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 艾磊. All rights reserved.
//

#import "HUD.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "GetCurrentViewcontroller.h"
#define COLOR(x, y, z, a)       [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

static MBProgressHUD *Hud = nil;
@implementation HUD

+ (void)HUDNotHidden:(NSString *)message

{
        dispatch_async(dispatch_get_main_queue(), ^{
    Hud = [MBProgressHUD showHUDAddedTo:[GetCurrentViewcontroller topViewController].view animated:YES];
    Hud.mode = MBProgressHUDModeIndeterminate;
//            Hud.offset = CGPointMake(0, 200);//移动hud显示的位置
//            Hud.userInteractionEnabled = NO;//使hud覆盖的view也可以响应用户点击
            Hud.label.text = message;
    Hud.removeFromSuperViewOnHide = YES;
    Hud.bezelView.color = [UIColor whiteColor];
    Hud.bezelView.color = COLOR(0, 0, 0, 0.4);
        });
}




+ (void)HUDHidden
{
        dispatch_async(dispatch_get_main_queue(), ^{
    if (Hud)
    {
        [Hud hideAnimated:YES];
        
    }
        });
                       
}


+ (void)HUDWithString:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (Hud)
        {
            [Hud hideAnimated:YES];
            
        }
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        HUD.userInteractionEnabled = YES;
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = message;
        HUD.removeFromSuperViewOnHide = YES;
        HUD.bezelView.color = [UIColor whiteColor];
        HUD.bezelView.color = COLOR(0, 0, 0, 0.4);
        [Hud hideAnimated:YES afterDelay:1];
    });
    

}

+ (void)HUDWithString:(NSString *)message Delay:(NSInteger)delay{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (Hud)
        {
            [Hud hideAnimated:YES];
            
        }
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        HUD.userInteractionEnabled = YES;
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = message;
        HUD.removeFromSuperViewOnHide = YES;
        HUD.bezelView.color = [UIColor whiteColor];
        HUD.bezelView.color = COLOR(0, 0, 0, 0.4);
        [HUD hideAnimated:YES afterDelay:delay];
        
    });
}



+ (void)HUDRootViewWithStr:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = message;
        HUD.removeFromSuperViewOnHide = YES;
        HUD.bezelView.color = [UIColor whiteColor];
        HUD.bezelView.color = COLOR(0, 0, 0, 0.4);
        [HUD hideAnimated:YES afterDelay:1];
        
    });
}

+ (void)HUDKeyWindowWithStr:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.text = message;
        HUD.removeFromSuperViewOnHide = YES;
        HUD.bezelView.color = [UIColor whiteColor];
        HUD.bezelView.color = COLOR(0, 0, 0, 0.4);
        [Hud hideAnimated:YES afterDelay:1];

    });
}
@end
