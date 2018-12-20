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
#import "HPShareListParam.h"

#define CELL_ID @"HPShareManageCell"

@interface HPShareManageController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@end

@implementation HPShareManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _dataArray = [NSMutableArray array];
    
    HPLoginModel *loginModel = [HPUserTool account];
    
    _shareListParam = [HPShareListParam new];
    [_shareListParam setCreateTimeOrderType:@"0"];
    [_shareListParam setUserId:loginModel.userInfo.userId];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isPop) {
        [self loadTableViewFreshUI];
    }
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

- (void)loadTableViewFreshUI {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.shareListParam.page = 1;
        [self getShareListData:self.shareListParam reload:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.shareListParam.page ++;
        [self getShareListData:self.shareListParam reload:NO];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (HPShareManageCell *)getParentCellofView:(UIView *)view {
    while (view != nil) {
        if ([view isKindOfClass:HPShareManageCell.class]) {
            return (HPShareManageCell *)view;
        }
        
        view = view.superview;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListModel *model = _dataArray[indexPath.row];
    [self pushVCByClassName:@"HPShareDetailController"withParam:@{@"model":model}];
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
    
    HPShareListModel *model = _dataArray[indexPath.row];
    
    [cell setModel:model];
    [cell.deleteBtn addTarget:self action:@selector(onClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(onClickEditBtn) forControlEvents:UIControlEventTouchUpInside];
    
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
        HPShareManageCell *cell = [self getParentCellofView:btn];
        
        if (!cell) {
            return;
        }
        
        NSString *spaceId = cell.model.spaceId;
        NSString *url = [NSString stringWithFormat:@"/v1/space/delete/%@", spaceId];
        [HPHTTPSever HPGETServerWithMethod:url isNeedToken:YES paraments:@{} complete:^(id  _Nonnull responseObject) {
            if (CODE == 200) {
                [HPProgressHUD alertMessage:MSG];
                
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
                [HPProgressHUD alertMessage:MSG];
        } Failure:^(NSError * _Nonnull error) {
            ErrorNet
        }];
    }];
    
    [_textDialogView show:YES];
}

#pragma mark - NetWork

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload {
    NSMutableDictionary *dict = param.mj_keyValues;
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:NO paraments:dict complete:^(id  _Nonnull responseObject) {
        NSArray<HPShareListModel *> *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:DATA[@"list"]];
        
        if (models.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
        }
        else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (isReload) {
            self.dataArray = [NSMutableArray arrayWithArray:models];
        }
        else {
            [self.dataArray addObjectsFromArray:models];
        }
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

@end
