//
//  testViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/17.
#import "HPMyCardController.h"
#import "YYGestureRecognizer.h"
#import "HPShareListCell.h"
#import "HPShareListModel.h"
#import "HPCardHeaderView.h"
#import "HPCardDetailsModel.h"
#import "UIButton+WebCache.h"
#import "UIScrollView+Refresh.h"
#import "HPGlobalVariable.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//虚假的悬浮效果
static CGFloat floatViewHeight = 62.f;

static CGFloat navHeitht = 64;
// 这个系数根据自己喜好设置大小，=屏幕视图滑动距离/手指滑动距离
#define  moveScale 2

typedef NS_ENUM(NSInteger, HPMyCardType) {
    HPMyCardTypeEdit = 20,
    HPMyCardTypeFocus,
    HPMyCardTypeCancelFocus,
};

@interface HPMyCardController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,YYLRefreshNoDataViewDelegate>
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

@end

@implementation HPMyCardController
static NSString *shareListCell = @"shareListCell";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取 共享发布数据
    [self getShareListData];
    HPShareListModel *model = self.param[@"model"];
    if ([model.userId intValue]) {//非自己
        [self getCardInfoDetails:model];
        
    }else{//自己
        HPLoginModel *account = [HPUserTool account];
        NSDictionary *dic = (NSDictionary *)account.cardInfo;
        NSDictionary *userdic = (NSDictionary *)account.userInfo;
        
        NSString *company = dic[@"company"];
        NSString *title = dic[@"title"];
        NSString *signature = dic[@"signature"];
        NSString *mobile = userdic[@"mobile"];
        
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
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *userdic =(NSDictionary *)account.userInfo;
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
//    [self setupNavigationBarWithTitle:@"我的名片"];
    
    // 有导航最上部视图是scrollview 内部空间位置会下移，设置这个属性后不下移。
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIScrollView  *scroll = [[UIScrollView alloc]init];
    scroll.backgroundColor = COLOR_GRAY_F6F6F6;
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);

    }];
    self.scroll = scroll;
    
    
    //根据需求设置tableview的y值 暂写scroll高的2分之一
    self.tableFrameY = getWidth(480.f);//self.scroll.frame.size.height/2;
    
    [self setupUI];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = UIColor.whiteColor;
    [self.scroll addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(476.f));
        make.bottom.equalTo(self.scroll);
    }];

    UILabel *shareLabel = [UILabel new];
    shareLabel.text = @"共享发布";
    [shareLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [shareLabel setTextColor:COLOR_BLACK_333333];
    [topView addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(getWidth(20.f));
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.height.mas_equalTo(shareLabel.font.pointSize);
    }];
    
    UITableView *insetTable = [[UITableView alloc]init];
    insetTable.dataSource = self;
    insetTable.delegate = self;
    [insetTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [insetTable registerClass:HPShareListCell.class forCellReuseIdentifier:shareListCell];
    [topView addSubview:insetTable];
    [insetTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(topView);
        make.top.equalTo(shareLabel.mas_bottom).with.offset(getWidth(20.f));
        make.bottom.equalTo(topView);
        
    }];
    self.insetTableView = insetTable;
    
    //github搜索 yykit 或yytext 里面有 yygestureRecognizer这个类，这个类需要做一些修改，    // 在yygesture中所有触摸事件方法里 加上super的方法，原文件里没有，否则响应链条终端，scroll或tablew的按钮点击事件不执行。
    //这个类原文件继承于UIGestureRecognizer， 改为继承于UIPanGestureRecognizer 否则点击事件不执行。
    //运行效果详见我的demo
    
    YYGestureRecognizer *yyges = [YYGestureRecognizer new];
    yyges.action = ^(YYGestureRecognizer *gesture, YYGestureRecognizerState state){
        if (state != YYGestureRecognizerStateMoved) return ;
        
        if (CGRectContainsPoint(self.insetTableView.frame, gesture.startPoint)) {
            
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
}

//解决手势按钮冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //如果是 segment或scroll上的其他按钮，取消手势
    if([NSStringFromClass(touch.view.superclass) isEqualToString:@"UIControl"]){
        return NO;
    }
    
    
    //
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
        scrolly =  -(gesture.currentPoint.y-gesture.lastPoint.y) ;
    }
    self.scrollStartY = gesture.startPoint.y;
    
    self.scrollY += scrolly*moveScale;
    
    //如果滑到了scroll的底部就不要滑了
    if (self.scrollY> self.scroll.contentSize.height-self.insetTableView.bounds.size.height-floatViewHeight){
        self.scrollY = self.scroll.contentSize.height-self.insetTableView.bounds.size.height-floatViewHeight;
        //如果scrollview意外的contentsize 小于自己的大小，scrollview就不要滑了
        if (self.scrollY<0) {
            self.scrollY = 0;
        }
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

#pragma mark - OnClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_GRAY_F6F6F6];
    HPCardHeaderView *headerView = [[HPCardHeaderView alloc] init];
    [self.scroll addSubview:headerView];
    self.headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.scroll);
        make.height.mas_equalTo(getWidth(488.f));
    }];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"my_business_card_background_map"]];
    [headerView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(headerView);
        make.top.equalTo(headerView).with.offset(-g_statusBarHeight);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back"]];
    [headerView addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(25.f * g_rateWidth);
        make.top.equalTo(headerView).with.offset(g_statusBarHeight);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.top.mas_equalTo(headerView).offset(g_statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"我的名片"];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.centerY.equalTo(backIcon);
    }];
    
    UIView *cardPanel = [[UIView alloc] init];
    [cardPanel.layer setCornerRadius:5.f];
    [cardPanel.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [cardPanel.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [cardPanel.layer setShadowOpacity:0.07f];
    [cardPanel.layer setShadowRadius:16.f];
    [cardPanel setBackgroundColor:UIColor.whiteColor];
    [headerView addSubview:cardPanel];
    _cardPanel = cardPanel;
    [cardPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backIcon.mas_bottom).with.offset(33.f * g_rateWidth);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 215.f * g_rateWidth));
    }];
    [self setupCardPanel:cardPanel];
    
    UIView *infoRegion = [[UIView alloc] init];
    [infoRegion.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [infoRegion.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [infoRegion.layer setShadowOpacity:0.07f];
    [infoRegion.layer setShadowRadius:16.f];
    [infoRegion setBackgroundColor:UIColor.whiteColor];
    [headerView addSubview:infoRegion];
    [infoRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(headerView);
        make.top.equalTo(cardPanel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(225.f * g_rateWidth);
    }];
    [self setupInfoRegion:infoRegion];
    
    
    [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(infoRegion.mas_bottom);
        make.width.equalTo(self.view);
        make.left.top.right.mas_equalTo(self.scroll);
    }];
    
}

- (void)setupCardPanel:(UIView *)view {
    
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *userdic = (NSDictionary *)account.cardInfo;
    NSString *avatarUrl = userdic[@"avatarUrl"];
    UIButton *portraitView = [[UIButton alloc] init];
    [portraitView.layer setCornerRadius:getWidth(63.f) * 0.5];
    [portraitView.layer setMasksToBounds:YES];
    if (avatarUrl.length == 0) {
        [portraitView setBackgroundImage:ImageNamed(@"personal_center_not_login_head") forState:UIControlStateNormal];
    }else{
        [portraitView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal];
    }
    [view addSubview:portraitView];
    _portraitView = portraitView;
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(17.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(getWidth(63.f), getWidth(63.f)));
    }];
    
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    [phoneNumLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [phoneNumLabel setTextColor:COLOR_BLACK_333333];
    phoneNumLabel.text = userdic[@"telephone"];
    [view addSubview:phoneNumLabel];
    _phoneNumLabel = phoneNumLabel;
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitView.mas_right).with.offset(13.f * g_rateWidth);
        make.top.equalTo(portraitView).with.offset(12.f * g_rateWidth);
        make.height.mas_equalTo(phoneNumLabel.font.pointSize);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [companyLabel setTextColor:COLOR_BLACK_666666];
    [view addSubview:companyLabel];
    _companyLabel = companyLabel;
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumLabel);
        make.bottom.equalTo(portraitView.mas_bottom).with.offset(-11.f * g_rateWidth);
        make.height.mas_equalTo(phoneNumLabel.font.pointSize);
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.layer setCornerRadius:9.f];
    [editBtn.layer setMasksToBounds:YES];
    [editBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:10.f]];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    HPShareListModel *model = self.param[@"model"];
    _model = model;
    
    if ([model.userId intValue] == [userdic[@"userId"] intValue]) {
        [editBtn setTitle:@"编辑名片" forState:UIControlStateNormal];
        [editBtn setTag:HPMyCardTypeEdit];
        [editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        if(!_cardDetailsModel.fans){
            [editBtn setTitle:@"关注" forState:UIControlStateNormal];
            [editBtn setTag:HPMyCardTypeFocus];
            self.method = @"/v1/fans/add";
            [editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if(_cardDetailsModel.fans){
            [editBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [editBtn setTag:HPMyCardTypeCancelFocus];
            self.method = @"/v1/fans/cancel";
            [editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    [editBtn setBackgroundColor:COLOR_RED_FF3455];
    [view addSubview:editBtn];
    self.editBtn = editBtn;
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(8.f);
        make.centerY.equalTo(phoneNumLabel);
        make.size.mas_equalTo(CGSizeMake(55.f, 19.f));
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portraitView.mas_bottom).with.offset(18.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(301.f * g_rateWidth, 1.f));
    }];
    
    UIImageView *signatureIcon = [[UIImageView alloc] init];
    [signatureIcon setImage:[UIImage imageNamed:@"my_business_card_leaf"]];
    [view addSubview:signatureIcon];
    [signatureIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.top.equalTo(line.mas_bottom).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(getWidth(13.f), getWidth(13.f)));
    }];
    
    UILabel *signatureLabel = [[UILabel alloc] init];
    [signatureLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [signatureLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:signatureLabel];
    _signatureLabel = signatureLabel;
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureIcon.mas_right).with.offset(8.f);
        make.centerY.equalTo(signatureIcon);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setNumberOfLines:0];
    [view addSubview:descLabel];
    _descLabel = descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureLabel);
        make.top.equalTo(signatureIcon.mas_bottom).with.offset(15.f * g_rateWidth);
        make.width.mas_equalTo(271.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(- 10.f * g_rateWidth);
    }];
}
#pragma mark - 关注某人
- (void)focusSBToFansList:(UIButton *)button
{
    if (button.tag == HPMyCardTypeEdit) {
        [self pushVCByClassName:@"HPEditPersonOInfoController"];
    }else {
        HPShareListModel *model = self.param[@"model"];
        HPLoginModel *account = [HPUserTool account];
        NSDictionary *dic = (NSDictionary *)account.userInfo;
        
        if (model) {//只有是非自己的信息界面传入的model不为空，才会调用关注接口
            [HPHTTPSever HPPostServerWithMethod:_method paraments:@{@"userId":dic[@"userId"],@"followedId":model.userId} needToken:YES complete:^(id  _Nonnull responseObject) {
                if (CODE == 200) {
                    [HPProgressHUD alertMessage:MSG];
                    HPShareListModel *model = self.param[@"model"];
                    [self getCardInfoDetails:model];
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
- (void)getCardInfoDetails:(HPShareListModel *)model
{
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *userdic = (NSDictionary *)account.userInfo;
    NSMutableDictionary *detaildic = [NSMutableDictionary dictionary];
    detaildic[@"followedId"] = model.userId;
    detaildic[@"userId"] = userdic[@"userId"];
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/cardDetails" isNeedToken:YES paraments:detaildic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.cardDetailsModel = [HPCardDetailsModel mj_objectWithKeyValues:responseObject[@"data"][@"cardInfo"]];
            [self.phoneNumLabel setText:self.cardDetailsModel.telephone.length >0 ?self.cardDetailsModel.telephone:@"未填写"];
            [self.companyLabel setText:self.cardDetailsModel.company.length >0 ?self.cardDetailsModel.company:@"未填写"];
            [self.descLabel setText:self.cardDetailsModel.signature.length >0 ?self.cardDetailsModel.signature:@"未填写"];
            [self.signatureLabel setText:self.cardDetailsModel.title.length > 0?self.cardDetailsModel.title:@"未填写"];
            [self.portraitView sd_setImageWithURL:[NSURL URLWithString:self.cardDetailsModel.avatarUrl.length >0?self.cardDetailsModel.avatarUrl:userdic[@"avatarUrl"]] forState:UIControlStateNormal];
            if(!self.cardDetailsModel.fans){
                [self.editBtn setTitle:@"关注" forState:UIControlStateNormal];
                self.method = @"/v1/fans/add";
                [self.editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if(self.cardDetailsModel.fans){
                [self.editBtn setTitle:@"已关注" forState:UIControlStateNormal];
                self.method = @"/v1/fans/cancel";
                [self.editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
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

@end

