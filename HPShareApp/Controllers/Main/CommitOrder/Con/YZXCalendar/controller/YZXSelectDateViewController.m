//
//  YZXSelectDateViewController.m
//  Replenishment
//
//  Created by 尹星 on 2017/7/19.
//  Copyright © 2017年 ruwang. All rights reserved.
//

#import "YZXSelectDateViewController.h"
#import "YZXCalendarView.h"
#import "SJPageNavigationView.h"
#import "YZXAnnualReportView.h"
#import "YZXMonthlyReportView.h"
#import "YZXCustomDateBottomView.h"
#import "HPGlobalVariable.h"
#import "MBProgressHUD.h"

#import "Macro.h"

#import "YZXDaysMenuView.h"

static const CGFloat topPageNavigationView_height = 44.0;
static const CGFloat bottomView_height = 60.0;
static const CGFloat blankSpace = 40.0;

@interface YZXSelectDateViewController () <SJPageNavigationViewDelegate,SJPageNavigationViewDataSource,YZXCalendarDelegate,YZXMonthlyReportViewDelegate,YZXAnnualReportViewDelegate>

@property (nonatomic, strong) YZXCalendarHelper           *helper;
@property (nonatomic, strong) YZXCalendarView             *calendarView;
@property (nonatomic, strong) SJPageNavigationView        *topPageNavigationView;
@property (nonatomic, strong) YZXCalendarView             *customCalendarView;
@property (nonatomic, strong) YZXAnnualReportView         *annualReportView;
@property (nonatomic, strong) YZXMonthlyReportView        *monthlyReportView;
@property (nonatomic, strong) NSDateFormatter             *formatter;
@property (nonatomic, strong) NSDateFormatter             *yearFormatter;
@property (nonatomic, strong) NSDateFormatter             *yearAndMonthFormatter;
@property (nonatomic, strong) YZXCustomDateBottomView     *bottomView;
@property (nonatomic, strong) UIView                      *selectedView;

@property (nonatomic, strong) UIView             *topView;

@property (nonatomic, strong) MBProgressHUD             *hud;

@property (nonatomic, assign) CGFloat         hudYOffset;

/**
 单选时选中的起始日期
 */
@property (nonatomic, copy) NSString *selectedDay;

@end

@implementation YZXSelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择日期";
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_initData];
    [self p_initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_hud) {
        [self p_hideHUD];
    }
}

- (void)p_initData
{
    //默认为日报
    if (self.selectedType == YZXTimeToChooseInAll) {
        self.selectedType = YZXTimeToChooseInCustom;
    }
    
    if (IPHONE_HAS_NOTCH) {
        self.hudYOffset = SCREEN_HEIGHT / 2.0 - HomeIndicator - bottomView_height - (blankSpace / 2.0);
    }else {
        self.hudYOffset = SCREEN_HEIGHT / 2.0 - bottomView_height - (blankSpace / 2.0);
    }
}

- (void)p_initView
{
    [self.view addSubview:self.topView];
    
    self.bottomView.hidden = YES;
    
    self.selectedView = [[UIView alloc] init];
    
//    [self.view addSubview:self.topPageNavigationView];
    
    [self.view addSubview:self.calendarView];

    [self.view addSubview:self.monthlyReportView];

    [self.view addSubview:self.annualReportView];
    
    [self.view addSubview:self.customCalendarView];
    
//    [self.view addSubview:self.bottomView];
    
    self.calendarView.hidden = YES;
    self.monthlyReportView.hidden = YES;
    self.annualReportView.hidden = YES;
    self.customCalendarView.hidden = YES;

    //根据传入内容确定选择的内容
    switch (_selectedType) {
        case YZXTimeToChooseInAll:
        {
        }
            break;
        
        case YZXTimeToChooseInCustom:
        {
//            self.customCalendarView.dateArray = @[self.startDate,self.endDate];
            self.bottomView.startTime = self.startDate;
            self.bottomView.endTime = self.endDate;
            if (self.endDate) {
                [self p_hideHUD];
            }
            self.selectedView = self.customCalendarView;
        }
        break;
            
        default:
            break;
    }
    
    [self didSelectedIndex:_selectedType - 1];
}

#pragma mark - <SJPageNavigationViewDelegate,SJPageNavigationViewDataSource>
- (void)didSelectedIndex:(NSUInteger)index
{
    self.selectedView.hidden = YES;
    switch (index) {
        case 0:
        {
            self.calendarView.hidden = NO;
            self.selectedView = self.calendarView;
            self.bottomView.hidden = YES;
        }
            break;
        case 1:
        {
            self.monthlyReportView.hidden = NO;
            self.selectedView = self.monthlyReportView;
            self.bottomView.hidden = YES;
        }
            break;
        case 2:
        {
            self.annualReportView.hidden = NO;
            self.selectedView = self.annualReportView;
            self.bottomView.hidden = YES;
        }
            break;
        case 3:
        {
            if (!self.bottomView.startTime && !self.bottomView.endTime) {
//                [self p_hudWithContent:@"请选择日期" WithYOffset:self.hudYOffset];
            }
            if (self.bottomView.startTime && !self.bottomView.endTime) {
//                [self p_hudWithContent:@"请再选择一个日期" WithYOffset:self.hudYOffset];
            }
            self.customCalendarView.hidden = NO;
            self.selectedView = self.customCalendarView;
            self.bottomView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    if (index < 3) {
        [self p_hideHUD];
    }
}

- (void)p_cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//总累计
- (void)buttonPressed:(UIButton *)sender
{
    if (_confirmTheDateBlock) {
        _confirmTheDateBlock(nil,nil,YZXTimeToChooseInAll);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)p_errorMessageContent:(NSString *)content
                  withYOffset:(CGFloat)offset_y
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = content;
    hud.label.font = FONT12;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.layer.cornerRadius = 4.0;
    CGPoint point = hud.offset;
    point.y = offset_y;
    hud.offset = point;
    [hud hideAnimated:YES afterDelay:1];
}

- (void)p_hudWithContent:(NSString *)content
             WithYOffset:(CGFloat)offset_y
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeText;
        _hud.label.font = FONT12;
        _hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
        _hud.margin = 10.f;
        _hud.removeFromSuperViewOnHide = YES;
        _hud.layer.cornerRadius = 4.0;
        CGPoint point = _hud.offset;
        point.y = offset_y;
        _hud.offset = point;
    }
    if (content) {
        _hud.label.text = content;
    }
}

#pragma mark - <YZXCalendarDelegate>
//自定义时间
- (void)clickCalendarWithStartDate:(NSString *)startDate andEndDate:(NSString *)endDate
{
    if (startDate) {
        self.bottomView.startTime = startDate;
    }else {
//        [self p_hudWithContent:@"请选择日期" WithYOffset:self.hudYOffset];
        self.bottomView.startTime = nil;
    }
    
    if ([endDate isEqualToString:@"error"]) {
//        [self p_errorMessageContent:@"最多可选择31天" withYOffset:0];
        return;
    }
    
    if (endDate) {
        self.bottomView.endTime = endDate;
        [self p_hideHUD];
    }else {
        if (startDate) {
//            [self p_hudWithContent:@"请再选择一个日期" WithYOffset:self.hudYOffset];
        }
        self.bottomView.endTime = nil;
    }
}

- (void)p_hideHUD
{
    [_hud hideAnimated:YES];
    [_hud removeFromSuperViewOnHide];
    _hud = nil;
}

//日报
- (void)clickCalendarDate:(NSString *)date
{
    if (_confirmTheDateBlock) {
        _confirmTheDateBlock(date,nil,YZXTimeToChooseInDay);
    }
//    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - <YZXMonthlyReportViewDelegate>
//月报
- (void)clickTheMonth:(NSString *)month
{
    if (_confirmTheDateBlock) {
        _confirmTheDateBlock(month,nil,YZXTimeToChooseInMonth);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <YZXAnnualReportViewDelegate>
//年报
- (void)clickTheYear:(NSString *)year
{
    if (_confirmTheDateBlock) {
        _confirmTheDateBlock(year,nil,YZXTimeToChooseInYear);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <SJPageNavigationViewDataSource>
- (UIColor *)selectedTitleColor
{
    return CustomRedColor;
}

- (UIFont *)titleFont
{
    return FONT15;
}

- (UIColor *)unSelectedTitleColor
{
    return CustomBlackColor;
}

#pragma mark - 懒加载
- (YZXCalendarHelper *)helper
{
    if (!_helper) {
        _helper = [YZXCalendarHelper helper];
    }
    return _helper;
}

//navigationView
- (UIView *)topView
{
    if (!_topView) {
        CGRect rect = CGRectZero;
        if (kDevice_iPhoneX) {
            rect = CGRectMake(0, 0, SCREEN_WIDTH, StatusBarHeight + NavigationBarHeight);
        }else {
            rect = CGRectMake(0, 0, SCREEN_WIDTH, TOPHEIGHT);
        }
        _topView = [[UIView alloc] initWithFrame:rect];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"选择日期";
        label.textColor = CustomBlackColor;
        label.font = [UIFont systemFontOfSize:16.0];
        [label sizeToFit];
        label.center = CGPointMake(SCREEN_WIDTH / 2.0, (_topView.bounds.size.height - StatusBarHeight) / 2.0 + StatusBarHeight);
        [_topView addSubview:label];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(-8, CGRectGetMaxY(_topView.bounds) - 44, 45, 44);
        cancel.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [cancel setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(p_cancelPressed) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:cancel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.bounds) - 1, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = CustomLineColor;
        [_topView addSubview:lineView];
        
//        if (self.selectedDateType == YZXSalesTrendsType) {
//            rightItemButton.hidden = YES;
//        }
    }
    return _topView;
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [YZXCalendarHelper.helper yearMonthAndDayFormatter];
    }
    return _formatter;
}
//设置日期格式
- (NSDateFormatter *)yearFormatter
{
    if (!_yearFormatter) {
        _yearFormatter = self.helper.yearFormatter;
    }
    return _yearFormatter;
}
//设置日期格式
- (NSDateFormatter *)yearAndMonthFormatter
{
    if (!_yearAndMonthFormatter) {
        _yearAndMonthFormatter = self.helper.yearAndMonthFormatter;
    }
    return _yearAndMonthFormatter;
}
//顶部选择控制器
- (SJPageNavigationView *)topPageNavigationView
{
    if (!_topPageNavigationView) {//CGRectGetMaxY(self.topView.frame)
        _topPageNavigationView = [[SJPageNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topPageNavigationView_height) titles:@[@"日期",@"",@"",@"段选"] dataSource:self selectedIndex:self.selectedType - 1];
        _topPageNavigationView.sjDelegate = self;
        _topPageNavigationView.isShowTopView = NO;
        _topPageNavigationView.isShowBottomView = NO;
    }
    return _topPageNavigationView;
}
//日历
- (YZXCalendarView *)calendarView
{
    if (!_calendarView) {
        CGRect rect = CGRectZero;
        if (kDevice_iPhoneX) {// CGRectGetMaxY(self.topPageNavigationView.frame)
            rect = CGRectMake(0,0, self.view.frame.size.width, SCREEN_HEIGHT - topPageNavigationView_height - 1 - TOPHEIGHT_IPHONE_X - g_bottomSafeAreaHeight - g_statusBarHeight);
        }else {
            rect = CGRectMake(0,0, self.view.frame.size.width, SCREEN_HEIGHT - topPageNavigationView_height - 1 - TOPHEIGHT - g_bottomSafeAreaHeight - g_statusBarHeight);
        }
        _calendarView = [[YZXCalendarView alloc] initWithFrame:rect withStartDateString:self.helper.dayReportStartDate endDateString:self.helper.dayReportEndDate];
        _calendarView.delegate = self;
    }
    return _calendarView;
}
//自定义日历
- (YZXCalendarView *)customCalendarView
{
    if (!_customCalendarView) {
        CGRect rect = CGRectZero;
        if (kDevice_iPhoneX) {
            rect = CGRectMake(0,0, self.view.frame.size.width, SCREEN_HEIGHT - bottomView_height - 1 - TOPHEIGHT_IPHONE_X - blankSpace - bottomView_height + 20);
        }else {
            rect = CGRectMake(0,0, self.view.frame.size.width, SCREEN_HEIGHT - bottomView_height - 1 - TOPHEIGHT - blankSpace - bottomView_height);
        }
        
        _customCalendarView = [[YZXCalendarView alloc] initWithFrame:rect withStartDateString:self.helper.customDateStartDate endDateString:self.helper.customDateEndDate];
        _customCalendarView.backgroundColor = [UIColor redColor];
        _customCalendarView.delegate = self;
        _customCalendarView.customSelect = YES;
        if (self.maxChooseNumber) {
            _customCalendarView.maxChooseNumber = self.maxChooseNumber;
        }
        self.bottomView.hidden = YES;
    }
    return _customCalendarView;
}
//年报
- (YZXAnnualReportView *)annualReportView
{
    if (!_annualReportView) {
        CGRect rect = CGRectZero;
        if (kDevice_iPhoneX) {
            rect = CGRectMake(0, CGRectGetMaxY(self.topPageNavigationView.frame), self.view.frame.size.width, SCREEN_HEIGHT - topPageNavigationView_height - 1 - TOPHEIGHT_IPHONE_X);
        }else {
            rect = CGRectMake(0, CGRectGetMaxY(self.topPageNavigationView.frame), self.view.frame.size.width, SCREEN_HEIGHT - topPageNavigationView_height - 1 - TOPHEIGHT);
        }
        _annualReportView = [[YZXAnnualReportView alloc] initWithFrame:rect withStartDateString:self.helper.yearReportStartDate endDateString:self.helper.yearReportEndDate];
        _annualReportView.delegate = self;
    }
    return _annualReportView;
}
//月报
- (YZXMonthlyReportView *)monthlyReportView
{
    if (!_monthlyReportView) {
        CGRect rect = CGRectZero;
        if (kDevice_iPhoneX) {
            rect = CGRectMake(0, CGRectGetMaxY(self.topPageNavigationView.frame), self.view.frame.size.width, SCREEN_HEIGHT - topPageNavigationView_height - 1 - TOPHEIGHT_IPHONE_X);
        }else {
            rect = CGRectMake(0, CGRectGetMaxY(self.topPageNavigationView.frame), self.view.frame.size.width, SCREEN_HEIGHT - topPageNavigationView_height - 1 - TOPHEIGHT);
        }
        _monthlyReportView = [[YZXMonthlyReportView alloc] initWithFrame:rect withStartDateString:self.helper.monthReportStartDate endDateString:self.helper.monthReportEndDate];
        _monthlyReportView.delegate = self;
    }
    return _monthlyReportView;
}

//底部视图
- (YZXCustomDateBottomView *)bottomView
{
    if (!_bottomView) {// CGRectGetMaxY(self.customCalendarView.frame) + blankSpace
        _bottomView = [[YZXCustomDateBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.customCalendarView.frame), self.view.bounds.size.width, bottomView_height)];
        //确定 选择日期
        __weak typeof(self) weak_self = self;
        _bottomView.confirmBlock = ^(NSString *startTime, NSString *endTime) {
            if (weak_self.confirmTheDateBlock) {
                weak_self.confirmTheDateBlock(startTime,endTime,YZXTimeToChooseInCustom);
                weak_self.confirmTheDateBlock =nil;//ssj
            }
//            [weak_self dismissViewControllerAnimated:YES completion:nil];
            
        };

    }
    return _bottomView;
}

@end
