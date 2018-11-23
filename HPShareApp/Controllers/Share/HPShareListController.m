//
//  HPShareListController.m
//  HPShareApp
//
//  Created by HP on 2018/11/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareListController.h"
#import "HPShareListCell.h"
#import "HPShareDetailController.h"

@interface HPShareListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HPShareListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = @[@{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"}];
    
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
    [self.view setBackgroundColor:COLOR_WHITE_F9FCFF];
    [self setupNavigationBarWithTitle:@"共享"];
    UIView *filterBar = [self setupFilterBar];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(filterBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (UIView *)setupFilterBar {
    UIView *filterBar = [[UIView alloc] init];
    [filterBar.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [filterBar.layer setShadowOpacity:0.1f];
    [filterBar.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [filterBar setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:filterBar];
    [filterBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(g_navigationBarHeight);
        make.height.mas_equalTo(44.f * g_rateWidth);
    }];
    
    UIButton *sortBtn = [[UIButton alloc] init];
    [sortBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [sortBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [sortBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"] forState:UIControlStateNormal];
    [sortBtn setImage:[UIImage imageNamed:@"triangle_selected"] forState:UIControlStateSelected];
    [sortBtn setTitle:@"全部" forState:UIControlStateNormal];
    [sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -6.f, 0.f, 6.f)];
    [sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 29.f, 0.f, -29.f)];
    [filterBar addSubview:sortBtn];
    [sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(filterBar);
        make.top.and.bottom.equalTo(filterBar);
        make.width.mas_equalTo(79.f * g_rateWidth);
    }];
    
    UIView *seprartor = [[UIView alloc] init];
    [seprartor setBackgroundColor:COLOR_GRAY_CDCDCD];
    [filterBar addSubview:seprartor];
    [seprartor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sortBtn.mas_right);
        make.centerY.equalTo(filterBar);
        make.size.mas_equalTo(CGSizeMake(1.f, 16.f * g_rateWidth));
    }];
    
    UIView *rightView = [[UIView alloc] init];
    [filterBar addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seprartor.mas_right);
        make.top.and.bottom.equalTo(filterBar);
        make.right.equalTo(filterBar);
    }];
    
    UIView *btnView = [[UIView alloc] init];
    [rightView addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView);
        make.top.and.bottom.equalTo(rightView);
    }];
    
    UIButton *tradeBtn = [[UIButton alloc] init];
    [tradeBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [tradeBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [tradeBtn setTitle:@"行业" forState:UIControlStateNormal];
    [tradeBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"] forState:UIControlStateNormal];
    [tradeBtn setImage:[UIImage imageNamed:@"triangle_selected"] forState:UIControlStateSelected];
    [tradeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -6.f, 0.f, 6.f)];
    [tradeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 29.f, 0.f, -29.f)];
    [btnView addSubview:tradeBtn];
    [tradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnView);
        make.top.and.bottom.equalTo(btnView);
        make.width.mas_equalTo(35.f);
    }];
    
    UIButton *districtBtn = [[UIButton alloc] init];
    [districtBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [districtBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [districtBtn setTitle:@"区域" forState:UIControlStateNormal];
    [districtBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"] forState:UIControlStateNormal];
    [districtBtn setImage:[UIImage imageNamed:@"triangle_selected"] forState:UIControlStateSelected];
    [districtBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -6.f, 0.f, 6.f)];
    [districtBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 29.f, 0.f, -29.f)];
    [btnView addSubview:districtBtn];
    [districtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tradeBtn.mas_right).with.offset(35.f * g_rateWidth);
        make.top.and.bottom.equalTo(btnView);
        make.width.mas_equalTo(35.f);
    }];
    
    UIButton *timeBtn = [[UIButton alloc] init];
    [timeBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [timeBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [timeBtn setTitle:@"最近" forState:UIControlStateNormal];
    [timeBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"] forState:UIControlStateNormal];
    [timeBtn setImage:[UIImage imageNamed:@"inverted_triangle_selected"] forState:UIControlStateSelected];
    [timeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -6.f, 0.f, 6.f)];
    [timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 29.f, 0.f, -29.f)];
    [btnView addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(districtBtn.mas_right).with.offset(35.f * g_rateWidth);
        make.top.and.bottom.equalTo(btnView);
        make.width.mas_equalTo(35.f);
    }];
    
    UIButton *priceBtn = [[UIButton alloc] init];
    [priceBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [priceBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    [priceBtn setImage:[UIImage imageNamed:@"sort_icon_normal"] forState:UIControlStateNormal];
    [priceBtn setImage:[UIImage imageNamed:@"sort_icon_up"] forState:UIControlStateSelected];
    [priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -6.f, 0.f, 6.f)];
    [priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 29.f, 0.f, -29.f)];
    [btnView addSubview:priceBtn];
    [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBtn.mas_right).with.offset(35.f * g_rateWidth);
        make.top.and.bottom.equalTo(btnView);
        make.width.mas_equalTo(35.f);
        make.right.equalTo(btnView);
    }];
    
    return filterBar;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareDetailController *shareDetailController = [[HPShareDetailController alloc] init];
    [self.navigationController pushViewController:shareDetailController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5f * g_rateWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell_%ld", (long)indexPath.row];
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSDictionary *dict = _dataArray[indexPath.row];
        
        cell = [[HPShareListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setTitle:dict[@"title"]];
        [cell setTrade:dict[@"trade"]];
        [cell setRentTime:dict[@"rentTime"]];
        [cell setArea:dict[@"area"]];
        [cell setPrice:dict[@"price"]];
        
        if ([dict[@"type"] isEqualToString:@"startup"]) {
            [cell setTagType:HPShareListCellTypeStartup];
        }
        else if ([dict[@"type"] isEqualToString:@"owner"]) {
            [cell setTagType:HPShareListCellTypeOwner];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - onClick

@end
