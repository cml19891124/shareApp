//
//  HPCalenderView.h
//  HPShareApp
//
//  Created by HP on 2019/3/29.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

#import "YZXCalendarView.h"

static const CGFloat bottomView_height = 60.0;

/**
 block回调
 
 @param startDate 自定义时间时返回的开始时间，非自定义时间时返回当前选择的时间
 @param endDate 自定义时间时返回的结束时间，非自定义时为nil
 @param selectedType 查看的报表类型
 */
typedef void (^ConfirmTheDateBlock) (NSString *startDate,NSString *endDate, YZXTimeToChooseType selectedType);

typedef void(^CalenderViewBlock)(NSString *startDate, NSString *endDate, YZXTimeToChooseType selectedType);

typedef void(^SelectSingleDay)(NSString *day);

NS_ASSUME_NONNULL_BEGIN

@interface HPCalenderView : HPBaseModalView<YZXCalendarDelegate>

@property (nonatomic, strong) UIView *view;

@property (strong, nonatomic) UIView *bgView;

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) UIButton *singleSelectBtn;

@property (nonatomic, strong) UIButton *duringBtn;

@property (nonatomic, copy) CalenderViewBlock calenderBlock;

@property (nonatomic, assign) YZXTimeToChooseType         selectedType;
@property (nonatomic, copy) NSString             *startDate;
@property (nonatomic, copy) NSString             *endDate;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, copy) SelectSingleDay singleBlock;

/**
 单选的日期
 */
@property (nonatomic, copy) NSString *singleDay;

@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) UIButton *confirmButton;

@property (strong, nonatomic) UIView *bottomView;

@property (nonatomic, strong) NSDateFormatter             *formatter;
@property (nonatomic, strong) NSDateFormatter             *yearFormatter;
@property (nonatomic, strong) NSDateFormatter             *yearAndMonthFormatter;

@property (nonatomic, strong) YZXCalendarHelper           *helper;
@property (nonatomic, strong) YZXCalendarView             *calendarView;
@property (nonatomic, strong) YZXCalendarView             *customCalendarView;

@property (nonatomic, copy) ConfirmTheDateBlock             confirmTheDateBlock;

//@property (nonatomic, assign) YZXSelectedDateType         selectedDateType;

/**
 自定义时最多选择的天数
 */
@property (nonatomic, assign) NSInteger         maxChooseNumber;

@property (strong, nonatomic) NSMutableArray *hasOrderArray;

@end

NS_ASSUME_NONNULL_END
