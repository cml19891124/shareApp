//
//  AppDelegate.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "HPGlobalVariable.h"
#import "Macro.h"
#import "HPMainTabBarController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AppDelegate+JPush.h"
#import <UserNotifications/UserNotifications.h>
#import "HPTextDialogView.h"
#import "HPGuideViewController.h"
#import "HPCommonData.h"
#import "HPCommonBannerData.h"
#import "HPHomeBannerModel.h"
#import "HPSingleton.h"
#import "Bugly/Bugly.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>
@property (nonatomic, weak) HPTextDialogView *textDialogView;

@end

@implementation AppDelegate

#pragma mark - 检测版本更新信息
- (void)updateAppVersionInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        
        //获取本地版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *newVersion = [NSString stringWithFormat:@"%@", version];
        NSArray *currentVersionArr = [newVersion componentsSeparatedByString:@"."];
        NSString *currentVersion =@"";
        for (int i = 0;i < currentVersionArr.count; i++) {
            currentVersion = [currentVersion stringByAppendingString:currentVersionArr[i]];
        }
        //获取appStore网络版本号
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kAppleId]];
        NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        NSRange range1 = NSMakeRange(substr.location+substr.length,10);
        NSRange substr2 = [file rangeOfString:@"\"" options:NSCaseInsensitiveSearch  range:range1];
        NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
        NSString *appStoreVersion =[file substringWithRange:range2];
        NSArray *appStoreVersionArr = [appStoreVersion componentsSeparatedByString:@"."];
        NSString *onlineVersion = @"";
        for (int i = 0;i < appStoreVersionArr.count; i++) {
            onlineVersion = [onlineVersion stringByAppendingString:appStoreVersionArr[i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            //如果不一样去更新
            if([currentVersion intValue] < [onlineVersion intValue])
            {
                [self showAlert];
            }
        });
    });

}

/**
 *  检查新版本更新弹框
 */
-(void)showAlert
{
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setText:@"有新的版本啦"];
        [textDialogView setModalTop:279.f * g_rateHeight];
        [textDialogView setCanecelBtnTitle:@"暂不更新"];
        [textDialogView setConfirmBtnTitle:@"前往更新"];
        _textDialogView = textDialogView;
    }
    
    [_textDialogView setConfirmCallback:^{
        // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kAppleId]];
        [[UIApplication sharedApplication] openURL:url];
    }];
    
    [_textDialogView show:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //极光
    [AppDelegate setUpJPushAndMessageConfigWithOptions:launchOptions];
    
    [Bugly startWithAppId:kAppleId];
    
    [self updateAppVersionInfo];
    [HPGlobalVariable initVariable];
    [HPCommonData getAreaData];
    [HPCommonData getIndustryData];
    
    [self configureAMapKey];
    HPGuideViewController *guidevc = [[HPGuideViewController alloc] init];
    HPMainTabBarController *mainTabBarController = [[HPMainTabBarController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
    navigationController.navigationBarHidden = YES;
    [navigationController.interactivePopGestureRecognizer setDelegate:mainTabBarController];
    NSString *isFirst = [kUserDefaults objectForKey:@"isFirst"];
    if ([isFirst isEqualToString:@"isFirst"]) {
        self.window.rootViewController = navigationController;
    }else{
        self.window.rootViewController = guidevc;
    }
    return YES;
}

- (void)configureAMapKey {
    if ([AMAP_KEY length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)AMAP_KEY;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
