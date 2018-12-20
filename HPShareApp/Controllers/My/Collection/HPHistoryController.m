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
#import "YYLRefreshNoDataView.h"
#import "UIScrollView+Refresh.h"
#import "HPCollectListModel.h"
#import "HPShareListParam.h"
#import "HPHistoryListData.h"

@interface HPHistoryController () <YYLRefreshNoDataViewDelegate>

@property (nonatomic, strong) JTDateHelper *dateHelper;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UIImageView *waitingView;

@property (nonatomic, strong) UILabel *waitingLabel;

@property (nonatomic, strong) NSMutableArray<HPHistoryListData *> *histroyDataList;

@end

@implementation HPHistoryController
/**
 逛逛事件
 */
- (void)clickToCheckSTHForRequirments
{
    [self pushVCByClassName:@"HPShareShopListController"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateHelper = [[JTDateHelper alloc] initWithLocale:[NSLocale currentLocale] andTimeZone:[NSTimeZone localTimeZone]];
    _dateFormatter = [_dateHelper createDateFormatter];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    HPLoginModel *account = [HPUserTool account];
    [self.shareListParam setPageSize:10];
    [self.shareListParam setUserId:account.userInfo.userId];
    [self.shareListParam setPage:1];
    
    _histroyDataList = [[NSMutableArray alloc] init];
    
    [self setupUI];
}

#pragma mark - 上下啦刷新控件
- (void)loadTableViewFreshUI
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.shareListParam.page = 1;
        [self getBrowseListDataReload:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.shareListParam.page ++;
        [self getBrowseListDataReload:NO];
    }];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.estimatedRowHeight = 0;
        
        self.tableView.estimatedSectionFooterHeight = 0;
        
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 获取浏览历史数据
- (void)getBrowseListDataReload:(BOOL)isReload
{
    NSDictionary *dict = self.shareListParam.mj_keyValues;

    [HPHTTPSever HPGETServerWithMethod:@"/v1/browseHistory/list" isNeedToken:YES paraments:dict complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            HPCollectListModel *collectListModel = [HPCollectListModel mj_objectWithKeyValues:DATA];
            if (collectListModel.total == 0) {
                self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
                self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"empty_list_history");
                self.tableView.refreshNoDataView.tipLabel.text = @"历史足迹啥都没有，快去逛逛吧！";
                self.tableView.refreshNoDataView.delegate = self;
            }
            else {
                if (collectListModel.list.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (isReload) {
                    [self.histroyDataList removeAllObjects];
                }
                
                NSArray<HPBrowseModel *> *models = [HPBrowseModel mj_objectArrayWithKeyValuesArray:collectListModel.list];
                NSMutableArray<HPHistoryListData *> *historyDataList = [HPHistoryListData getHistroyListDataFromModels:models];
                [self.histroyDataList addObjectsFromArray:historyDataList];
            }
            
            [self.tableView reloadData];
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    self.tableView = tableView;
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
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
    
    if (section < _histroyDataList.count) {
        HPHistoryListData *historyListData = _histroyDataList[section];
        NSString *dateStr = historyListData.dateStr;
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
    
    HPHistoryListData *data = _histroyDataList[indexPath.section];
    HPShareListModel *model = data.items[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _histroyDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < _histroyDataList.count) {
        HPHistoryListData *data = _histroyDataList[section];
        return data.count;
    }
    else
        return 0;
}

@end
