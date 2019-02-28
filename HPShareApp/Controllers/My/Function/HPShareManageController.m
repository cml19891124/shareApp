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
#import "YYLRefreshNoDataView.h"
#import "HPReleaseModalView.h"
#import "HPShareReleaseParam.h"

#define CELL_ID @"HPShareManageCell"

@interface HPShareManageController () <UITableViewDelegate, UITableViewDataSource, YYLRefreshNoDataViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, weak) HPReleaseModalView *releaseModalView;

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
    
    if (self.param[@"update"]) {
        [self updataCellData];
    }
    
    if (self.param[@"delete"]) {
        [self deleteCell];
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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"拼租管理"];
    
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
    NSNumber *index = [NSNumber numberWithInteger:indexPath.row];
    [self pushVCByClassName:@"HPShareDetailController" withParam:@{@"model":model, @"index":index}];
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
    [cell.editBtn addTarget:self action:@selector(onClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - OnClick

- (void)onClickEditBtn:(UIButton *)btn {
    HPShareManageCell *cell = [self getParentCellofView:btn];
    NSNumber *index = [NSNumber numberWithInteger:[_tableView indexPathForCell:cell].row];
    HPShareListModel *model = cell.model;
    
    if (model.type == 1) {
        [self pushVCByClassName:@"HPOwnerCardDefineController" withParam:@{@"spaceId":model.spaceId, @"index":index}];
    }
    else if (model.type == 2) {
        [self pushVCByClassName:@"HPStartUpCardDefineController" withParam:@{@"spaceId":model.spaceId, @"index":index}];
    }
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
                [HPProgressHUD alertMessage:@"删除成功"];
                
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

- (void)onClickCancelBtn:(UIButton *)btn {
    if (_releaseModalView) {
        [_releaseModalView show:NO];
    }
}

#pragma mark - NetWork

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload {
    NSMutableDictionary *dict = param.mj_keyValues;
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/myList" isNeedToken:YES paraments:dict complete:^(id  _Nonnull responseObject) {
        NSArray<HPShareListModel *> *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:DATA[@"list"]];
        
        if (models.count < self.shareListParam.pageSize) {
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
        
        if (self.dataArray.count == 0) {
            self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
            self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"list_default_page");
            self.tableView.refreshNoDataView.tipLabel.text = @"店铺拼租，你是第一个吃螃蟹的人！！";
            [self.tableView.refreshNoDataView.tipBtn setTitle:@"立即发布" forState:UIControlStateNormal];
            self.tableView.refreshNoDataView.delegate = self;
        }
        
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - YYLRefreshNoDataViewDelegate

- (void)clickToCheckSTHForRequirments {
    if (_releaseModalView == nil) {
        HPReleaseModalView *releaseModalView = [[HPReleaseModalView alloc] init];
        [releaseModalView setCallBack:^(HPReleaseCardType type) {
            if (type == HPReleaseCardTypeOwner) {
                [self pushVCByClassName:@"HPOwnerCardDefineController"];
            }
            else if (type == HPReleaseCardTypeStartup) {
                [self pushVCByClassName:@"HPStartUpCardDefineController"];
            }
            
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setImage:[UIImage imageNamed:@"customizing_business_cards_close_button"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [releaseModalView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop).with.offset(-6.f);
        }];
        
        _releaseModalView = releaseModalView;
    }
    
    [_releaseModalView show:YES];
}

#pragma mark - UpdateData

- (void)updataCellData {
    if (!self.param[@"update"]) {
        return;
    }
    
    HPShareReleaseParam *param = self.param[@"update"];
    NSInteger index = ((NSNumber *)self.param[@"index"]).integerValue;
    
    HPShareManageCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        [cell setTitle:param.title];
        [cell setPhotoUrl:param.pictureUrlArr[0]];
        [cell setPrice:param.rent];
        [cell setUnitType:param.rentType.integerValue];
        if (param.tag && ![param.tag isEqualToString:@""]) {
            NSArray *tags = [param.tag componentsSeparatedByString:@","];
            [cell setTags:tags];
        }
        else {
            [cell setTags:@[@""]];
        }
    }
    
    [self.param removeObjectsForKeys:@[@"update", @"index"]];
}

- (void)deleteCell {
    if (!self.param[@"delete"]) {
        return;
    }
    
    NSInteger index = ((NSNumber *)self.param[@"delete"]).integerValue;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.dataArray removeObjectAtIndex:index];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.param removeObjectsForKeys:@[@"delete", @"index"]];
}

@end
