//
//  HPCalendarView.m
//  HPShareApp
//
//  Created by HP on 2018/11/19.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCalendarView.h"
#import "JTCalendar.h"

@interface HPCalendarView () <JTCalendarDelegate> {
    NSMutableArray *_selectedDates;
}

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, strong) JTCalendarManager *calendarManager;

@property (nonatomic, weak) JTHorizontalCalendarView *calendarContentView;

@property (nonatomic, weak) JTDateHelper *helper;

@property (nonatomic, weak) UIImageView *previousIcon;

@property (nonatomic, weak) UIImageView *nextIcon;

@property (nonatomic, weak) UIButton *previousBtn;

@property (nonatomic, weak) UIButton *nextBtn;

@end

@implementation HPCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        _canTouch = NO;
        _selectedDates = [[NSMutableArray alloc] init];
        
        _calendarManager = [JTCalendarManager new];
        [_calendarManager setDelegate:self];
        _calendarManager.settings.zeroPaddedDayFormat = NO;
        _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatCN;
        _helper = _calendarManager.dateHelper;
        
        [self setupUI];
    }
    return self;
}

- (NSArray *)selectedDates {
    return [NSArray arrayWithArray:_selectedDates];
}

- (void)setSelectedDates:(NSArray *)selectedDates {
    _selectedDates = [NSMutableArray arrayWithArray:selectedDates];
    [_calendarManager reload];
}

- (void)setSelectedDateStrs:(NSArray *)selectedDateStrs {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *str in selectedDateStrs) {
        NSDate *date = [dateFormatter dateFromString:str];
        [array addObject:date];
    }
    
    _selectedDates = array;
    NSDate *firstDate = array[0];
    [_calendarManager setDate:firstDate];
    [_calendarManager reload];
}

- (void)setCanTouch:(BOOL)canTouch {
    _canTouch = canTouch;
    [_calendarManager reload];
}

- (void)setStartMonthOfDate:(NSDate *)startMonthOfDate {
    _startMonthOfDate = startMonthOfDate;
    [_calendarManager reload];
}

- (void)setEndMonthOfDate:(NSDate *)endMonthOfDate {
    _endMonthOfDate = endMonthOfDate;
    [_calendarManager reload];
}

- (void)setupUI {
    [self.layer setCornerRadius:10.f];
    [self.layer setShadowColor:COLOR_GRAY_F0F0F0.CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.f, 6.f)];
    [self.layer setShadowOpacity:0.9f];
    [self setBackgroundColor:UIColor.whiteColor];
    
    UIView *contentView = [[UIView alloc] init];
    [contentView.layer setCornerRadius:10.f];
    [contentView.layer setMasksToBounds:YES];
    [self addSubview:contentView];
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    JTCalendarMenuView *calendarMenuView = [[JTCalendarMenuView alloc] init];
    [calendarMenuView setBackgroundColor:COLOR_RED_FF3C5E];
    [contentView addSubview:calendarMenuView];
    [calendarMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.width.equalTo(contentView);
        make.height.mas_equalTo(42.f * g_rateWidth);
    }];
    
    UIImageView *previousIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shared_shop_details_calendar_forward"]];
    [calendarMenuView addSubview:previousIcon];
    _previousIcon = previousIcon;
    [previousIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(calendarMenuView).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(calendarMenuView);
    }];
    
    UIImageView *nextIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shared_shop_details_calendar_backward"]];
    [calendarMenuView addSubview:nextIcon];
    _nextIcon = nextIcon;
    [nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(calendarMenuView).with.offset(-18.f * g_rateWidth);
        make.centerY.equalTo(calendarMenuView);
    }];
    
    UIButton *previousBtn = [[UIButton alloc] init];
    [previousBtn setTag:0];
    [previousBtn addTarget:self action:@selector(onClickPageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [calendarMenuView addSubview:previousBtn];
    _previousBtn = previousBtn;
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(calendarMenuView);
        make.width.mas_equalTo(40.f * g_rateWidth);
    }];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTag:1];
    [nextBtn addTarget:self action:@selector(onClickPageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [calendarMenuView addSubview:nextBtn];
    _nextBtn = nextBtn;
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.top.and.right.equalTo(calendarMenuView);
        make.width.mas_equalTo(40.f * g_rateWidth);
    }];
    
    JTHorizontalCalendarView *calendarContentView = [[JTHorizontalCalendarView alloc] init];
    [contentView addSubview:calendarContentView];
    _calendarContentView = calendarContentView;
    [calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(contentView);
        make.top.equalTo(calendarMenuView.mas_bottom);
        make.bottom.equalTo(contentView);
    }];
    
    [_calendarManager setMenuView:calendarMenuView];
    [_calendarManager setContentView:calendarContentView];
    [_calendarManager setDate:[NSDate date]];
}

- (void)setContentCornerRadius:(CGFloat)contentCornerRadius {
    [_contentView.layer setCornerRadius:contentCornerRadius];
}

- (CGFloat)contentCornerRadius {
    return _contentView.layer.cornerRadius;
}

#pragma mark - JTCalendarDelegate

- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar {
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [label setTextColor:UIColor.whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar {
    JTCalendarWeekDayView *weekDayView = [[JTCalendarWeekDayView alloc] init];
    for (UILabel *weekLabel in weekDayView.dayViews) {
        [weekLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
        [weekLabel setTextColor:COLOR_BLACK_666666];
    }
    
    return weekDayView;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar {
    JTCalendarDayView *dayView = [[JTCalendarDayView alloc] init];
    [dayView.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [dayView.textLabel setTextColor:COLOR_BLACK_666666];
    [dayView.circleView setBackgroundColor:COLOR_RED_F94766];
    [dayView.dotView setBackgroundColor:COLOR_RED_F94766];
    return dayView;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date {
    UILabel *label = (UILabel *)menuItemView;
    NSDateFormatter *dateFormatter = [_calendarManager.dateHelper createDateFormatter];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:date];
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:date];
    [label setText:[NSString stringWithFormat:@"%@年%@月", year, month]];
    
    if (_canTouch) {
        if (_startMonthOfDate && ![_helper date:_startMonthOfDate isBeforeMonthOf:calendar.date]) {
            [_previousIcon setHidden:YES];
            [_previousBtn setHidden:YES];
        }
        else {
            [_previousIcon setHidden:NO];
            [_previousBtn setHidden:NO];
        }
        
        if (_endMonthOfDate && ![_helper date:_endMonthOfDate isAfterMonthOf:calendar.date]) {
            [_nextIcon setHidden:YES];
            [_nextBtn setHidden:YES];
        }
        else {
            [_nextIcon setHidden:NO];
            [_nextBtn setHidden:NO];
        }
        
        return;
    }
    
    BOOL anySelectedDateBefore = NO;
    BOOL anySelectedDateAfter = NO;
    
    for (NSDate *selectedDate in _selectedDates) {
        if ([_helper date:selectedDate isBeforeMonthOf:calendar.date]) {
            anySelectedDateBefore = YES;
        }
        
        if ([_helper date:selectedDate isAfterMonthOf:calendar.date]) {
            anySelectedDateAfter = YES;
        }
    }
    
    if (_startMonthOfDate && ![_helper date:_startMonthOfDate isBeforeMonthOf:calendar.date]) {
        anySelectedDateBefore = NO;
    }
    
    if (_endMonthOfDate && ![_helper date:_endMonthOfDate isAfterMonthOf:calendar.date]) {
        anySelectedDateAfter = NO;
    }
    
    if (!anySelectedDateBefore) {
        [_previousIcon setHidden:YES];
        [_previousBtn setHidden:YES];
    }
    else {
        [_previousIcon setHidden:NO];
        [_previousBtn setHidden:NO];
    }
    
    if (!anySelectedDateAfter) {
        [_nextIcon setHidden:YES];
        [_nextBtn setHidden:YES];
    }
    else {
        [_nextIcon setHidden:NO];
        [_nextBtn setHidden:NO];
    }
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(UIView<JTCalendarDay> *)dayView {
    JTCalendarDayView *calendarDayView = (JTCalendarDayView *)dayView;
    
    if ([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:calendarDayView.date]) {
        [calendarDayView.dotView setHidden:NO];
    }
    else if (!calendarDayView.dotView.isHidden) {
        [calendarDayView.dotView setHidden:YES];
    }
    
    BOOL isSelected = NO;
    
    for (NSDate *date in _selectedDates) {
        if ([_helper date:date isTheSameMonthThan:calendar.date] && [_helper date:date isTheSameDayThan:calendarDayView.date]) {
            isSelected = YES;
            break;
        }
    }
    
    
    if (calendarDayView.isFromAnotherMonth || ![_helper date:calendar.date isTheSameMonthThan:calendarDayView.date]) {
        [calendarDayView setHidden:YES];
    }
    else if (isSelected) {
        [calendarDayView setHidden:NO];
        [calendarDayView.circleView setHidden:NO];
        [calendarDayView.textLabel setTextColor:UIColor.whiteColor];
    }
    else {
        [calendarDayView setHidden:NO];
        if (!calendarDayView.circleView.isHidden) {
            [calendarDayView.circleView setHidden:YES];
            [calendarDayView.textLabel setTextColor:COLOR_BLACK_666666];
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView {
    if (_canTouch) {
        JTCalendarDayView *calendarDayView = (JTCalendarDayView *)dayView;
        if (calendarDayView.circleView.isHidden) {
            [calendarDayView.textLabel setTextColor:UIColor.whiteColor];
            [calendarDayView.circleView setHidden:NO];
            [_selectedDates addObject:calendarDayView.date];
        }
        else {
            [calendarDayView.textLabel setTextColor:COLOR_BLACK_666666];
            [calendarDayView.circleView setHidden:YES];
            [_selectedDates removeObject:calendarDayView.date];
        }
    }
}

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date {
    if (_canTouch) {
        if (_startMonthOfDate && [_helper date:date isBeforeMonthOf:_startMonthOfDate]) {
            return NO;
        }
        else if (_endMonthOfDate && [_helper date:date isAfterMonthOf:_endMonthOfDate]) {
            return NO;
        }
        
        return YES;
    }
    
    BOOL anySelectedDateBeforeOrSameMonth = NO;
    BOOL anySelectedDateAfterOrSameMonth = NO;
    
    for (NSDate *selectedDate in _selectedDates) {
        if ([_helper date:selectedDate isBeforeMonthOf:date] || [_helper date:selectedDate isTheSameMonthThan:date]) {
            anySelectedDateBeforeOrSameMonth = YES;
        }
        
        if ([_helper date:selectedDate isAfterMonthOf:date] || [_helper date:selectedDate isTheSameMonthThan:date]) {
            anySelectedDateAfterOrSameMonth = YES;
        }
    }
    
    if (_startMonthOfDate && [_helper date:date isBeforeMonthOf:_startMonthOfDate]) {
        anySelectedDateBeforeOrSameMonth = NO;
    }
    
    if (_endMonthOfDate && [_helper date:date isAfterMonthOf:_endMonthOfDate]) {
        anySelectedDateAfterOrSameMonth = NO;
    }
    
    if (anySelectedDateBeforeOrSameMonth && anySelectedDateAfterOrSameMonth)
        return YES;
    else
        return NO;
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {
    [_nextBtn setEnabled:YES];
    [_previousBtn setEnabled:YES];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {
    [_nextBtn setEnabled:YES];
    [_previousBtn setEnabled:YES];
}

#pragma mark - OnClick

- (void)onClickPageBtn:(UIButton *)btn {
    [btn setEnabled:NO];
    
    if (btn.tag == 0) {
        [_calendarContentView loadPreviousPageWithAnimation];
    }
    else if (btn.tag == 1) {
        [_calendarContentView loadNextPageWithAnimation];
    }
}

@end
