//
//  HPRentDuringView.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/1.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRentDuringView.h"

@implementation HPRentDuringView

- (void)setupModalView:(UIView *)view
{
    _startTimeArr = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
    
    _endTimeArr = @[@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(getWidth(280.f));
    }];
    
    [view addSubview:self.bgView];
    
    [self setRentSubviews];
    
    [self setRentSubviewsMasonry];

}

- (void)setRentSubviews
{
    [self.bgView addSubview:self.btnView];
    
    [self.btnView addSubview:self.cancelBtn];

    [self.btnView addSubview:self.confirmBtn];
    
    [self.bgView addSubview:self.lineView];

    [self.bgView addSubview:self.rentView];

    [self.rentView addSubview:self.arriveLabel];

    [self.rentView addSubview:self.leaveLabel];

    [self.bgView addSubview:self.pickerView];

}

- (void)setRentSubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.bgView);
        make.height.mas_equalTo(getWidth(50.f));
    }];
    
    CGFloat btnW = BoundWithSize(self.cancelBtn.currentTitle, kScreenWidth, 16.f).size.width;

    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnView);
        make.left.mas_equalTo(getWidth(18.f));
        make.height.mas_equalTo(getWidth(50.f));
        make.width.mas_equalTo(btnW);
    }];

    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnView);
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(getWidth(50.f));
        make.width.mas_equalTo(btnW);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.btnView.mas_bottom);
    }];

    [self.rentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(getWidth(40.f));
        make.top.mas_equalTo(self.lineView.mas_bottom);
    }];

    [self.arriveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(60.f));
        make.height.mas_equalTo(self.arriveLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2 - getWidth(60.f));
        make.top.bottom.mas_equalTo(self.rentView);
    }];

    [self.leaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-60.f));
        make.width.mas_equalTo(kScreenWidth/2 - getWidth(60.f));
        make.top.bottom.mas_equalTo(self.rentView);
    }];

    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(getWidth(40.f));
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_GRAY_FFFFFF;
        _bgView.layer.cornerRadius = 4.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)btnView
{
    if (!_btnView) {
        _btnView = [UIView new];
        _btnView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _btnView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_GRAY_E4E4E4;
    }
    return _lineView;
}

- (UIView *)rentView
{
    if (!_rentView) {
        _rentView = [UIView new];
        _rentView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _rentView;
}

- (UILabel *)arriveLabel
{
    if (!_arriveLabel) {
        _arriveLabel = [UILabel new];
        _arriveLabel.text = @"入店时间";
        _arriveLabel.textColor = COLOR_GRAY_999999;
        _arriveLabel.font = kFont_Bold(14.f);
        _arriveLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _arriveLabel;
}

- (UILabel *)leaveLabel
{
    if (!_leaveLabel) {
        _leaveLabel = [UILabel new];
        _leaveLabel.text = @"离店时间";
        _leaveLabel.textColor = COLOR_GRAY_999999;
        _leaveLabel.font = kFont_Bold(14.f);
        _leaveLabel.textAlignment = NSTextAlignmentRight;
    }
    return _leaveLabel;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = kFont_Bold(16.f);
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = kFont_Bold(16.f);
        _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _confirmBtn;
}

- (void)onTapModalOutSide{
    [self show:NO];
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

@end
