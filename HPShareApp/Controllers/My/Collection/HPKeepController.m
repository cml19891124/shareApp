//
//  HPKeepController.m
//  HPShareApp
//
//  Created by HP on 2018/11/28.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPKeepController.h"
#import "HPShareListCell.h"
#import "HPImageUtil.h"
#import "HPTextDialogView.h"
#import "HPCollectListModel.h"
#import "HPIndustryModel.h"

@interface HPKeepController ()

@property (nonatomic, weak) UIButton *editBtn;

@property (nonatomic, weak) UIView *bottomDeleteView;

@property (nonatomic, weak) UIButton *allCheckBtn;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) NSMutableArray *checkArray;

@property (nonatomic, assign) BOOL isEdited;
@property (nonatomic, assign) int                        count;
@property (nonatomic, strong) UIImageView *waitingView;
@property (nonatomic, strong) UILabel *waitingLabel;

@property (nonatomic, strong) NSMutableArray *industryModels;
@property (strong, nonatomic) HPCollectListModel *model;

@property (nonatomic, strong) HPCollectListModel *selectedModel;
@end

@implementation HPKeepController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isEdited = NO;
    
//    self.dataArray = [NSMutableArray arrayWithArray:self.testDataArray];
    
    _checkArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArray.count; i ++) {
        [_checkArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _industryModels = [NSMutableArray array];
    self.count = 1;
    [self loadtableViewFreshUi];
    [self getTradeList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_bottomDeleteView removeFromSuperview];
}

- (void)getTradeList {
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/industry/listWithChildren" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            weakSelf.industryModels = [HPIndustryModel mj_objectArrayWithKeyValuesArray:DATA];
            [self.tableView reloadData];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
#pragma mark - 上下啦刷新控件
- (void)loadtableViewFreshUi
{
    [self getCollectionsListData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.count = 1;
        [self getCollectionsListData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.count++;
        [self getCollectionsListData];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.estimatedRowHeight = 0;
        
        self.tableView.estimatedSectionFooterHeight = 0;
        
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
        }
}
#pragma mark - 获取收藏数据
- (void)getCollectionsListData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = [NSString stringWithFormat:@"%d",self.count];
    dic[@"pageSize"] = @"10";
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/collection/list" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
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
                waitingLabel.text = @"您还没有添加收藏哦～";
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
//    BOOL isChecked = ((NSNumber *)_checkArray[indexPath.row]).boolValue;
//    HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setChecked:!isChecked];
//    [_checkArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!isChecked]];
//
//    for (NSNumber *boolNum in _checkArray) {
//        if (boolNum.boolValue == NO) {
//            [_allCheckBtn setSelected:NO];
//            return;
//        }
//    }
//
//    [_allCheckBtn setSelected:YES];
    _selectedModel = self.dataArray[indexPath.row];
    
    HPCollectListModel *model = self.dataArray[indexPath.row];
    
//    model.selected = !model.selected;//默认选一种，不可不选
//    self.selectedModel.selected = NO;
//    model.selected = YES;
//    self.selectedModel = model;
    
        if(self.selectedModel.spaceId != model.spaceId){//默认选一种，可不选
            //点击不同的spaceId，当原来的spaceId选中时，设置原来的不选中
            if(self.selectedModel.selected){
                self.selectedModel.selected = !self.selectedModel.selected;
            }
            model.selected = !model.selected;
            self.selectedModel = model;
        }else{
            model.selected = !model.selected;
            self.selectedModel = model;
        }
    
    _model = model;
    HPShareListCell *cell = (HPShareListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.model = model;
    //没有动画闪烁问题
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
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
    HPCollectListModel *model = self.dataArray[indexPath.row];
    for (int i = 0; i < self.industryModels.count; i++) {
        HPIndustryModel *industryModel = self.industryModels[i];
//        cell.industryModel = industryModel;
    }
    cell.model = model;
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
    
    [cell setCheckEnabled:_isEdited];
    
//    BOOL isChecked = ((NSNumber *)_checkArray[indexPath.row]).boolValue;
//    [cell setChecked:isChecked];
    
    return cell;
}

#pragma mark - CheckCell

- (void)setAllCellChecked:(BOOL)isChecked {
    for (HPShareListCell *cell in self.tableView.visibleCells) {
        [cell setChecked:isChecked];
    }
    
    for (int i = 0; i < _checkArray.count; i ++) {
        [_checkArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:isChecked]];
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
    if (btn.selected) {
        for (HPCollectListModel *model in self.dataArray) {
            model.selected = YES;
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
//            NSMutableArray *deleteRowIndexPaths = [[NSMutableArray alloc] init];
//            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            
//            for (int i = 0; i < weakSelf.checkArray.count; i ++) {
//                BOOL isChecked = ((NSNumber *)weakSelf.checkArray[i]).boolValue;
//                if (isChecked) {
//                    [deleteRowIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//                    [indexSet addIndex:i];
//                }
//            }
//
//            [weakSelf.checkArray removeObjectsAtIndexes:indexSet];
//            [weakSelf.dataArray removeObjectsAtIndexes:indexSet];
//            [weakSelf.tableView deleteRowsAtIndexPaths:deleteRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//            HPCollectListModel *model = self.dataArray[indexPath.row];
            NSMutableArray *spaceIds = [NSMutableArray array];

                for (HPCollectListModel *model in self.dataArray) {
                    if (model.selected) {
                        [spaceIds addObject:model.spaceId];
                    }
                }
            [HPHTTPSever HPPostServerWithMethod:@"/v1/collection/cancelCollections" paraments:@{@"spaceIds":spaceIds} needToken:YES complete:^(id  _Nonnull responseObject) {
                if (CODE == 200) {
                    [HPProgressHUD alertMessage:MSG];
                    [self getCollectionsListData];
                }else{
                    [HPProgressHUD alertMessage:MSG];
                }
            } Failure:^(NSError * _Nonnull error) {
                ErrorNet
            }];
            
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.allCheckBtn setSelected:NO];
            }
        }];
        
        _textDialogView = textDialogView;
    }
    
    [_textDialogView show:YES];
}

@end
