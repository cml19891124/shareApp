//
//  HPProfileViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPProfileViewController.h"

#import "HPHeaderViewCell.h"

#import "HPRelationViewCell.h"

#import "HPCustomerServiceModalView.h"

#import "HPSingleton.h"

#import "HPOrderItemCell.h"

#import "HPUploadImageHandle.h"

#import "HPUpdateVersionView.h"

#import "HPUpdateVersionTool.h"

#import <JMessage/JMessage.h>

#import "JCHATStringUtils.h"

#import "HPNewOrderView.h"

#import "HPUserNewOrderView.h"

#import "HPOwnnerOrderModel.h"

#import "HOOrderListModel.h"

typedef NS_ENUM(NSInteger, HPProfileSelectedRow) {
    HPProfileSelectedRowIdentify = 0,//资格认证
    HPProfileSelectedRowAccountSafe,//账号安全
    HPProfileSelectedRowEmotion,//意见反馈
    HPProfileSelectedRowOnlineServer,//在线客服
    HPProfileSelectedRowAbountUs//关于我们
};

@interface HPProfileViewController ()<UITableViewDelegate,UITableViewDataSource,HPHeaderViewCellDelegate>

@property (nonatomic, copy) NSString *identifyTag;

@property (nonatomic, strong) HPNewOrderView *newOrderView;

@property (strong, nonatomic) HPUserNewOrderView *userOrderView;

@property (nonatomic, weak) HPUpdateVersionView *updateView;

@property (nonatomic, weak) HPCustomerServiceModalView *customerServiceModalView;

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (strong, nonatomic) HPOwnnerOrderModel *ownnerModel;

@property (strong, nonatomic) HOOrderListModel *model;
@end

@implementation HPProfileViewController

static NSString *headerViewCell = @"HPHeaderViewCell";

static NSString *relationViewCell = @"HPRelationViewCell";

static NSString *orderItemCell = @"HPOrderItemCell";

#pragma mark - HPHeaderViewCellDelegate

- (void)onClicked:(HPHeaderViewCell *)tableviewCell LoginBtn:(UIButton *)button
{
    HPLoginModel *model = [HPUserTool account];
    if (!model.token) {
        //        [HPProgressHUD alertMessage:@"用户未登录"];
        [self pushVCByClassName:@"HPLoginController"];
        
        return;
    }
}

- (HPNewOrderView *)newOrderView
{
    if (!_newOrderView) {
        _newOrderView = [[HPNewOrderView alloc] initWithParent:self.tabBarController.view];
        kWEAKSELF
        _newOrderView.newBlock = ^(NSInteger newIndex) {
            if (newIndex == HPNewOrderStateCommunicate) {
                HPLog(@"communciate");
            }else if (newIndex == HPNewOrderStateReceive){
                HPLog(@"receive");

            }else if (newIndex == HPNewOrderStateCloseOrder){
                HPLog(@"CloseOrder");
                [weakSelf.newOrderView show:NO];
            }
        };
    }
    return _newOrderView;
}

- (HPUserNewOrderView *)userOrderView
{
    if (!_userOrderView) {
        kWEAKSELF
        _userOrderView = [[HPUserNewOrderView alloc] initWithParent:self.tabBarController.view];
        _userOrderView.newBlock = ^(NSInteger userindex) {
            if (userindex == UserNewOrderStateCommunicate) {
                HPLog(@"communciate");
            }else if (userindex == UserNewOrderStateReceive){
                HPLog(@"receive");
                
            }else if (userindex == UserNewOrderStateCloseOrder){
                HPLog(@"CloseOrder");
                [weakSelf.userOrderView show:NO];
            }
        };
    }
    return _userOrderView;
}

- (void)onTapped:(HPHeaderViewCell *)tableviewCell HeaderView:(UITapGestureRecognizer *)tap
{
    HPLog(@"tap");
    HPLoginModel *model = [HPUserTool account];
    if (!model.token) {
        //        [HPProgressHUD alertMessage:@"用户未登录"];
        [self pushVCByClassName:@"HPLoginController"];
        
        return;
    }else{
        
        [self pushVCByClassName:@"HPConfigCenterController"];
    }
}

- (void)onClicked:(HPHeaderViewCell *)tableviewCell EditProfileInfoBtn:(UIButton *)button
{
    HPLog(@"edit");
    [self pushVCByClassName:@"HPEditPersonOInfoController"];
}

- (void)onClicked:(HPHeaderViewCell *)tableviewCell OptionalBtn:(UIButton *)optionalBtn
{
    HPLog(@"optional");
    optionalBtn.selected = !optionalBtn.selected;
    if (optionalBtn.selected) {
        [HPSingleton sharedSingleton].identifyTag = 1;

        [self getOwnnerOrdersListApi];
        [self.tabBarController.view addSubview:self.newOrderView];
        
        [self.newOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
    }else{
        [HPSingleton sharedSingleton].identifyTag = 0;
    }
    [self.tableView reloadData];
}

#pragma mark - 店主接到新订单的弹框
- (void)showNewOrederView
{
//    self.model = noti.userInfo[@"model"];
    if (self.model.order.status.integerValue == 2) {
        [self.userOrderView show:YES];
        self.userOrderView.tipLabel.text = [NSString stringWithFormat:@"新订单提醒（%@）",self.model.spaceDetail.shortName];
        NSString *leftTime = [NSString stringWithFormat:@"%@前", [HPTimeString gettimeInternalFromPassedTimeToNowDate:_model.order.admitTime]];

        self.userOrderView.timeLabel.text = leftTime;
        self.userOrderView.nameLabel.text = self.model.spaceDetail.contact;
        NSArray *rentDays = [self.model.order.days componentsSeparatedByString:@","];
        self.userOrderView.rentDaysLabel.text = [NSString stringWithFormat:@"租（%ld天",rentDays.count];
        self.userOrderView.toPayLabel.text = [NSString stringWithFormat:@"¥%@",self.model.order.totalFee];

    }
}

#pragma mark - 租客接到新订单的弹框

- (void)showUserNewOrederView
{
//    self.model = noti.userInfo[@"model"];
    if (self.model.order.status.integerValue == 1) {
        [self.newOrderView show:YES];
        self.newOrderView.tipLabel.text = [NSString stringWithFormat:@"新订单提醒（%@）",self.model.spaceDetail.shortName];
        NSString *leftTime = [NSString stringWithFormat:@"%@前", [HPTimeString gettimeInternalFromPassedTimeToNowDate:_model.order.admitTime]];
        
        self.newOrderView.timeLabel.text = leftTime;
        self.newOrderView.nameLabel.text = self.model.spaceDetail.contact;
        self.newOrderView.phoneLabel.text = self.model.spaceDetail.contactMobile;
        NSArray *rentDays = [self.model.order.days componentsSeparatedByString:@","];
        self.newOrderView.rentDaysLabel.text = [NSString stringWithFormat:@"拼租日期（共%ld天）",rentDays.count];
        self.newOrderView.daysLabel.text = self.model.order.days;
        self.newOrderView.rentDesLabel.text = self.model.spaceDetail.remark;
        
    }
}
/**
 商家订单数量
 */
- (void)getOwnnerOrdersListApi
{
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/order/stats" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.ownnerModel = [HPOwnnerOrderModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
        }else if (CODE == 401){
            [HPUserTool deleteAccount];
            [self pushVCByClassName:@"HPLoginController"];
            [HPSingleton sharedSingleton].identifyTag = 0;
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateAppVersionInfo];

//    [HPSingleton sharedSingleton].identifyTag = 0;
    
    [self.tableView reloadData];
}

#pragma  mark - 上传一张图片
- (void)uploadLocalImageGetAvatarUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/file/uploadPicture",kBaseUrl];//放上传图片的网址
    HPLoginModel *account = [HPUserTool account];
    NSString *historyTime = [HPTimeString getNowTimeTimestamp];
    UIImage *image = [UIImage imageNamed:@"personal_center_not_login_head"];
    [HPUploadImageHandle sendPOSTWithUrl:url withLocalImage:image isNeedToken:YES parameters:@{@"file":historyTime} success:^(id data) {
        if ([data[@"code"] intValue]== 200) {
            HPUserInfo *userInfo = [[HPUserInfo alloc] init];
            userInfo.avatarUrl = [data[@"data"]firstObject][@"url"]?:@"";
            userInfo.password = account.userInfo.password?:@"";
            userInfo.username = account.userInfo.username?:@"";
            userInfo.userId = account.userInfo.userId?:@"";
            userInfo.mobile = account.userInfo.mobile?:@"";
            account.userInfo = userInfo;
            [HPUserTool saveAccount:account];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }else if ([data[@"code"] intValue]== 401){
            [HPUserTool deleteAccount];
            [self pushVCByClassName:@"HPLoginController"];
            
        }
        
    } fail:^(NSError *error) {
        ErrorNet
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }

    self.view.backgroundColor = COLOR_GRAY_f9fafd;

    self.imageArray = @[@"",@"",@[@"me_business_identify",@"me_business_safe",@"me_business_emotion",@"me_business_server",@"me_business_ours"]];
    
    self.titleArray = @[@"",@"",@[@"资格认证",@"账号安全",@"意见反馈",@"在线客服",@"关于我们"]];
//    [self.tableView reloadData];
    [self setUpSubviewsUI];
    
    [self setUpSubviewsUIMasonry];

}

- (void)setUpSubviewsUI
{
    [self.view addSubview:self.tableView];
}

- (void)setUpSubviewsUIMasonry
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(-g_statusBarHeight);
    }];
}

#pragma mark - 初始化控件

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_GRAY_f9fafd;
        _tableView.separatorColor = COLOR_GRAY_FAFAFA;
        [_tableView registerClass:HPHeaderViewCell.class forCellReuseIdentifier:headerViewCell];
        [_tableView registerClass:HPRelationViewCell.class forCellReuseIdentifier:relationViewCell];
        [_tableView registerClass:HPOrderItemCell.class forCellReuseIdentifier:orderItemCell];

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 5;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            return getWidth(315.f);

        }else{
            return getWidth(295.f);
        }
    }else if (indexPath.section == 1){
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            return getWidth(152.f);
            
        }else{
            return getWidth(67.f);
        }
    }else if (indexPath.section == 2){
        return getWidth(53.f);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:kRect(0, 0, kScreenWidth, getWidth(15.f))];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return getWidth(15.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCell = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {

        HPHeaderViewCell *cell = [self setUpHeaderViewCell:tableView];

        return cell;
    }
    else if(indexPath.section == 1){
        
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            HPOrderItemCell *cell = [self setOrderItemCell:tableView];
            
            return cell;
        }else{
            UIImageView *protectView = [UIImageView new];
            protectView.image = ImageNamed(@"me_business_protect");
            
            [cell.contentView addSubview:protectView];
            [protectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(getWidth(67.f));
                make.centerY.mas_equalTo(cell);
                make.left.mas_equalTo(getWidth(15.f));
                make.right.mas_equalTo(getWidth(-15.f));
                
            }];
            cell.backgroundColor = COLOR_GRAY_f9fafd;
            
            return cell;
        }
        
        
    }
        else if (indexPath.section == 2){
        HPRelationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:relationViewCell];
        cell.backgroundColor = COLOR_GRAY_f9fafd;
            
        UIImage *image = ImageNamed(self.imageArray[indexPath.section][indexPath.row]);
            cell.iconView.image = image;
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
            return cell;
    }
    return cell;
}


- (HPOrderItemCell *)setOrderItemCell:(UITableView *)tableView
{
    HPOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:orderItemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.returnBlock = ^(NSInteger HPReturnOrderIndex) {
        if (HPReturnOrderIndex == 4405) {//全部订单
            [self pushVCByClassName:@"HPOrderListViewController" withParam:@{@"orderStaus":@(0)}];
        }else if(HPReturnOrderIndex == HPMineOrderCellToReceive){
            [self pushVCByClassName:@"HPOrderListViewController" withParam:@{@"orderStaus":@(1)}];
        }else if(HPReturnOrderIndex == HPMineOrderCellToPay){
            [self pushVCByClassName:@"HPOrderListViewController" withParam:@{@"orderStaus":@(2)}];
        }else if(HPReturnOrderIndex == HPMineOrderCellToRent){//待收货
            [self pushVCByClassName:@"HPOrderListViewController" withParam:@{@"orderStaus":@(3)}];
        }else if(HPReturnOrderIndex == HPMineOrderCellToComment){
            [self pushVCByClassName:@"HPOrderListViewController" withParam:@{@"orderStaus":@(4)}];
        }
    };

    return cell;
}

- (HPHeaderViewCell *)setUpHeaderViewCell:(UITableView *)tableView
{
    HPHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.identifyTag = [HPSingleton sharedSingleton].identifyTag;

    HPLoginModel *account = [HPUserTool account];

    if (!account.token) {
        cell.optionalBtn.hidden = YES;
        [cell.phoneBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        cell.identifiLabel.text = @"登录即可在线拼租";
        cell.iconImageView.image = ImageNamed(@"personal_center_not_login_head");
    }else{
        cell.optionalBtn.hidden = NO;
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            cell.identifiLabel.text = @"租客信息，资质认证";
            [cell.optionalBtn setTitle:@"切换为店主" forState:UIControlStateNormal];
            
        }else{
            [cell.optionalBtn setTitle:@"切换为租客" forState:UIControlStateNormal];
            
            cell.identifiLabel.text = @"店主信息，资质认证";
            //商家订单信息数量
            
            cell.ownnerView.toReceiveBtn.numLabel.text = self.ownnerModel.needAdmittedNum;
            cell.ownnerView.toPayBtn.numLabel.text = self.ownnerModel.needPaidNum;
            cell.ownnerView.toGetBtn.numLabel.text = self.ownnerModel.cooperatingNum;
            cell.ownnerView.compelteBtn.numLabel.text = self.ownnerModel.finishedNum;

        }
        [cell.phoneBtn setTitle:account.userInfo.mobile forState:UIControlStateNormal];
        if (account.userInfo.avatarUrl) {
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.userInfo.avatarUrl] placeholderImage:ImageNamed(@"personal_center_not_login_head")];
        }else{
            [self uploadLocalImageGetAvatarUrl];
        }
        
        if (account.userInfo.avatarUrl) {
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.userInfo.avatarUrl] placeholderImage:ImageNamed(@"personal_center_not_login_head")];
        }else{
            [self uploadLocalImageGetAvatarUrl];
        }
    }
    
    cell.userView.profileBlock = ^(NSInteger orderIndex) {
        if (orderIndex == HPOrderCellIndexToCollection) {
            HPLog(@"toreceive");
            [self pushVCByClassName:@"HPKeepController"];
        }else if (orderIndex == HPOrderCellIndexToFocus){
            [self pushVCByClassName:@"HPFollowController"];
        }else if (orderIndex == HPOrderCellIndexToFoot){
            [self pushVCByClassName:@"HPHistoryController"];
        }else if (orderIndex == HPOrderCellIndexTodiscount){
            HPLog(@"to return");
        }
    };
    
    cell.ownnerView.busiBlock = ^(NSInteger businessIndex) {
        if (businessIndex == HPBusinessCellIndexStores) {
            [self pushVCByClassName:@"HPShareManageController"];
        }else if (businessIndex == HPBusinessCellIndexOrder){
            [self pushVCByClassName:@"HPOrderListViewController"];
        }else if (businessIndex == HPBusinessCellIndexWallet){
            HPLog(@"wallet");
        }else if (businessIndex == HPBusinessCellIndexName){
            HPLog(@"name");
            [self pushVCByClassName:@"HPMyCardController" withParam:@{@"userId":account.userInfo.userId}];
        }
    };
    return cell;
}

//设置分割线的位置 在willDisplayCell上增加如下代码

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.separatorInset = UIEdgeInsetsMake(0, getWidth(62.f), 0, getWidth(35.f));
    
    //缩进50pt
    
    //去了最后一行cell的分割线需要这样
//    if (indexPath.row== self.imageArray.count-1) {
//        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth , 0, 0);
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HPLoginModel *account = [HPUserTool account];
    
    if (indexPath.section == 1) {
        HPLog(@"application");
        [self pushVCByClassName:@"HPCommentViewController"];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == HPProfileSelectedRowIdentify) {
            if (account.token) {
                [self pushVCByClassName:@"HPIdentifyViewController"];
            }
        }else if (indexPath.row == HPProfileSelectedRowAccountSafe) {
            if (account.token) {
                [self pushVCByClassName:@"HPConfigCenterController"];
            }
        }else if (indexPath.row == HPProfileSelectedRowEmotion) {
            [self pushVCByClassName:@"HPFeedbackController"];
        }else if (indexPath.row == HPProfileSelectedRowOnlineServer) {
            if (_customerServiceModalView == nil) {
                HPCustomerServiceModalView *customerServiceModalView = [[HPCustomerServiceModalView alloc] initWithParent:self.parentViewController.view];
                customerServiceModalView.phone = @"0755-86566389";
                [customerServiceModalView setPhoneString:@"0755-86566389"];
                _customerServiceModalView = customerServiceModalView;
            }
            
            [_customerServiceModalView show:YES];
            [self.parentViewController.view bringSubviewToFront:_customerServiceModalView]; 
        }else if (indexPath.row == HPProfileSelectedRowAbountUs) {
            [self pushVCByClassName:@"HPAboutUsViewController"];
        }
    }
}

#pragma mark - 检测版本更新信息
- (void)updateAppVersionInfo
{
    
    BOOL isUpdate = [HPUpdateVersionTool updateAppVersionTool];
    if (isUpdate) {
        [self showAlert];
    }else{
        
    }
}

/**
 *  检查新版本更新弹框
 */
-(void)showAlert
{
    if (_updateView == nil) {
        kWEAKSELF
        HPUpdateVersionView *updateView = [[HPUpdateVersionView alloc] initWithParent:self.tabBarController.view];
        
        [updateView setUpdateBlock:^{
            // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kAppleId]];
            [[UIApplication sharedApplication] openURL:url];
            
        }];
        
        [updateView setCloseBlcok:^{
            [weakSelf.updateView removeFromSuperview];
        }];
        _updateView = updateView;
    }
    
    [_updateView show:YES];
    
}

#pragma mark - 登录im------------
- (void)loginJMessage
{
    HPLoginModel *account = [HPUserTool account];
    JMSGUserInfo *userInfo = [JMSGUserInfo new];
    userInfo.nickname = account.userInfo.username;
    userInfo.signature = account.cardInfo.signature;
    NSString *imAccount = [NSString stringWithFormat:@"hepai%@",account.userInfo.userId];
    
    [JMSGUser loginWithUsername:imAccount password:@"hepai123" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //登录成功
            
        } else {
            NSString * errorStr = [JCHATStringUtils errorAlert:error];
            if ([errorStr isEqualToString:@"用户名不合法"]||[errorStr isEqualToString:@"用户名还没有被注册过"]) {
                [self regiestJMessage];
            }
        }
    }];
}

/**
 *  注册极光
 */
-(void)gotoRegiestIM
{
    [self regiestJMessage];
}

#pragma mark - 注册im
- (void)regiestJMessage
{
    HPLoginModel *account = [HPUserTool account];
    JMSGUserInfo *userInfo = [JMSGUserInfo new];
    userInfo.nickname = account.userInfo.username;
    userInfo.signature = account.cardInfo.signature;
    NSString *imAccount = [NSString stringWithFormat:@"hepai%@",account.userInfo.userId];
    
    kWEAKSELF
    [JMSGUser registerWithUsername:imAccount password:@"hepai123" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //极光注册成功
            [kUserDefaults setObject:@"hepai123" forKey:@"password"];
            [kUserDefaults synchronize];
            [weakSelf loginJMessage];
        } else {
            //极光注册失败
            [HPProgressHUD alertMessage:@"注册极光失败"];
        }
    }];
}

@end
