//
//  HPBaseShareListController.m
//  HPShareApp
//
//  Created by HP on 2018/11/30.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseShareListController.h"

@interface HPBaseShareListController ()

@end

@implementation HPBaseShareListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _testDataArray = @[@{@"userId":@"27",@"spaceId":@"1",@"followedId":@"23",@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                       @{@"userId":@"10",@"spaceId":@"2",@"followedId":@"23",@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                       @{@"userId":@"11",@"spaceId":@"10",@"followedId":@"20",@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                       @{@"userId":@"21",@"spaceId":@"11",@"followedId":@"21",@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                       @{@"userId":@"121",@"spaceId":@"13",@"followedId":@"25",@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                       @{@"userId":@"120",@"spaceId":@"17",@"followedId":@"26",@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                       @{@"userId":@"128",@"spaceId":@"18",@"followedId":@"27",@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                       @{@"userId":@"122",@"spaceId":@"29",@"followedId":@"28",@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                       @{@"userId":@"125",@"spaceId":@"16",@"followedId":@"230",@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)setupFilterBar {
    UIView *filterBar = [[UIView alloc] init];
    [filterBar.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [filterBar.layer setShadowOpacity:0.1f];
    [filterBar.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [filterBar setBackgroundColor:UIColor.whiteColor];
    
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
    NSDictionary *datadict = self.testDataArray[indexPath.row];
    [self pushVCByClassName:@"HPShareDetailController" withParam:datadict];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    NSDictionary *dict = _dataArray[indexPath.row];
    
    NSString *title = dict[@"title"];
    NSString *trade = dict[@"trade"];
    NSString *rentTime = dict[@"rentTime"];
    NSString *area = dict[@"area"];
    NSString *price = dict[@"price"];
    NSString *type = dict[@"type"];
    
    [cell setTitle:title];
    [cell setTrade:trade];
    [cell setRentTime:rentTime];
    [cell setArea:area];
    [cell setPrice:price];
    
    if ([type isEqualToString:@"startup"]) {
        [cell setTagType:HPShareListCellTypeStartup];
    }
    else if ([type isEqualToString:@"owner"]) {
        [cell setTagType:HPShareListCellTypeOwner];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

@end
