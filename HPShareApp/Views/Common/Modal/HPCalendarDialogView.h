//
//  HPCalendarModalView.h
//  HPShareApp
//
//  Created by HP on 2018/11/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCalendarDialogView : HPBaseDialogView

@property (nonatomic, readonly) NSArray *selectedDates;

@property (nonatomic, strong) NSDate *startMonthOfDate;

- (void)setSelectedDateStrs:(NSArray *)selectedDateStrs;

@end

NS_ASSUME_NONNULL_END
