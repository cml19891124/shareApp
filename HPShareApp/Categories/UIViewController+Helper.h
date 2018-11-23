//
//  UIViewController+Helper.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 为 UIViewController 添加一些实用方法。
 */
@interface UIViewController (Helper)

/**
 获取当前 UIViewController。

 @return 当前 UIViewController
 */
+ (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END
