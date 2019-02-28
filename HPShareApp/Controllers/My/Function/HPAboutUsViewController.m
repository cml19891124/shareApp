//
//  HPAboutUsViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/18.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAboutUsViewController.h"

@interface HPAboutUsViewController ()
@property (nonatomic, strong) UIView *navtitleView;
@property (nonatomic, strong) UIView *usTitleView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UILabel *themeSBLabel;
@property (nonatomic, strong) UIView *abountUSView;
@property (nonatomic, strong) UILabel *abountUSLabel;
@property (nonatomic, strong) UILabel *rightCopyLabel;

@end

@implementation HPAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *navtitleView = [self setupNavigationBarWithTitle:@"关于我们"];
    self.navtitleView = navtitleView;
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    [self.view addSubview:self.abountUSView];
    [self.view addSubview:self.usTitleView];
    [self.view addSubview:self.iconView];
    [self.usTitleView addSubview:self.themeLabel];
    [self.usTitleView addSubview:self.themeSBLabel];
    [self.abountUSView addSubview:self.abountUSLabel];
    [self.abountUSView addSubview:self.rightCopyLabel];
    [self setUpSubviews];
}
#pragma mark - 子控件布局
- (void)setUpSubviews
{
    [self.usTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.abountUSView.mas_top).offset(getWidth(-3.f));
        make.top.mas_equalTo(self.navtitleView.mas_bottom);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(75.f), getWidth(75.f)));
        make.top.mas_equalTo(self.usTitleView).offset(getWidth(30.f));
        make.centerX.mas_equalTo(self.usTitleView);
    }];
    
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).with.offset(getWidth(15.f));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, self.themeLabel.font.pointSize));
        make.centerX.mas_equalTo(self.usTitleView);
    }];
    
    [self.themeSBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeLabel.mas_bottom).with.offset(getWidth(10.f));
        make.height.mas_equalTo(self.themeSBLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth);
        make.centerX.mas_equalTo(self.usTitleView);
    }];
    
    [self.abountUSView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(getWidth(70.f) + g_bottomSafeAreaHeight);
    }];
    
    [self.abountUSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.abountUSView).with.offset(getWidth(13.f));
        make.height.mas_equalTo(self.abountUSLabel.font.pointSize);
        make.width.mas_equalTo(self.abountUSView);
        make.centerX.mas_equalTo(self.abountUSView);
    }];
    
    [self.rightCopyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.abountUSLabel.mas_bottom).with.offset(getWidth(10.f));
        make.height.mas_equalTo(self.rightCopyLabel.font.pointSize);
        make.width.mas_equalTo(self.abountUSView);
        make.centerX.mas_equalTo(self.abountUSView);
    }];
}
#pragma mark - 底部view
- (UIView *)usTitleView
{
    if (!_usTitleView) {
        _usTitleView = [UIView new];
        _usTitleView.backgroundColor = COLOR_GRAY_F9F9F9;
    }
    
    return _usTitleView;
}

#pragma mark - 顶部view 图标
- (UIImageView *)iconView
{
    if (!_iconView) {
        UIImage *imageIcon = ImageNamed(@"about_us_application_icon");
        _iconView = [UIImageView new];
        _iconView.image = imageIcon;
    }
    return _iconView;
}

#pragma mark - 底部view 版权主信息
- (UILabel *)themeLabel
{
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        [_themeLabel setFont:kFont_Bold(18.f)];
        [_themeLabel setTextColor:COLOR_BLACK_333333];
        _themeLabel.textAlignment = NSTextAlignmentCenter;
        [_themeLabel setText:@"合店站"];
    }
    return _themeLabel;
}

#pragma mark - 底部view 子信息
- (UILabel *)themeSBLabel
{
    if (!_themeSBLabel) {
        _themeSBLabel = [UILabel new];
        [_themeSBLabel setFont:kFont_Regular(13.f)];
        [_themeSBLabel setTextColor:COLOR_BLACK_666666];
        _themeSBLabel.textAlignment = NSTextAlignmentCenter;
        [_themeSBLabel setText:@"打造全球空间拼租、短租第一平台"];
    }
    return _themeSBLabel;
}
#pragma mark - 底部view 版权信息
- (UIView *)abountUSView
{
    if (!_abountUSView) {
        _abountUSView = [UILabel new];
        _abountUSView.backgroundColor = COLOR_GRAY_F9F9F9;
    }
    return _abountUSView;
}

- (UILabel *)abountUSLabel
{
    if (!_abountUSLabel) {
        _abountUSLabel = [UILabel new];
        [_abountUSLabel setFont:kFont_Medium(13.f)];
        [_abountUSLabel setTextColor:COLOR_GRAY_F44230];
        _abountUSLabel.textAlignment = NSTextAlignmentCenter;
        [_abountUSLabel setText:@"合派科技  版权所有"];
    }
    return _abountUSLabel;
}

- (UILabel *)rightCopyLabel
{
    if (!_rightCopyLabel) {
        _rightCopyLabel = [UILabel new];
        [_rightCopyLabel setFont:kFont_Medium(12.f)];
        [_rightCopyLabel setTextColor:COLOR_BLACK_333333];
        _rightCopyLabel.textAlignment = NSTextAlignmentCenter;
        [_rightCopyLabel setText:@"Copyright © 2017-2018 | 粤ICP备18067943号 "];
    }
    return _rightCopyLabel;
}
@end
