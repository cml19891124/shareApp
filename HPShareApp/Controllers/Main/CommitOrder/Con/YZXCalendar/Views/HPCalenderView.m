//
//  HPCalenderView.m
//  HPShareApp
//
//  Created by HP on 2019/3/29.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCalenderView.h"

#import "HPGlobalVariable.h"

#import "HPTimeString.h"

@implementation HPCalenderView

- (void)setupModalView:(UIView *)view
{
    self.view = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(g_statusBarHeight + 44 + getWidth(53.f));
    }];
    
    [self.view addSubview:self.selectView];
    
    [self.selectView addSubview:self.singleSelectBtn];
    
    [self.selectView addSubview:self.closeBtn];
    
    [self.view addSubview:self.bottomView];

    [self.bottomView addSubview:self.resetBtn];

    //确定按钮
    [self.bottomView addSubview:self.confirmButton];
    
    [self.view addSubview:self.customCalendarView];
    
    [self setUpSubviewsMasonry];
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _bottomView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _bgView;
}

- (void)setUpSubviewsMasonry
{
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(46.f));
    }];
    
    CGFloat btnW = BoundWithSize(self.singleSelectBtn.currentTitle, kScreenWidth, 16.f).size.width;
    [self.singleSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(self.singleSelectBtn.titleLabel.font.pointSize);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.width.height.mas_equalTo(getWidth(15.f));
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(getWidth(165.f));
        make.bottom.mas_equalTo(getWidth(-10.f));
        make.top.mas_equalTo(getWidth(10.f));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(getWidth(165.f));
        make.top.mas_equalTo(self.resetBtn.mas_top);
        make.bottom.mas_equalTo(getWidth(-10.f));
    }];
}

- (UIView *)selectView
{
    if (!_selectView) {
        _selectView = [UIView new];
        _selectView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _selectView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setBackgroundImage:ImageNamed(@"close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(onClickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)singleSelectBtn
{
    if (!_singleSelectBtn) {
        _singleSelectBtn = [UIButton new];
        _singleSelectBtn.tag = YZXTimeToChooseInDay;
        [_singleSelectBtn setTitle:@"选择日期" forState:UIControlStateNormal];
        [_singleSelectBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        _singleSelectBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _singleSelectBtn.titleLabel.font = kFont_Medium(16.f);
        _singleSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _singleSelectBtn;
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

//自定义日历
- (YZXCalendarView *)customCalendarView
{
    if (!_customCalendarView) {
        CGRect rect = CGRectZero;
        if (kDevice_iPhoneX) {
            rect = CGRectMake(0, getWidth(46.f),kScreenWidth, SCREEN_HEIGHT - bottomView_height - TOPHEIGHT_IPHONE_X - g_statusBarHeight + 20 -getWidth(46.f));
        }else {
            rect = CGRectMake(0,getWidth(46.f),kScreenWidth, SCREEN_HEIGHT - bottomView_height - 1 - TOPHEIGHT - bottomView_height - getWidth(46.f)+10);
        }
        
        _customCalendarView = [[YZXCalendarView alloc] initWithFrame:rect withStartDateString:self.helper.customDateStartDate endDateString:self.helper.customDateEndDate];
        _customCalendarView.backgroundColor = [UIColor whiteColor];
        _customCalendarView.delegate = self;
        _customCalendarView.customSelect = YES;
        if (self.maxChooseNumber) {
            _customCalendarView.maxChooseNumber = self.maxChooseNumber;
        }
    }
    return _customCalendarView;
}

- (UIButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [UIButton new];
        _resetBtn.backgroundColor = COLOR_YELLOW_FFB400;
        _resetBtn.layer.cornerRadius = 2.f;
        _resetBtn.layer.masksToBounds= YES;
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = kFont_Medium(14.f);
        [_resetBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _resetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_resetBtn addTarget:self action:@selector(onClickResetBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 2;
        _confirmButton.layer.masksToBounds= YES;
        _confirmButton.backgroundColor = COLOR_RED_FF1213;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = FONT15;
        [_confirmButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.userInteractionEnabled = YES;
    }
    return _confirmButton;
}

- (void)onTapModalOutSide
{
    [self show:NO];
}

- (void)onClickCloseBtn:(UIButton *)button
{
    [self show:NO];
}

- (void)onClickResetBtn:(UIButton *)button
{
    [self.customCalendarView.daysMenuView.selectedArray removeAllObjects];
    
    self.customCalendarView.customSelect = YES;
    
    [self.customCalendarView.daysMenuView.collectionView reloadData];
}

- (void)buttonPressed
{
    
    if (!self.startDate) {
        [HPProgressHUD alertMessage:@"请选择日期"];
        return;
    }

    if (self.confirmTheDateBlock) {
        [self show:NO];
        self.confirmTheDateBlock(self.startDate, self.endDate, self.selectedType);
    }
}

#pragma mark - YZXCalendarDelegate

- (void)clickCalendarWithStartDate:(NSString *)startDate andEndDate:(NSString *)endDate
{
    self.startDate = startDate;

    self.endDate = endDate;

}

#pragma mark - 懒加载
- (YZXCalendarHelper *)helper
{
    if (!_helper) {
        _helper = [YZXCalendarHelper helper];
    }
    return _helper;
}

@end
