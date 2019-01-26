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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_bannerView removeFromSuperview];
    [kUserDefaults setObject:@"isFirst" forKey:@"isFirst"];
    [kUserDefaults synchronize];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    _bannerView.currentPageIndex = (int)index;
    NSArray *themeTitleArray = @[@"店铺拼租",@"店铺短租",@"智能推送"];
    NSArray *themeSBTitleArray = @[@"让店铺每平米空间都能增值",@"租期灵活，一天一月都能租",@"AI赋能，用算法匹配最适合你的店"];
    _bannerView.themeTitleArray = themeTitleArray;
    _bannerView.themeSBTitleArray = themeSBTitleArray;
}
@end
