//
//  HPHistoryController.m
//  HPShareApp
//
//  Created by HP on 2018/11/30.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHistoryController.h"
#import "HPShareListCell.h"
#import "JTDateHelper.h"

@interface HPHistoryController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) JTDateHelper *dateHelper;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSMutableArray *sectionDataArray;
@property (nonatomic, assign) int count;

@property (nonatomic, strong) UIImageView *waitingView;
@property (nonatomic, strong) UILabel *waitingLabel;
@property (nonatomic, strong) NSMutableArray *industryModels;
@end

@implementation HPHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateHelper = [[JTDateHelper alloc] initWithLocale:[NSLocale currentLocale] andTimeZone:[NSTimeZone localTimeZone]];
    _dateFormatter = [_dateHelper createDateFormatter];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [self setupUI];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _industryModels = [NSMutableArray array];
    self.count = 1;
    [self loadtableViewFreshUi];
}
#pragma mark - 上下啦刷新控件
- (void)loadtableViewFreshUi
{
    [self getBrowsListData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.count = 1;
        [self getBrowsListData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.count++;
        [self getBrowsListData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
}
#pragma mark - 获取浏览历史数据
- (void)getBrowsListData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = @(self.count);
    dic[@"pageSize"] = @(10);
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/browseHistory/list" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.dataArray removeAllObjects];
            weakSelf.dataArray = [HPCollectListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if ([responseObject[@"data"][@"total"] integerValue] == 0) {
                //                [HPProgressHUD alertMessage:@"您还没有添加关注哦～"];
                UIImage *image = ImageNamed(@"waiting");
                UIImageView *waitingView = [[UIImageView alloc] init];
                waitingView.image = image;
                [self.tableView addSubview:waitingView];
                self.waitingView = waitingView;
                [waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.size.mas_equalTo(CGSizeMake(343.f * g_rateWidth, 197.f * g_rateWidth));
                    make.center.mas_equalTo(self.tableView);
                }];
                
                
                UILabel *waitingLabel = [[UILabel alloc] init];
                waitingLabel.text = @"您还没有浏览记录哦～";
                waitingLabel.font = [UIFont fontWithName:FONT_MEDIUM size:12];
                waitingLabel.textColor = COLOR_GRAY_BBBBBB;
                waitingLabel.textAlignment = NSTextAlignmentCenter;
                [self.tableView addSubview:waitingLabel];
                self.waitingLabel = waitingLabel;
                [waitingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.tableView);
                    make.top.mas_equalTo(waitingView.mas_bottom).offset(15.f * g_rateWidth);
                    make.width.mas_equalTo(self.tableView);
                }];
            }else{
                [self.waitingView removeFromSuperview];
                [self.waitingLabel removeFromSuperview];
            }
            if ([weakSelf.dataArray count] < 10) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
    
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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"浏览历史"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];;
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
}

- (void)reloadData {
    NSArray *dataArray = @[@{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner", @"date":@"2018-11-30"},
                           @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup", @"date":@"2018-11-30"},
                           @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner", @"date":@"2018-11-29"},
                           @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner", @"date":@"2018-11-29"},
                           @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup", @"date":@"2018-11-29"},
                           @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner", @"date":@"2018-11-28"},
                           @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner", @"date":@"2018-11-27"},
                           @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup", @"date":@"2018-11-26"},
                           @{@"title":@ "常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner", @"date":@"2018-11-26"}];
//    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    _sectionDataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSDictionary *dict = self.dataArray[i];
        NSString *dateStr = dict[@"date"];
        
        BOOL isExistDateStr = NO;
        
        for (NSMutableDictionary *sectionData in _sectionDataArray) {
            NSString *sectionDateStr = sectionData[@"date"];
            if ([sectionDateStr isEqualToString:dateStr]) {
                NSInteger count = ((NSNumber *)sectionData[@"count"]).integerValue;
                count ++;
                [sectionData setObject:[NSNumber numberWithInteger:count] forKey:@"count"];
                NSMutableArray *dataIndexArray = sectionData[@"dataIndex"];
                [dataIndexArray addObject:[NSNumber numberWithInteger:i]];
                isExistDateStr = YES;
                break;
            }
        }
        
        if (!isExistDateStr) {
            NSMutableDictionary *sectionData = [[NSMutableDictionary alloc] init];
            [sectionData setObject:dateStr forKey:@"date"];
            [sectionData setObject:[NSNumber numberWithInteger:1] forKey:@"count"];
            NSMutableArray *dataIndexArray = [[NSMutableArray alloc] init];
            [dataIndexArray addObject:[NSNumber numberWithInteger:i]];
            [sectionData setObject:dataIndexArray forKey:@"dataIndex"];
            [_sectionDataArray addObject:sectionData];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [dateLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [dateLabel setTextColor:COLOR_BLACK_666666];
    [view addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (section == 0) {
            make.top.equalTo(view).with.offset((41.f * g_rateWidth - 12.f)/2);
        }
        else {
            make.centerY.equalTo(view);
        }
        
        make.left.equalTo(view).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(dateLabel.font.pointSize);
    }];
    
    UILabel *tagLabel = [[UILabel alloc] init];
    [tagLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [tagLabel setTextColor:COLOR_BLACK_666666];
    [view addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.mas_right).with.offset(12.f);
        make.centerY.equalTo(dateLabel);
    }];
    [tagLabel setHidden:YES];
    
    if (section < _sectionDataArray.count) {
        NSDictionary *sectionData = _sectionDataArray[section];
        NSString *dateStr = sectionData[@"date"];
        [dateLabel setText:dateStr];
        
        NSDate *date = [_dateFormatter dateFromString:dateStr];
        if (date) {
            if ([_dateHelper date:date isTheSameDayThan:[NSDate date]]) {
                [tagLabel setHidden:NO];
                [tagLabel setText:@"今天"];
            }
            else {
                date = [_dateHelper addToDate:date days:1];
                if ([_dateHelper date:date isTheSameDayThan:[NSDate date]]) {
                    [tagLabel setHidden:NO];
                    [tagLabel setText:@"昨天"];
                }
            }
        }
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 33.5f * g_rateWidth;
    }
    else {
        return 26.f * g_rateWidth;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    HPCollectListModel *model = self.dataArray[indexPath.row];
    HPIndustryModel *industryModel = self.industryModels[indexPath.row];
    cell.model = model;
    cell.industryModel = industryModel;
//    NSDictionary *sectionData = _sectionDataArray[indexPath.section];
//    NSArray *sectionDataIndex = sectionData[@"dataIndex"];
//    NSInteger index = ((NSNumber *)sectionDataIndex[indexPath.row]).integerValue;
//
//    NSDictionary *dict = self.dataArray[index];
//
//    NSString *title = dict[@"title"];
//    NSString *trade = dict[@"trade"];
//    NSString *rentTime = dict[@"rentTime"];
//    NSString *area = dict[@"area"];
//    NSString *price = dict[@"price"];
//    NSString *type = dict[@"type"];
//
//    [cell setTitle:title];
//    [cell setTrade:trade];
//    [cell setRentTime:rentTime];
//    [cell setArea:area];
//    [cell setPrice:price];
    
    if ([model.type isEqualToString:@"startup"]) {
        [cell setTagType:HPShareListCellTypeStartup];
    }
    else if ([model.type isEqualToString:@"owner"]) {
        [cell setTagType:HPShareListCellTypeOwner];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < _sectionDataArray.count) {
        NSDictionary *sectionData = _sectionDataArray[section];
        NSNumber *number = sectionData[@"count"];
        return number.integerValue;
    }
    else
        return 0;
}

@end
