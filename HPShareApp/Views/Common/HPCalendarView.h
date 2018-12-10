//
//  HPCalendarView.h
//  HPShareApp
//
//  Created by HP on 2018/11/19.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCalendarView : HPBaseView

@property (nonatomic, assign) BOOL canTouch;

@property (nonatomic, strong) NSArray *selectedDates;

@property (nonatomic, strong) NSDate *startMonthOfDate;

@property (nonatomic, strong) NSDate *endMonthOfDate;

/**
 内部图层嵌套涂层圆角（嵌套图层是为了外部显示阴影效果，内部限制子视图在圆角范围内）
 */
@property (nonatomic, assign) CGFloat contentCornerRadius;

@end

NS_ASSUME_NONNULL_END
