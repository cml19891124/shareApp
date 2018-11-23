//
//  HPCalendarModalView.m
//  HPShareApp
//
//  Created by HP on 2018/11/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCalendarModalView.h"
#import "HPCalendarView.h"

@interface HPCalendarModalView ()

@property (nonatomic, weak) HPCalendarView *calendarView;

@end

@implementation HPCalendarModalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupModalView:(UIView *)view {
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:10.f];
    [view setBackgroundColor:UIColor.whiteColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(150.f * g_rateHeight);
        make.width.mas_equalTo(325.f * g_rateWidth);
        make.height.mas_equalTo(334.f * g_rateWidth);
        make.centerX.equalTo(self);
    }];
    
    HPCalendarView *calendarView = [[HPCalendarView alloc] init];
    [calendarView setCanTouch:YES];
    [view addSubview:calendarView];
    _calendarView = calendarView;
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.width.equalTo(view);
        make.height.mas_equalTo(274.f * g_rateWidth);
    }];
    
    UIView *btnRegion = [[UIView alloc] init];
    [btnRegion setBackgroundColor:UIColor.whiteColor];
    [view addSubview:btnRegion];
    [btnRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.top.equalTo(calendarView.mas_bottom).with.offset(-10.f * g_rateWidth);
        make.bottom.equalTo(view);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.layer setCornerRadius:5.f];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegion addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnRegion).with.offset(-30.f * g_rateWidth);
        make.centerY.equalTo(btnRegion);
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn.layer setBorderWidth:1.f];
    [cancelBtn.layer setBorderColor:COLOR_GRAY_7A7878.CGColor];
    [cancelBtn.layer setCornerRadius:5.f];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [cancelBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:UIColor.whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegion addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmBtn.mas_left).with.offset(-30.f * g_rateWidth);
        make.centerY.equalTo(btnRegion);
        make.size.mas_equalTo(CGSizeMake(60.f, 30.f));
    }];
}

- (void)onClickConfirmBtn:(UIButton *)btn {
    [self show:NO];
    
    if (_confirmCallback) {
        _confirmCallback(_calendarView.selectedDates);
    }
}

- (void)onClickCancelBtn:(UIButton *)btn {
    [self show:NO];
}

@end
