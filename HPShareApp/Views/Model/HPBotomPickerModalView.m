//
//  HPBotomPickerModalView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/28.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBotomPickerModalView.h"

@interface HPBotomPickerModalView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) HPLinkageData *data;

@property (nonatomic, assign) NSInteger parentIndex;

@property (nonatomic, assign) NSInteger childIndex;

@end

@implementation HPBotomPickerModalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithData:(HPLinkageData *)data {
    _data = data;
    self = [super init];
    return self;
}

- (void)setupModalView:(UIView *)view {
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
        _parentIndex = row;
        [pickerView reloadComponent:1];
    }
    else {
        [btn setSelected:YES];
        _childIndex = row;
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
    
    NSString *title;
    if (component == 0) {
        title = [_data getParentNameAtIndex:row];
    }
    else {
        title = [_data getChildNameOfParentIndex:_parentIndex atChildIndex:row];
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
        return [_data getParentCount];
    }
    else {
        return [_data getChildrenCountOfParentIndex:_parentIndex];
    }
}

#pragma mark - OnClick

- (void)onClickConfirmBtn:(UIButton *)btn {
    [self show:NO];
    
    if (_confirmCallBack) {
        _confirmCallBack(_parentIndex, _childIndex, [_data getChildModelOfParentIndex:_parentIndex atChildIndex:_childIndex]);
    }
}

- (void)onClickCancelBtn:(UIButton *)btn {
    [self show:NO];
}

- (void)onTapModalOutSide {
    [self show:NO];
}

@end
