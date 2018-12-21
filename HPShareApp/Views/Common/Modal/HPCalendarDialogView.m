//
//  HPCalendarModalView.m
//  HPShareApp
//
//  Created by HP on 2018/11/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCalendarDialogView.h"
#import "HPCalendarView.h"

@interface HPCalendarDialogView ()

@property (nonatomic, weak) HPCalendarView *calendarView;

@end

@implementation HPCalendarDialogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupCustomView:(UIView *)view {
    HPCalendarView *calendarView = [[HPCalendarView alloc] init];
    [calendarView.layer setCornerRadius:0.f];
    [calendarView.layer setShadowOpacity:0.f];
    [calendarView setContentCornerRadius:0.f];
    [calendarView setStartMonthOfDate:[NSDate date]];
    [calendarView setCanTouch:YES];
    [view addSubview:calendarView];
    _calendarView = calendarView;
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self setModalSize:CGSizeMake(getWidth(300.f), getWidth(300.f))];
}

- (NSArray *)selectedDates {
    return _calendarView.selectedDates;
}

@end
