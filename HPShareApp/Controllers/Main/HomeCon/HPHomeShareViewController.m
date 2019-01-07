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
#define slideRatio fabs(y/71.0f)

typedef NS_ENUM(NSInteger, HPDisplaycellIndexpath) {
    HPDisplaycellIndexpathMenu = 50
};

@interface HPHomeShareViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) HPMenuOpenStoreView *openView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HPShareListModel *model;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *appNameLabel;
/**
 每次请求的页码数，自增长
 */
@property (nonatomic, copy) NSString *page;

@property (nonatomic, assign) BOOL isExpaned;

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
static NSString *gamesItemCell = @"gamesItemCell";
static NSString *hotShareStoreCell = @"hotShareStoreCell";
static NSString *shareListCell = @"shareListCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    _dataArray = [NSMutableArray array];
    [self getShareListData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    CGPoint cityPoint = [self.view convertPoint:self.openView.cityBtn.center fromView:self.openView];
//    CGPoint searchPoint = self.headerView.center;
//    CGFloat deltaY = (searchPoint.y - cityPoint.y)/g_rateWidth;
//    HPLog(@"deltaY : %f", deltaY);
}

#pragma mark - 共享发布数据

- (void)getShareListData {
    NSString *areaId = nil;
    NSString *districtId = nil; //街道筛选，属于区下面的
    NSString *industryId = nil; //行业筛选，一级行业
    NSString *subIndustryId = nil; //行业筛选，二级行业
    NSString *page = @"0";
    _page = page;
    NSString *pageSize = @"20";
    NSString *createTimeOrderType = @"0"; //发布时间排序，1升序，0降序
    NSString *rentOrderType = @"0"; //租金排序排序，1升序，0降序
    NSString *type = nil; //类型筛选，1业主， 2创客
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    HPLoginModel *account = [HPUserTool account];
    param[@"areaId"] = areaId;
    param[@"districtId"] = districtId;
    param[@"industryId"] = industryId;
    param[@"subIndustryId"] = subIndustryId;
    param[@"page"] = _page;
    param[@"pageSize"] = pageSize;
    param[@"createTimeOrderType"] = createTimeOrderType;
    param[@"rentOrderType"] = rentOrderType;
    param[@"type"] = type;
    param[@"userId"] = account.userInfo.userId;
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:YES paraments:param complete:^(id  _Nonnull responseObject) {
        [self.dataArray removeAllObjects];
        weakSelf.dataArray = [HPShareListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if ([responseObject[@"data"][@"total"] integerValue] == 0 || weakSelf.dataArray.count == 0) {
            /*UIImage *image = ImageNamed(@"waiting");
            UIImageView *waitingView = [[UIImageView alloc] init];
            waitingView.image = image;
            [self.tableView addSubview:waitingView];
            [waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-70.f * g_rateWidth);
                make.size.mas_equalTo(CGSizeMake(343.f * g_rateWidth, 197.f * g_rateWidth));
                make.centerX.mas_equalTo(self.tableView);
            }];
            
            UILabel *waitingLabel = [[UILabel alloc] init];
            waitingLabel.text = @"共享发布孤单很久了，快去逛逛吧！";
            waitingLabel.font = [UIFont fontWithName:FONT_MEDIUM size:12];
            waitingLabel.textColor = COLOR_GRAY_BBBBBB;
            waitingLabel.textAlignment = NSTextAlignmentCenter;
            [self.tableView addSubview:waitingLabel];

            [waitingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.tableView);
                make.top.mas_equalTo(waitingView.mas_top).offset(158.f * g_rateWidth);
                make.width.mas_equalTo(kScreenWidth);
            }];*/
        }
        if ([weakSelf.dataArray count] < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.openView];
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self.view insertSubview:self.tableView aboveSubview:self.openView];
    [self.view addSubview:[self createHeaderView]];
    [self.headerView addSubview:self.searchBar];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        NSInteger page = [self.page integerValue];
        self.page = [NSString stringWithFormat:@"%ld",page ++];
        [self getShareListData];
    }];
    
    [self setUpSubviewsFrame];
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
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
//    self.headerView.backgroundColor = [UIColor redColor];
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
        
    }
    return _searchBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
//        return _dataArray.count;
        return 3;
    }
    return 1.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    switch (indexPath.section) {
        case 0:
            return [self setUpMenuCell:tableView];
            break;
        case 1:
            return [self setUpGamesCell:tableView];
            break;
        case 2:
            return [self setUpHotShareCell:tableView];
            break;
        case 3:
            return [self setUpShareListCell:tableView withIndexpath:indexPath];
            break;
        default:
            break;
    }
    return cell;
}

- (HPTopMenuItemCell *)setUpMenuCell:(UITableView *)tableView
{
    HPTopMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:topMenuItemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HPLoginModel *account = [HPUserTool account];
    
//    kWeakSelf(weakSlef);
    [cell setClickMenuItemBlock:^(NSInteger HPHomeShareMenuItem) {
        switch (HPHomeShareMenuItem) {
            case HPHome_page_store_sharing:
                if (!account.token) {
                    [HPProgressHUD alertMessage:@"请前往登录"];
                }else{
                    [self pushVCByClassName:@"HPShareShopListController"];
                }
                break;
            case HPHome_page_lobby_sharing:
                HPLog(@"HPHome_page_lobby_sharing");
                break;
            case HPHome_page_other_sharing:
                HPLog(@"HPHome_page_other_sharing");
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
                HPLog(@"HPGamesCellIndexNinePointNine");
                break;
            case HPGamesCellIndexpfrofessionalGoods:
                HPLog(@"HPGamesCellIndexpfrofessionalGoods");
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
    [cell setClickMoreBtnBlock:^{
        HPLog(@"MoreBtn");
    }];
    
    [cell setTapHotImageViewBlock:^(NSInteger tag) {
        switch (tag) {
            case HPStoresShareAreaIndexBaoan:
                HPLog(@"HPStoresShareAreaIndexBaoan");
                break;
            case HPStoresShareAreaIndexLonghua:
                HPLog(@"HPStoresShareAreaIndexLonghua");
                break;
            case HPStoresShareAreaIndexNanshan:
                HPLog(@"HPStoresShareAreaIndexNanshan");
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
    if (indexPath.section == 3) {
        HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:shareListCell];
//        HPShareListModel *model = _dataArray[indexPath.row];
//        cell.model = model;
        
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return getWidth(356.f);
            break;
        case 1:
            return getWidth(165.f);
            break;
        case 2:
            return getWidth(135.f);
        case 3:
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
    if (indexPath.section == 3) {
        HPLog(@"sharelist");
    }
}

#pragma mark - 取消下拉  允许上拉
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
            make.width.mas_equalTo(getWidth(225.f));
            make.height.mas_equalTo(getWidth(30.f));
            make.centerY.mas_equalTo(self.openView.cityBtn).offset(0.f);
            make.centerX.mas_equalTo(self.tableView);
        }];
    }
    
//    HPLog(@"yyyyy:%f",y);
}

@end
