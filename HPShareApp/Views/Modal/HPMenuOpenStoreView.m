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
    [self addSubview:self.searchView];
    [self.searchView addSubview:self.searchImage];
    [self.searchView addSubview:self.searchField];
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

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [UIView new];
        _searchView.backgroundColor = COLOR_GRAY_FFFFFF;
        _searchView.layer.cornerRadius = 3.f;
        _searchView.layer.shadowColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.08].CGColor;
        _searchView.layer.shadowOpacity = 1.f;
        _searchView.layer.shadowOffset = CGSizeMake(0, 2);
        _searchView.layer.shadowRadius = 17;
        
    }
    return _searchView;
}

- (UIButton *)searchImage
{
    if (!_searchImage) {
        _searchImage = [UIButton new];
        [_searchImage setBackgroundImage:ImageNamed(@"home_page_search") forState:UIControlStateNormal];
        [_searchImage addTarget:self action:@selector(searchImageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchImage;
}

- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [UITextField new];
        _searchField.placeholder = @"你想在哪开店？";
        [_searchField setValue:COLOR_GRAY_CCCCCC forKeyPath:@"_placeholderLabel.textColor"];
        [_searchField setValue:kFont_Medium(13.f) forKeyPath:@"_placeholderLabel.font"];
        _searchField.textColor = COLOR_BLACK_333333;
        _searchField.font = kFont_Medium(13.f);
        _searchField.tintColor = COLOR_RED_EA0000;
        _searchField.delegate = self;
        _searchField.returnKeyType = UIReturnKeyDone;
    }
    return _searchField;
}
- (void)setSubviewsFrame
{
    [self.tipimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(115.f));
    }];
    
    [self.sloganImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(getWidth(144.f), getWidth(20.f)));
    }];
    
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(getWidth(18.f));
        make.width.mas_equalTo(63.f * g_rateWidth);
        make.centerY.mas_equalTo(self.sloganImageView);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(325.f), getWidth(40.f)));
        make.top.mas_equalTo(getWidth(95.f));
        make.centerX.mas_equalTo(self);
    }];
    
    [self.searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(15.f), getWidth(15.f)));
        make.centerY.mas_equalTo(self.searchView);
        make.left.mas_equalTo(getWidth(105.f));
    }];
    
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(100.f), getWidth(13.f)));
        make.left.mas_equalTo(self.searchImage.mas_right).offset(getWidth(10.f));
        make.centerY.mas_equalTo(self.searchView);
    }];
}

- (void)onClickCityBtn:(UIButton *)button
{
    if (self.clickCityBtnBlock) {
        self.clickCityBtnBlock();
    }
}

- (void)searchImageClick:(UIButton *)button
{
    if (self.searchClickBtnBlock) {
        self.searchClickBtnBlock(self.searchField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    if (self.searchClickBtnBlock) {
        self.searchClickBtnBlock(self.searchField.text);
    }
    return YES;
}
@end
