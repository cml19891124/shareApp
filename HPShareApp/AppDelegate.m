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
#import "AppDelegate+Config.h"
#import <UserNotifications/UserNotifications.h>
#import "HPTextDialogView.h"
#import "HPGuideViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
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
        NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *newVersion = [NSString stringWithFormat:@"%@.%@", version, build];
        NSArray *currentVersionArr = [newVersion componentsSeparatedByString:@"."];
        NSString *currentVersion =@"";
        for (int i = 0;i < currentVersionArr.count; i++) {
            currentVersion = [currentVersion stringByAppendingString:currentVersionArr[i]];
        }
        //获取appStore网络版本号
        /*NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kAppleId]];
        NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSRange substr = [file rangeOfString:@"\"version\":\""];
        NSRange range1 = NSMakeRange(substr.location+substr.length,10);
        NSRange substr2 = [file rangeOfString:@"\"" options:NSCaseInsensitiveSearch  range:range1];
        NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
        NSString *appStoreVersion =[file substringWithRange:range2];*/
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            //如果不一样去更新
            if([currentVersion intValue] > 1)
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
    //    kWeakSelf(weakSlef);
    [_textDialogView setConfirmCallback:^{
        // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kAppleId]];
        [[UIApplication sharedApplication] openURL:url];
    }];
    
    [_textDialogView show:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AppDelegate setUpConfig];
    
//    [self updateAppVersionInfo];
    // 使用 UNUserNotificationCenter 来管理通知
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;
        
        //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                              }];
        
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
        
    } else {
        // Fallback on earlier versions
    }
    [HPGlobalVariable initVariable];
    
    [self configureAMapKey];
    HPGuideViewController *guidevc = [[HPGuideViewController alloc] init];
    HPMainTabBarController *mainTabBarController = [[HPMainTabBarController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
    navigationController.navigationBarHidden = YES;
    [navigationController.interactivePopGestureRecognizer setDelegate:mainTabBarController];
    
     self.window.rootViewController = guidevc;
    
    return YES;
}

#pragma mark - UNUserNotificationCenterDelegate
//iOS10新增：处理前台收到通知的代理方法

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//应用处于前台时的远程推送接受
        
    } else {//应用处于前台时的本地推送接受
            
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);//
            
    }
    
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    
    if (@available(iOS 10.0, *)) {
        
        UNNotificationContent *content = response.notification.request.content;
        
        // 如果在上面的通知方法中设置了一些，可以在这里打印额外信息的内容，就做到监听，也就可以根据额外信息，做出相应的判断
        
        NSData *data = [content.userInfo objectForKey:@"userInfo"];
        
        NSString *type = [content.userInfo objectForKey:@"type"];
        
        NSUInteger c = [type integerValue];
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
//        [app processNotificationData:c data:data];
        
        } else {
            
            // Fallback on earlier versions
            
        }
    
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
