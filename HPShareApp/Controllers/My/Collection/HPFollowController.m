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
@property (strong, nonatomic) HPFansListModel *model;

@property (nonatomic, strong) HPFansListModel *selectedModel;
@property (nonatomic, strong) UIButton *forbtn;
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
    self.count = 1;
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
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
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
    [HPHTTPSever HPGETServerWithMethod:@"/v1/fans/list" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.dataArray removeAllObjects];
            weakSelf.dataArray = [HPFansListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if ([responseObject[@"data"][@"total"] integerValue] == 0 || weakSelf.dataArray.count == 0) {
//                [HPProgressHUD alertMessage:@"您还没有添加关注哦～"];
                UIImage *image = ImageNamed(@"empty_list");
                UIImageView *waitingView = [[UIImageView alloc] init];
                waitingView.image = image;
                [self.tableView addSubview:waitingView];
                self.waitingView = waitingView;
                [waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.size.mas_equalTo(CGSizeMake(153.f * g_rateWidth, 177.f * g_rateWidth));
                    make.center.mas_equalTo(self.tableView);
                }];
                
                
                UILabel *waitingLabel = [[UILabel alloc] init];
                waitingLabel.text = @"关注列表空空如也，快去逛逛吧！";
                waitingLabel.font = [UIFont fontWithName:FONT_MEDIUM size:8];
                waitingLabel.textColor = COLOR_GRAY_999999;
                waitingLabel.textAlignment = NSTextAlignmentCenter;
                [self.tableView addSubview:waitingLabel];
                self.waitingLabel = waitingLabel;
                [waitingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.tableView);
                    make.top.mas_equalTo(waitingView.mas_top).offset(138.f * g_rateWidth);
                    make.width.mas_equalTo(self.tableView);
                }];
                
                UIButton *forbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                forbtn.backgroundColor = COLOR_RED_FF3C5E;
                forbtn.layer.cornerRadius = 4.f;
                forbtn.layer.masksToBounds = YES;
                forbtn.titleLabel.font = kFont_Medium(9.f);
                [forbtn setTitle:@"去逛逛" forState:UIControlStateNormal];
                [forbtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
                forbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.tableView addSubview:forbtn];
                self.forbtn = forbtn;
                [forbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(getWidth(69.f), getWidth(19.f)));
                    make.top.mas_equalTo(waitingView.mas_bottom).offset(getWidth(2.f));
                    make.centerX.mas_equalTo(self.tableView);
                }];
            }else{
                [self.waitingView removeFromSuperview];
                [self.waitingLabel removeFromSuperview];
                [self.forbtn removeFromSuperview];

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
    kWeakSelf(weakSlef);
    [_textDialogView setConfirmCallback:^{
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        NSLog(@"indexPath: %ld", (long)indexPath.row);
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [HPHTTPSever HPPostServerWithMethod:@"/v1/fans/cancel" paraments:@{@"shareFans":weakSlef.selectedModel.followed_id} needToken:YES complete:^(id  _Nonnull responseObject) {
            if (CODE == 200) {
                [HPProgressHUD alertMessage:MSG];
                [self getFansListData];
            }else{
                [HPProgressHUD alertMessage:MSG];
            }
        } Failure:^(NSError * _Nonnull error) {
            ErrorNet
        }];
    }];
    
    [_textDialogView show:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedModel = self.dataArray[indexPath.row];
    
    HPFansListModel *model = self.dataArray[indexPath.row];
    
    //    model.selected = !model.selected;//默认选一种，不可不选
    //    self.selectedModel.selected = NO;
    //    model.selected = YES;
    //    self.selectedModel = model;
    
    if(self.selectedModel.followed_id != model.followed_id){//默认选一种，可不选
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
    HPFollowListCell *cell = (HPFollowListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.model = model;
    //没有动画闪烁问题
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}
@end
