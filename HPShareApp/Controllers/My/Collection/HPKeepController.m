//
//  HPKeepController.m
//  HPShareApp
//
//  Created by HP on 2018/11/28.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPKeepController.h"
#import "HPImageUtil.h"
#import "HPTextDialogView.h"
#import "HPIndustryModel.h"
#import "YYLRefreshNoDataView.h"
#import "UIScrollView+Refresh.h"
#import "HPCollectListModel.h"

@interface HPKeepController () <YYLRefreshNoDataViewDelegate>

@property (nonatomic, weak) UIButton *editBtn;

@property (nonatomic, weak) UIView *bottomDeleteView;

@property (nonatomic, weak) UIButton *allCheckBtn;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, assign) BOOL isEdited;

@property (nonatomic, strong) UIImageView *waitingView;

@property (nonatomic, strong) UILabel *waitingLabel;

@end

@implementation HPKeepController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isEdited = NO;
    
    [self.shareListParam setPageSize:10];
    
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        [self getCollectionsListDataReload:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.shareListParam.page ++;
        [self getCollectionsListDataReload:NO];
    }];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.estimatedRowHeight = 0;
        
        self.tableView.estimatedSectionFooterHeight = 0;
        
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
        }
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 获取收藏数据
- (void)getCollectionsListDataReload:(BOOL)isReload
{
    NSDictionary *dict = self.shareListParam.mj_keyValues;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/collection/list" isNeedToken:NO paraments:dict complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            HPCollectListModel *collectListModel = [HPCollectListModel mj_objectWithKeyValues:DATA];
            
            if (collectListModel.total == 0) {
                self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
                self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"empty_list_collect");
                self.tableView.refreshNoDataView.tipLabel.text = @"收藏夹孤单很久了，快去逛逛吧！";
                self.tableView.refreshNoDataView.delegate = self;
            }
            else {
                if ([self.dataArray count] < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (isReload) {
                    [self.dataArray removeAllObjects];
                }
                
                NSArray<HPShareListModel *> *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:collectListModel.list];
                [self.dataArray addObjectsFromArray:models];
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
    [self.view setBackgroundColor:COLOR_WHITE_FCFDFF];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"收藏"];
    
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
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {\
        make.top.and.bottom.and.right.equalTo(navigationView);
        make.width.mas_equalTo(40.f);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListModel *model = self.dataArray[indexPath.row];
    model.selected = !model.selected;//默认选一种，不可不选
    HPShareListCell *cell = (HPShareListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setChecked:model.selected];
    
    for (HPShareListModel *model in self.dataArray) {
        if (!model.selected) {
            [_allCheckBtn setSelected:NO];
            return;
        }
    }
    
    [_allCheckBtn setSelected:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    HPShareListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    [cell setCheckEnabled:_isEdited];
    [cell setChecked:model.selected];
    
    return cell;
}

#pragma mark - CheckCell

- (void)setAllCellChecked:(BOOL)isChecked {
    for (HPShareListCell *cell in self.tableView.visibleCells) {
        [cell setChecked:isChecked];
    }
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        HPShareListModel *model = self.dataArray[i];
        [model setSelected:isChecked];
    }
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
                make.bottom.equalTo(self.view).with.offset(- g_bottomSafeAreaHeight);
                make.left.and.width.equalTo(self.view);
                make.height.mas_equalTo(55.f * g_rateWidth);
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
                make.centerY.equalTo(view);
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
                make.centerY.equalTo(view);
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
            
            for (int i = 0; i < weakSelf.dataArray.count; i ++) {
                HPShareListModel *model = weakSelf.dataArray[i];
                if (model.selected) {
                    [deleteRowIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    [indexSet addIndex:i];
                    [spaceIds addObject:model.spaceId];
                }
            }
            
            [HPHTTPSever HPPostServerWithMethod:@"/v1/collection/cancelCollections" paraments:@{@"spaceIds":spaceIds} needToken:YES complete:^(id  _Nonnull responseObject) {
                if (CODE == 200) {
                    [HPProgressHUD alertMessage:MSG];
                    
                    [weakSelf.dataArray removeObjectsAtIndexes:indexSet];
                    [weakSelf.tableView deleteRowsAtIndexPaths:deleteRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    
                    if (weakSelf.dataArray.count == 0) {
                        [weakSelf.allCheckBtn setSelected:NO];
                    }
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

/**
 逛逛事件
 */
- (void)clickToCheckSTHForRequirments
{
    HPLog(@"forsth");
    [self pushVCByClassName:@"HPShareShopListController"];
}

@end
