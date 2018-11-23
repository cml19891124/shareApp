//
//  HPCalendarModalView.h
//  HPShareApp
//
//  Created by HP on 2018/11/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^CalendarBtnConfirmCallback)(NSArray *selectDates);

NS_ASSUME_NONNULL_BEGIN

@interface HPCalendarModalView : HPBaseModalView

@property (nonatomic, strong) CalendarBtnConfirmCallback confirmCallback;

@end

NS_ASSUME_NONNULL_END
