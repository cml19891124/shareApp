//
//  HPShareSelectedItemView.m
//  HPShareApp
//
//  Created by HP on 2018/12/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareSelectedItemView.h"

@implementation HPShareSelectedItemView

- (void)setupModalView:(UIView *)view {
    [self setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.95f]];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self setUpBgView];
}

- (void)setUpBgView
{
    UIView *bgview = [UIView new];
    bgview.backgroundColor = COLOR_GRAY_FFFFFF;
    bgview.alpha = 0.6;
    bgview.layer.cornerRadius = 5.f;
    bgview.layer.masksToBounds = YES;
    [self addSubview:bgview];
    _bgview = bgview;
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(229.f), getWidth(175.f)));
        make.center.mas_equalTo(self);
    }];
    
    [self setUpSubviews];
}

- (void)setUpSubviews
{
    UIButton *tipBtn = [UIButton new];
    [tipBtn setImage:ImageNamed(@"tishi") forState:UIControlStateNormal];
    [tipBtn setTitle:@"提示" forState:UIControlStateNormal];
    [tipBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
    [tipBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(12.f), getWidth(84.f), getWidth(12.f), 0)];
    [tipBtn setTitleEdgeInsets:UIEdgeInsetsMake(getWidth(13.f), getWidth(7.f), getWidth(13.f), getWidth(129.f))];
    tipBtn.titleLabel.font = kFont_Bold(15.f);
    [self.bgview addSubview:tipBtn];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.bgview);
        make.height.mas_equalTo(getWidth(40.f));
    }];
    
    UILabel *focusLabel = [UILabel new];
    focusLabel.text = @"请先填完带*号的内容";
    focusLabel.textColor = COLOR_BLACK_1B1C23;
    focusLabel.textAlignment = NSTextAlignmentCenter;
    focusLabel.font = kFont_Bold(15.f);
    [self.bgview addSubview:focusLabel];
    [focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgview);
        make.top.mas_equalTo(getWidth(32.f));
        make.height.mas_equalTo(focusLabel.font.pointSize);
    }];
    
    UIButton *knownBtn = [UIButton new];
    [knownBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [knownBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
    knownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    knownBtn.layer.cornerRadius = 4.f;
    knownBtn.layer.borderColor = COLOR_RED_EA0000.CGColor;
    knownBtn.layer.borderWidth = 1;
    knownBtn.titleLabel.font = kFont_Bold(13.f);
    [knownBtn addTarget:self action:@selector(clickKnownBtnRemoveView:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgview addSubview:knownBtn];
    [knownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(focusLabel.mas_bottom).offset(getWidth(33.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(140.f), getWidth(29.f)));
    }];
}

- (void)clickKnownBtnRemoveView:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickKnownBtnRemoveView:)]) {
        [self.delegate clickBtnInShareSelectViewToRemoveView];
    }
}
@end
