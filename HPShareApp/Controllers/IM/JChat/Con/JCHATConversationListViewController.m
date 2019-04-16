
#import "JCHATConversationListViewController.h"
#import "JCHATConversationListCell.h"
#import "JCHATConversationViewController.h"
#import "JCHATSelectFriendsCtl.h"
#import "Macro.h"
#import "JCHATAlertViewWait.h"
//#import "JCHATAlreadyLoginViewController.h"
#import "AppDelegate.h"
#import "HPImageUtil.h"

#define kBackBtnFrame CGRectMake(0, 0, 50, 30)
#define kBubbleBtnColor UIColorFromRGB(0x4880d7)
#define kDBMigrateFinishNotification @"DBMigrateFinishNotification"
#define kLogin_NotifiCation @"loginNotification"
#define JCHATMAINTHREAD(block) dispatch_async(dispatch_get_main_queue(), block)
#define kCreatGroupState  @"creatGroupState"
#define kSkipToSingleChatViewState  @"SkipToSingleChatViewState"
@interface JCHATConversationListViewController ()
{
    __block NSMutableArray *_conversationArr;
    UIButton *_rightBarButton;
    NSInteger _unreadCount;
    
//    UILabel *_titleLabel;
    
//    UIView  *_activityView;
//    UIActivityIndicatorView *_av;
//    UILabel *_avTitleLabel;
    
    IBOutlet UIView *myTitleView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIActivityIndicatorView *_titleActivity;
}

@end

@implementation JCHATConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HPLog(@"Action - viewDidLoad");
    [self setupNavigation];
    [self addNotifications];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupBubbleView];
    [self setupChatTable];
    if (!self.isDBMigrating) {
        [self addDelegate];
    } else {
        HPLog(@"is DBMigrating don't get allconversations");
        [HPProgressHUD alertMessage:@"正在升级数据库"];
    }
}

- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_RED_EA0000] forBarMetrics:UIBarMetricsDefault];
    // 底部分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"会话";
    
    _titleLabel.text = @"会话";
    _titleLabel.textColor = COLOR_BLACK_333333;
    _titleActivity.hidden = YES;
    [_titleActivity startAnimating];
    self.navigationItem.titleView = myTitleView;
    
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:kNavigationLeftButtonRect];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加右侧按钮
    
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarButton setFrame:kBackBtnFrame];
    [_rightBarButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarButton setImage:[UIImage imageNamed:@"createConversation"] forState:UIControlStateNormal];
    [_rightBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15*[UIScreen mainScreen].scale)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];//为导航栏添加右侧按钮
    
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectClose)
                                                 name:kJMSGNetworkDidCloseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectSetup)
                                                 name:kJMSGNetworkDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectSucceed)
                                                 name:kJMSGNetworkDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnecting)
                                                 name:kJMSGNetworkIsConnectingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dBMigrateFinish)
                                                 name:kDBMigrateFinishNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadyLoginClick)
                                                 name:kLogin_NotifiCation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creatGroupSuccessToPushView:)
                                                 name:kCreatGroupState
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skipToSingleChatView:)
                                                 name:kSkipToSingleChatViewState
                                               object:nil];
}

- (void)backClick
{
    [self.navigationController dismissViewControllerAnimated:NO completion:NULL];
}

- (void)setupBubbleView {
    _addBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 100,g_statusBarHeight + 44.5, 100, 100)];
    [_addBgView setBackgroundColor:[UIColor clearColor]];
    [_addBgView setUserInteractionEnabled:YES];
    UIImage *frameImg = [UIImage imageNamed:@"frame"];
    frameImg = [frameImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 64) resizingMode:UIImageResizingModeTile];
    [_addBgView setImage:frameImg];
    [_addBgView setHidden:YES];
    [self.view addSubview:self.addBgView];
    [self.view bringSubviewToFront:self.addBgView];
    [self addBtn];
}

- (void)setupChatTable {
    [_chatTableView setBackgroundColor:[UIColor whiteColor]];
    _chatTableView.dataSource=self;
    _chatTableView.delegate=self;
    _chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _chatTableView.touchDelegate = self;
    
    [_chatTableView registerNib:[UINib nibWithNibName:@"JCHATConversationListCell" bundle:nil] forCellReuseIdentifier:@"JCHATConversationListCell"];
}

- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}

- (void)skipToSingleChatView :(NSNotification *)notification {
    JMSGUser *user = [[notification object] copy];
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];//!!
    __weak typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:user.username appKey:JPushAppKey completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
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

- (void)dBMigrateFinish {
    HPLog(@"Migrate is finish  and get allconversation");
    JCHATMAINTHREAD(^{
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    [self addDelegate];
    [self getConversationList];
}

- (JMSGConversation *)getConversationWithTargetId:(NSString *)targetId {
    for (NSInteger i=0; i< [_conversationArr count]; i++) {
        JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
        
        if (conversation.conversationType == kJMSGConversationTypeSingle) {
            if ([((JMSGUser *)conversation.target).username isEqualToString:targetId]) {
                return conversation;
            }
        } else {
            if ([((JMSGGroup *)conversation.target).gid isEqualToString:targetId]) {
                return conversation;
            }
        }
    }
    HPLog(@"Action getConversationWithTargetId  fail to meet conversation");
    return nil;
}

- (void)reloadConversationInfo:(JMSGConversation *)conversation {
    HPLog(@"Action - creatGroupSuccessToPushView - %@", conversation);
    for (NSInteger i=0; i<[_conversationArr count]; i++) {
        JMSGConversation *conversationObject = [_conversationArr objectAtIndex:i];
        if ([conversationObject.target isEqualToConversation:conversation.target]) {
            [_conversationArr removeObjectAtIndex:i];
            [_conversationArr insertObject:conversation atIndex:i];
            [_chatTableView reloadData];
            return;
        }
    }
}

#pragma mark --创建群成功Push group viewctl
- (void)creatGroupSuccessToPushView:(NSNotification *)object{//group
    HPLog(@"Action - creatGroupSuccessToPushView - %@", object);
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (!self.isDBMigrating) {
        [self getConversationList];
    } else {
        HPLog(@"is DBMigrating don't get allconversations");
        [HPProgressHUD alertMessage:@"正在升级数据库"];
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    }
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
    [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    HPLog(@"Action -- onGroupInfoChanged");
    [self getConversationList];
}

- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
                         offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages {
    HPLog(@"Action -- onSyncOfflineMessageConversation:offlineMessages:");
    
        [self getConversationList];
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation {
    HPLog(@"Action -- onSyncRoamingMessageConversation:");
    
    [self getConversationList];
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
    [self.chatTableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    HPLog(@"Action - viewDidAppear");
    [super viewDidAppear:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    HPLog(@"Action - viewDidDisappear");
    [super viewDidDisappear:YES];
}

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
            [self.chatTableView reloadData];
            HPLog(@"get allConversation -- end");
            self->isGetingAllConversation = NO;
            [self checkCacheGetAllConversationAction];
        });
    }];
}
- (void)checkCacheGetAllConversationAction {
    if (cacheCount > 0) {
        HPLog(@"is have cache ,once again get all conversation");
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
        [btn setFrame:CGRectMake(10, i*30+30, 80, 30)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setBackgroundImage:[ViewUtil colorImage:kBubbleBtnColor frame:btn.frame] forState:UIControlStateHighlighted];
        [self.addBgView addSubview:btn];
    }
}

- (void)btnClick :(UIButton *)btn {
    [self.addBgView setHidden:YES];
    if (btn.tag == 100) {
        JCHATSelectFriendsCtl *selectCtl =[[JCHATSelectFriendsCtl alloc] init];
        UINavigationController *selectNav =[[UINavigationController alloc] initWithRootViewController:selectCtl];
        [self.navigationController presentViewController:selectNav animated:YES completion:nil];
    } else if (btn.tag == 101) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加聊天对象"
                                                          message:@"输入对方的用户名!"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle =UIAlertViewStylePlainTextInput;
        [alerView show];
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1)
    {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {

            [HUD HUDWithString:@"请输入用户名"  Delay:1.0];
            return;
        }
        
        [[JCHATAlertViewWait ins] showInView];
        __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
        sendMessageCtl.superViewController = self;
        sendMessageCtl.hidesBottomBarWhenPushed = YES;
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        [HUD HUDNotHidden:@"正在添加用户..."];

        kWEAKSELF
        [JMSGConversation createSingleConversationWithUsername:[alertView textFieldAtIndex:0].text appKey:JPushAppKey completionHandler:^(id resultObject, NSError *error) {
            
            [[JCHATAlertViewWait ins] hidenAll];
            
            if (error == nil) {
                kSTRONGSELF
                sendMessageCtl.conversation = resultObject;
                
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
                [HUD HUDHidden];
            } else {
                HPLog(@"createSingleConversationWithUsername fail");
                [HUD HUDWithString:@"添加的用户不存在" Delay:2.0];

            }
        }];
    }
}

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

- (void)perFormAdd {
    
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    [self.addBgView setHidden:YES];
    _rightBarButton.selected=NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HPLog(@"Action - tableView");
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username appKey:JPushAppKey
         ];
    } else {
        [JMSGConversation deleteGroupConversationWithGroupId:((JMSGGroup *)conversation.target).gid];
    }
    
    [_conversationArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_conversationArr count] > 0) {
        return [_conversationArr count];
    } else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JCHATConversationListCell";
    JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    [cell setCellDataWithConversation:conversation];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar {
    
}

//响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_conversationArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    sendMessageCtl.superViewController = self;
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    sendMessageCtl.conversation = conversation;
//    self.isPop = YES;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendMessageCtl];
    [self.navigationController pushViewController:sendMessageCtl animated:YES];
//    [self.navigationController presentViewController:nav animated:YES completion:NULL];
    
    NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
    [self saveBadge:badge];
}

- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:@"badge"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Via Jack Lucky
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar {
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}


@end
