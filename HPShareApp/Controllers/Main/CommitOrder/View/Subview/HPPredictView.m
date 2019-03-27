//
//  HPPredictView.m
//  HPShareApp
//
//  Created by HP on 2019/3/27.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPredictView.h"

@implementation HPPredictView

- (void)setupModalView:(UIView *)view
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f));
        make.height.mas_equalTo(getWidth(160.f));
        make.center.mas_equalTo(self);
    }];
    
    [view addSubview:self.bgView];
    
    [self.bgView addSubview:self.tipBtn];

    [self.bgView addSubview:self.messageLabel];
    
    [self.bgView addSubview:self.knownBtn];

    [self.bgView addSubview:self.imergencyBtn];

    [self.bgView addSubview:self.line];

    [self setUpPredictSubViewsMasonry];
    
}

- (void)setUpPredictSubViewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self);
        make.height.mas_equalTo(self.tipBtn.titleLabel.font.pointSize);
        make.top.mas_equalTo(getWidth(34.f));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self);
        make.height.mas_equalTo(self.messageLabel.font.pointSize);
        make.top.mas_equalTo(self.tipBtn.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.knownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f)/2);
        make.height.mas_equalTo(getWidth(43.f));
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.left.mas_equalTo(self.bgView);
    }];
    
    [self.imergencyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f)/2);
        make.height.mas_equalTo(getWidth(43.f));
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.right.mas_equalTo(self.bgView);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.knownBtn.mas_top);
        make.left.width.mas_equalTo(self.bgView);
    }];
}

- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = COLOR_RED_EA0000;
    }
    return _line;
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

- (UIButton *)tipBtn
{
    if (!_tipBtn) {
        _tipBtn = [UIButton new];
        [_tipBtn setTitle:@"预定成功" forState:UIControlStateNormal];
        [_tipBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(12.f), 0, 0)];
        [_tipBtn setImage:ImageNamed(@"reserve_succes") forState:UIControlStateNormal];
        [_tipBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        _tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _tipBtn.titleLabel.font = kFont_Bold(16.f);
    }
    return _tipBtn;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.text = @"店主同意接单后即可付款";
        _messageLabel.textColor = COLOR_GRAY_666666;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = kFont_Medium(14.f);
    }
    return _messageLabel;
}

- (UIButton *)knownBtn
{
    if (!_knownBtn) {
        _knownBtn = [UIButton new];
        [_knownBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        _knownBtn.backgroundColor = COLOR_RED_EA0000;
        [_knownBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_knownBtn addTarget:self action:@selector(onClickKnownBtn:) forControlEvents:UIControlEventTouchUpInside];
        _knownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _knownBtn;
}

- (UIButton *)imergencyBtn
{
    if (!_imergencyBtn) {
        _imergencyBtn = [UIButton new];
        [_imergencyBtn setTitle:@"在线催单" forState:UIControlStateNormal];
        _imergencyBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        [_imergencyBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        _imergencyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

        [_imergencyBtn addTarget:self action:@selector(onClickImergencyBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imergencyBtn;
}

- (void)onClickKnownBtn:(UIButton *)button
{
    if (self.knownBlock) {
        self.knownBlock();
    }
}

- (void)onClickImergencyBtn:(UIButton *)button
{
    if (self.onlineBlock) {
        self.onlineBlock();
    }
}

- (void)onTapModalOutSide
{
    [self show:NO];
}

- (void)setKnownBtnText:(NSString *)knowText
{
    _knowText = knowText;
    
    [self.knownBtn setTitle:knowText forState:UIControlStateNormal];
}

- (void)setOnlineText:(NSString *)onlineText
{
    _onlineText = onlineText;
    
    [self.imergencyBtn setTitle:onlineText forState:UIControlStateNormal];
}

@end
