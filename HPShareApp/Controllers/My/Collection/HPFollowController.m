//
//  HPFollowController.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPFollowController.h"
#import "HPFollowListCell.h"
#import "HPTextDialogView.h"
#import "HPFansListModel.h"

#define CELL_ID @"HPFollowListCell"

@interface HPFollowController () <UITableViewDelegate, UITableViewDataSource, HPFollowListCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, assign) int                        count;
@property (nonatomic, strong) UIImageView *waitingView;
@property (nonatomic, strong) UILabel *waitingLabel;
@end

@implementation HPFollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 1;

    // Do any additional setup after loading the view.
    NSArray *dataArray = @[@{@"userName":@"刘晓玉", @"company":@"深圳市斯蒂格环保设备有限公司", @"portrait":[UIImage imageNamed:@"shared_shop_details_head_portrait"]},
                           @{@"userName":@"董晓丽", @"company":@"深圳市瑞鹏宠物医疗集团股份有限公司xxxxxxxxxxx", @"portrait":[UIImage imageNamed:@"personal_center_login_head"]},
                           @{@"userName":@"周XX", @"company":@"深圳市前海合派科技有限公司", @"portrait":[UIImage imageNamed:@"customizing_business_cards_entrepreneur's_head_portrait"]},
                           @{@"userName":@"王彤彤", @"company":@"广州区势时代品牌咨询管理有限...", @"portrait":[UIImage imageNamed:@"customizing_business_cards_owner's_head_portrait"]},
                           @{@"userName":@"刘晓玉", @"company":@"深圳市斯蒂格环保设备有限公司", @"portrait":[UIImage imageNamed:@"shared_shop_details_head_portrait"]},
                           @{@"userName":@"董晓丽", @"company":@"深圳市瑞鹏宠物医疗集团股份有...", @"portrait":[UIImage imageNamed:@"personal_center_login_head"]},
                           @{@"userName":@"周XX", @"company":@"深圳市前海合派科技有限公司", @"portrait":[UIImage imageNamed:@"customizing_business_cards_entrepreneur's_head_portrait"]},
                           @{@"userName":@"王彤彤", @"company":@"广州区势时代品牌咨询管理有限...", @"portrait":[UIImage imageNamed:@"customizing_business_cards_owner's_head_portrait"]},
                           @{@"userName":@"刘晓玉", @"company":@"深圳市斯蒂格环保设备有限公司", @"portrait":[UIImage imageNamed:@"shared_shop_details_head_portrait"]},
                           @{@"userName":@"董晓丽", @"company":@"深圳市瑞鹏宠物医疗集团股份有...", @"portrait":[UIImage imageNamed:@"personal_center_login_head"]},
                           @{@"userName":@"周XX", @"company":@"深圳市前海合派科技有限公司", @"portrait":[UIImage imageNamed:@"customizing_business_cards_entrepreneur's_head_portrait"]},
                           @{@"userName":@"王彤彤", @"company":@"广州区势时代品牌咨询管理有限...", @"portrait":[UIImage imageNamed:@"customizing_business_cards_owner's_head_portrait"]}];
    
//    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadtableViewFreshUi];
}
#pragma mark - 上下啦刷新控件
- (void)loadtableViewFreshUi
{
    [self getFansListData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.count = 1;
        [self getFansListData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.count++;
        [self getFansListData];
    }];
}
#pragma mark - 获取关注数据
- (void)getFansListData
{
    HPLoginModel *model = [HPUserTool account];
    NSDictionary *userdic = (NSDictionary *)model.userInfo;
    NSString *userId = userdic[@"userId"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"page"] = [NSString stringWithFormat:@"%d",self.count];
    dic[@"pageSize"] = @"10";
    dic[@"userId"] = userId;
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/fans/list" paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.dataArray removeAllObjects];
            weakSelf.dataArray = [HPFansListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
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
                waitingLabel.text = @"您还没有添加关注哦～";
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
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"关注"];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPFollowListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    HPFansListModel *model = _dataArray[indexPath.row];
//    NSString *userName = dict[@"userName"];
//    NSString *company = dict[@"company"];
//    UIImage *portrait = dict[@"portrait"];
//
//    [cell setUserName:userName];
//    [cell setCompany:company];
//    [cell setPortrait:portrait];
    cell.model = model;
    [cell setDelegate:self];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - HPFollowListCellDelegate

- (void)followListCell:(HPFollowListCell *)cell didClickFollowBtn:(UIButton *)btn {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setText:@"确定取消关注此人？"];
        [textDialogView setModalTop:279.f * g_rateHeight];
        _textDialogView = textDialogView;
    }
    
    [_textDialogView setConfirmCallback:^{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSLog(@"indexPath: %ld", (long)indexPath.row);
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [_textDialogView show:YES];
}

@end
