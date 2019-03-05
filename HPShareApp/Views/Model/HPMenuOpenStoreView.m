//
//  HPMenuOpenStoreView.m
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMenuOpenStoreView.h"

@implementation HPMenuOpenStoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_GRAY_FFFFFF;
        [self setUpOpenStoreTips];
        [self setSubviewsFrame];
    }
    return self;
}

- (void)setUpOpenStoreTips
{
    [self addSubview:self.tipimageView];
    [self addSubview:self.sloganImageView];
    [self addSubview:self.cityBtn];    
}

- (UIImageView *)tipimageView
{
    if (!_tipimageView) {
        _tipimageView = [UIImageView new];
        _tipimageView.image = ImageNamed(@"home_page_background_map");
    }
    return _tipimageView;
}

- (UIImageView *)sloganImageView
{
    if (!_sloganImageView) {
        _sloganImageView = [UIImageView new];
        [_sloganImageView setContentMode:UIViewContentModeScaleAspectFill];
        _sloganImageView.image = ImageNamed(@"home_page_slogan");
    }
    return _sloganImageView;
}

- (UIButton *)cityBtn
{
    if (!_cityBtn) {
        _cityBtn = [UIButton new];
        [_cityBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
        [_cityBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_cityBtn setTitle:@"深圳" forState:UIControlStateNormal];
        [_cityBtn setImage:[UIImage imageNamed:@"shouye_xiala"] forState:UIControlStateNormal];
        [_cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -12.f, 0.f, 12.f)];
        [_cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 30.f, 0.f, -30.f)];
        [_cityBtn addTarget:self action:@selector(onClickCityBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityBtn;
}

- (void)setSubviewsFrame
{
    [self.tipimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(getWidth(18.f));
        make.width.mas_equalTo(63.f * g_rateWidth);
        make.top.mas_equalTo(g_statusBarHeight + 15.f);
        make.height.mas_equalTo(self.cityBtn.titleLabel.font.pointSize);
    }];
    
    [self.sloganImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.equalTo(self.cityBtn).with.offset(getWidth(10.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(144.f), getWidth(20.f)));
    }];
}

- (void)onClickCityBtn:(UIButton *)button
{
    if (self.clickCityBtnBlock) {
        self.clickCityBtnBlock();
    }
}

@end
