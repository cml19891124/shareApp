//
//  HPBaseShareListController.m
//  HPShareApp
//
//  Created by HP on 2018/11/30.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseShareListController.h"
#import "HPHTTPSever.h"
#import "HPShareListCell.h"
#import "HPSortSelectModalView.h"
#import "HPLinkageTopModalView.h"
#import "HPCommonData.h"
#import "HPRightImageButton.h"
#import "YYLRefreshNoDataView.h"
#import "HPReleaseModalView.h"

typedef NS_ENUM(NSInteger, HPFilterBtn) {
    HPFilterBtnSort = 0, //全部
    HPFilterBtnTrade,    //行业
    HPFilterBtnArea,     //区域
    HPFilterBtnTime,     //最新
    HPFilterBtnPrice     //价格
};

@interface HPBaseShareListController () <HPSortSelectModalViewDelegate, HPLinkageViewDelegate, YYLRefreshNoDataViewDelegate>

@property (nonatomic, strong) UIView *filterBar;

@property (nonatomic, weak) HPRightImageButton *sortBtn;

@property (nonatomic, weak) HPRightImageButton *tradeBtn;

@property (nonatomic, weak) HPRightImageButton *areaBtn;

@property (nonatomic, weak) HPSortSelectModalView *sortSelectView;

@property (nonatomic, strong) NSArray *sorts;

@property (nonatomic, weak) HPLinkageTopModalView *tradeLinkageView;

@property (nonatomic, weak) HPLinkageTopModalView *areaLinkageView;

@property (nonatomic, weak) HPReleaseModalView *releaseModalView;

@end

@implementation HPBaseShareListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] init];
    _shareListParam = [HPShareListParam new];
    [_shareListParam setCreateTimeOrderType:@"0"];
    _sorts = @[@"全部", @"店主", @"租客"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isPop) {
        [self loadTableViewFreshUI];
    }
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

- (UIView *)setupFilterBar {
    UIView *filterBar = [[UIView alloc] init];
    _filterBar = filterBar;
    [filterBar.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [filterBar.layer setShadowOpacity:0.1f];
    [filterBar.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [filterBar setBackgroundColor:UIColor.whiteColor];
    
    HPRightImageButton *sortBtn = [[HPRightImageButton alloc] init];
    [sortBtn setTag:HPFilterBtnSort];
    [sortBtn setSpace:5.f];
    [sortBtn setAlignMode:HPRightImageBtnAlignModeCenter];
    [sortBtn setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [sortBtn setText:@"全部"];
    [sortBtn setColor:COLOR_BLACK_666666];
    [sortBtn setSelectedColor:COLOR_RED_FF3455];
    [sortBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"]];
    [sortBtn setSelectedImage:[UIImage imageNamed:@"inverted_triangle_selected"]];
    [sortBtn addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [filterBar addSubview:sortBtn];
    _sortBtn = sortBtn;
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
    
    HPRightImageButton *tradeBtn = [[HPRightImageButton alloc] init];
    [tradeBtn setTag:HPFilterBtnTrade];
    [tradeBtn setSpace:5.f];
    [tradeBtn setAlignMode:HPRightImageBtnAlignModeCenter];
    [tradeBtn setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [tradeBtn setText:@"行业"];
    [tradeBtn setColor:COLOR_BLACK_666666];
    [tradeBtn setSelectedColor:COLOR_RED_FF3455];
    [tradeBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"]];
    [tradeBtn setSelectedImage:[UIImage imageNamed:@"inverted_triangle_selected"]];
    [tradeBtn addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:tradeBtn];
    _tradeBtn = tradeBtn;
    [tradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView);
        make.top.and.bottom.equalTo(rightView);
        make.width.equalTo(rightView).multipliedBy(0.25);
    }];
    
    HPRightImageButton *areaBtn = [[HPRightImageButton alloc] init];
    [areaBtn setTag:HPFilterBtnArea];
    [areaBtn setSpace:5.f];
    [areaBtn setAlignMode:HPRightImageBtnAlignModeCenter];
    [areaBtn setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [areaBtn setText:@"区域"];
    [areaBtn setColor:COLOR_BLACK_666666];
    [areaBtn setSelectedColor:COLOR_RED_FF3455];
    [areaBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"]];
    [areaBtn setSelectedImage:[UIImage imageNamed:@"inverted_triangle_selected"]];
    [areaBtn addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:areaBtn];
    _areaBtn = areaBtn;
    [areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tradeBtn.mas_right);
        make.top.and.bottom.equalTo(rightView);
        make.width.equalTo(rightView).multipliedBy(0.25);
    }];
    
    HPRightImageButton *timeBtn = [[HPRightImageButton alloc] init];
    [timeBtn setTag:HPFilterBtnTime];
    [timeBtn setSpace:5.f];
    [timeBtn setAlignMode:HPRightImageBtnAlignModeCenter];
    [timeBtn setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [timeBtn setText:@"最新"];
    [timeBtn setColor:COLOR_BLACK_666666];
    [timeBtn setSelectedColor:COLOR_RED_FF3455];
    [timeBtn setImage:[UIImage imageNamed:@"inverted_triangle_normal"]];
    [timeBtn setSelectedImage:[UIImage imageNamed:@"inverted_triangle_selected"]];
    [timeBtn addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaBtn.mas_right);
        make.top.and.bottom.equalTo(rightView);
        make.width.equalTo(rightView).multipliedBy(0.25);
    }];
    [timeBtn setSelected:YES];
    
    HPRightImageButton *priceBtn = [[HPRightImageButton alloc] init];
    [priceBtn setTag:HPFilterBtnPrice];
    [priceBtn setSpace:5.f];
    [priceBtn setAlignMode:HPRightImageBtnAlignModeCenter];
    [priceBtn setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [priceBtn setText:@"价格"];
    [priceBtn setColor:COLOR_BLACK_666666];
    [priceBtn setSelectedColor:COLOR_RED_FF3455];
    [priceBtn setImage:[UIImage imageNamed:@"sort_icon_up"]];
    [priceBtn setSelectedImage:[UIImage imageNamed:@"sort_icon_down"]];
    [priceBtn addTarget:self action:@selector(onClickFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:priceBtn];
    [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeBtn.mas_right);
        make.top.and.bottom.equalTo(rightView);
        make.width.equalTo(rightView).multipliedBy(0.25);
    }];
    
    return filterBar;
}

#pragma mark - OnClick

- (void)onClickFilterBtn:(HPRightImageButton *)btn {
    if (btn.isSelected) {
        [btn setSelected:NO];
    }
    else {
        [btn setSelected:YES];
    }
    
    kWeakSelf(weakSelf);
    if (btn.tag == HPFilterBtnSort) {
        if (_sortSelectView == nil) {
            HPSortSelectModalView *sortSelectView = [[HPSortSelectModalView alloc] initWithOptions:_sorts];
            [sortSelectView setDelegate:self];
            [sortSelectView setModalShowCallBack:^(BOOL isShow) {
                [btn setSelected:isShow];
                
                if (weakSelf.tradeLinkageView && isShow) {
                    [weakSelf.tradeLinkageView show:NO];
                }
                
                if (weakSelf.areaLinkageView && isShow) {
                    [weakSelf.areaLinkageView show:NO];
                }
            }];
            [sortSelectView selectCellAtIndex:0];
            [self.view addSubview:sortSelectView];
            [sortSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.width.and.bottom.equalTo(self.view);
                make.top.equalTo(self.filterBar.mas_bottom).with.offset(1.f);
            }];
            _sortSelectView = sortSelectView;
        }
        
        [_sortSelectView show:btn.isSelected];
    }
    else if (btn.tag == HPFilterBtnTrade) {
        if (_tradeLinkageView == nil) {
            NSArray *models = [HPCommonData getIndustryData];
            HPLinkageData *linkageData = [[HPLinkageData alloc] initWithModels:models];
            [linkageData setParentNameKey:@"industryName"];
            [linkageData setChildNameKey:@"industryName"];
            [linkageData addChildrenAllModelWithParentIdKey:@"industryId" childParentIdKey:@"pid"];
            [linkageData addParentAllModel];
            HPLinkageTopModalView *linkageView = [[HPLinkageTopModalView alloc] initWithData:linkageData];
            [linkageView setDelegate:self];
            [linkageView setModalShowCallBack:^(BOOL isShow) {
                [btn setSelected:isShow];
                
                if (weakSelf.sortSelectView && isShow) {
                    [weakSelf.sortSelectView show:NO];
                }
                
                if (weakSelf.areaLinkageView && isShow) {
                    [weakSelf.areaLinkageView show:NO];
                }
            }];
            [linkageView selectCellAtParentIndex:0 childIndex:0];
            [self.view addSubview:linkageView];
            [linkageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.width.and.bottom.equalTo(self.view);
                make.top.equalTo(self.filterBar.mas_bottom).with.offset(1.f);
            }];
            _tradeLinkageView = linkageView;
        }
        
        [_tradeLinkageView show:btn.isSelected];
    }
    else if (btn.tag == HPFilterBtnArea) {
        if (_areaLinkageView == nil) {
            NSArray *models = [HPCommonData getAreaData];
            HPLinkageData *linkageData = [[HPLinkageData alloc] initWithModels:models];
            [linkageData setParentNameKey:@"name"];
            [linkageData setChildNameKey:@"name"];
            [linkageData addChildrenAllModelWithParentIdKey:@"areaId" childParentIdKey:@"areaId"];
            [linkageData addParentAllModel];
            HPLinkageTopModalView *linkageView = [[HPLinkageTopModalView alloc] initWithData:linkageData];
            [linkageView setDelegate:self];
            [linkageView setModalShowCallBack:^(BOOL isShow) {
                [btn setSelected:isShow];
                
                if (weakSelf.tradeLinkageView && isShow) {
                    [weakSelf.tradeLinkageView show:NO];
                }
                
                if (weakSelf.sortSelectView && isShow) {
                    [weakSelf.sortSelectView show:NO];
                }
            }];
            [linkageView selectCellAtParentIndex:0 childIndex:0];
            [self.view addSubview:linkageView];
            [linkageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.width.and.bottom.equalTo(self.view);
                make.top.equalTo(self.filterBar.mas_bottom).with.offset(1.f);
            }];
            _areaLinkageView = linkageView;
        }
        
        [_areaLinkageView show:btn.isSelected];
    }
    else if (btn.tag == HPFilterBtnPrice) {
        if (weakSelf.sortSelectView) {
            [weakSelf.sortSelectView show:NO];
        }
        
        if (weakSelf.tradeLinkageView) {
            [weakSelf.tradeLinkageView show:NO];
        }
        
        if (weakSelf.areaLinkageView) {
            [weakSelf.areaLinkageView show:NO];
        }
        
        NSString *rentOrderType = btn.isSelected ? @"1" : @"0";
        [_shareListParam setRentOrderType:rentOrderType];
        [_tableView.mj_header beginRefreshing];
    }
    else if (btn.tag == HPFilterBtnTime) {
        if (weakSelf.sortSelectView) {
            [weakSelf.sortSelectView show:NO];
        }
        
        if (weakSelf.tradeLinkageView) {
            [weakSelf.tradeLinkageView show:NO];
        }
        
        if (weakSelf.areaLinkageView) {
            [weakSelf.areaLinkageView show:NO];
        }
        
        NSString *timeOrderType = btn.isSelected ? @"0" : @"1";
        [_shareListParam setCreateTimeOrderType:timeOrderType];
        [_tableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        if (cell.model) {
//            NSString *spaceId = cell.model.spaceId;
            [self pushVCByClassName:@"HPShareDetailController" withParam:@{@"model":cell.model}];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f * g_rateWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return getWidth(20.f);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    HPShareListModel *model = _dataArray[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

#pragma mark - HPSortSelectViewDelegate

- (void)sortSelectView:(HPSortSelectModalView *)sortSelectView didSelectAtIndex:(NSInteger)index {
    [sortSelectView show:NO];
    NSString *type;
    
    switch (index) {
        case 0:
            type = nil;
            break;
        case 1:
            type = @"1";
            break;
        case 2:
            type = @"2";
            break;
            
        default:
            break;
    }
    
    [_sortBtn setSelected:NO];
    [_sortBtn setText:_sorts[index]];
    [_shareListParam setType:type];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - HPLinkageViewDelegate

- (void)linkageView:(HPLinkageView *)linkageView didSelectParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex withChildModel:(NSObject *)model {
    if (!model) {
        return;
    }
    
    if ([model isKindOfClass:HPIndustryModel.class]) {
        HPIndustryModel *industryModel = (HPIndustryModel *)model;
        NSString *tradeName = industryModel.industryName;
        NSString *industryId = industryModel.pid;
        NSString *subIndustryId = industryModel.industryId;
        [_tradeLinkageView show:NO];
        [_tradeBtn setSelected:NO];
        if (industryId && !subIndustryId) {
            tradeName = [HPCommonData getIndustryNameById:industryId];
        }
        [_tradeBtn setText:tradeName];
        [_shareListParam setIndustryId:industryId];
        [_shareListParam setSubIndustryId:subIndustryId];
        [self.tableView.mj_header beginRefreshing];
    }
    else if ([model isKindOfClass:HPDistrictModel.class]) {
        HPDistrictModel *districtModel = (HPDistrictModel *)model;
        NSString *name = districtModel.name;
        NSString *areaId = districtModel.areaId;
        NSString *districtId = districtModel.districtId;
        [_areaLinkageView show:NO];
        [_areaBtn setSelected:NO];
        [_areaBtn setText:name];
        [_shareListParam setAreaId:areaId];
        if (![name isEqualToString:@"不限"]) {
            [_shareListParam setDistrictId:districtId];
        }
        else {
            name = [HPCommonData getAreaNameById:areaId];
            [_areaBtn setText:name];
        }
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - NetWork

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload {
    NSMutableDictionary *dict = param.mj_keyValues;
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:NO paraments:dict complete:^(id  _Nonnull responseObject) {
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
            [HPProgressHUD alertMessage:@"暂无数据"];
//            self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
//            self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"list_default_page");
//            self.tableView.refreshNoDataView.tipLabel.text = @"店铺共享，你是第一个吃螃蟹的人！！";
//            [self.tableView.refreshNoDataView.tipBtn setTitle:@"立即发布" forState:UIControlStateNormal];
//            self.tableView.refreshNoDataView.delegate = self;
        }
//        else {
//            self.tableView.loadErrorType = YYLLoadErrorTypeDefalt;
//        }
        
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

- (void)onClickCancelBtn:(UIButton *)btn {
    if (_releaseModalView) {
        [_releaseModalView show:NO];
    }
}

@end
