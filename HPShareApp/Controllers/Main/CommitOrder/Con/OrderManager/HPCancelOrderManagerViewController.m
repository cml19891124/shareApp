#define carlenderhasOrderArrayName @"carlenderhasOrderArrayName"

#import "HPTimeString.h"

#import "HPCancelOrderManagerViewController.h"

#import "HOOrderListModel.h"

#import "HPAttributeLabel.h"

#import "HPRightImageButton.h"

#import "YZXCalendarView.h"

#import "YZXSelectDateViewController.h"

#import "YZXCalendarHelper.h"

#import "HPRentTimePicker.h"

#import "HPOrderInfoListView.h"

#import "HPPredictView.h"

#import "HPShareShopListController.h"

#import "JCHATAlertViewWait.h"

#import "JCHATConversationViewController.h"

#import "HPQuitOrderView.h"

#import "HPSingleton.h"

#import "HPCalenderView.h"

#define topaytimeout @"topaytimeout"
@interface HPCancelOrderManagerViewController ()<UITextFieldDelegate>

/**
 新订单的要求预订的日期
 */
@property (strong, nonatomic) NSMutableArray *orderNewArray;

@property (strong, nonatomic) NSMutableArray *orderArray;

@property (strong, nonatomic) NSMutableArray *hasOrderArray;

@property (nonatomic, copy) NSString *arriveTime;

@property (nonatomic, copy) NSString *leaveTime;

@property (nonatomic, strong) HPQuitOrderView *quitView;

@property (nonatomic, strong) HPOrderInfoListView *orderListView;

@property (nonatomic, strong) HPRentTimePicker *picker;

@property (nonatomic, strong) HPPredictView *predictView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

/**
 室内、室外
 */
@property (strong, nonatomic) UILabel *rentOutsideLabel;
/**
 剩余时间
 */
@property (nonatomic, strong) HPAttributeLabel *leftLabel;

@property (nonatomic, strong) UIView *storeInfoView;

@property (nonatomic, strong) UIImageView *storeView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *spaceInfoLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) HOOrderListModel *model;

@property (nonatomic, strong) UIView *rentInfoView;

@property (nonatomic, strong) UILabel *rentDaysLabel;

@property (nonatomic, strong) UIView *rentDaysView;

@property (nonatomic, strong) UILabel *rentStartDayLabel;

@property (nonatomic, strong) UIView *rentLineLabel;

@property (nonatomic, strong) UILabel *rentEndDayLabel;

@property (nonatomic, strong) UIButton *rentSelectDaysBtn;

@property (nonatomic, strong) HPAttributeLabel *inStoreDuringLabel;

@property (nonatomic, strong) UIView *inStoreDuringView;

@property (nonatomic, strong) UILabel *arrivalLabel;

@property (nonatomic, strong) UIView *inlineLabel;

@property (nonatomic, strong) UILabel *leaveLabel;

@property (nonatomic, strong) UIButton *duringBtn;

@property (nonatomic, strong) UIView *contactView;

@property (nonatomic, strong) UILabel *contactLabel;
//沟通
@property (nonatomic, strong) UIButton *communicateBtn;
//电话
@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UIView *contactInfoView;

@property (nonatomic, strong) UIButton *contactStarBtn;

@property (nonatomic, strong) UILabel *ownnerLabel;

@property (nonatomic, strong) UITextField *ownnerField;

@property (nonatomic, strong) UIView *phoneInfoView;

@property (nonatomic, strong) UIButton *phoneStarBtn;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) UIView *desView;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UITextField *desField;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) HPRightImageButton *priceListBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIImageView *cartView;

@property (nonatomic, strong) UILabel *predictLabel;

@property (nonatomic, strong) UILabel *confirmLabel;

@property (strong, nonatomic) NSArray *daysArray;

@property (nonatomic, strong) YZXCalendarView             *calendarView;

@property (nonatomic, assign) YZXTimeToChooseType         selectedType;
@property (nonatomic, copy) NSString             *startDate;
@property (nonatomic, copy) NSString             *endDate;

@property (nonatomic, strong) HPCalenderView *calenderView;

@property (strong, nonatomic) UIView *reasonView;

@property (strong, nonatomic) UILabel *reasonLabel;

@property (strong, nonatomic) UILabel *reasonSubLabel;

@end

@implementation HPCancelOrderManagerViewController

- (UIView *)reasonView
{
    if (!_reasonView) {
        _reasonView = [UIView new];
        _reasonView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _reasonView;
}

- (UILabel *)reasonLabel
{
    if (!_reasonLabel) {
        _reasonLabel = [UILabel new];
        _reasonLabel.text = @"拒绝原因:";
        _reasonLabel.textColor = COLOR_RED_FF2F46;
        _reasonLabel.font = kFont_Bold(14.f);
        _reasonLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _reasonLabel;
}

- (UILabel *)reasonSubLabel
{
    if (!_reasonSubLabel) {
        _reasonSubLabel = [UILabel new];
        _reasonSubLabel.text = @"前几天已经把场地租给别人啦，期待下次合作";
        _reasonSubLabel.textColor = COLOR_GRAY_666666;
        _reasonSubLabel.font = kFont_Medium(12.f);
        _reasonSubLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _reasonSubLabel;
}

- (HPCalenderView *)calenderView
{
    if (!_calenderView) {
        _calenderView = [HPCalenderView new];
        kWEAKSELF
        _calenderView.calenderBlock = ^(NSString *startDate, NSString *endDate, YZXTimeToChooseType selectedType) {
            weakSelf.rentStartDayLabel.text = startDate;
            if (endDate) {
                weakSelf.rentEndDayLabel.text = endDate;
            }else{
                weakSelf.rentLineLabel.hidden = YES;
                weakSelf.rentEndDayLabel.hidden = YES;
            }
        };
    }
    return _calenderView;
}


- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.hasOrderArray = [NSMutableArray array];
    
    [self getHasPredictOrderApi];
    
    [self.view addSubview:self.calenderView];
        
    [self.calenderView show:YES];
    
    if (self.orderNewArray.count) {
        [kNotificationCenter postNotificationName:carlenderhasOrderArrayName object:nil userInfo:@{@"array":self.orderNewArray}];
        
    }
}

#pragma mark - 获取已经预定的订单
- (void)getHasPredictOrderApi
{
    NSString *method = [NSString stringWithFormat:@"/v1/order/spaceId/%@/orderedDays",_model.order.spaceId];
    [HPHTTPSever HPGETServerWithMethod:method isNeedToken:YES paraments:@{@"spaceId":_model.order.spaceId?_model.order.spaceId:@""} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *orderArray = responseObject[@"data"];
            [self.hasOrderArray addObjectsFromArray:orderArray];
            
            [kNotificationCenter postNotificationName:carlenderhasOrderArrayName object:nil userInfo:@{@"array":self.hasOrderArray}];
            
            if (orderArray.count == 0) {
                HPLog(@"暂无已预订的数据");
            }
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orderArray = [NSMutableArray array];
    
    self.orderNewArray = [NSMutableArray array];

    [self.view setBackgroundColor:COLOR_GRAY_F9FAFD];
    
    //    [self setupNavigationBarWithTitle:@"提交订单"];
    self.model = self.param[@"model"];
    
    if (@available(iOS 11.0, *)) {
        
        self.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
    
    [self setUpCommitSubviews];
    
    [self setUpCommitSubviewsmasonry];
    
    [self loadData];
    
}

- (void)loadData
{
    [self.storeView sd_setImageWithURL:[NSURL URLWithString:_model.spaceDetail.picture.url] placeholderImage:ImageNamed(@"loading_logo_small")];
    
    self.nameLabel.text = [NSString stringWithFormat:@"拼租位置：%@",_model.spaceDetail.address];
    
    if (_model.spaceDetail.area && [_model.spaceDetail.area isEqualToString:@"0"]) {
        if ([_model.spaceDetail.areaRange intValue] == 1) {
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"不限"]];
        }else if ([_model.spaceDetail.areaRange intValue] == 2){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"小于5㎡"]];
        }else if ([_model.spaceDetail.areaRange intValue] == 3){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"5-10㎡"]];
        }else if ([_model.spaceDetail.areaRange intValue] == 4){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"10-20㎡"]];
        }else if ([_model.spaceDetail.areaRange intValue] == 5){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"20㎡以上"]];
        }else {
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:面议"]];
        }
    }
    else{
        [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:不限"]];
    }
    
    if (_model.spaceDetail.rentOutside.integerValue == 0) {
        [self.rentOutsideLabel setText:@"室外"];
    }else{
        [self.rentOutsideLabel setText:@"室内"];
        
    }
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",_model.spaceDetail.address];
    
    self.phoneField.text = _model.spaceDetail.contactMobile;
    
    self.phoneField.delegate = self;
    
    self.ownnerField.text = _model.spaceDetail.contact?_model.spaceDetail.contact:@"--";
    
    self.desField.text = _model.order.remark?_model.order.remark:@"--";
    
    self.desField.delegate = self;
    
    _daysArray = [_model.order.days componentsSeparatedByString:@","];
    
    [self p_sortingTheSelectedArray];
    
    NSString *start = self.daysArray.firstObject;
    NSString *end = self.daysArray.lastObject;
    NSArray * orderArray = [_model.order.days componentsSeparatedByString:@","];
    NSString *days = [NSString stringWithFormat:@"拼租日期(共%ld天)",orderArray.count];
    if (orderArray.count == 1) {
        self.rentStartDayLabel.text = [[HPTimeString noPortraitLineToDateStr:start] substringFromIndex:5];
        self.rentLineLabel.hidden = YES;
        self.rentEndDayLabel.hidden = YES;
    }else{
        self.rentStartDayLabel.text = [[HPTimeString noPortraitLineToDateStr:start] substringFromIndex:5];
        self.rentEndDayLabel.text = [[HPTimeString noPortraitLineToDateStr:end] substringFromIndex:5];
    }
    
    self.rentDaysLabel.text = days;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.model.order.totalFee];
    self.orderListView.model = self.model;
    if ([_model.order.openTime isEqualToString:@"0"]) {
        self.arrivalLabel.text = [NSString stringWithFormat:@"入店：00:00"];
    }else{
        self.arrivalLabel.text = [NSString stringWithFormat:@"入店：%@:%@",[_model.order.openTime substringToIndex:_model.order.openTime.length - 2],[_model.order.openTime substringFromIndex:_model.order.openTime.length - 2]];
    }
    
    if ([_model.order.closeTime isEqualToString:@"0"]) {
        self.leaveLabel.text = [NSString stringWithFormat:@"离店：00:00"];
    }else{
        self.leaveLabel.text = [NSString stringWithFormat:@"离店：%@:%@",[_model.order.closeTime substringToIndex:_model.order.closeTime.length - 2],[_model.order.closeTime substringFromIndex:_model.order.closeTime.length - 2]];
    }
    
    
    self.desField.text = self.model.order.remark?self.model.order.remark:@"--";
    NSArray *shareDays = [self.model.order.days componentsSeparatedByString:@","];
    [self.orderNewArray addObjectsFromArray:shareDays];
    
    if (_model.order.status.integerValue == 12 || _model.order.status.integerValue == 14) {//14，商家订单处理超时，默认商家拒绝
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            self.titleLabel.text = @"商家未同意接单";
        }else{
            self.titleLabel.text = @"订单已拒绝";

        }
        self.reasonLabel.text = @"拒绝原因";
        self.reasonSubLabel.text = _model.order.cancelReason?_model.order.cancelReason:@"--";
        [self.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    }else if (_model.order.status.integerValue == 13){
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            self.titleLabel.text = @"取消订单";
        }else{
            self.titleLabel.text = @"订单已取消";
            
        }
        self.reasonLabel.text = @"取消原因";
        self.reasonSubLabel.text = _model.order.cancelReason?_model.order.cancelReason:@"--";
        [self.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    }
    
}


//对选中的selectedArray中的数据排序
- (void)p_sortingTheSelectedArray
{
    if ([self.daysArray.firstObject compare:self.daysArray.lastObject] == NSOrderedDescending) {
        self.daysArray = [[[[self.daysArray copy] reverseObjectEnumerator] allObjects] mutableCopy];
    }
}

- (void)setUpCommitSubviews
{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.scrollView addSubview:self.reasonView];
    
    [self.reasonView addSubview:self.reasonLabel];

    [self.reasonView addSubview:self.reasonSubLabel];

    [self.scrollView addSubview:self.storeInfoView];
    
    [self.storeInfoView addSubview:self.storeView];
    
    [self.storeInfoView addSubview:self.nameLabel];
    
    [self.storeInfoView addSubview:self.locationLabel];
    
    [self.storeInfoView addSubview:self.rentOutsideLabel];
    
    [self.storeInfoView addSubview:self.spaceInfoLabel];
    
    [self.storeInfoView addSubview:self.addressLabel];
    
    [self.scrollView addSubview:self.rentInfoView];
    
    [self.rentInfoView addSubview:self.rentDaysLabel];
    
    [self.rentInfoView addSubview:self.rentDaysView];
    
    [self.rentDaysView addSubview:self.rentStartDayLabel];
    
    [self.rentDaysView addSubview:self.rentLineLabel];
    
    [self.rentDaysView addSubview:self.rentEndDayLabel];
    
    [self.rentDaysView addSubview:self.rentSelectDaysBtn];
    
    [self.rentInfoView addSubview:self.inStoreDuringLabel];
    
    [self.rentInfoView addSubview:self.inStoreDuringView];
    
    [self.inStoreDuringView addSubview:self.arrivalLabel];
    
    [self.inStoreDuringView addSubview:self.inlineLabel];
    
    [self.inStoreDuringView addSubview:self.leaveLabel];
    
    [self.inStoreDuringView addSubview:self.duringBtn];
    
    [self.scrollView addSubview:self.contactInfoView];
    
    [self.contactInfoView addSubview:self.contactLabel];
    //即时通讯按钮
    [self.contactInfoView addSubview:self.communicateBtn];
    
    [self.contactInfoView addSubview:self.contactView];
    
    [self.contactView addSubview:self.contactStarBtn];
    
    [self.contactView addSubview:self.ownnerLabel];
    
    [self.contactView addSubview:self.ownnerField];
    
    [self.contactInfoView addSubview:self.phoneInfoView];
    
    [self.phoneInfoView addSubview:self.phoneStarBtn];
    
    [self.phoneInfoView addSubview:self.phoneLabel];
    
    [self.phoneInfoView addSubview:self.phoneField];
    
    [self.phoneInfoView addSubview:self.phoneBtn];
    
    [self.scrollView addSubview:self.desView];
    
    [self.desView addSubview:self.desLabel];
    
    [self.desView addSubview:self.desField];
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.priceLabel];
    
    [self.bottomView addSubview:self.deleteBtn];
}

-(void)setUpCommitSubviewsmasonry
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-g_bottomSafeAreaHeight + getWidth(-60.f));
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(g_statusBarHeight+ 44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(getWidth(345.f));
        make.left.mas_equalTo(getWidth(15.f)); make.top.mas_equalTo(self.headerView.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(72.f));
    }];

    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.reasonLabel.font.pointSize);
    }];
    
    [self.reasonSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(self.reasonLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.reasonSubLabel.font.pointSize);
    }];
    
    [self.storeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.reasonView);
        make.left.mas_equalTo(getWidth(15.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(345.f), getWidth(115.f)));
        make.top.mas_equalTo(self.reasonView.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(85.f), getWidth(85.f)));
        make.centerY.mas_equalTo(self.storeInfoView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.storeView.mas_right).offset(getWidth(13.f));
        make.right.mas_equalTo(getWidth(-13.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
    }];
    
    CGFloat locW = BoundWithSize(self.locationLabel.text, kScreenWidth, 12.f).size.width;
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(locW); make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.locationLabel.font.pointSize);
    }];
    
    [self.rentOutsideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationLabel.mas_right);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.rentOutsideLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(30.f));
    }];
    
    [self.spaceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.locationLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.spaceInfoLabel.font.pointSize);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.spaceInfoLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.addressLabel.font.pointSize);
    }];
    
    [self.rentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.storeInfoView);
        make.top.mas_equalTo(self.storeInfoView.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(167.f));
    }];
    
    [self.rentDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(self.rentDaysLabel.font.pointSize);
    }];
    
    [self.rentDaysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.rentDaysLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(35.f));
    }];
    
    CGFloat rentStartW = BoundWithSize(self.rentStartDayLabel.text, kScreenWidth, 14.f).size.width;
    [self.rentStartDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.centerY.mas_equalTo(self.rentDaysView);
        make.height.mas_equalTo(self.rentStartDayLabel.font.pointSize);
        make.width.mas_equalTo(rentStartW);
    }];
    
    [self.rentLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rentStartDayLabel.mas_right).offset(getWidth(10.f));
        make.centerY.mas_equalTo(self.rentStartDayLabel);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(getWidth(15.f));
    }];
    
    [self.rentEndDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rentLineLabel.mas_right).offset(getWidth(10.f));
        make.centerY.mas_equalTo(self.rentDaysView);
        make.height.mas_equalTo(self.rentEndDayLabel.font.pointSize);
        make.width.mas_equalTo(self.rentStartDayLabel);
        
    }];
    
    [self.rentSelectDaysBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-10.f));
        make.centerY.mas_equalTo(self.rentDaysView);
        make.height.width.mas_equalTo(getWidth(18.f));
        
    }];
    
    [self.inStoreDuringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(self.rentDaysView.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.rentDaysLabel.font.pointSize);
        
    }];
    
    [self.inStoreDuringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.inStoreDuringLabel);
        make.top.mas_equalTo(self.inStoreDuringLabel.mas_bottom).offset(getWidth(12.f));
        make.height.mas_equalTo(getWidth(35.f));
        
    }];
    
    CGFloat instoreW = BoundWithSize(self.arrivalLabel.text, kScreenWidth, 14.f).size.width;
    
    [self.arrivalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.centerY.mas_equalTo(self.inStoreDuringView);
        make.width.mas_equalTo(instoreW);
        make.height.mas_equalTo(self.arrivalLabel.font.pointSize);
        
    }];
    
    [self.inlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.arrivalLabel.mas_right).offset(getWidth(20.f));
        make.centerY.mas_equalTo(self.inStoreDuringView);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(getWidth(15.f));
        
    }];
    
    [self.leaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inlineLabel.mas_right).offset(getWidth(20.f));
        make.centerY.mas_equalTo(self.inStoreDuringView);
        make.height.mas_equalTo(self.leaveLabel.font.pointSize);
        make.width.mas_equalTo(rentStartW);
        
    }];
    
//    [self.duringBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(getWidth(-10.f));
//        make.centerY.mas_equalTo(self.inStoreDuringView);
//        make.height.width.mas_equalTo(getWidth(18.f));
//    }];
    
    [self.contactInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.rentInfoView);
        make.top.mas_equalTo(self.rentInfoView.mas_bottom);
        make.height.mas_equalTo(getWidth(140.f));
    }];
    
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth/2);
        make.left.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.contactLabel.font.pointSize);
    }];
    
    [self.communicateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.centerY.mas_equalTo(self.contactLabel);
        make.height.mas_equalTo(getWidth(25.f));
    }];
    
    [self.contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(self.contactLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
    
    [self.contactStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(10.f));
        make.centerY.mas_equalTo(self.contactView);
        make.width.height.mas_equalTo(getWidth(7.f));
    }];
    
    [self.ownnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contactView).offset(getWidth(20.f));
        make.centerY.height.mas_equalTo(self.contactView);
        make.width.mas_equalTo(getWidth(50.f));
    }];
    
    [self.ownnerField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ownnerLabel.mas_right).offset(getWidth(18.f));
        make.right.centerY.height.mas_equalTo(self.contactView);
    }];
    
    [self.phoneInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.contactView);
        make.top.mas_equalTo(self.contactView.mas_bottom).offset(getWidth(10.f));
    }];
    
    [self.phoneStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(10.f));
        make.centerY.mas_equalTo(self.phoneInfoView);
        make.width.height.mas_equalTo(getWidth(7.f));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.ownnerLabel);
        make.centerY.mas_equalTo(self.phoneInfoView);
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(getWidth(15.f));
        make.centerY.mas_equalTo(self.phoneInfoView);
        make.right.mas_equalTo(getWidth(-13.f));
        
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.ownnerField);
        make.centerY.mas_equalTo(self.phoneInfoView);
        make.right.mas_equalTo(self.phoneBtn.mas_left);
        
    }];
    
    [self.desView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.rentInfoView);
        make.height.mas_equalTo(getWidth(45.f));        make.top.mas_equalTo(self.contactInfoView.mas_bottom).offset(getWidth(15.f));
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
        
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.desLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(60.f));
        make.centerY.mas_equalTo(self.desView);
    }];
    
    [self.desField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.desLabel.mas_right).offset(getWidth(15.f));
        make.height.mas_equalTo(self.desLabel.font.pointSize);
        make.right.mas_equalTo(self.desView);
        make.centerY.mas_equalTo(self.desView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(60.f));
        make.top.mas_equalTo(self.view).offset(kScreenHeight getWidth(-60.f));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(kScreenWidth/4);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView).offset(getWidth(-15.f));
        make.centerY.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(kScreenWidth/4);
        make.height.mas_equalTo(getWidth(30));
        
    }];

}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.image = ImageNamed(@"order_head");
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];
        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_GRAY_FFFFFF;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"待付款";
    }
    return _titleLabel;
}

- (UIView *)storeInfoView
{
    if (!_storeInfoView) {
        _storeInfoView = [UIView new];
        _storeInfoView.backgroundColor = COLOR_GRAY_FFFFFF;
        _storeInfoView.layer.cornerRadius = 2;
        _storeInfoView.layer.masksToBounds = YES;
    }
    return _storeInfoView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"小女当家场地拼租";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = kFont_Medium(14.f);
        _nameLabel.textColor = COLOR_BLACK_333333;
    }
    return _nameLabel;
}


- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.text = @"拼租位置：正门扶手梯旁";
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = kFont_Medium(12.f);
        _locationLabel.textColor = COLOR_GRAY_999999;
    }
    return _locationLabel;
}

- (UILabel *)rentOutsideLabel
{
    if (!_rentOutsideLabel) {
        _rentOutsideLabel = [UILabel new];
        _rentOutsideLabel.layer.cornerRadius = 2.f;
        _rentOutsideLabel.layer.masksToBounds = YES;
        _rentOutsideLabel.textColor = COLOR_GRAY_FFFFFF;
        _rentOutsideLabel.backgroundColor = COLOR_RED_EA0000;
        _rentOutsideLabel.font = kFont_Medium(12.f);
        _rentOutsideLabel.text = @"室内";
        _rentOutsideLabel.textAlignment = NSTextAlignmentCenter;
        _rentOutsideLabel.numberOfLines = 0;
        [_rentOutsideLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _rentOutsideLabel;
}

- (UILabel *)spaceInfoLabel
{
    if (!_spaceInfoLabel) {
        _spaceInfoLabel = [UILabel new];
        _spaceInfoLabel.text = @"场地规格：3*2（m²）";
        _spaceInfoLabel.textAlignment = NSTextAlignmentLeft;
        _spaceInfoLabel.font = kFont_Medium(12.f);
        _spaceInfoLabel.textColor = COLOR_GRAY_999999;
    }
    return _spaceInfoLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.text = @"地址：南山科苑兴兴四道科能大厦";
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.font = kFont_Medium(12.f);
        _addressLabel.textColor = COLOR_GRAY_999999;
    }
    return _addressLabel;
}

- (UIImageView *)storeView
{
    if (!_storeView) {
        _storeView = [UIImageView new];
        _storeView.image = ImageNamed(@"");
    }
    return _storeView;
}

- (UIView *)rentInfoView
{
    if (!_rentInfoView) {
        _rentInfoView = [UIView new];
        _rentInfoView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _rentInfoView;
}

- (UILabel *)rentDaysLabel
{
    if (!_rentDaysLabel) {
        _rentDaysLabel = [UILabel new];
        _rentDaysLabel.text = @"拼租日期（共3天）";
        _rentDaysLabel.textAlignment = NSTextAlignmentLeft;
        _rentDaysLabel.font = kFont_Medium(14.f);
        _rentDaysLabel.textColor = COLOR_BLACK_333333;
    }
    return _rentDaysLabel;
}

- (UIView *)rentDaysView
{
    if (!_rentDaysView) {
        _rentDaysView = [UIView new];
        _rentDaysView.backgroundColor = COLOR_GRAY_F9FAFD;
        _rentDaysView.layer.cornerRadius = 2.f;
        _rentDaysView.layer.masksToBounds = YES;
    }
    return _rentDaysView;
}

- (UILabel *)rentStartDayLabel
{
    if (!_rentStartDayLabel) {
        _rentStartDayLabel = [UILabel new];
        _rentStartDayLabel.text = @"请选择起始日期";
        _rentStartDayLabel.textAlignment = NSTextAlignmentCenter;
        _rentStartDayLabel.font = kFont_Regular(14.f);
        _rentStartDayLabel.textColor = COLOR_GRAY_CCCCCC;
    }
    return _rentStartDayLabel;
}

- (UIView *)rentLineLabel
{
    if (!_rentLineLabel) {
        _rentLineLabel = [UIView new];
        _rentLineLabel.backgroundColor = COLOR_GRAY_DCDCDC;
        
    }
    return _rentLineLabel;
}

- (UILabel *)rentEndDayLabel
{
    if (!_rentEndDayLabel) {
        _rentEndDayLabel = [UILabel new];
        _rentEndDayLabel.text = @"请选择结束日期";
        _rentEndDayLabel.textAlignment = NSTextAlignmentCenter;
        _rentEndDayLabel.font = kFont_Regular(14.f);
        _rentEndDayLabel.textColor = COLOR_GRAY_CCCCCC;
    }
    return _rentEndDayLabel;
}

- (UIButton *)rentSelectDaysBtn
{
    if (!_rentSelectDaysBtn) {
        _rentSelectDaysBtn = [UIButton new];
        [_rentSelectDaysBtn setBackgroundImage:ImageNamed(@"days_select") forState:UIControlStateNormal];
        [_rentSelectDaysBtn addTarget:self action:@selector(onClickSelectedDaysbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rentSelectDaysBtn;
}

- (HPAttributeLabel *)inStoreDuringLabel
{
    if (!_inStoreDuringLabel) {
        NSString *text = @"入离店时间 （每天拼租入店离店时间）";
        _inStoreDuringLabel = [HPAttributeLabel getTitle:text andFromFont:kFont_Medium(14.f) andToFont:kFont_Regular(12.f) andFromColor:COLOR_BLACK_333333 andToColor:COLOR_GRAY_999999 andFromRange:NSMakeRange(0, 5) andToRange:NSMakeRange(5, text.length - 5) andLineSpace:0.f andNumbersOfLine:0 andTextAlignment:NSTextAlignmentLeft andLineBreakMode:NSLineBreakByWordWrapping];
        
    }
    return _inStoreDuringLabel;
}

- (UIView *)inStoreDuringView
{
    if (!_inStoreDuringView) {
        _inStoreDuringView = [UIView new];
        _inStoreDuringView.backgroundColor = COLOR_GRAY_F9FAFD;
        _inStoreDuringView.layer.cornerRadius = 2.f;
        _inStoreDuringView.layer.masksToBounds = YES;
    }
    return _inStoreDuringView;
}

- (UILabel *)arrivalLabel
{
    if (!_arrivalLabel) {
        _arrivalLabel = [UILabel new];
        _arrivalLabel.text = @"入店：09:00";
        _arrivalLabel.textAlignment = NSTextAlignmentLeft;
        _arrivalLabel.font = kFont_Regular(14.f);
        _arrivalLabel.textColor = COLOR_GRAY_999999;
        
    }
    return _arrivalLabel;
}

- (UIView *)inlineLabel
{
    if (!_inlineLabel) {
        _inlineLabel = [UIView new];
        _inlineLabel.backgroundColor = COLOR_GRAY_DCDCDC;
        
    }
    return _inlineLabel;
}

- (UILabel *)leaveLabel
{
    if (!_leaveLabel) {
        _leaveLabel = [UILabel new];
        _leaveLabel.text = @"离店：18:00";
        _leaveLabel.textAlignment = NSTextAlignmentLeft;
        _leaveLabel.font = kFont_Regular(14.f);
        _leaveLabel.textColor = COLOR_GRAY_999999;
        
    }
    return _leaveLabel;
}

- (UIButton *)duringBtn
{
    if (!_duringBtn) {
        _duringBtn = [UIButton new];
        [_duringBtn setBackgroundImage:ImageNamed(@"during") forState:UIControlStateNormal];
        [_duringBtn addTarget:self action:@selector(onClickManagerTimesBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _duringBtn;
}

- (UIView *)contactInfoView
{
    if (!_contactInfoView) {
        _contactInfoView = [UIView new];
        _contactInfoView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _contactInfoView;
}

- (UILabel *)contactLabel
{
    if (!_contactLabel) {
        _contactLabel = [UILabel new];
        _contactLabel.text = @"联系人";
        _contactLabel.textAlignment = NSTextAlignmentLeft;
        _contactLabel.font = kFont_Medium(14.f);
        _contactLabel.textColor = COLOR_BLACK_333333;
    }
    return _contactLabel;
}

- (UIView *)contactView
{
    if (!_contactView) {
        _contactView = [UIView new];
        _contactView.backgroundColor = COLOR_GRAY_F9FAFD;
        _contactView.layer.cornerRadius = 2.f;
        _contactView.layer.masksToBounds = YES;
    }
    return _contactView;
}

- (UIButton *)contactStarBtn
{
    if (!_contactStarBtn) {
        _contactStarBtn = [UIButton new];
        [_contactStarBtn setTitle:@"*" forState:UIControlStateNormal];
        [_contactStarBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    }
    return _contactStarBtn;
}
- (UILabel *)ownnerLabel
{
    if (!_ownnerLabel) {
        _ownnerLabel = [UILabel new];
        _ownnerLabel.text = @"姓名:";
        _ownnerLabel.textAlignment = NSTextAlignmentLeft;
        _ownnerLabel.font = kFont_Regular(13.f);
        _ownnerLabel.textColor = COLOR_BLACK_333333;
    }
    return _ownnerLabel;
}

- (UITextField *)ownnerField
{
    if (!_ownnerField) {
        _ownnerField = [UITextField new];
        _ownnerField.textColor = COLOR_BLACK_333333;
        _ownnerField.textAlignment = NSTextAlignmentLeft;
        _ownnerField.tintColor = COLOR_RED_EA0000;
        _ownnerField.placeholder = @"请输入姓名";
        [_ownnerField setValue:COLOR_GRAY_CCCCCC forKeyPath:@"_placeholderLabel.textColor"];
        [_ownnerField setValue:kFont_Regular(13.f) forKeyPath:@"_placeholderLabel.font"];
        _ownnerField.font = kFont_Medium(13.f);
    }
    return _ownnerField;
}

- (UIView *)phoneInfoView
{
    if (!_phoneInfoView) {
        _phoneInfoView = [UIView new];
        _phoneInfoView.backgroundColor = COLOR_GRAY_F9FAFD;
        _phoneInfoView.layer.cornerRadius = 2.f;
        _phoneInfoView.layer.masksToBounds = YES;
    }
    return _phoneInfoView;
}

- (UIButton *)phoneStarBtn
{
    if (!_phoneStarBtn) {
        _phoneStarBtn = [UIButton new];
        [_phoneStarBtn setTitle:@"*" forState:UIControlStateNormal];
        [_phoneStarBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    }
    return _phoneStarBtn;
}
- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.text = @"手机:";
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.font = kFont_Regular(13.f);
        _phoneLabel.textColor = COLOR_BLACK_333333;
    }
    return _phoneLabel;
}

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton new];
        [_phoneBtn setBackgroundImage:ImageNamed(@"tel_phone") forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(onClickPhoneUser:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UITextField *)phoneField
{
    if (!_phoneField) {
        _phoneField = [UITextField new];
        _phoneField.textColor = COLOR_BLACK_333333;
        _phoneField.textAlignment = NSTextAlignmentLeft;
        _phoneField.tintColor = COLOR_RED_EA0000;
        _phoneField.placeholder = @"请输入手机号码";
        _phoneField.textColor = COLOR_GREEN_2DC22A;
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneField setValue:COLOR_GRAY_CCCCCC forKeyPath:@"_placeholderLabel.textColor"];
        [_phoneField setValue:kFont_Regular(13.f) forKeyPath:@"_placeholderLabel.font"];
        _phoneField.font = kFont_Medium(13.f);
    }
    return _phoneField;
}

- (UIView *)desView{
    if (!_desView) {
        _desView = [UIView new];
        _desView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _desView;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.text = @"拼租说明:";
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.font = kFont_Medium(13.f);
        _desLabel.textColor = COLOR_BLACK_333333;
    }
    return _desLabel;
}

- (UITextField *)desField
{
    if (!_desField) {
        _desField = [UITextField new];
        _desField.textColor = COLOR_BLACK_333333;
        _desField.textAlignment = NSTextAlignmentLeft;
        _desField.tintColor = COLOR_RED_EA0000;
        _desField.placeholder = @"一句话说明场地使用目的，提升接单效率";
        [_desField setValue:COLOR_GRAY_CCCCCC forKeyPath:@"_placeholderLabel.textColor"];
        [_desField setValue:kFont_Regular(13.f) forKeyPath:@"_placeholderLabel.font"];
        _desField.font = kFont_Medium(13.f);
        
    }
    return _desField;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _bottomView;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.text = @"¥ 0.00";
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = kFont_Medium(19.f);
        _priceLabel.textColor = COLOR_RED_EA0000;
        
    }
    return _priceLabel;
}

- (HPRightImageButton *)priceListBtn
{
    if (!_priceListBtn) {
        _priceListBtn = [HPRightImageButton new];
        _priceListBtn.image = ImageNamed(@"arrow_down");
        [_priceListBtn setText:@"明细"];
        [_priceListBtn setFont:kFont_Medium(14)];
        [_priceListBtn setColor:COLOR_GRAY_999999];
        [_priceListBtn setRightSpace: getWidth(-30.f)];
        [_priceListBtn setAlignMode:HPRightImageBtnAlignModeLeftOrRight];
        [_priceListBtn addTarget:self action:@selector(onClickOrderListBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceListBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        _deleteBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _deleteBtn.layer.cornerRadius = 15;
        _deleteBtn.layer.borderColor = COLOR_RED_FF1213.CGColor;
        _deleteBtn.layer.borderWidth = 1;
        _deleteBtn.layer.masksToBounds = YES;
        [_deleteBtn setTitle:@"在线催单" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:COLOR_RED_FF1213 forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = kFont_Medium(12.f);
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_deleteBtn addTarget:self action:@selector(onClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)communicateBtn
{
    if (!_communicateBtn) {
        _communicateBtn = [UIButton new];
        [_communicateBtn setTitle:@"免费沟通" forState:UIControlStateNormal];
        [_communicateBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [_communicateBtn setImage:ImageNamed(@"communicate_serve") forState:UIControlStateNormal];
        [_communicateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(6.f), 0, 0)];
        [_communicateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, getWidth(6.f))];
        _communicateBtn.titleLabel.font = kFont_Medium(12.f);
        _communicateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_communicateBtn addTarget:self action:@selector(onClickFreeCommicateBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _communicateBtn;
}

- (HPPredictView *)predictView
{
    if (!_predictView) {
        _predictView = [HPPredictView new];
        kWEAKSELF
        _predictView.knownBlock = ^{
            [weakSelf.predictView show:NO];
            for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[HPShareShopListController class]]) {
                    //                    HPShareShopListController *shopList = [HPShareShopListController new];
                    //                    shopList.isPop = YES;
                    [weakSelf.navigationController popToViewController:controller animated:YES];
                }
            }
            
        };
        
        _predictView.onlineBlock = ^{
            [weakSelf createConversationWithFriend:nil];
        };
        
        [_predictView setOnlineText:@"付款提醒"];
    }
    return _predictView;
}

- (void)onClickFreeCommicateBtn:(UIButton *)button
{
    HPLog(@"free");
}

- (void)onClickPhoneUser:(UIButton *)button
{
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@", _model.spaceDetail.contactMobile];
    
    NSURL *aURL = [NSURL URLWithString: telNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
        [[UIApplication sharedApplication] openURL:aURL];
    }}

#pragma mark - 开启会话
- (void)createConversationWithFriend:(UIButton *)button
{
//    [[JCHATAlertViewWait ins] showInView];
    __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
//    [HUD HUDNotHidden:@"正在添加用户..."];
    
    NSString *storeOwnner = [NSString stringWithFormat:@"hepai%@",_model.order.userId];
    kWEAKSELF
    [JMSGConversation createSingleConversationWithUsername:storeOwnner appKey:JPushAppKey completionHandler:^(id resultObject, NSError *error) {
        
//        [[JCHATAlertViewWait ins] hidenAll];
        
        if (error == nil) {
            kSTRONGSELF
            sendMessageCtl.conversation = resultObject;
            
            [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            [HUD HUDHidden];
        } else {
            HPLog(@"createSingleConversationWithUsername fail");
            [HUD HUDWithString:@"用户不存在" Delay:2.0];
            
        }
    }];
}

- (void)onClickDeleteBtn:(UIControl *)button
{
    
    [self getConfirmDeleteOrderApi];
}

#pragma mark - 商家确认删除订单
- (void)getConfirmDeleteOrderApi
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isBoss"] = @([HPSingleton sharedSingleton].identifyTag);
    dic[@"orderId"] = _model.order.orderId;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/order/delete" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [HPProgressHUD alertMessage:MSG];
            
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)onClickSelectedDaysbtn:(UIButton *)button
{
    [self.calenderView show:YES];
}

- (void)onClickManagerTimesBtn:(UIButton *)button
{
    kWEAKSELF
    self.picker = [HPRentTimePicker new];
    self.picker.timeBlock = ^(NSString *startTime, NSString *endTime) {
        
        if (!startTime) {
            [HPProgressHUD alertMessage:@"请选择入店时间"];
            return;
        }
        
        if (!endTime) {
            [HPProgressHUD alertMessage:@"请选择离店时间"];
            return;
        }
        weakSelf.arriveTime = startTime;
        weakSelf.leaveTime = endTime;
        [weakSelf.arrivalLabel setText:startTime];
        [weakSelf.leaveLabel setText:endTime];
        
    };
    [self.picker show:YES];
}

- (void)onClickOrderListBtn:(HPRightImageButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        _priceListBtn.selectedImage = ImageNamed(@"arrow_up");
        [self.orderListView show:YES];
        
    }else{
        _priceListBtn.selectedImage = ImageNamed(@"arrow_down");
        [self.orderListView show:NO];
    }
}

- (void)onClickLoundBtn:(UIButton *)button
{

}

#pragma mark - textField detegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return NO;
    
}
@end
