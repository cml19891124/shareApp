//
//  HPScreenAdapter.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 获取屏幕适配所需参数的工具类。
 */
@interface HPScreenAdapter : NSObject

/**
 屏幕宽度与375的比例。

 @return 宽度比例
 */
+ (CGFloat)rateForWidth;

/**
 屏幕高度与667的比例。

 @return 高度比例
 */
+ (CGFloat)rateForHeight;

/**
 底部 TabBar 的高度。

 @return TabBar高度
 */
+ (CGFloat)tabBarHeight;

/**
 底部安全区域的高度。
 
 @return 安全区域高度
 */
+ (CGFloat)bottomSafeAreaHeight;

/**
 顶部状态栏的高度。

 @return 状态栏高度
 */
+ (CGFloat)statusBarHeight;

/**
 顶部导航栏（包含状态栏）的高度。

 @return 导航栏高度
 */
+ (CGFloat)navigationBarHeight;

@end

NS_ASSUME_NONNULL_END
