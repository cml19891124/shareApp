//
//  HPHomeShareViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHomeShareViewController.h"
#import "HPTopMenuItemCell.h"
#import "HPMenuOpenStoreView.h"
#import "HPGamesCell.h"
#import "HPHotShareStoreCell.h"
#import "HPShareListCell.h"
#import "HPSearchBar.h"
#import "HPShareListParam.h"
#import "HPCommonData.h"
#import "HPHomeBannerModel.h"
#import "HPMenuItemCell.h"

#define slideRatio fabs(y/71.0f)

typedef NS_ENUM(NSInteger, HPDisplaycellIndexpath) {
    HPDisplaycellIndexpathMenu = 50
};

@interface HPHomeShareViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HPSearchBarDelegate>

@property (nonatomic, strong) HPMenuOpenStoreView *openView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *appNameLabel;

@property (nonatomic, assign) BOOL isExpaned;

@property (strong, nonatomic) NSMutableArray *bannerImageArr;

/**
 searchBar 所属父视图
 */
@property (nonatomic, strong) UIView *headerView;
/**
 搜索栏
 */
@property (nonatomic, strong) HPSearchBar *searchBar;

@end

@implementation HPHomeShareViewController
static NSString *defaultCell = @"defaultCell";
static NSString *topMenuItemCell = @"topMenuItemCell";
static NSString *menuItemCell = @"menuItemCell";
static NSString *gamesItemCell = @"gamesItemCell";
static NSString *hotShareStoreCell = @"hotShareStoreCell";
static NSString *shareListCell = @"shareListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.openView];
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self.view insertSubview:self.tableView aboveSubview:self.openView];
    [self.view addSubview:[self createHeaderView]];
    [self.headerView addSubview:self.searchBar];
    
    _dataArray = [NSMutableArray array];
    
    _shareListParam = [HPShareListParam new];
    _shareListParam.pageSize = 10;
    _shareListParam.page = 1;
    _shareListParam.createTimeOrderType = @"0";
    
    _shareListParam.areaIds = [NSString stringWithFormat:@"9,7,1"]; //宝安，龙华，南山
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getShareListDataReload:NO];
    }];
    
    [self setUpSubviewsFrame];
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.bannerImageArr = [NSMutableArray array];
    if (self.isPop) {
        self.isPop = NO;
    }
    else {
        [self getShareListDataReload:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    CGPoint cityPoint = [self.view convertPoint:self.openView.cityBtn.center fromView:self.openView];
//    CGPoint searchPoint = self.headerView.center;
//    CGFloat deltaY = (searchPoint.y - cityPoint.y)/g_rateWidth;
//    HPLog(@"deltaY : %f", deltaY);
}

#pragma mark - 共享发布数据

- (void)getShareListDataReload:(BOOL)isReload {
    
    if (isReload) {
        _shareListParam.page = 1;
    }
    
    NSMutableDictionary *param = _shareListParam.mj_keyValues;
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:NO paraments:param complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (models) {
                if (isReload) {
                    [weakSelf.dataArray removeAllObjects];
                }
                
                [weakSelf.dataArray addObjectsFromArray:models];
            }
            
            if ([responseObject[@"data"][@"total"] integerValue] == 0 || weakSelf.dataArray.count == 0) {
                [HPProgressHUD alertMessage:@"暂无发布数据"];
            }
            
            if (models.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.shareListParam.page ++;
            }
            
            [weakSelf.tableView reloadData];
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
        
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setUpSubviewsFrame
{
    [self.openView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(g_statusBarHeight + getWidth(95.f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(g_statusBarHeight +44.f);
        make.bottom.mas_equalTo(getWidth(-g_bottomSafeAreaHeight - 49));
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(325.f), getWidth(40.f)));
        make.centerY.mas_equalTo(self.openView.mas_bottom);
        make.centerX.mas_equalTo(self.tableView);
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.headerView);
    }];
}

-(UIView *)createHeaderView {
    self.headerView = [[UIView alloc] init];
    return  self.headerView;
    
}

- (HPMenuOpenStoreView *)openView
{
    if (!_openView) {
        _openView = [HPMenuOpenStoreView new];
        _openView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _openView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
        _tableView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.001];;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCell];
        [_tableView registerClass:HPTopMenuItemCell.class forCellReuseIdentifier:topMenuItemCell];
        [_tableView registerClass:HPMenuItemCell.class forCellReuseIdentifier:menuItemCell];
        [_tableView registerClass:HPGamesCell.class forCellReuseIdentifier:gamesItemCell];
        [_tableView registerClass:HPHotShareStoreCell.class forCellReuseIdentifier:hotShareStoreCell];
        [_tableView registerClass:HPShareListCell.class forCellReuseIdentifier:shareListCell];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(getWidth(71.f), 0, 0, 0);
        [_tableView setContentOffset:CGPointMake(0, getWidth(-71.f)) animated:YES];
    }
    return _tableView;
}

- (UIView *)searchBar
{
    if (!_searchBar) {
        _searchBar = [HPSearchBar new];
        _searchBar.layer.cornerRadius = 3.f;
        _searchBar.layer.shadowColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.08].CGColor;
        _searchBar.layer.shadowOpacity = 1.f;
        _searchBar.layer.shadowOffset = CGSizeMake(0, 2);
        _searchBar.layer.shadowRadius = 17;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        return _dataArray.count;
    }
    return 1.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    switch (indexPath.section) {
        case 0:
            return [self setUpBannerCell:tableView];
            break;
        case 1:
            return [self setUpMenuCell:tableView];
            break;
        case 2:
            return [self setUpGamesCell:tableView];
            break;
        case 3:
            return [self setUpHotShareCell:tableView];
            break;
        case 4:
            return [self setUpShareListCell:tableView withIndexpath:indexPath];
            break;
        default:
            break;
    }
    return cell;
}

- (HPTopMenuItemCell *)setUpBannerCell:(UITableView *)tableView
{
    HPTopMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:topMenuItemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    kWEAKSELF
    //广告点击跳转block
    [cell setBannerClickTypeBlock:^(HPHomeBannerModel *model,NSInteger index) {
        if (model.linkType && [model.linkType isEqualToString:@"shopList"]) {
            [weakSelf pushVCByClassName:@"HPShareShopListController"];
        }else if (index && model.linkType && [model.linkType isEqualToString:@"article"]) {
            [weakSelf pushVCByClassName:@"HPIdeaController"];
        }else if (index && model.linkType && [model.linkType isEqualToString:@"playShare"]) {
            [weakSelf pushVCByClassName:@"HPGetherRentViewController"];
        }
        
    }];

    
    return cell;
}


- (HPMenuItemCell *)setUpMenuCell:(UITableView *)tableView
{
    HPMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:menuItemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    HPLoginModel *account = [HPUserTool account];

    //    kWeakSelf(weakSlef);
    [cell setClickMenuItemBlock:^(NSInteger HPHomeShareMenuItem,NSString *menuString) {
//        if (!account.token) {
//            [HPProgressHUD alertMessage:@"请前往登录"];
//            return ;
//        }
        switch (HPHomeShareMenuItem) {
            case HPHome_page_store_sharing:
                [self pushVCByClassName:@"HPShareShopListController" withParam:@{@"title":menuString}];

                break;
            case HPHome_page_lobby_sharing:
                HPLog(@"HPHome_page_lobby_sharing");
                [self pushVCByClassName:@"HPShareShopListController" withParam:@{@"title":menuString}];
                break;
            case HPHome_page_other_sharing:
                HPLog(@"HPHome_page_other_sharing");
                [self pushVCByClassName:@"HPShareShopListController" withParam:@{@"title":menuString}];

                break;
            case HPHome_page_map:
                HPLog(@"HPHome_page_map");
                [self pushVCByClassName:@"HPShareMapController"];
                
                break;
            case HPHome_page_stock_purchase:
                HPLog(@"HPHome_page_stock_purchase");
                break;
            case HPHome_page_shelf_rental:
                HPLog(@"HPHome_page_shelf_rental");
                break;
            case HPHome_page_used_shelves:
                HPLog(@"HPHome_page_used_shelves");
                break;
            case HPHome_page_new_store_opens:
                HPLog(@"HPHome_page_new_store_opens");
                break;
            default:
                break;
        }
    }];
    
    return cell;
    
}

#pragma mark - games活动专区
- (HPGamesCell *)setUpGamesCell:(UITableView *)tableView
{
    HPGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:gamesItemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTapClickImageViewBlcok:^(NSInteger tap) {
        switch (tap) {
            case HPGamesCellIndexNinePointNine:
//                HPLog(@"HPGamesCellIndexNinePointNine");
                [HPProgressHUD alertMessage:@"一大波活动正拼命赶来～"];
                break;
            case HPGamesCellIndexpfrofessionalGoods:
//                HPLog(@"HPGamesCellIndexpfrofessionalGoods");
                [HPProgressHUD alertMessage:@"一大波活动正拼命赶来～"];

                break;
            default:
                break;
        }
    }];
    return cell;
}
#pragma mark - 热门共享店铺
- (HPHotShareStoreCell *)setUpHotShareCell:(UITableView *)tableView
{
    HPHotShareStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:hotShareStoreCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    kWEAKSELF
    [cell setClickMoreBtnBlock:^{
//        HPLog(@"MoreBtn");
        weakSelf.shareListParam.areaIds = @"9,7,1";
        [self pushVCByClassName:@"HPAreaStoreListViewController" withParam:@{@"area": weakSelf.shareListParam}];
    }];
    
    [cell setTapHotImageViewBlock:^(NSInteger tag) {
        switch (tag) {
            case HPStoresShareAreaIndexBaoan:
                weakSelf.shareListParam.areaIds = @"9";
                [self pushVCByClassName:@"HPAreaStoreListViewController" withParam:@{@"area":weakSelf.shareListParam}];

                break;
            case HPStoresShareAreaIndexLonghua:
                weakSelf.shareListParam.areaIds = @"7";
                [self pushVCByClassName:@"HPAreaStoreListViewController" withParam:@{@"area":weakSelf.shareListParam}];

                break;
            case HPStoresShareAreaIndexNanshan:
                weakSelf.shareListParam.areaIds = @"1";
                [self pushVCByClassName:@"HPAreaStoreListViewController" withParam:@{@"area":weakSelf.shareListParam}];

                break;
            default:
                break;
        }
    }];
    return cell;
}

#pragma mark - 共享店铺列表
- (HPShareListCell *)setUpShareListCell:(UITableView *)tableView withIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:shareListCell forIndexPath:indexPath];
        HPShareListModel *model = _dataArray[indexPath.row];
        cell.model = model;
        cell.backgroundColor = UIColor.whiteColor;
        
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return getWidth(132.f);
            break;
        case 1:
            return getWidth(96.f);
            break;
        case 2:
            return getWidth(165.f);
            break;
        case 3:
            return getWidth(135.f);
        case 4:
            return getWidth(137.f);
        default:
            return CGFLOAT_MIN;
            break;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HPShareListModel *model = self.dataArray[indexPath.row];
    if (indexPath.section == 4) {
        HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [self pushVCByClassName:@"HPShareDetailController" withParam:@{@"model":model}];
        }
    }
}

#pragma mark - 上下拉 搜索栏的动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    [self updateSearchViewWithMaonryOffset:offset.y];
}

- (void)updateSearchViewWithMaonryOffset:(CGFloat)y{

    if (y > -71.f && y <= 0.f) {
        [self.openView.sloganImageView setAlpha:slideRatio];
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(getWidth(325.f) - (getWidth(325) - getWidth(225.f)) * (1 - slideRatio));
            make.height.mas_equalTo(getWidth(40.f) - (getWidth(40.f) - getWidth(30.f)) * (1 - slideRatio));
            make.centerY.mas_equalTo(self.openView.cityBtn).offset(getWidth(73.5f) * slideRatio);
            make.centerX.mas_equalTo(self.tableView);
        }];
    }
    else if (y <= -71.f) {
        [self.openView.sloganImageView setAlpha:1.f];
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(getWidth(325.f));
            make.height.mas_equalTo(getWidth(40.f));
            make.centerY.mas_equalTo(self.openView.cityBtn).offset(getWidth(73.5f));
            make.centerX.mas_equalTo(self.tableView);
        }];
    }
    else if (y > 0.f) {
        [self.openView.sloganImageView setAlpha:0.f];
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(getWidth(225.f));
            make.left.mas_equalTo(self.openView.cityBtn.mas_right).offset(getWidth(15.f));
            make.right.mas_equalTo(self.openView.mas_right).offset(getWidth(-30.f));
            make.height.mas_equalTo(getWidth(30.f));
            make.centerY.mas_equalTo(self.openView.cityBtn).offset(0.f);
//            make.centerX.mas_equalTo(self.tableView);
        }];
    }
    
}

#pragma mark - searchBar.delegate

- (void)clickTextfieldJumpToSearchResultVC
{
    [self pushVCByClassName:@"HPSearchResultViewController"];
}
@end
