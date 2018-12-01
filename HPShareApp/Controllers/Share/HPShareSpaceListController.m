//
//  HPShareSpaceListController.m
//  HPShareApp
//
//  Created by HP on 2018/11/30.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareSpaceListController.h"
#import "HPBanner.h"
#import "HPImageUtil.h"
#import "HPPageControlFactory.h"

#define BANNER_SEPARATOR_HEIGHT 150.f * g_rateWidth + 10.f

@interface HPShareSpaceListController () <HPBannerDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPPageControl *pageControl;

@end

@implementation HPShareSpaceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithArray:self.testDataArray];
    
    [self setupUI];
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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"共享空间"];
    
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

#pragma mark - HPBannerDelegate

- (void)banner:(HPBanner *)banner didScrollAtIndex:(NSInteger)index {
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
    
    HPBanner *banner = [[HPBanner alloc] init];
    [banner setImageArray:@[[UIImage imageNamed:@"banner_share_space_red"],
                            [UIImage imageNamed:@"banner_share_space_purple"]]];
//    [UIImage imageNamed:@"banner_share_good_red"],
//    [UIImage imageNamed:@"banner_share_good_purple"],
//    [UIImage imageNamed:@"banner_share_shop_red"],
//    [UIImage imageNamed:@"banner_share_shop_purple"]
    [banner setDelegate:self];
    [view addSubview:banner];
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(view);
        make.height.mas_equalTo(150.f * g_rateWidth);
    }];
    
    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
    [pageControl setNumberOfPages:2];
    [pageControl setCurrentPage:0];
    [banner addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(banner);
        make.bottom.equalTo(banner).with.offset(-22.f * g_rateWidth);
    }];
    
    UIView *separator = [[UIView alloc] init];
    [separator setBackgroundColor:COLOR_GRAY_F1F1F1];
    [view addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banner.mas_bottom);
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
