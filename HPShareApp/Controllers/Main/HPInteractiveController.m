//
//  HPInteractiveController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "JCHATConversationListCell.h"
#import "HPInteractiveController.h"
#import "HPInteractiveCell.h"
#import "HPInterActiveModel.h"
#import "ViewUtil.h"
#import "JCHATSelectFriendsCtl.h"
#import "JCHATAlertViewWait.h"
#import "JCHATConversationViewController.h"
#import "HPImageUtil.h"
#import "JCHATConversationListViewController.h"
#import "HPNavGationViewController.h"

#define JCHATMAINTHREAD(block) dispatch_async(dispatch_get_main_queue(), block)
#define kDBMigrateFinishNotification @"DBMigrateFinishNotification"
#define kLogin_NotifiCation @"loginNotification"
#define kCreatGroupState  @"creatGroupState"
#define kSkipToSingleChatViewState  @"SkipToSingleChatViewState"


#define kBackBtnFrame CGRectMake(0, 0, 50, 30)
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kBubbleBtnColor UIColorFromRGB(0x4880d7)

@interface HPInteractiveController ()<UITableViewDelegate,UITableViewDataSource,HPBaseViewControllerDelegate,TouchTableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,JMessageDelegate>

{
        UIButton *_leftBarButton;
        __block NSMutableArray *_conversationArr;
        UIButton *_rightBarButton;
        NSInteger _unreadCount;
}
@property (nonatomic, strong) UIView *myTitleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *titleActivity;


@property (nonatomic, strong) UIView *navTitleView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *interArray;
@property (nonatomic, strong) NSDictionary *userInfo;

/**
 是否有新的通知消息
 */
@property (nonatomic, assign) BOOL hasNoti;


/**
 蒙版
 */
@property (nonatomic, strong) UIButton *coverBtn;
@end

@implementation HPInteractiveController

- (UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [UIButton new];
        _coverBtn.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.7];
        [_coverBtn addTarget:self action:@selector(hiddenCoverBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}

- (void)hiddenCoverBtn:(UIButton *)button
{
    self.addBgView.hidden = YES;
}

#pragma mark - 设置源数据为已读数据
- (void)clickRightButtonToHandle
{
    [self getDataResources];
}

- (void)clickLeftButtonToHandle:(UIButton *)button
{
//    [self addBtnClick:button];
}
static NSString *interactiveCell = @"interactiveCell";
static NSString *conversationListCell = @"conversationListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPop = NO;
//    [self setUpNavgationBarConfig];
    [self setupBubbleView];
    _conversationArr = [NSMutableArray array];
    [self setUpNotiConfig];
    // Do any additional setup after loading the view.
    self.delegate = self;
    _interArray = [NSMutableArray array];
    [self getDataResources];
    
    [self setupUI];
    _navTitleView = [self setupNavigationBarWithTitle:@"互动"];
    [self setupRightBarbuttonBtn:@"一键已读"];
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];
//左边按钮
//    [self setupLeftBarbuttonBtn:@"fdf"];
}

#pragma mark - 下拉IM卡选项
- (void)setupBubbleView {
    
    _addBgView = [[UIImageView alloc] init];
    [_addBgView setBackgroundColor:[UIColor clearColor]];
    [_addBgView setUserInteractionEnabled:YES];
    UIImage *frameImg = [UIImage imageNamed:@"frame"];
    frameImg = [frameImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 64) resizingMode:UIImageResizingModeTile];
    [_addBgView setImage:frameImg];
    [_addBgView setHidden:YES];
    
    [self.view addSubview:self.addBgView];

    [self.addBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(g_statusBarHeight + getWidth(54.5f));
        make.size.mas_equalTo(CGSizeMake(getWidth(100.f), getWidth(100.f)));
        make.left.mas_equalTo(self.view);
    }];
    [self.view bringSubviewToFront:self.addBgView];
    [self addBtn];
}

- (void)addBtn {
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            [btn setTitle:@"发起群聊" forState:UIControlStateNormal];
        }
        if (i==1) {
            [btn setTitle:@"发起单聊" forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i + 100;
        [btn setFrame:CGRectMake(5, i*30+15, 80, 30)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setBackgroundImage:[ViewUtil colorImage:kBubbleBtnColor frame:btn.frame] forState:UIControlStateHighlighted];
        [self.addBgView addSubview:btn];
    }
}

- (void)btnClick :(UIButton *)btn {
    [self.addBgView setHidden:YES];
    if (btn.tag == 100) {
        JCHATSelectFriendsCtl *selectCtl = [[JCHATSelectFriendsCtl alloc] init];
        UINavigationController *selectNav = [[UINavigationController alloc] initWithRootViewController:selectCtl];
        UINavigationBar *bar = [UINavigationBar appearance];
        
        //设置显示的颜色
        
        bar.barTintColor = COLOR_RED_EA0000;
        [self.navigationController presentViewController:selectNav animated:YES completion:nil];
    } else if (btn.tag == 101) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加聊天对象"
                                                          message:@"输入对方的用户名!"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
        alerView.delegate = self;
        [alerView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

        if (buttonIndex == 0) {
        } else if (buttonIndex == 1)
        {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                [HPProgressHUD alertMessage:@"请输入用户名"];
                
                return;
            }
            
            [[JCHATAlertViewWait ins] showInView];
            __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
            sendMessageCtl.superViewController = self;
            
            sendMessageCtl.hidesBottomBarWhenPushed = YES;
            [[alertView textFieldAtIndex:0] resignFirstResponder];
            
            [HPProgressHUD alertWithLoadingText:@"正在添加用户..."];
            kWEAKSELF
            [JMSGConversation createSingleConversationWithUsername:[alertView textFieldAtIndex:0].text appKey:JPushAppKey completionHandler:^(id resultObject, NSError *error) {
                [[JCHATAlertViewWait ins] hidenAll];
                
                if (error == nil) {
                    //                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    kSTRONGSELF
                    sendMessageCtl.conversation = resultObject;
                    [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
                } else {
                    HPLog(@"createSingleConversationWithUsername fail");
                    [HPProgressHUD alertWithFinishText:@"添加的用户不存在"];
                }
            }];
        }
    
}

#pragma mark - 获取原始数据-也是设置消息是否已读的源数据
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

//    [kNotificationCenter addObserver:self
//                                             selector:@selector(netWorkConnectClose)
//                                                 name:kJMSGNetworkDidCloseNotification
//                                               object:nil];
    
//    [kNotificationCenter addObserver:self
//                                             selector:@selector(netWorkConnectSetup)
//                                                 name:kJMSGNetworkDidSetupNotification
//                                               object:nil];
    
//    [kNotificationCenter addObserver:self
//                                             selector:@selector(connectSucceed)
//                                                 name:kJMSGNetworkDidLoginNotification
//                                               object:nil];
    
//    [kNotificationCenter addObserver:self
//                                             selector:@selector(isConnecting)
//                                                 name:kJMSGNetworkIsConnectingNotification
//                                               object:nil];
    
    [kNotificationCenter addObserver:self
                                             selector:@selector(dBMigrateFinish)
                                                 name:kDBMigrateFinishNotification object:nil];
    
    
//    [kNotificationCenter addObserver:self
//                                             selector:@selector(alreadyLoginClick)
//                                                 name:kLogin_NotifiCation object:nil];
    
    [kNotificationCenter addObserver:self
                                             selector:@selector(creatGroupSuccessToPushView:)
                                                 name:kCreatGroupState
                                               object:nil];
    
    [kNotificationCenter addObserver:self
                                             selector:@selector(skipToSingleChatView:)
                                                 name:kSkipToSingleChatViewState
                                               object:nil];
}

#pragma mark - 拿到监听消息
- (void)getNotiInfo:(NSNotification *)noti
{
    _hasNoti = YES;
    [self.interArray removeAllObjects];
    self.userInfo = noti.userInfo;
    NSString *date = self.userInfo[@"date"];

    NSString *title = self.userInfo[@"title"];
    NSString *subtitle = self.userInfo[@"content"];
    HPInterActiveModel *model = [HPInterActiveModel new];
    model.date = date;
    model.photo = @"system notification";
    model.title = title;
    model.subtitle = subtitle;
    model.hasnoti = YES;
    NSArray *interArray = @[[model mj_keyValues],@{@"photo":@"activity center",@"title":@"活动中心",@"subtitle":@"暂无数据"}];
    self.interArray = [HPInterActiveModel mj_objectArrayWithKeyValuesArray:interArray];
    [self.tableView reloadData];
}

- (void)dBMigrateFinish {
    HPLog(@"Migrate is finish  and get allconversation");
    JCHATMAINTHREAD(^{
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    [self addDelegate];
//    [self getConversationList];
}

#pragma mark --创建群成功Push group viewctl
- (void)creatGroupSuccessToPushView:(NSNotification *)object{//group
    HPLog(@"Action - creatGroupSuccessToPushView - %@", object);
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    kWEAKSELF
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed=YES;
    [JMSGConversation createGroupConversationWithGroupId:((JMSGGroup *)[object object]).gid completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = (JMSGConversation *)resultObject;
            JCHATMAINTHREAD(^{
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            HPLog(@"createGroupConversationwithgroupid fail");
        }
    }];
    
}

- (void)skipToSingleChatView :(NSNotification *)notification {
    JMSGUser *user = [[notification object] copy];
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];//!!
    kWEAKSELF
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:user.username appKey:JPushAppKey completionHandler:^(id resultObject, NSError *error) {
        kSTRONGSELF
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            JCHATMAINTHREAD(^{
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            HPLog(@"createSingleConversationWithUsername");
        }
    }];
}


- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];
//    [kNotificationCenter removeObserver:self];
//    [kNotificationCenter removeObserver:self];
//    [kNotificationCenter removeObserver:self];

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
    return _interArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_interArray count];
    }else if (section == 1) {
        return 1.f;
//        return _conversationArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPInterActiveModel *model = _interArray[indexPath.row];
    HPInteractiveCell *cell = [tableView dequeueReusableCellWithIdentifier:interactiveCell];
    if (indexPath.section == 0) {
        
        cell.model = model;
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
//        if (_conversationArr.count == 0) {
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
//            return cell;
//        }else{
//            JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:conversationListCell];
//
//            JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
//            [cell setCellDataWithConversation:conversation];
//            return cell;
//        }
//        cell.titleLabel.text = @"合店在线";
//        cell.subtitleLabel.text = @"暂无数据";
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
    HPInterActiveModel *model = self.interArray[indexPath.row];
    model.hasnoti = NO;
    if (indexPath.section == 0 && indexPath.row == 0) {
            [self pushVCByClassName:@"HPSystemNotiController" withParam:@{@"data":self.interArray}];
    }else if (indexPath.section == 0 && indexPath.row == 1){
            [self pushVCByClassName:@"HPPartyCenterController" withParam:@{@"data":self.interArray}];
    }
    
    if (indexPath.section == 1) {
//        JCHATConversationListViewController *listvc = [JCHATConversationListViewController new];
//        HPNavGationViewController *nav = [[HPNavGationViewController alloc] initWithRootViewController:listvc];
//        self.isPop = YES;
//        [self.navigationController presentViewController:nav animated:NO completion:NULL];
    }
}

#pragma mark - TouchTableViewDelegate
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.addBgView setHidden:YES];
    _leftBarButton.selected=NO;
}

#pragma mark - 取消下拉  允许上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.tableView.contentOffset = offset;
}

#pragma mark - JPush IM
/*
- (void)addBtnClick:(UIButton *)btn {
    
    if (btn.selected) {
        btn.selected=NO;
        [self.addBgView setHidden:YES];
    } else {
        btn.selected=YES;
        [self.addBgView setHidden:NO];
    }
    [self.view bringSubviewToFront:self.addBgView];
}

- (void)netWorkConnectClose {
    HPLog(@"Action - netWorkConnectClose");
    _titleLabel.text = @"未连接";
    _titleActivity.hidden = YES;
}

- (void)netWorkConnectSetup {
    HPLog(@"Action - netWorkConnectSetup");
    
    _titleLabel.text = @"收取中...";
    _titleActivity.hidden = NO;
}

- (void)connectSucceed {
    HPLog(@"Action - connectSucceed");
    
    _titleLabel.text = @"会话";
    _titleActivity.hidden = YES;
    
}

- (void)isConnecting {
    HPLog(@"Action - isConnecting");
    
    _titleLabel.text = @"连接中...";
    _titleActivity.hidden = NO;
}


#pragma mark JMSGMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    HPLog(@"Action -- onReceivemessage %@",message.serverMessageId);
    [self getConversationList];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    HPLog(@"Action -- onConversationChanged");
    //    [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    HPLog(@"Action -- onGroupInfoChanged");
    [self getConversationList];
}

- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
                         offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages {
    HPLog(@"Action -- onSyncOfflineMessageConversation:offlineMessages:");
    
    //    [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation {
    HPLog(@"Action -- onSyncRoamingMessageConversation:");
    
    //    [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onSyncReloadConversationListWithConversation:(JMSGConversation *)conversation {
    if (!conversation) {
        return ;
    }
    BOOL isHave = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *newUser = (JMSGUser *)conversation.target;
        for (int i = 0; i < _conversationArr.count; i++) {
            JMSGConversation *oldConversation = _conversationArr[i];
            if (oldConversation.conversationType == kJMSGConversationTypeSingle) {
                JMSGUser *oldUser = (JMSGUser *)oldConversation.target;
                if ([newUser.username isEqualToString:oldUser.username] && [newUser.appKey isEqualToString:oldUser.appKey]) {
                    [_conversationArr replaceObjectAtIndex:i withObject:conversation];
                    isHave = YES;
                    break ;
                }
            }
        }
    }else{
        JMSGGroup *newGroup = (JMSGGroup *)conversation.target;
        for (int i = 0; i < _conversationArr.count; i++) {
            JMSGConversation *oldConversation = _conversationArr[i];
            if (oldConversation.conversationType == kJMSGConversationTypeGroup) {
                JMSGGroup *oldGroup = (JMSGGroup *)oldConversation.target;
                if ([newGroup.gid isEqualToString:oldGroup.gid]) {
                    [_conversationArr replaceObjectAtIndex:i withObject:conversation];
                    isHave = YES;
                    break ;
                }
            }
        }
    }
    if (!isHave) {
        [_conversationArr insertObject:conversation atIndex:0];
    }
    _conversationArr = [self sortConversation:_conversationArr];
    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
    [self saveBadge:_unreadCount];
    [self.tableView reloadData];
}*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_RED_EA0000] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

/*
- (void)getConversationList {
    
    if (isGetingAllConversation) {
        HPLog(@"is loading conversation list");
        cacheCount++;
        return ;
    }
    
    HPLog(@"get allConversation -- start");
    isGetingAllConversation = YES;
    
    [self.addBgView setHidden:YES];
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        JCHATMAINTHREAD(^{
            self->isGetingAllConversation = NO;
            if (error == nil) {
                self->_conversationArr = [self sortConversation:resultObject];
                self->_unreadCount = 0;
                for (NSInteger i=0; i < [self->_conversationArr count]; i++) {
                    JMSGConversation *conversation = [self->_conversationArr objectAtIndex:i];
                    self->_unreadCount = self->_unreadCount + [conversation.unreadCount integerValue];
                }
                [self saveBadge:self->_unreadCount];
            } else {
                self->_conversationArr = nil;
            }
            [self.tableView reloadData];
            HPLog(@"get allConversation -- end");
            self->isGetingAllConversation = NO;
            [self checkCacheGetAllConversationAction];
        });
    }];
}
- (void)checkCacheGetAllConversationAction {
    if (cacheCount > 0) {
        NSLog(@"is have cache ,once again get all conversation");
        cacheCount = 0;
        [self getConversationList];
    }
}

NSInteger sortType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    NSArray *sortedArray = [conversationArr sortedArrayUsingDescriptors:sortDescriptors];
    
    return [NSMutableArray arrayWithArray:sortedArray];
    
    //    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    //    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)alreadyLoginClick {
    [self getConversationList];
}

- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:@"badge"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/
@end
