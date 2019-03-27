//
//  HPCancelView.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCancelView.h"

@implementation HPCancelView

- (void)setupModalView:(UIView *)view
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f));
        make.height.mas_equalTo(getWidth(160.f));
        make.center.mas_equalTo(self);
    }];
    
    [view addSubview:self.bgview];
    
    [self setUpSubviews];
    
    [self setUpSubviewsMasonry];

}

- (UIView *)bgview
{
    if (!_bgview) {
        _bgview = [UIView new];
        [_bgview setBackgroundColor:COLOR_GRAY_FFFFFF];
        _bgview.layer.cornerRadius = 4.f;
        _bgview.layer.masksToBounds = YES;
    }
    return _bgview;
}

- (UIButton *)tipBtn
{
    if (!_tipBtn) {
        _tipBtn = [UIButton new];
        [_tipBtn setImage:ImageNamed(@"tishi") forState:UIControlStateNormal];
        [_tipBtn setTitle:@"温馨提示" forState:UIControlStateNormal];
        [_tipBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_tipBtn setImageEdgeInsets:UIEdgeInsetsMake(0,0,0, getWidth(7.f))];
        _tipBtn.titleLabel.font = kFont_Bold(15.f);
        _tipBtn.backgroundColor = COLOR_RED_EA0000;
    }
    return _tipBtn;
}

- (UIView *)lineV
{
    if (!_lineV) {
        _lineV = [UIView new];
        [_lineV setBackgroundColor:COLOR_GRAY_E7E7E7];
    }
    return _lineV;
}

- (UILabel *)focusLabel
{
    if (!_focusLabel) {
        _focusLabel = [UILabel new];
        _focusLabel.text = @"账号注销后，正在进行中的交易以及所有账户信息将不再保存,确定注销吗？";
        _focusLabel.textColor = COLOR_GRAY_999999;
        _focusLabel.textAlignment = NSTextAlignmentCenter;
        _focusLabel.font = kFont_Regular(14.f);
        _focusLabel.numberOfLines = 0;
        [_focusLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _focusLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = kFont_Regular(16.f);
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _leftBtn.backgroundColor = COLOR_RED_EA0000;
        [_leftBtn addTarget:self action:@selector(cancelTipView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = kFont_Regular(16.f);
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _rightBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        [_rightBtn addTarget:self action:@selector(applyTipView:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightBtn;
}

- (UIView *)bottomV
{
    if (!_bottomV) {
        _bottomV = [UIView new];
        [_bottomV setBackgroundColor:COLOR_RED_EA0000];
    }
    return _bottomV;
}

- (void)setUpSubviews
{
    
    [self.bgview addSubview:self.tipBtn];

    [self.bgview addSubview:self.lineV];

    [self.bgview addSubview:self.focusLabel];

    [self.bgview addSubview:self.leftBtn];

    [self.bgview addSubview:self.rightBtn];

    [self.bgview addSubview:self.bottomV];

}

- (void)setUpSubviewsMasonry
{
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.bgview);
        make.height.mas_equalTo(getWidth(43.f));
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipBtn.mas_bottom);
        make.left.width.mas_equalTo(self.bgview);
        make.height.mas_equalTo(1);
    }];
    
    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.top.mas_equalTo(self.lineV.mas_bottom);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.bgview);
        make.width.mas_equalTo(getWidth(280.f)/2);
        make.height.mas_equalTo(getWidth(43.f));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.bgview);
        make.width.mas_equalTo(getWidth(280.f)/2);
        make.height.mas_equalTo(getWidth(43.f));
    }];
    
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.bgview);
        make.bottom.mas_equalTo(self.rightBtn.mas_top);
        make.height.mas_equalTo(1);
    }];
}

- (void)cancelTipView:(UIButton *)button
{
    [self show:NO];
}

- (void)applyTipView:(UIButton *)button
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)onTapModalOutSide
{
    self.hidden = YES;
}
@end
