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
#import "HPTextDialogView.h"
#import "HPGuideViewController.h"
#import "HPCommonData.h"
#import "HPCommonBannerData.h"
#import "HPHomeBannerModel.h"
#import "HPSingleton.h"
#import "Bugly/Bugly.h"
#import <JMessage/JMessage.h>

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>
@property (nonatomic, weak) HPTextDialogView *textDialogView;
@property (nonatomic, strong) HPMainTabBarController *mainTabBarController;
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
    [self setUpJPushAndMessageConfigWithOptions:launchOptions];
    
    //注册极光IM
    [self regiestJMessage];
    
    //登录极光IM
    [self loginJMessage];
    
    //注册腾讯bugly
    [Bugly startWithAppId:kAppleId];
    
    [self updateAppVersionInfo];
    [HPGlobalVariable initVariable];
    [HPCommonData getAreaData];
    [HPCommonData getIndustryData];
    
    [self configureAMapKey];
    HPGuideViewController *guidevc = [[HPGuideViewController alloc] init];
    _mainTabBarController = [[HPMainTabBarController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_mainTabBarController];
    navigationController.navigationBarHidden = YES;
    [navigationController.interactivePopGestureRecognizer setDelegate:_mainTabBarController];
    NSString *isFirst = [kUserDefaults objectForKey:@"isFirst"];
    if ([isFirst isEqualToString:@"isFirst"]) {
        self.window.rootViewController = navigationController;
    }else{
        self.window.rootViewController = guidevc;
    }
    return YES;
}

#pragma mark - 注册im
- (void)regiestJMessage
{
    HPLoginModel *account = [HPUserTool account];
    JMSGUserInfo *userInfo = [JMSGUserInfo new];
    userInfo.nickname = account.userInfo.username;
    userInfo.signature = account.cardInfo.signature;
    [JMSGUser registerWithUsername:account.userInfo.username password:account.userInfo.userId completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //注册成功
            
        } else {
            //注册失败
        }
    }];
}

#pragma mark - 登录im
- (void)loginJMessage
{
    [JMSGUser loginWithUsername:@"cml19891124" password:@"cml16875" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //登录成功
            [HPProgressHUD alertMessage:@"登录极光IM成功！"];
        } else {
            //登录失败
            [HPProgressHUD alertMessage:@"登录极光IM失败！"];

        }
    }];
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

#pragma mark - jpush
- (void)setUpJPushAndMessageConfigWithOptions:(NSDictionary *)launchOptions{
    // Required - 启动 JMessage SDK  开启消息漫游
    [JMessage setupJMessage:launchOptions appKey:JPushAppKey channel:nil apsForProduction:NO category:nil messageRoaming:YES];
    
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
        
        [JMessage registerForRemoteNotificationTypes:(UNAuthorizationOptionProvidesAppNotificationSettings |
                                                      UNAuthorizationOptionSound |
                                                      UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
                                          categories:nil];
    } else {
        // Fallback on earlier versions
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //初始化极光
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    /*channel
     指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
     */
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:@""
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    // Required - 注册token
    [JMessage registerDeviceToken:deviceToken];
}

//实现注册 APNs 失败接口（可选）

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}
@end
