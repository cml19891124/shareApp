//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */
#import "Masonry.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"
#import "HPMainTabBarController.h"
@implementation SDCollectionViewCell
{
    __weak UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
        
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
//        enterBtn.hidden = YES;
        enterBtn.titleLabel.font = kFont_Medium(18.f);
        enterBtn.layer.cornerRadius = getWidth(15.f)/2;
        enterBtn.layer.masksToBounds = YES;
        [enterBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        enterBtn.backgroundColor = COLOR_RED_EA0000;
        enterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [enterBtn addTarget:self action:@selector(enterApp:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:enterBtn];
        self.enterBtn = enterBtn;
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(getWidth(140.f), getWidth(35.f)));
            make.centerX.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(getWidth(-78.f));
        }];
        
        UILabel *themeSBLabel = [[UILabel alloc] init];
        [self.contentView addSubview:themeSBLabel];
        _themeSBLabel = themeSBLabel;
        [_themeSBLabel setFont:kFont_Medium(16.f)];
        [_themeSBLabel setTextColor:COLOR_GRAY_666666];
        _themeSBLabel.textAlignment = NSTextAlignmentCenter;
        [themeSBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(enterBtn.mas_top).with.offset(getWidth(-39.f));
            make.height.mas_equalTo(themeSBLabel.font.pointSize);
            make.width.mas_equalTo(kScreenWidth);
            make.centerX.mas_equalTo(self.contentView);
        }];
        
        
        UILabel *themeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:themeLabel];
        _themeLabel = themeLabel;
        [_themeLabel setFont:kFont_Bold(24.f)];
        [_themeLabel setTextColor:COLOR_BLACK_333333];
        _themeLabel.textAlignment = NSTextAlignmentCenter;
        [themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.themeSBLabel.mas_top).with.offset(getWidth(-22.f));
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, getWidth(23.f)));
            make.centerX.mas_equalTo(self.contentView);
        }];
        
    }
    
    return self;
}

- (void)enterApp:(UIButton *)button
{
    HPMainTabBarController *mainTabBarController = [[HPMainTabBarController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
    navigationController.navigationBarHidden = YES;
    [navigationController.interactivePopGestureRecognizer setDelegate:mainTabBarController];
    [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(258.f), getWidth(260)));
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(getWidth(-298.f));
    }];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self.contentView addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
    if (_titleLabel.hidden) {
        _titleLabel.hidden = NO;
    }
}

-(void)setTitleLabelTextAlignment:(NSTextAlignment)titleLabelTextAlignment
{
    _titleLabelTextAlignment = titleLabelTextAlignment;
    _titleLabel.textAlignment = titleLabelTextAlignment;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.onlyDisplayText) {
        _titleLabel.frame = self.bounds;
    } else {
        _imageView.frame = self.bounds;
        CGFloat titleLabelW = self.sd_width;
        CGFloat titleLabelH = _titleLabelHeight;
        CGFloat titleLabelX = 0;
        CGFloat titleLabelY = self.sd_height - titleLabelH;
        _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    }
    
    _pageControl.frame = CGRectMake((self.contentView.frame.size.width - getWidth(100.f))/2,self.contentView.frame.size.height - getWidth(256.f), getWidth(100.f), getWidth(24.f));

}

@end
