//
//  HPRentTimePicker.m
//  HPShareApp
//
//  Created by HP on 2019/3/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRentTimePicker.h"

@implementation HPRentTimePicker
- (void)setupModalView:(UIView *)view
{
    _startTimeArr = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];

    _endTimeArr = @[@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"];

    [view setBackgroundColor:UIColor.whiteColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(getWidth(280.f));
    }];
    
    UIView *btnBar = [[UIView alloc] init];
    [view addSubview:btnBar];
    [btnBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.top.equalTo(view);
        make.height.mas_equalTo(50.f);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.titleLabel setFont:kFont_Medium(16.f)];
    [confirmBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnBar addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnBar);
        make.top.and.bottom.equalTo(btnBar);
        make.width.mas_equalTo(getWidth(100.f));
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn.titleLabel setFont:kFont_Medium(16.f)];
    [cancelBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnBar);
        make.top.and.bottom.equalTo(btnBar);
        make.width.mas_equalTo(getWidth(100.f));
    }];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [view addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBar.mas_bottom);
        make.left.and.width.and.bottom.equalTo(view);
    }];
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UIButton *btn = (UIButton *)[pickerView viewForRow:row forComponent:component];

    if (component == 0) {
        [btn setSelected:YES];
        [pickerView reloadComponent:1];
        _startTime = self.startTimeArr[row];

    }
    else {
        [btn setSelected:YES];
        _endTime = self.endTimeArr[row];

    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return getWidth(160.f);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return getWidth(50.f);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIButton *btn = [[UIButton alloc] init];
    [btn.titleLabel setFont:kFont_Medium(15.f)];
    [btn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateSelected];
    self.btn = btn;
    NSString *title,*startTime,*endTime;
    if (component == 0) {
        startTime = self.startTimeArr[row];
    }
    else {
        endTime = self.endTimeArr[row];
    }
    
    if (!endTime) {
        title = startTime;
    }
    if(!startTime){
        title = endTime;
    }

    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.startTimeArr.count;
    }
    else {
        return self.endTimeArr.count;
    }
}

#pragma mark - OnClick

- (void)onClickConfirmBtn:(UIButton *)btn {
    [self show:NO];
    
    if (self.timeBlock) {
        self.timeBlock(_startTime,_endTime);
    }
}

- (void)onClickCancelBtn:(UIButton *)btn {
    [self show:NO];
}

- (void)onTapModalOutSide {
    [self show:NO];
}

@end
