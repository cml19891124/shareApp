//
//  HPGlobalVariable.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern CGFloat g_rateWidth; //屏幕宽度与375的比例
extern CGFloat g_rateHeight; //屏幕高度与667的比例
extern CGFloat g_statusBarHeight; //状态栏高度
extern CGFloat g_navigationBarHeight; //顶部导航栏高度
extern CGFloat g_tabBarHeight; //底部导航栏高度
extern CGFloat g_bottomSafeAreaHeight; //底部安全区域的高度

extern BOOL g_isLogin; //用户是否登录
extern BOOL g_isCertified; //用户是否认证

NS_ASSUME_NONNULL_BEGIN

/**
 初始化全局变量的类。
 */
@interface HPGlobalVariable : NSObject

/**
 初始化全局变量
 */
+ (void)initVariable;

@end

NS_ASSUME_NONNULL_END
