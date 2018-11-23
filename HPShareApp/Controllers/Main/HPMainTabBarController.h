//
//  HPMainTabBarController.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 主页 TabBarController，代理所有 UIViewController 侧滑返回判断。
 */
@interface HPMainTabBarController : UITabBarController <UIGestureRecognizerDelegate>

@end

NS_ASSUME_NONNULL_END
