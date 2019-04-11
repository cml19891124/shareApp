//
//  HPAcceptView.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAcceptView.h"

@implementation HPAcceptView

- (void)setupModalView:(UIView *)view
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f));
        make.height.mas_equalTo(getWidth(160.f));
        make.center.mas_equalTo(self);
    }];
    
    [view addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.bgView addSubview:self.confirmLabel];
    
    [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(30.f));
        make.right.mas_equalTo(getWidth(-30.f));
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(getWidth(50.f));
    }];
    
    [self.bgView addSubview:self.kownBtn];
}

- (UILabel *)confirmLabel
{
    if (!_confirmLabel) {
        _confirmLabel = [UILabel new];
        _confirmLabel.text = @"您的申请已受理，请耐心等候";
        _confirmLabel.textColor = COLOR_GRAY_666666;
        _confirmLabel.font = kFont_Medium(16.f);
        [_confirmLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _confirmLabel;
}

- (UIButton *)kownBtn
{
    if (!_kownBtn) {
        _kownBtn = [UIButton new];
        _kownBtn.backgroundColor = COLOR_RED_EA0000;
        [_kownBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [_kownBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_kownBtn addTarget:self action:@selector(onClickKnown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kownBtn;
}

- (void)onClickKnown:(UIButton *)button
{
    if (self.kownBlock) {
        self.kownBlock();
    }
}
@end
