//
//  HPShareShopListController.m
//  HPShareApp
//
//  Created by HP on 2018/12/3.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareShopListController.h"
#import "HPBannerView.h"
#import "HPPageControlFactory.h"
#import "HPParentScrollView.h"
#import "HPSubTableView.h"

#define BANNER_SEPARATOR_HEIGHT 150.f * g_rateWidth + 10.f

@interface HPShareShopListController () <HPBannerViewDelegate>

@property (nonatomic, weak) UIView *navigationView;

@property (nonatomic, weak) HPBannerView *bannerView;

@property (nonatomic, weak) HPPageControl *pageControl;

@property (nonatomic, weak) UIView *headerMaskView;

@property (nonatomic, weak) HPParentScrollView *parentScrollView;

@property (nonatomic, weak) HPSubTableView *subTableView;

@property (nonatomic, assign) CGFloat headerHeight;

@end

@implementation HPShareShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_bannerView startAutoScrollWithInterval:6.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_bannerView stopAutoScroll];
}

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    NSString *title = self.param[@"title"];
    if (!title) {
        title = @"店铺拼租";
    }
    UIView *navigationView = [self setupNavigationBarWithTitle:title];
    _navigationView = navigationView;
    
    _headerHeight = getWidth(150.f) + 10.f;
    CGFloat contentHeight = kScreenHeight - g_navigationBarHeight - g_bottomSafeAreaHeight + _headerHeight;
    
    HPParentScrollView *parentScrollView = [[HPParentScrollView alloc] init];
    [parentScrollView setBounces:NO];
    [parentScrollView setShowsVerticalScrollIndicator:NO];
    [parentScrollView setContentSize:CGSizeMake(0.f, contentHeight)];
    [parentScrollView setDelegate:self];
    [self.view addSubview:parentScrollView];
    _parentScrollView = parentScrollView;
    [parentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    UIView *headerView = [[UIView alloc] init];
    [parentScrollView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(parentScrollView);
        make.top.equalTo(parentScrollView);
    }];
    
    HPBannerView *bannerView = [[HPBannerView alloc] init];
    [bannerView setImages:@[[UIImage imageNamed:@"banner_shop1"],
                            [UIImage imageNamed:@"banner_shop2"]]];
    [bannerView setBannerViewDelegate:self];
    [bannerView setImageContentMode:UIViewContentModeCenter];
    [headerView addSubview:bannerView];
    _bannerView = bannerView;

    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(headerView);
        make.top.equalTo(headerView);
        make.height.mas_equalTo(150.f * g_rateWidth);
    }];

    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
    [pageControl setNumberOfPages:2];
    [pageControl setCurrentPage:0];
    [headerView addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.bottom.equalTo(bannerView).with.offset(-22.f * g_rateWidth);
    }];

    UIView *separator = [[UIView alloc] init];
    [separator setBackgroundColor:COLOR_GRAY_F1F1F1];
    [headerView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView.mas_bottom);
        make.left.and.width.equalTo(headerView);
        make.height.mas_equalTo(10.f);
        make.bottom.equalTo(headerView);
    }];
    
    UIView *headerMaskView = [[UIView alloc] init];
    [headerMaskView setBackgroundColor:COLOR_RED_EA0000];
    [headerMaskView setAlpha:0.f];
    [headerView addSubview:headerMaskView];
    _headerMaskView = headerMaskView;
    [headerMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    
    UIView *filterBar = [self setupFilterBar];
    [parentScrollView addSubview:filterBar];
    [filterBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(parentScrollView);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(44.f * g_rateWidth);
    }];
    
    HPSubTableView *subTableView = [[HPSubTableView alloc] init];
    [subTableView setBackgroundColor:UIColor.clearColor];
    [subTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [subTableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [subTableView setDelegate:self];
    [subTableView setDataSource:self];
    [subTableView setCanRefresh:YES];
    [parentScrollView insertSubview:subTableView belowSubview:filterBar];
    _subTableView = subTableView;
    self.tableView = subTableView;
    [subTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(parentScrollView);
        make.top.equalTo(filterBar.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

#pragma mark - HPBannerViewDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return getWidth(7.5f);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    if (scrollView == _parentScrollView) {
        _headerMaskView.alpha = (contentOffset.y/_headerHeight)*1.5f;
        
        if (fabs(contentOffset.y - _headerHeight) <= 0.5) {// 滚动距离为 headerView 高度的那一刻
            if (_parentScrollView.canScroll) {
                _parentScrollView.canScroll = NO;
                _subTableView.canScroll = YES;
            } else {
                _subTableView.canScroll = YES;
            }
        } else {
            if (!_parentScrollView.canScroll) {//子视图没到顶部
                _parentScrollView.contentOffset = CGPointMake(0, _headerHeight);
            }
        }
        
        if (_parentScrollView.contentOffset.y == 0) {
            _subTableView.canRefresh = YES;
        } else {
            _subTableView.canRefresh = NO;
        }
    }
    else if (scrollView == _subTableView) {
        if (!_subTableView.canScroll) {
            if (_subTableView.canRefresh && contentOffset.y < 0.5f) {
                return;
            }
            
            _subTableView.contentOffset = CGPointMake(0.f, 0.5f);
        }
        
        if (_subTableView.contentOffset.y <= 0.5f) {
            
            _subTableView.canScroll = NO;
            _subTableView.contentOffset = CGPointMake(0.f, 0.5f);
            _parentScrollView.canScroll = YES;//到顶通知父视图改变状态
        }
    }
}
@end
