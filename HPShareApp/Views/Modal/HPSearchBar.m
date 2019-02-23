//
//  HPSearchBar.m
//  HPShareApp
//
//  Created by HP on 2018/12/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSearchBar.h"

@implementation HPSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_GRAY_FFFFFF;

        [self setUpSearchSubviews];
        [self setUpSearchSubviewsFrame];
    }
    return self;
}
- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [UIView new];
        
    }
    return _centerView;
}
- (void)setUpSearchSubviewsFrame
{
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.bottom.mas_equalTo(self);
    }];
    [self.searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(15.f), getWidth(15.f)));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.centerView);
    }];
    
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(150.f));
        make.left.mas_equalTo(self.searchImage.mas_right).offset(getWidth(10.f));
        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.centerView);

    }];
}

- (void)setUpSearchSubviews
{
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.searchImage];
    [self.centerView addSubview:self.searchField];
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

- (void)searchImageClick:(UIButton *)button
{
    if (self.searchClickBtnBlock) {
        self.searchClickBtnBlock(self.searchField.text);
    }
}

- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [UITextField new];
        _searchField.placeholder = @"快速搜索心仪拼租店铺";
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    if (self.searchClickBtnBlock) {
        self.searchClickBtnBlock(self.searchField.text);
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //页面跳转的相关代码
    if ([self.delegate respondsToSelector:@selector(clickTextfieldJumpToSearchResultVC)]) {
        [self.delegate clickTextfieldJumpToSearchResultVC];
    }
    return NO;
}
@end
