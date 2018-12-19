//
//  testViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/17.
#import "HPMyCardController.h"
#import "YYGestureRecognizer.h"
#import "HPShareListCell.h"
#import "HPCardHeaderView.h"
#import "HPCardDetailsModel.h"
#import "UIButton+WebCache.h"
#import "UIScrollView+Refresh.h"
#import "HPGlobalVariable.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//虚假的悬浮效果
static CGFloat floatViewHeight = 62.f;

// 这个系数根据自己喜好设置大小，=屏幕视图滑动距离/手指滑动距离
#define  moveScale 3

@interface HPMyCardController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,YYLRefreshNoDataViewDelegate,HPCardHeaderViewDelegate>
@property (nonatomic,weak)UIScrollView *scroll;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic,strong) UITableView *insetTableView;
@property (nonatomic,assign)CGFloat tableY;
@property (nonatomic,assign)CGFloat tableStartY;
@property (nonatomic,assign)CGFloat scrollY;
@property (nonatomic,assign)CGFloat scrollStartY;

//tableview 的y值 在scrollview中的位置
@property (nonatomic,assign)CGFloat tableFrameY;

@property (strong, nonatomic) UIView *cardPanel;
@property (nonatomic, weak) UIButton *portraitView;

@property (nonatomic, weak) UILabel *phoneNumLabel;

@property (nonatomic, weak) UILabel *companyLabel;

@property (nonatomic, weak) UILabel *signatureLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) CGRect tableRect;
/**
 当前model.userId
 */
@property (nonatomic, strong) HPShareListModel *model;

/**
 关注/取消关注
 */
@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong) HPCardDetailsModel *cardDetailsModel;
@property (strong, nonatomic) HPCardHeaderView *headerView;
@property (strong, nonatomic) UIView *releaseRegion;
@property (nonatomic, strong) UIView *topView;

@end

@implementation HPMyCardController
static NSString *shareListCell = @"shareListCell";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取 共享发布数据
    [self getShareListData];
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *dic = (NSDictionary *)account.cardInfo;
    NSDictionary *userdic = (NSDictionary *)account.userInfo;
    
    NSString *company = dic[@"company"];
    NSString *title = dic[@"title"];
    NSString *signature = dic[@"signature"];
    NSString *mobile = userdic[@"mobile"];
    NSString *myUserId = userdic[@"userId"];

    NSString *userId = self.param[@"userId"];
    if (userId && [userId intValue] != [myUserId intValue]) {//非自己
        [self getCardInfoDetailByUserId:userId];
        
    }else{//自己
        
        [_phoneNumLabel setText:mobile.length >0 ?mobile:@"未填写"];
        [_companyLabel setText:company.length >0 ?company:@"未填写"];
        [_signatureLabel setText:signature.length >0 ?signature:@"未填写"];
        _descLabel.text = dic[@"signature"];
        [_signatureLabel setText:title.length > 0?title:@"未填写"];
        [self.editBtn setTitle:@"编辑名片" forState:UIControlStateNormal];
        [self.editBtn setTag:HPMyCardTypeEdit];
    }

}

#pragma mark - 共享发布数据

- (void)getShareListData {
    NSString *areaId = nil;
    NSString *districtId = nil; //街道筛选，属于区下面的
    NSString *industryId = nil; //行业筛选，一级行业
    NSString *subIndustryId = nil; //行业筛选，二级行业
    NSString *page = @"0";
    NSString *pageSize = @"20";
    NSString *createTimeOrderType = @"0"; //发布时间排序，1升序，0降序
    NSString *rentOrderType = @"0"; //租金排序排序，1升序，0降序
    NSString *type = nil; //类型筛选，1业主， 2创客
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"areaId"] = areaId;
    param[@"districtId"] = districtId;
    param[@"industryId"] = industryId;
    param[@"subIndustryId"] = subIndustryId;
    param[@"page"] = page;
    param[@"pageSize"] = pageSize;
    param[@"createTimeOrderType"] = createTimeOrderType;
    param[@"rentOrderType"] = rentOrderType;
    param[@"type"] = type;
    param[@"userId"] = @"6";//userdic[@"21"];
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:YES paraments:param complete:^(id  _Nonnull responseObject) {
        [self.dataArray removeAllObjects];
        weakSelf.dataArray = [HPShareListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if ([responseObject[@"data"][@"total"] integerValue] == 0 || weakSelf.dataArray.count == 0) {
            self.insetTableView.loadErrorType = YYLLoadErrorTypeNoData;
            self.insetTableView.refreshNoDataView.tipImageView.image = ImageNamed(@"empty_list_collect");
            self.insetTableView.refreshNoDataView.tipLabel.text = @"共享发布孤单很久了，快去逛逛吧！";
            self.insetTableView.refreshNoDataView.delegate = self;
            self.insetTableView.scrollsToTop = YES;
            self.insetTableView.hidden = YES;
        }
        if ([weakSelf.dataArray count] < 10) {
//            [self.insetTableView reloadData];

            [self.insetTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.insetTableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 有导航最上部视图是scrollview 内部空间位置会下移，设置这个属性后不下移。
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIScrollView  *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scroll.backgroundColor = COLOR_GRAY_F6F6F6;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    
    
    //根据需求设置tableview的y值 暂写scroll高的2分之一
    self.tableFrameY = getWidth(480.f);//self.scroll.frame.size.height/2;
    
    [self.view setBackgroundColor:COLOR_GRAY_F6F6F6];
    HPCardHeaderView *headerView = [[HPCardHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, getWidth(540.f)) withUserId:self.param[@"userId"]];

    [self.scroll addSubview:headerView];
    headerView.delegate = self;
    self.headerView = headerView;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame) + getWidth(15.f), kScreenWidth, getWidth(476.f))];
    topView.backgroundColor = COLOR_GRAY_FFFFFF;
    [self.scroll addSubview:topView];
    _topView = topView;
    
    UILabel *shareLabel = [[UILabel alloc] init];
    shareLabel.text = @"共享发布";
    shareLabel.frame = CGRectMake(getWidth(20.f), getWidth(20.f), kScreenWidth - getWidth(40.f), shareLabel.font.pointSize);
    [shareLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [shareLabel setTextColor:COLOR_BLACK_333333];
    [topView addSubview:shareLabel];
    
    UITableView *insetTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareLabel.frame) + getWidth(20.f), kScreenWidth, getWidth(476.f))];
    insetTable.dataSource = self;
    insetTable.delegate = self;
    [insetTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [insetTable registerClass:HPShareListCell.class forCellReuseIdentifier:shareListCell];
    [topView addSubview:insetTable];
    self.insetTableView = insetTable;
    
    //github搜索 yykit 或yytext 里面有 yygestureRecognizer这个类，这个类需要做一些修改，    // 在yygesture中所有触摸事件方法里 加上super的方法，原文件里没有，否则响应链条终端，scroll或tablew的按钮点击事件不执行。
    //这个类原文件继承于UIGestureRecognizer， 改为继承于UIPanGestureRecognizer 否则点击事件不执行。
    //运行效果详见我的demo
    
    YYGestureRecognizer *yyges = [YYGestureRecognizer new];
    yyges.action = ^(YYGestureRecognizer *gesture, YYGestureRecognizerState state){
        if (state != YYGestureRecognizerStateMoved) return ;
        
        if (CGRectContainsPoint(topView.frame, gesture.startPoint)) {
            //滑动tableview
            [self tableScrollWithGesture:gesture];
        }else{
            //滑动scrollview
            [self scrollScrollWithGesture:gesture];
        }
        
    };
    //必须给scroll 加上手势  不要给view加，不然滑动tablew的时候会错误判断去滑动scroll。
    [self.scroll addGestureRecognizer:yyges];
    
    //实现手势代理，解决交互冲突
    yyges.delegate = self;
    self.scroll.contentSize = CGSizeMake(kScreenWidth,(CGRectGetMaxY(topView.frame) + CGRectGetMaxY(headerView.frame)) - kScreenHeight);
}

//解决手势按钮冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //如果是 segment或scroll上的其他按钮，取消手势
    if([NSStringFromClass(touch.view.superclass) isEqualToString:@"UIControl"]){
        return NO;
    }
    return YES;
}

- (void)tableScrollWithGesture:(YYGestureRecognizer *)gesture{
    CGFloat scrolly;
    
    if (self.tableStartY != gesture.startPoint.y) {
        scrolly = -(gesture.currentPoint.y-gesture.startPoint.y) ;
    }else{
        scrolly =  -(gesture.currentPoint.y-gesture.lastPoint.y) ;
    }
    self.tableStartY = gesture.startPoint.y;
    
    self.tableY += scrolly*moveScale;
    
    //为了显示底部超出屏幕的tableview那部分 滑动scrollview 此时tablewview已经滑动到了底部
    if (self.tableY> self.insetTableView.contentSize.height-self.insetTableView.bounds.size.height){
        self.scrollY += self.tableY-(self.insetTableView.contentSize.height-self.insetTableView.bounds.size.height);
        
        //tablewview滑动到底部就不要滑了
        self.tableY = self.insetTableView.contentSize.height-self.insetTableView.bounds.size.height;
        
        //scrollview 滑动到了底部就不要滑动了
        if (self.scrollY> self.scroll.contentSize.height-self.insetTableView.bounds.size.height-floatViewHeight){
            self.scrollY = self.scroll.contentSize.height-self.insetTableView.bounds.size.height-floatViewHeight;
            //如果scrollview意外的contentsize 小于自己的大小，scrollview就不要滑了
            if (self.scrollY<0) {
                self.scrollY = 0;
            }
            
        }
        [self.scroll setContentOffset:CGPointMake(0, self.scrollY) animated:YES];
        
        //如果tablewview的cell过少或行高过少致使其contentsize 小于自己的大小，tableview就不要滑了
        if (self.tableY<0) {
            self.tableY = 0;
        }
        
    }
    
    
    //如果滑到了tableview的最上部，停止滑动tablewview,  如果此时scrollview 没有在最上部就滑动scrollview到最上部
    if (self.tableY<0){
        self.scrollY += self.tableY;
        
        //scroll已经在最上部了，scroll就不滑了
        if (self.scrollY<0) {
            self.scrollY = 0;
        }
        
        NSLog(@"scroll  %lf",self.scrollY);
        [self.scroll setContentOffset:CGPointMake(0, self.scrollY) animated:YES];
        
        //停止滑动tablewview
        self.tableY = 0;
        
    }
    NSLog(@"table  %lf",self.tableY);
    
    [self.insetTableView setContentOffset:CGPointMake(0, self.tableY) animated:YES];
}
- (void)scrollScrollWithGesture:(YYGestureRecognizer *)gesture{
    CGFloat scrolly;
    
    if (self.scrollStartY != gesture.startPoint.y) {
        scrolly = -(gesture.currentPoint.y-gesture.startPoint.y) ;
    }else{
        scrolly =  -(gesture.currentPoint.y-gesture.startPoint.y) ;
    }
    self.scrollStartY = gesture.startPoint.y;
    
    self.scrollY += scrolly;//>0?scrolly*moveScale:0;//;
    CGFloat scrollH = self.scroll.contentSize.height-self.insetTableView.bounds.size.height-floatViewHeight;
    //如果滑到了scroll的底部就不要滑了
    if (self.scrollY>= scrollH){
        self.scrollY = scrollH;//-(self.scroll.contentSize.height-self.insetTableView.bounds.size.height-floatViewHeight);
        //如果scrollview意外的contentsize 小于自己的大小，scrollview就不要滑了
        if (self.scrollY<0) {
            self.scrollY = 0;
        }
    }else{
        self.scrollY += scrolly>0?scrolly*moveScale:0;
    }
    //如果滑到了scroll顶部就不要滑了
    if (self.scrollY<0){
        self.scrollY = 0;
    }
    NSLog(@"scroll  %lf",self.scrollY);
    
    
    [self.scroll setContentOffset:CGPointMake(0, self.scrollY) animated:YES];
    
}

#pragma mark - 展示tableview的代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 137.f * g_rateWidth;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:shareListCell];
    HPShareListModel *model = _dataArray[indexPath.row];
    cell.model = model;
    if (cell == nil) {
        cell = [[HPShareListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareListCell];
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//这个方法不可用了，除非点击了cellcontenview之外的区域 只能同过加按钮的方式接受点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld行",indexPath.row);
}

#pragma mark - 返回上一个界面
- (void)clickBackButtonBackToMyContoller
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 关注某人
- (void)clickButtonInCardHeaderView:(HPCardHeaderView *)CardHeaderView focusSBToFansList:(HPShareListModel *)model andCardType:(HPMyCardType)cardType
{
    if (cardType == HPMyCardTypeEdit) {
        [self pushVCByClassName:@"HPEditPersonOInfoController"];
    }else {
        NSString *userId = self.param[@"userId"];
        HPLoginModel *account = [HPUserTool account];
        NSDictionary *dic = (NSDictionary *)account.userInfo;
        NSString *myUserId = dic[@"userId"];
        if ([userId intValue] != [myUserId intValue]) {//只有是非自己的信息界面传入的model不为空，才会调用关注接口
            [HPHTTPSever HPPostServerWithMethod:_headerView.method paraments:@{@"userId":myUserId,@"followedId":userId} needToken:YES complete:^(id  _Nonnull responseObject) {
                if (CODE == 200) {
                    [HPProgressHUD alertMessage:MSG];
                    NSString *userId = self.param[@"userId"];
                    [self getCardInfoDetailByUserId:userId];
                }else{
                    [HPProgressHUD alertMessage:MSG];
                }
            } Failure:^(NSError * _Nonnull error) {
                ErrorNet
            }];
        }
    }
    
    
}

#pragma mark - 获取卡片详情
- (void)getCardInfoDetailByUserId:(NSString *)userId
{
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *userdic = (NSDictionary *)account.userInfo;
    NSMutableDictionary *detaildic = [NSMutableDictionary dictionary];
    detaildic[@"followedId"] = userId;
    detaildic[@"userId"] = userdic[@"userId"];
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/cardDetails" isNeedToken:YES paraments:detaildic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.cardDetailsModel = [HPCardDetailsModel mj_objectWithKeyValues:responseObject[@"data"][@"cardInfo"]];
            [self.headerView.phoneNumLabel setText:self.cardDetailsModel.telephone.length >0 ?self.cardDetailsModel.telephone:@"未填写"];
            [self.headerView.companyLabel setText:self.cardDetailsModel.company.length >0 ?self.cardDetailsModel.company:@"未填写"];
            [self.headerView.descLabel setText:self.cardDetailsModel.signature.length >0 ?self.cardDetailsModel.signature:@"未填写"];
            [self.headerView.signatureLabel setText:self.cardDetailsModel.title.length > 0?self.cardDetailsModel.title:@"未填写"];
            [self.headerView.portraitView sd_setImageWithURL:[NSURL URLWithString:self.cardDetailsModel.avatarUrl.length >0?self.cardDetailsModel.avatarUrl:userdic[@"avatarUrl"]] forState:UIControlStateNormal];
            
            if([self.cardDetailsModel.fans isEqualToString:@"0"]){
                [self.headerView.editBtn setTitle:@"关注" forState:UIControlStateNormal];
            }else if(self.cardDetailsModel.fans){
                [self.headerView.editBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet;
    }];
    
}
#pragma mark - 编辑个人信息界面
- (void)editPersonalInfo:(UIButton *)button
{
    [self pushVCByClassName:@"HPEditPersonOInfoController"];
}
- (void)setupInfoRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"认证信息"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UIControl *creditCtrl = [[UIControl alloc] init];
    [creditCtrl.layer setBorderWidth:1.f];
    [creditCtrl.layer setBorderColor:COLOR_GRAY_EEEEEE.CGColor];
    [creditCtrl setBackgroundColor:UIColor.whiteColor];
    [view addSubview:creditCtrl];
    [creditCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 65.f * g_rateWidth));
    }];
    [self setupCreditCtrl:creditCtrl];
    
    UIControl *verifiedCtrl = [[UIControl alloc] init];
    [verifiedCtrl.layer setBorderWidth:1.f];
    [verifiedCtrl.layer setBorderColor:COLOR_GRAY_EEEEEE.CGColor];
    [verifiedCtrl setBackgroundColor:UIColor.whiteColor];
    [view addSubview:verifiedCtrl];
    [verifiedCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(creditCtrl.mas_bottom).with.offset(15.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 65.f * g_rateWidth));
    }];
    [self setupVerifiedCtrl:verifiedCtrl];
}

- (void)setupCreditCtrl:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:[UIImage imageNamed:@"my_business_card_sesame_credit"]];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"芝麻信用"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.left.equalTo(iconView.mas_right).with.offset(12.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setText:@"芝麻信用还未授权"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:@"select_the_arrow"]];
    [view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-23.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *gotoLabel = [[UILabel alloc] init];
    [gotoLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [gotoLabel setTextColor:COLOR_RED_FF3455];
    [gotoLabel setText:@"去授权"];
    [view addSubview:gotoLabel];
    [gotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left).with.offset(-6.f);
        make.centerY.equalTo(arrow);
    }];
}

- (void)setupVerifiedCtrl:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:[UIImage imageNamed:@"my_business_card_real_name_authentication"]];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"实名认证"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.left.equalTo(iconView.mas_right).with.offset(12.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setText:@"未实名认证"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:@"select_the_arrow"]];
    [view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-23.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *gotoLabel = [[UILabel alloc] init];
    [gotoLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [gotoLabel setTextColor:COLOR_RED_FF3455];
    [gotoLabel setText:@"去认证"];
    [view addSubview:gotoLabel];
    [gotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left).with.offset(-6.f);
        make.centerY.equalTo(arrow);
    }];
}

- (void)setupReleaseRegion{
    UIView *releaseRegion = [[UIView alloc] init];
    [releaseRegion setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:releaseRegion];
    [releaseRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(15.f * g_rateWidth);
        make.bottom.mas_equalTo(self.view);
    }];
    _releaseRegion = releaseRegion;
    UIView *titleRegion = [[UIView alloc] init];
    [titleRegion setBackgroundColor:UIColor.whiteColor];
    [releaseRegion addSubview:titleRegion];
    [titleRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).with.offset(15.f * g_rateWidth);
        make.left.and.width.equalTo(self.headerView);
        make.height.mas_equalTo(52.f * g_rateWidth);
    }];
    
    UILabel *shareLabel = [[UILabel alloc] init];
    [shareLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [shareLabel setTextColor:COLOR_BLACK_333333];
    [shareLabel setText:@"共享发布"];
    [titleRegion addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(releaseRegion).with.offset(21.f * g_rateWidth);
        make.centerY.mas_equalTo(titleRegion);
        make.height.mas_equalTo(shareLabel.font.pointSize);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView setBackgroundColor:COLOR_GRAY_F6F6F6];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [releaseRegion addSubview:tableView];
    _insetTableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(releaseRegion);
        make.top.equalTo(titleRegion.mas_bottom);
        make.bottom.equalTo(releaseRegion.mas_bottom).with.offset(-19.f * g_rateWidth);
    }];
}

//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    HPLog(@"scrollView:%f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y<=0) {
            [UIView animateWithDuration:0.5 animations:^{
                [self.releaseRegion mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(self.view);
                    make.top.mas_equalTo(self.headerView.mas_bottom).offset(15.f * g_rateWidth);
                    make.bottom.mas_equalTo(self.view);
                }];
            }];
            
        } else if (scrollView.contentOffset.y>0) {
            [UIView animateWithDuration:0.5 animations:^{
                [self.releaseRegion mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(self.view);
                    make.top.mas_equalTo(self.cardPanel.mas_top);
                }];
            }];
            
        }
}

@end

