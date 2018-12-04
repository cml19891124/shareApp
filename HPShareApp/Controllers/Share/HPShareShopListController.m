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

#define BANNER_SEPARATOR_HEIGHT 150.f * g_rateWidth + 10.f

@interface HPShareShopListController () <HPBannerViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPBannerView *bannerView;

@property (nonatomic, weak) HPPageControl *pageControl;

@end

@implementation HPShareShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithArray:self.testDataArray];
    
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_bannerView startAutoScrollWithInterval:2.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_bannerView stopAutoScroll];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"共享店铺"];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
}

#pragma mark - HPBannerViewDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        if (scrollView.contentOffset.y < BANNER_SEPARATOR_HEIGHT && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= BANNER_SEPARATOR_HEIGHT) {
            scrollView.contentInset = UIEdgeInsetsMake(-(BANNER_SEPARATOR_HEIGHT), 0, 0, 0);
        }
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    HPBannerView *bannerView = [[HPBannerView alloc] init];
    [bannerView setImages:@[[UIImage imageNamed:@"banner_share_shop_red"],
                            [UIImage imageNamed:@"banner_share_shop_purple"]]];
    [bannerView setBannerViewDelegate:self];
    [bannerView setImageContentMode:UIViewContentModeCenter];
    [view addSubview:bannerView];
    _bannerView = bannerView;
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(view);
        make.height.mas_equalTo(150.f * g_rateWidth);
    }];
    
    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
    [pageControl setNumberOfPages:2];
    [pageControl setCurrentPage:0];
    [view addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.equalTo(bannerView).with.offset(-22.f * g_rateWidth);
    }];
    
    UIView *separator = [[UIView alloc] init];
    [separator setBackgroundColor:COLOR_GRAY_F1F1F1];
    [view addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView.mas_bottom);
        make.left.and.width.equalTo(view);
        make.height.mas_equalTo(10.f);
    }];
    
    UIView *filterBar = [self setupFilterBar];
    [view addSubview:filterBar];
    [filterBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.top.equalTo(separator.mas_bottom);
        make.height.mas_equalTo(44.f * g_rateWidth);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return BANNER_SEPARATOR_HEIGHT + (44.f + 14.5f) * g_rateWidth;
}

@end
