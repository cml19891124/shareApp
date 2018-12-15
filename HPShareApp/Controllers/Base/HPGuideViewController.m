//
//  HPGuideViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPGuideViewController.h"
#import "SDCycleScrollView.h"
#import "Macro.h"
#import "HPMainTabBarController.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"

@interface HPGuideViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UILabel *themeSBLabel;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation HPGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    NSArray *imageArray = @[ImageNamed(@"boot_page_1"),ImageNamed(@"boot_page_2"),ImageNamed(@"boot_page_3")];
    // 本地加载 --- 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:YES imageNamesGroup:imageArray];
    cycleScrollView.backgroundColor = COLOR_GRAY_FFFFFF;
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    [self.view addSubview:cycleScrollView];
    cycleScrollView.pageDotColor = COLOR_GRAY_DDDDDD;
    cycleScrollView.infiniteLoop = NO;
    cycleScrollView.currentPageDotColor = COLOR_RED_F91E54;
    [cycleScrollView setPageControlDotSize:CGSizeMake(getWidth(6.f), getWidth(6.f))];

    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 3.0;
    [self.view addSubview:cycleScrollView];
    _bannerView = cycleScrollView;
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    for (int i = 0; i < imageArray.count; i++) {
        [self cycleScrollView:cycleScrollView didScrollToIndex:i];
    }
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [_bannerView addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cycleScrollView.mas_bottom).with.offset(getWidth(38.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(6.f), getWidth(6.f)));
        make.centerX.mas_equalTo(self.bannerView);
    }];

    UILabel *themeLabel = [[UILabel alloc] init];
    [_bannerView addSubview:themeLabel];
    _themeLabel = themeLabel;
    [_themeLabel setFont:kFont_Bold(24.f)];
    [_themeLabel setTextColor:COLOR_BLACK_333333];
    _themeLabel.textAlignment = NSTextAlignmentCenter;
    [_themeLabel setText:@"共享店铺"];
    [themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cycleScrollView.mas_bottom).with.offset(getWidth(82.f));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, getWidth(23.f)));
        make.centerX.mas_equalTo(self.bannerView);
    }];

    UILabel *themeSBLabel = [[UILabel alloc] init];
    [_bannerView addSubview:themeSBLabel];
    _themeSBLabel = themeSBLabel;
    [_themeSBLabel setFont:kFont_Medium(16.f)];
    [_themeSBLabel setTextColor:COLOR_BLACK_666666];
    _themeSBLabel.textAlignment = NSTextAlignmentCenter;
    [_themeSBLabel setText:@"让店铺每平米空间都能增值"];
    [themeSBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(themeLabel.mas_bottom).with.offset(getWidth(22.f));
        make.height.mas_equalTo(themeSBLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth);
        make.centerX.mas_equalTo(self.bannerView);
    }];
    
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    enterBtn.hidden = YES;
    enterBtn.titleLabel.font = kFont_Medium(18.f);
    enterBtn.layer.cornerRadius = 15.f;
    enterBtn.layer.masksToBounds = YES;
    [enterBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
    enterBtn.backgroundColor = COLOR_RED_F91E54;
    enterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [enterBtn addTarget:self action:@selector(enterApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    self.enterBtn = enterBtn;
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(140.f), getWidth(35.f)));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(getWidth(-78.f));
    }];
    
}

- (void)enterApp:(UIButton *)button
{
    kAppdelegateWindow.rootViewController = [HPMainTabBarController new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_bannerView removeFromSuperview];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (index == 2) {
        _enterBtn.hidden = NO;
    }
    NSArray *themeTitle = @[@"共享店铺",@"共享货品",@"共享人力"];
    NSArray *themeSBTitle = @[@"让店铺每平米空间都能增值",@"厂家直供，没有中间商",@"人手不够，短工随时找"];
    [_themeLabel setText:themeTitle[index]];
    [_themeSBLabel setText:themeSBTitle[index]];
    _pageControl.backgroundColor = UIColor.redColor;
    _pageControl.currentPageIndicatorTintColor = COLOR_RED_F91E54;
    _pageControl.pageIndicatorTintColor = COLOR_GRAY_DDDDDD;
    _pageControl.currentPage = index;
    _pageControl.layer.cornerRadius = 3.f;
    _pageControl.layer.masksToBounds = YES;
}
@end
