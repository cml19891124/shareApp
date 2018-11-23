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

@end

NS_ASSUME_NONNULL_END
