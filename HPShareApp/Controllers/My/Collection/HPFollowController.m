//
//  HPFollowController.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPFollowController.h"
#import "HPFollowListCell.h"
#import "HPTextDialogView.h"
#import "HPFansListModel.h"
#import "UIScrollView+Refresh.h"
#import "HPShareListParam.h"
#import "HPCollectListModel.h"

#define CELL_ID @"HPFollowListCell"

@interface HPFollowController () <UITableViewDelegate, UITableViewDataSource, HPFollowListCellDelegate,YYLRefreshNoDataViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) UIImageView *waitingView;

@property (nonatomic, strong) UILabel *waitingLabel;

@property (strong, nonatomic) HPFansListModel *model;

@property (nonatomic, strong) HPFansListModel *selectedModel;

@property (nonatomic, strong) UIButton *forbtn;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HPFollowController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    _shareListParam = [HPShareListParam new];
    [_shareListParam setPageSize:10];
    HPLoginModel *model = [HPUserTool account];
    [_shareListParam setUserId:model.userInfo.userId];
    
    _dataArray = [NSMutableArray array];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isPop) {
        [self loadTableViewFreshUI];
    }
}
#pragma mark - 上下啦刷新控件
- (void)loadTableViewFreshUI
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.shareListParam.page = 1;
        [self getFansListDataReload:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.shareListParam.page ++;
        [self getFansListDataReload:NO];
    }];
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 获取关注数据
- (void)getFansListDataReload:(BOOL)isReload
{
    NSDictionary *dict = self.shareListParam.mj_keyValues;
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/fans/list" isNeedToken:YES paraments:dict complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            HPCollectListModel *collectionListModel = [HPCollectListModel mj_objectWithKeyValues:DATA];
            if (isReload) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray<HPFansListModel *> *models = [HPFansListModel mj_objectArrayWithKeyValuesArray:collectionListModel.list];
            [weakSelf.dataArray addObjectsFromArray:models];
            
            if (collectionListModel.total == 0 || weakSelf.dataArray.count == 0) {
                self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
                self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"empty_list");
                self.tableView.refreshNoDataView.tipLabel.text = @"关注列表空空如也，快去逛逛吧！";
                self.tableView.refreshNoDataView.delegate = self;
            }
            
            if (collectionListModel.list.count < collectionListModel.pageSize) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"关注"];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPFollowListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    HPFansListModel *model = _dataArray[indexPath.row];
    cell.model = model;
    [cell setDelegate:self];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - HPFollowListCellDelegate

- (void)followListCell:(HPFollowListCell *)cell didClickWithFollowModel:(HPFansListModel *)model {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setText:@"确定取消关注此人？"];
        [textDialogView setModalTop:279.f * g_rateHeight];
        _textDialogView = textDialogView;
    }
    
    HPLoginModel *account = [HPUserTool account];
    kWeakSelf(weakSelf);
    [_textDialogView setConfirmCallback:^{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [HPHTTPSever HPPostServerWithMethod:@"/v1/fans/cancel" paraments:@{@"userId":account.userInfo.userId,@"followedId":model.userId} needToken:YES complete:^(id  _Nonnull responseObject) {
            if (CODE == 200) {
                [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [HPProgressHUD alertMessage:MSG];
            }else{
                [HPProgressHUD alertMessage:MSG];
            }
        } Failure:^(NSError * _Nonnull error) {
            ErrorNet
        }];
    }];
    
    [_textDialogView show:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPFansListModel *model = self.dataArray[indexPath.row];
    [self pushVCByClassName:@"HPMyCardController" withParam:@{@"userId":model.userId}];
}

#pragma mark - 逛逛
/**
 逛逛事件
 */
- (void)clickToCheckSTHForRequirments
{
    [self pushVCByClassName:@"HPShareShopListController"];
    
}

@end
