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
#import "HPGuideViewController.h"
#import "HPCommonData.h"
#import "HPCommonBannerData.h"

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

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "HPUpdateVersionTool.h"
#import "AvoidCrash.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate,WXApiDelegate>

@property (nonatomic, strong) HPMainTabBarController *mainTabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //极光推送
    [self setUpJPushAndMessageConfigWithOptions:launchOptions];
    
    //防止崩溃
    [AvoidCrash makeAllEffective];
    //微信注册
    [WXApi registerApp:WeiXinKey];
    //注册极光IM
//    [self regiestJMessage];
    
    //登录极光IM
//    [self loginJMessage];
    
    //注册腾讯bugly
    [Bugly startWithAppId:kAppleId];
    
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
    HPLog(@"willPresentNotification:%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    HPLog(@"didReceiveNotificationResponse:%@",userInfo);

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    HPLog(@"didReceiveRemoteNotification:%@",userInfo);

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    HPLog(@"didReceiveRemoteNotification:%@",userInfo);

    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark - IOS9.0以后废弃了这两个方法的调用  改用上边这个方法了，请注意、
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",kAppleId]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{
        return NO;
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",kAppleId]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else
    {
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
        return NO;
    }
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notice_AliPayReturnData object:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            HPLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            HPLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    if([[url absoluteString] containsString:WeiXinKey]){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}
@end
