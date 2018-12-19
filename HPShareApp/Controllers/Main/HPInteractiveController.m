//
//  HPInteractiveController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPInteractiveController.h"
#import "HPInteractiveCell.h"
#import "HPInterActiveModel.h"

@interface HPInteractiveController ()<UITableViewDelegate,UITableViewDataSource,HPBaseViewControllerDelegate>

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *interArray;
@property (nonatomic, strong) NSDictionary *userInfo;

/**
 是否有新的通知消息
 */
@property (nonatomic, assign) BOOL hasNoti;
@end

@implementation HPInteractiveController

#pragma mark - 设置源数据为已读数据
- (void)clickRightButtonToHandle
{
    [self getDataResources];
}
static NSString *interactiveCell = @"interactiveCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNotiConfig];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self getDataResources];
    
    [self setupUI];
    [self setupNavigationBarWithTitle:@"互动"];
    [self setupRightBarbuttonBtn:@"一键已读"];
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];

}
#pragma mark - 获取出事原始数据-也是设置消息是否已读的源数据
- (void)getDataResources
{
    _hasNoti = NO;
    [self.interArray removeAllObjects];
    NSArray *interArray = @[@{@"photo":@"system notification",@"title":@"系统通知",@"subtitle":@"暂无数据"//@"注册成功，欢迎进入“合店站”"
                              },@{@"photo":@"activity center",@"title":@"活动中心",@"subtitle":@"暂无数据"//@"锦鲤附身，您有1份新用户大礼包待领取"
                                  
                                  }];
    _interArray = [HPInterActiveModel mj_objectArrayWithKeyValuesArray:interArray];
    [_tableView reloadData];
}

#pragma mark - 添加通知监听注册/登录信息
- (void)setUpNotiConfig
{
    [kNotificationCenter addObserver:self selector:@selector(getNotiInfo:) name:@"regiest" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(getNotiInfo:) name:@"login" object:nil];

}

#pragma mark - 拿到监听消息
- (void)getNotiInfo:(NSNotification *)noti
{
    _hasNoti = YES;
    [self.interArray removeAllObjects];
    HPLog(@"noti:%@",noti.userInfo);
    self.userInfo = noti.userInfo;
    NSString *title = self.userInfo[@"title"];
    NSString *subtitle = self.userInfo[@"content"];
    NSArray *interArray = @[@{@"photo":@"system notification",@"title":title.length >0 ?title: @"暂无数据",@"subtitle":subtitle.length >0 ?subtitle: @"暂无数据"}];
    self.interArray = [HPInterActiveModel mj_objectArrayWithKeyValuesArray:interArray];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];

}
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:COLOR_GRAY_F7F7F7];
    [tableView setSeparatorColor:COLOR_GRAY_F7F7F7];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];

    [tableView registerClass:HPInteractiveCell.class forCellReuseIdentifier:interactiveCell];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.mas_equalTo(g_navigationBarHeight);
        make.bottom.equalTo(self.view);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _interArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_interArray count];
    }else if (section == 1) {
        return 1.f;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPInterActiveModel *model = _interArray[indexPath.row];
    HPInteractiveCell *cell = [tableView dequeueReusableCellWithIdentifier:interactiveCell];
    if (indexPath.section == 0) {
        
        cell.model = model;
        if (_hasNoti) {
            cell.badgeValue.hidden = NO;
        }else{
            cell.badgeValue.hidden = YES;
        }
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        [cell.contentView removeFromSuperview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImage *image = ImageNamed(@"waiting");
        UIImageView *waitingView = [[UIImageView alloc] init];
        waitingView.image = image;
        [cell addSubview:waitingView];
        [waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(72.f * g_rateWidth);
            make.size.mas_equalTo(CGSizeMake(343.f * g_rateWidth, 197.f * g_rateWidth));
            make.centerX.mas_equalTo(cell);
        }];
        
        UILabel *waitingLabel = [[UILabel alloc] init];
        waitingLabel.text = @"在线互动即将开启，敬情期待 ~";
        waitingLabel.font = [UIFont fontWithName:FONT_MEDIUM size:12];
        waitingLabel.textColor = COLOR_GRAY_BBBBBB;
        waitingLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:waitingLabel];
        [waitingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell);
            make.top.mas_equalTo(waitingView.mas_top).offset(158.f * g_rateWidth);
            make.width.mas_equalTo(kScreenWidth);
        }];
    }

    return cell;
}

- (void)viewLayoutMarginsDidChange
{
    [super viewLayoutMarginsDidChange];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone5) {
        if (indexPath.section == 1) {
            return kScreenHeight - g_navigationBarHeight - g_tabBarHeight - 20.f * g_rateWidth - 120.f * g_rateWidth;
        }else{
            return 60.f;
        }
    }else{
        if (indexPath.section == 1) {
            return kScreenHeight - g_navigationBarHeight - g_tabBarHeight - 20.f * g_rateWidth - 150.f;
        }else{
            return 75.f * g_rateWidth;
        }
    }
    return 75.f * g_rateWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    footerV.backgroundColor = COLOR_GRAY_F7F7F7;
    return footerV;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.f * g_rateHeight)];
    headerV.backgroundColor = COLOR_GRAY_F7F7F7;
    return headerV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _hasNoti = NO;
    [self.tableView reloadData];
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        [self pushVCByClassName:@"HPSystemNotiController"];
//    }else if (indexPath.section == 0 && indexPath.row == 1){
//        [self pushVCByClassName:@"HPPartyCenterController"];
//    }
}

#pragma mark - 取消下拉  允许上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.tableView.contentOffset = offset;
}

@end
