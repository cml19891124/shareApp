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
#import "HPImageUtil.h"
#import "HPTextDialogView.h"

@interface HPHistoryController () <YYLRefreshNoDataViewDelegate>

@property (nonatomic, weak) UIButton *editBtn;

@property (nonatomic, strong) JTDateHelper *dateHelper;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UIImageView *waitingView;

@property (nonatomic, strong) UILabel *waitingLabel;

@property (nonatomic, strong) NSMutableArray<HPHistoryListData *> *histroyDataList;

@property (nonatomic, weak) UIView *bottomDeleteView;

@property (nonatomic, assign) BOOL isEdited;

@property (nonatomic, weak) UIButton *allCheckBtn;

@property (nonatomic, weak) HPTextDialogView *textDialogView;
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
    _isEdited = NO;
    
    _dateHelper = [[JTDateHelper alloc] initWithLocale:[NSLocale currentLocale] andTimeZone:[NSTimeZone localTimeZone]];
    _dateFormatter = [_dateHelper createDateFormatter];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    HPLoginModel *account = [HPUserTool account];
    [self.shareListParam setPageSize:10];
    [self.shareListParam setUserId:account.userInfo.userId];
    [self.shareListParam setPage:1];
    [self.shareListParam setType:@"1" ];
    
    _histroyDataList = [[NSMutableArray alloc] init];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.shareListParam.page = 1;
    self.shareListParam.type = @"1";
    [self getBrowseListDataReload:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_bottomDeleteView removeFromSuperview];
}

#pragma mark - 上下啦刷新控件
- (void)loadTableViewFreshUI
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.shareListParam.page = 1;
        self.shareListParam.type = @"1";

        [self getBrowseListDataReload:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.shareListParam.page ++;
        self.shareListParam.type = @"1";

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
                self.tableView.refreshNoDataView.hidden = NO;

                self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
                self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"empty_list_history");
                self.tableView.refreshNoDataView.tipLabel.text = @"历史足迹啥都没有，快去逛逛吧！";
                self.tableView.refreshNoDataView.delegate = self;
            }
            else {
                if (collectListModel.list.count < collectListModel.pageSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.refreshNoDataView.hidden = YES;

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

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"浏览历史"];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [editBtn setImage:[UIImage imageNamed:@"collection_edit"] forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(onClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, -20.f * g_rateWidth, 0.f, 20.f * g_rateWidth)];
    [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -20.f * g_rateWidth, 0.f, 20.f * g_rateWidth)];
    [navigationView addSubview:editBtn];
    _editBtn = editBtn;
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.equalTo(navigationView);
        make.width.mas_equalTo(40.f);
    }];
    
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
    
    [cell setCheckEnabled:_isEdited];
    [cell setChecked:model.selected];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isEdited) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    
    HPHistoryListData *data = _histroyDataList[indexPath.section];
    HPShareListModel *model = data.items[indexPath.row];
    model.selected = !model.selected;//默认选一种，不可不选

    HPShareListCell *cell = (HPShareListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setChecked:model.selected];
    
    for (HPShareListModel *model in self.dataArray) {
        if (!model.selected) {
            [_allCheckBtn setSelected:NO];
            return;
        }
    }
    
//    [_allCheckBtn setSelected:YES];
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

#pragma mark - OnClick

- (void)onClickEditBtn:(UIButton *)btn {
    if (!_isEdited) {
        [_editBtn setImage:nil forState:UIControlStateNormal];
        [_editBtn setSelected:YES];
        _isEdited = YES;
        [self.tableView reloadData];
        
        if (_bottomDeleteView == nil) {
            UIView *view = [[UIView alloc] init];
            [view.layer setShadowColor:COLOR_GRAY_AAAAAA.CGColor];
            [view.layer setShadowOffset:CGSizeMake(0.f, -2.f)];
            [view.layer setShadowRadius:12.f];
            [view.layer setShadowOpacity:0.1f];
            [view setBackgroundColor:UIColor.whiteColor];
            [kAppdelegateWindow addSubview:view];
            _bottomDeleteView = view;
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(kScreenHeight - g_bottomSafeAreaHeight - getWidth(55.f));
                make.left.and.width.equalTo(self.view);
                make.height.mas_equalTo(55.f * g_rateWidth + g_bottomSafeAreaHeight);
            }];
            
            UIImage *normalImage = [HPImageUtil getRectangleByStrokeColor:COLOR_GRAY_BCC1CF fillColor:UIColor.whiteColor borderWidth:1.f cornerRadius:10.f inRect:CGRectMake(0.f, 0.f, 19.f, 19.f)];
            UIButton *allCheckBtn = [[UIButton alloc] init];
            [allCheckBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
            [allCheckBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
            [allCheckBtn setImage:normalImage forState:UIControlStateNormal];
            [allCheckBtn setImage:[UIImage imageNamed:@"collection_selection"] forState:UIControlStateSelected];
            [allCheckBtn setTitle:@"全选" forState:UIControlStateNormal];
            [allCheckBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 10.f, 0.f, -10.f)];
            [allCheckBtn addTarget:self action:@selector(onClickAllCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:allCheckBtn];
            _allCheckBtn = allCheckBtn;
            [allCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).with.offset(30.f * g_rateWidth);
                make.centerY.equalTo(view).offset(getWidth(-g_bottomSafeAreaHeight/2));
            }];
            
            UIButton *deleteBtn = [[UIButton alloc] init];
            [deleteBtn.layer setCornerRadius:18.f];
            [deleteBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
            [deleteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setBackgroundColor:COLOR_RED_FF3C5E];
            [deleteBtn addTarget:self action:@selector(onClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:deleteBtn];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
                make.centerY.equalTo(view).offset(getWidth(-g_bottomSafeAreaHeight/2));
                make.size.mas_equalTo(CGSizeMake(90.f, 35.f));
            }];
            
            _bottomDeleteView = view;
        }
        
        [_bottomDeleteView setHidden:NO];
    }
    else {
        [_editBtn setImage:[UIImage imageNamed:@"collection_edit"] forState:UIControlStateNormal];
        [_editBtn setSelected:NO];
        _isEdited = NO;
        [self.tableView reloadData];
        
        [_bottomDeleteView setHidden:YES];
        [self setAllCellChecked:NO];
        [_allCheckBtn setSelected:NO];
    }
}

- (void)onClickAllCheckBtn:(UIButton *)btn {
    [self setAllCellChecked:!btn.isSelected];
    [btn setSelected:!btn.isSelected];
}


#pragma mark - CheckCell

- (void)setAllCellChecked:(BOOL)isChecked {
    for (HPShareListCell *cell in self.tableView.visibleCells) {
        [cell setChecked:isChecked];
    }
    
    for (int i = 0; i < self.histroyDataList.count; i ++) {
        HPHistoryListData *listData = self.histroyDataList[i];
        for (int j = 0; j < listData.items.count; j++) {
            HPShareListModel *model = listData.items[j];
            [model setSelected:isChecked];
        }
    }
}

- (void)onClickDeleteBtn:(UIButton *)btn {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setModalTop:279.f * g_rateHeight];
        [textDialogView setText:@"确定删除这些信息？"];
        kWeakSelf(weakSelf);
        
        [textDialogView setConfirmCallback:^{
            NSMutableArray *spaceIds = [NSMutableArray array];
            NSMutableArray *deleteRowIndexPaths = [[NSMutableArray alloc] init];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            
            for (int i = 0; i < weakSelf.histroyDataList.count; i ++) {
                HPHistoryListData *listData = weakSelf.histroyDataList[i];
                for (int j = 0; j < listData.items.count; j++) {
                    HPShareListModel *model = listData.items[j];
                    if (model.selected) {
                        [deleteRowIndexPaths addObject:[NSIndexPath indexPathForRow:j inSection:0]];
                        [indexSet addIndex:j];
                        [spaceIds addObject:model.spaceId];
                    }
                    
                    if (spaceIds.count == 0 || !spaceIds) {
                        [HPProgressHUD alertMessage:@"请选择历史记录"];
                        return ;
                    }
                }
                
            }
            
            
            [HPHTTPSever HPPostServerWithMethod:@"/v1/browseHistory/cancelHistorys" paraments:@{@"spaceIds":spaceIds} needToken:YES complete:^(id  _Nonnull responseObject) {
                if (CODE == 200) {
                    [HPProgressHUD alertMessage:MSG];
                    
//                    [weakSelf.dataArray removeObjectsAtIndexes:indexSet];
//                    [weakSelf.tableView deleteRowsAtIndexPaths:deleteRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    
                    if (weakSelf.dataArray.count == 0) {
                        [weakSelf.allCheckBtn setSelected:NO];
                    }
                    [self getBrowseListDataReload:YES];
                }else{
                    [HPProgressHUD alertMessage:MSG];
                }
            } Failure:^(NSError * _Nonnull error) {
                ErrorNet
            }];
        }];
        
        _textDialogView = textDialogView;
    }
    
    [_textDialogView show:YES];
}

@end
