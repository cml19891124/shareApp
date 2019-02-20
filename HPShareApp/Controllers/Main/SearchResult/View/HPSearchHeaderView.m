//
//  HPSearchHeaderView.m
//  HPShareApp
//
//  Created by HP on 2019/2/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSearchHeaderView.h"

@implementation HPSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpSubviews];
        [self setUpSubviewsMasonry];

    }
    return self;
}

- (void)setUpSubviews
{
    [self addSubview:self.leftImage];
    
    [self addSubview:self.headerLab];
    
    [self addSubview:self.deleteBtn];

}

#pragma mark - 初始化控件

- (UIImageView *)leftImage
{
    if (!_leftImage) {
        _leftImage = [UIImageView new];
        _leftImage.image = ImageNamed(@"sousuo_remen");

    }
    return _leftImage;
}

- (UILabel *)headerLab
{
    if (!_headerLab) {
        _headerLab = [UILabel new];
        _headerLab.textColor = COLOR_BLACK_333333;
        _headerLab.font = kFont_Bold(14.f);
    }
    return _headerLab;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setBackgroundImage:ImageNamed(@"sousuo_shanchu") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteHistrotyList:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (void)setUpSubviewsMasonry
{
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12.f), getWidth(14.f)));
        make.centerY.mas_equalTo(self);
    }];
    
    [_headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImage.mas_right).offset(getWidth(7.f));
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(kScreenWidth/3);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-17.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(13.f), getWidth(13.f)));
        make.centerY.mas_equalTo(self);
    }];
}

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    [self layoutIfNeeded];
    [_headerLab mas_updateConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(getWidth(16.f));
    }];
}

- (void)deleteHistrotyList:(UIButton *)button
{
    if (self.block) {
        self.block();
    }
}
@end
