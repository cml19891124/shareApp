//
//  HPShareSpaceListController.m
//  HPShareApp
//
//  Created by HP on 2018/11/30.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareHumanListController.h"
#import "HPBannerView.h"
#import "HPPageControlFactory.h"

#define BANNER_SEPARATOR_HEIGHT 150.f * g_rateWidth + 10.f

@interface HPShareHumanListController () <HPBannerViewDelegate>

@property (nonatomic, weak) UIView *navigationView;

@property (nonatomic, weak) HPBannerView *bannerView;

@property (nonatomic, weak) HPPageControl *pageControl;

@end

@implementation HPShareHumanListController

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
    
    //    [_bannerView startAutoScrollWithInterval:2.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [_bannerView stopAutoScroll];
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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"人力共享"];
    _navigationView = navigationView;
    
    //    HPBannerView *bannerView = [[HPBannerView alloc] init];
    //    [bannerView setImages:@[[UIImage imageNamed:@"banner_shop1"],
    //                            [UIImage imageNamed:@"banner_shop2"]]];
    //    [bannerView setBannerViewDelegate:self];
    //    [bannerView setImageContentMode:UIViewContentModeCenter];
    //    [headerScrollView addSubview:bannerView];
    //    _bannerView = bannerView;
    //    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.and.width.equalTo(headerScrollView);
    //        make.top.equalTo(headerScrollView).with.offset(0.f);
    //        make.height.mas_equalTo(150.f * g_rateWidth);
    //    }];
    //
    //    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
    //    [pageControl setNumberOfPages:2];
    //    [pageControl setCurrentPage:0];
    //    [headerScrollView addSubview:pageControl];
    //    _pageControl = pageControl;
    //    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(headerScrollView);
    //        make.bottom.equalTo(bannerView).with.offset(-22.f * g_rateWidth);
    //    }];
    //
    //    UIView *separator = [[UIView alloc] init];
    //    [separator setBackgroundColor:COLOR_GRAY_F1F1F1];
    //    [headerScrollView addSubview:separator];
    //    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(bannerView.mas_bottom);
    //        make.left.and.width.equalTo(self.view);
    //        make.height.mas_equalTo(10.f);
    //    }];
    
    UIView *filterBar = [self setupFilterBar];
    [self.view addSubview:filterBar];
    [filterBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
        make.height.mas_equalTo(44.f * g_rateWidth);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view insertSubview:tableView belowSubview:filterBar];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
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

@end
