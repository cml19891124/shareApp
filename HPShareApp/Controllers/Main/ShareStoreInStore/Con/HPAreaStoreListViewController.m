//
//  HPAreaStoreListViewController.m
//  HPShareApp
//
//  Created by HP on 2019/1/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAreaStoreListViewController.h"
#import "HPShareListParam.h"
#import "HPShareListCell.h"

@interface HPAreaStoreListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@end

@implementation HPAreaStoreListViewController

static NSString *shareListCell = @"shareListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBarWithTitle:@"热门共享店铺"];
    
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];

    [self.view addSubview:self.headImageView];
    
    [self.view addSubview:self.tableView];
    
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
    if (self.isPop) {
        self.isPop = NO;
    }
    else {
        [self getShareListDataReload:YES];
    }
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.image = ImageNamed(@"hot_shop_background");
    }
    return _headImageView;
}

#pragma mark - 初始化控件
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
        _tableView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.001];;
        
        [_tableView registerClass:HPShareListCell.class forCellReuseIdentifier:shareListCell];
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
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
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(getWidth(g_statusBarHeight + 44.f));
        make.height.mas_equalTo(getWidth(110.f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(g_statusBarHeight + 44.f + getWidth(151.f));
        make.bottom.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:shareListCell];
    [self setUpShareListCell:tableView withIndexpath:indexPath];

    return cell;
}

#pragma mark - 共享店铺列表
- (HPShareListCell *)setUpShareListCell:(UITableView *)tableView withIndexpath:(NSIndexPath *)indexPath
{
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:shareListCell forIndexPath:indexPath];
    HPShareListModel *model = _dataArray[indexPath.row];
    cell.model = model;
    cell.backgroundColor = UIColor.whiteColor;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return getWidth(132.f);
            break;
        case 1:
            return getWidth(208.f);
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
    if (indexPath.section == 3) {
        HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [self pushVCByClassName:@"HPShareDetailController" withParam:@{@"model":cell.model}];
        }
    }
}
@end
