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
#import "HPSortSelectView.h"
#import "HPLinkageView.h"
#import "HPCommonData.h"
#import "HPRightImageButton.h"

typedef NS_ENUM(NSInteger, HPFilterBtn) {
    HPFilterBtnSort = 0, //全部
    HPFilterBtnTrade,    //行业
    HPFilterBtnArea,     //区域
    HPFilterBtnTime,     //最新
    HPFilterBtnPrice     //价格
};

@interface HPBaseShareListController () <HPSortSelectViewDelegate, HPLinkageViewDelegate>

@property (nonatomic, strong) UIView *filterBar;

@property (nonatomic, weak) HPRightImageButton *sortBtn;

@property (nonatomic, weak) HPRightImageButton *tradeBtn;

@property (nonatomic, weak) HPRightImageButton *areaBtn;

@property (nonatomic, weak) HPSortSelectView *sortSelectView;

@property (nonatomic, strong) NSArray *sorts;

@property (nonatomic, weak) HPLinkageView *tradeLinkageView;

@property (nonatomic, weak) HPLinkageView *areaLinkageView;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    if (btn.tag == HPFilterBtnSort) {
        if (_sortSelectView == nil) {
            HPSortSelectView *sortSelectView = [[HPSortSelectView alloc] initWithOptions:_sorts];
            [sortSelectView setBackgroundColor:COLOR_GRAY_F8F8F8];
            [sortSelectView setDelegate:self];
            [_tableView addSubview:sortSelectView];
            [sortSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.width.equalTo(self.view);
                make.top.equalTo(self.filterBar.mas_bottom);
            }];
            _sortSelectView = sortSelectView;
        }
        
        [_sortSelectView setHidden:!btn.isSelected];
    }
    else if (btn.tag == HPFilterBtnTrade) {
        if (_tradeLinkageView == nil) {
            NSArray *models = [HPCommonData getIndustryData];
            HPLinkageData *linkageData = [[HPLinkageData alloc] initWithModels:models];
            [linkageData setParentNameKey:@"industryName"];
            [linkageData setChildNameKey:@"industryName"];
            HPLinkageView *linkageView = [[HPLinkageView alloc] initWithData:linkageData];
            [linkageView setDelegate:self];
            [_tableView addSubview:linkageView];
            [linkageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.width.equalTo(self.view);
                make.top.equalTo(self.filterBar.mas_bottom);
                make.height.mas_equalTo(getWidth(250.f));
            }];
            _tradeLinkageView = linkageView;
        }
        
        [_tradeLinkageView setHidden:!btn.isSelected];
    }
    else if (btn.tag == HPFilterBtnArea) {
        if (_areaLinkageView == nil) {
            NSArray *models = [HPCommonData getAreaData];
            HPLinkageData *linkageData = [[HPLinkageData alloc] initWithModels:models];
            [linkageData setParentNameKey:@"name"];
            [linkageData setChildNameKey:@"name"];
            HPLinkageView *linkageView = [[HPLinkageView alloc] initWithData:linkageData];
            [linkageView setDelegate:self];
            [_tableView addSubview:linkageView];
            [linkageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.width.equalTo(self.view);
                make.top.equalTo(self.filterBar.mas_bottom);
                make.height.mas_equalTo(getWidth(250.f));
            }];
            _areaLinkageView = linkageView;
        }
        
        [_areaLinkageView setHidden:!btn.isSelected];
    }
    else if (btn.tag == HPFilterBtnPrice) {
        NSString *rentOrderType = btn.isSelected ? @"1" : @"0";
        [_shareListParam setRentOrderType:rentOrderType];
        [_tableView.mj_header beginRefreshing];
    }
    else if (btn.tag == HPFilterBtnTime) {
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

- (void)sortSelectView:(HPSortSelectView *)sortSelectView didSelectAtIndex:(NSInteger)index {
    [sortSelectView setHidden:YES];
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
    if (linkageView == _tradeLinkageView) {
        HPIndustryModel *industryModel = (HPIndustryModel *)model;
        NSString *tradeName = industryModel.industryName;
        NSString *industryId = industryModel.industryId;
        [_tradeLinkageView setHidden:YES];
        [_tradeBtn setSelected:NO];
        [_tradeBtn setText:tradeName];
        [_shareListParam setIndustryId:industryId];
        [self.tableView.mj_header beginRefreshing];
    }
    else if (linkageView == _areaLinkageView) {
        HPDistrictModel *districtModel = (HPDistrictModel *)model;
        NSString *name = districtModel.name;
        NSString *areaId = districtModel.areaId;
        NSString *districtId = districtModel.districtId;
        [_areaLinkageView setHidden:YES];
        [_areaBtn setSelected:NO];
        [_areaBtn setText:name];
        [_shareListParam setAreaId:areaId];
        [_shareListParam setDistrictId:districtId];
        [self.tableView.mj_header beginRefreshing];
    }
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
