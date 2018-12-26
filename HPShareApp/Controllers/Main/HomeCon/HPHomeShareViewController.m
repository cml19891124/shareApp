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
#define slideRatio fabs(y/100)
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
    _dataArray = [NSMutableArray array];
    [self getShareListData];
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
            UIImage *image = ImageNamed(@"waiting");
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
            }];
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
    [self.openView addSubview:self.appNameLabel];
    [self.view setBackgroundColor:COLOR_GRAY_F6F6F6];
    
    [self.view addSubview:self.tableView];
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
        make.height.mas_equalTo(getWidth(152.f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.openView.mas_bottom);
        make.bottom.mas_equalTo(getWidth(-g_bottomSafeAreaHeight - 49));
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(g_statusBarHeight + getWidth(18.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(self.appNameLabel.font.pointSize);
    }];
}

- (UILabel *)appNameLabel
{
    if (!_appNameLabel) {
        _appNameLabel = [UILabel new];
        _appNameLabel.text = @"合店站";
        _appNameLabel.textColor = COLOR_GRAY_FFFFFF;
        _appNameLabel.font = kFont_Medium(20.f);
        _appNameLabel.textAlignment = NSTextAlignmentLeft;
        _appNameLabel.hidden = YES;
    }
    return _appNameLabel;
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCell];
        [_tableView registerClass:HPTopMenuItemCell.class forCellReuseIdentifier:topMenuItemCell];
        [_tableView registerClass:HPGamesCell.class forCellReuseIdentifier:gamesItemCell];
        [_tableView registerClass:HPHotShareStoreCell.class forCellReuseIdentifier:hotShareStoreCell];
        [_tableView registerClass:HPShareListCell.class forCellReuseIdentifier:shareListCell];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
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
//    kWeakSelf(weakSlef);
    [cell setClickMenuItemBlock:^(NSInteger HPHomeShareMenuItem) {
        switch (HPHomeShareMenuItem) {
            case HPHome_page_store_sharing:
                HPLog(@"HPHome_page_store_sharing");
                break;
            case HPHome_page_lobby_sharing:
                HPLog(@"HPHome_page_lobby_sharing");
                break;
            case HPHome_page_other_sharing:
                HPLog(@"HPHome_page_other_sharing");
                break;
            case HPHome_page_map:
                HPLog(@"HPHome_page_map");
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
    
//    if (offset.y < -g_statusBarHeight) {
//        offset.y = -g_statusBarHeight;
//        scrollView.contentOffset = offset;
//    }
    
    if(offset.y > 0){
        [self updateSearchViewWithMaonryOffset:offset.y];

    }else{
        [self updateSearchViewWithMaonryOffset:offset.y];

    }
}

- (void)updateSearchViewWithMaonryOffset:(CGFloat)y{
    self.openView.sloganImageView.alpha -= y/10000.00;
    HPLog(@"ffff:%f",self.openView.sloganImageView.alpha);
    if (self.openView.sloganImageView.alpha <= 0) {
        self.openView.sloganImageView.alpha = 0;
        self.openView.sloganImageView.hidden = YES;
        self.appNameLabel.hidden = NO;
    }else if(self.openView.sloganImageView.alpha >= 1){
        self.openView.sloganImageView.hidden = NO;
        self.appNameLabel.hidden = YES;
    }
    
    /*
    if (y > 0) {
        [self.openView.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.openView).offset(getWidth(-26.f)* fabs(y/200));
            make.centerY.mas_equalTo(self.openView);
            make.height.mas_equalTo(getWidth(30.f)* fabs(y/200));
            make.left.mas_equalTo(self.openView.cityBtn.mas_right).offset(getWidth(22.f)* fabs(y/200));
        }];
    }else {
        [self.openView.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(getWidth(325.f)* fabs(y/200), getWidth(40.f)* fabs(y/200)));
            make.top.mas_equalTo(self.openView).offset(getWidth(95.f) * fabs(y/200));
            make.centerX.mas_equalTo(self.openView);
        }];
    }*/
    static BOOL isMove; //默认是NO
    if (isMove) {
        isMove = NO;
        // 注意需要先执行一次更新约束
        [self.openView layoutIfNeeded];
        //添加动画
        [UIView animateWithDuration:0.5 animations:^{
           
            [self.openView.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
                //更改距顶上的高度
//                make.right.mas_equalTo(self.openView).offset(getWidth(-26.f)* slideRatio);
//                make.centerY.mas_equalTo(self.openView);
//                make.height.mas_equalTo(getWidth(30.f)* slideRatio);
//            make.left.mas_equalTo(self.openView.cityBtn.mas_right).offset(getWidth(22.f)* slideRatio);
                make.centerY.mas_equalTo(self.openView);
                make.size.mas_equalTo(CGSizeMake(getWidth(225.f)* slideRatio, getWidth(30.f)* slideRatio));
                make.right.mas_equalTo(getWidth(-26.f)* slideRatio);
                
                //最小值
                make.width.greaterThanOrEqualTo(@(getWidth(225.f)* slideRatio));
                make.height.greaterThanOrEqualTo(@(getWidth(30.f)* slideRatio));

                //最大值
                make.width.lessThanOrEqualTo(@(getWidth(325.f)* slideRatio));
                make.height.lessThanOrEqualTo(@(getWidth(40.f)* slideRatio));
                }];
            
 //必须调用此方法，才能出动画效果
            [self.openView.searchView layoutIfNeeded];
            [self.openView layoutIfNeeded];
        }];
    }else{
        isMove = YES;
        [self.openView layoutIfNeeded];
        //开始动画
        [UIView beginAnimations:nil context:nil];
       //设定动画持续时间
        [UIView setAnimationDuration:1];
        [self.openView.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
            //动画的内容,更改距顶上的高度
            make.size.mas_equalTo(CGSizeMake(getWidth(325.f)* slideRatio, getWidth(40.f)* slideRatio));
            make.top.mas_equalTo(self.openView).offset(getWidth(95.f) * slideRatio);
            make.centerX.mas_equalTo(self.openView);
            }];
        
        //必须调用此方法，才能出动画效果
        [self.openView.searchView layoutIfNeeded];
        [self.openView layoutIfNeeded];

        //动画结束
        [UIView commitAnimations];
        
     }
}
@end
