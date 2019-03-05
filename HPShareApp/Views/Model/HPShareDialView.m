//
//  HPShareDialView.m
//  HPShareApp
//
//  Created by HP on 2019/3/5.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareDialView.h"

@implementation HPShareDialView

- (void)setupModalView:(UIView *)view
{
    [view setBackgroundColor:COLOR_GRAY_FFFFFF];
    view.layer.cornerRadius = 5.f;
    view.layer.masksToBounds = YES;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(250.f), getWidth(150.f)));
    }];
    
    [self setUpSubviews:view];
    
    [self setUpSubviewsMasonry:view];

}

- (void)onTapModalOutSide
{
    [self show:NO];
}

- (void)setUpSubviewsMasonry:(UIView *)view
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(getWidth(38.f));
        make.height.mas_equalTo(getWidth(12.f));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(25.f));
        make.height.mas_equalTo(self.phoneLabel.font.pointSize);
    }];
    
    [self.knownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
    }];
}

- (void)setUpSubviews:(UIView *)view
{
    [view addSubview:self.titleLabel];
    
    [view addSubview:self.phoneLabel];
    
    [view addSubview:self.knownBtn];

}

#pragma mark - 初始化控件

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_GRAY_666666;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Regular(12.f);
        _titleLabel.text = @"为保障隐私，请用注册手机号拨号";
    }
    return _titleLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
//        _phoneLabel.text = @"18603012947";
        _phoneLabel.textColor = COLOR_BLACK_333333;
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.font = kFont_Medium(18.f);
        
    }
    return _phoneLabel;
}

- (UIButton *)knownBtn
{
    if (!_knownBtn) {
        _knownBtn = [UIButton new];
        _knownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_knownBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [_knownBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _knownBtn.titleLabel.font = kFont_Bold(12.f);
        _knownBtn.backgroundColor = COLOR_RED_EA0000;
        [_knownBtn addTarget:self action:@selector(clickedPhoneCall:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knownBtn;
}

- (void)clickedPhoneCall:(UIButton *)button
{
    if (self.block) {
        self.block();
    }
}

- (void)setPhoneText:(NSString *)phoneText
{//拿到获取的值，直接更新UI
    [self.phoneLabel setText:phoneText];
}
@end
