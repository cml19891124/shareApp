//
//  HPShareManageController.m
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareManageController.h"
#import "HPShareManageCell.h"
#import "HPTextDialogView.h"

#define CELL_ID @"HPShareManageCell"

@interface HPShareManageController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@end

@implementation HPShareManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *testDataArray = @[@{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner", @"releaseTime":@"2018.11.22"},
                               @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup", @"releaseTime":@"2018.11.20"},
                       @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner", @"releaseTime":@"2018.11.18"},
                       @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner", @"releaseTime":@"2018.11.12"},
                       @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup", @"releaseTime":@"2018.11.17"},
                       @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner", @"releaseTime":@"2018.11.16"},
                       @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner", @"releaseTime":@"2018.11.15"},
                       @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup", @"releaseTime":@"2018.11.10"},
                       @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner", @"releaseTime":@"2018.11.11"}];
    _dataArray = [[NSMutableArray alloc] initWithArray:testDataArray];
    
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
    [self.view setBackgroundColor:COLOR_WHITE_FCFDFF];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"共享管理"];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:HPShareManageCell.class forCellReuseIdentifier:CELL_ID];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
}

- (UITableViewCell *)getParentCellofView:(UIView *)view {
    while (view != nil) {
        if ([view isKindOfClass:UITableViewCell.class]) {
            return (UITableViewCell *)view;
        }
        
        view = view.superview;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushVCByClassName:@"HPShareDetailController"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5f * g_rateWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 176.f * g_rateWidth;
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    NSDictionary *dict = _dataArray[indexPath.row];
    
    NSString *title = dict[@"title"];
    NSString *trade = dict[@"trade"];
    NSString *rentTime = dict[@"rentTime"];
    NSString *area = dict[@"area"];
    NSString *price = dict[@"price"];
    NSString *type = dict[@"type"];
    NSString *releaseTime = dict[@"releaseTime"];
    
    [cell setTitle:title];
    [cell setTrade:trade];
    [cell setRentTime:rentTime];
    [cell setArea:area];
    [cell setPrice:price];
    [cell setReleaseTime:releaseTime];
    [cell.deleteBtn addTarget:self action:@selector(onClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(onClickEditBtn) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark - OnClick

- (void)onClickEditBtn {
    [self pushVCByClassName:@"HPStartUpCardDefineController"];
}

- (void)onClickDeleteBtn:(UIButton *)btn {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setModalTop:279.f * g_rateHeight];
        [textDialogView setText:@"确定删除本条发布信息？"];
        _textDialogView = textDialogView;
    }
    
    [_textDialogView setConfirmCallback:^{
        UITableViewCell *cell = [self getParentCellofView:btn];
        if (cell) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    
    [_textDialogView show:YES];
}

@end
