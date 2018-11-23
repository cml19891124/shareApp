//
//  UIScrollView+GestureConflict.h
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 解决视图中多个ScrollView（包含子类）嵌套的滑动手势冲突。
 */
@interface UIScrollView (GestureConflict) <UIGestureRecognizerDelegate>

@end

NS_ASSUME_NONNULL_END
