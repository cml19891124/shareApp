//
//  HPCommitOrderViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#define carlenderhasOrderArrayName @"carlenderhasOrderArrayName"

#import "HPHasOrderModel.h"

#import "HPTimeString.h"

#import "HPOrderManagerViewController.h"

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
@interface HPOrderManagerViewController ()

@property (strong, nonatomic) NSMutableArray *orderArray;

/**
 接收新订单的时候已经被预订的日期
 */
@property (strong, nonatomic) NSMutableArray *hasOrderArray;
/**
 新订单的要求预订的日期
 */
@property (strong, nonatomic) NSMutableArray *orderNewArray;

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

@property (nonatomic, strong) UIButton *warningBtn;

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

@property (nonatomic, strong) UIButton *quitBtn;

@property (nonatomic, strong) UIButton *predictBtn;

@property (nonatomic, strong) UIImageView *cartView;

@property (nonatomic, strong) UILabel *predictLabel;

@property (nonatomic, strong) UILabel *confirmLabel;


@property (nonatomic, strong) YZXCalendarView             *calendarView;

@property (nonatomic, assign) YZXTimeToChooseType         selectedType;
@property (nonatomic, copy) NSString             *startDate;
@property (nonatomic, copy) NSString             *endDate;

@property (nonatomic, strong) HPCalenderView *calenderView;

@property (strong, nonatomic) NSArray *daysArray;

@end

@implementation HPOrderManagerViewController


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
    
    self.calenderView.calendarView.daysMenuView.userActivity = NO;
    
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
            NSArray *orderArray = [HPHasOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.hasOrderArray addObjectsFromArray:orderArray];
            
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
    
    self.ownnerField.text = _model.spaceDetail.contact;
    
    self.desField.text = _model.spaceDetail.remark;

    NSString *lefttime = [HPTimeString gettimeInternalFromPassedTimeToNowDate:_model.order.admitTime];
    if ([lefttime isEqualToString:@"剩余:00:00"]) {
        [kNotificationCenter postNotificationName:topaytimeout object:nil];
    }
    
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
    

    self.desField.text = self.model.order.remark;
    NSArray *shareDays = [self.model.order.days componentsSeparatedByString:@","];
    [self.orderNewArray addObjectsFromArray:shareDays];
    
}

//对选中的selectedArray中的数据排序
- (void)p_sortingTheSelectedArray
{
    if ([self.daysArray.firstObject compare:self.daysArray.lastObject] == NSOrderedDescending) {
        self.daysArray = [[[[self.daysArray copy] reverseObjectEnumerator] allObjects] mutableCopy];
    }
}

- (void)paytimeOutClick
{
    [self pushVCByClassName:@"HPOwnnerTimeOutViewController" withParam:@{@"model":_model}];
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}
- (void)setUpCommitSubviews
{
    [kNotificationCenter addObserver:self selector:@selector(paytimeOutClick) name:topaytimeout object:nil];
    
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.headerView addSubview:self.warningBtn];
    
    NSString *leftTime = [NSString stringWithFormat:@"剩余:%@", [HPTimeString gettimeInternalFromPassedTimeToNowDate:_model.order.admitTime]];
   
    self.leftLabel = [HPAttributeLabel getTitle:leftTime andFromFont:kFont_Medium(12.f) andToFont:kFont_Bold(14.f) andFromColor:COLOR_GRAY_FFFFFF andToColor:COLOR_GRAY_FFFFFF andFromRange:NSMakeRange(0, 3) andToRange:NSMakeRange(3,leftTime.length - 3) andLineSpace:0 andNumbersOfLine:0 andTextAlignment:NSTextAlignmentCenter andLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.headerView addSubview:self.leftLabel];

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
    
    [self.bottomView addSubview:self.priceListBtn];
    
    [self.bottomView addSubview:self.quitBtn];

    [self.bottomView addSubview:self.predictBtn];
    //预定按钮
//    [self.predictBtn addSubview:self.cartView];
//
//    [self.predictBtn addSubview:self.predictLabel];
//
//    [self.predictBtn addSubview:self.confirmLabel];
    //明细列表
    [self.scrollView addSubview:self.orderListView];
//预定
    [self.view addSubview:self.predictView];
    
    [self.predictView show:NO];
    //放弃
    [self.view addSubview:self.quitView];
    
    [self.quitView show:NO];
    
}

-(void)setUpCommitSubviewsmasonry
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-g_bottomSafeAreaHeight + getWidth(-60.f));
    }];
    
    CGFloat height = 0.00;
    if (IPHONE_HAS_NOTCH) {
        height = getWidth(155.f);
    }else if(kScreenHeight == 568){
        
    }else{
        height = getWidth(155.f);
    }
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, height));
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
    
    [self.warningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(13.f));
        make.height.mas_equalTo(self.warningBtn.titleLabel.font.pointSize);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.warningBtn.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.leftLabel.font.pointSize);
    }];
    
    [self.storeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.left.mas_equalTo(getWidth(15.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(345.f), getWidth(115.f)));
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(getWidth(-28.f));
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
    
    [self.priceListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.priceLabel.mas_right);
        make.width.mas_equalTo(kScreenWidth/4);
    }];
    
    [self.predictBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self.bottomView);
        make.top.mas_equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(kScreenWidth/4);
    }];
    
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.bottomView);
        make.right.mas_equalTo(self.predictBtn.mas_left);
        make.width.mas_equalTo(self.predictBtn);
    }];
    
    [self.orderListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(getWidth(-60.f)-g_bottomSafeAreaHeight);
    }];
    
    [self.predictView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    [self.quitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (UIButton *)quitBtn
{
    if (!_quitBtn) {
        _quitBtn = [UIButton new];
        _quitBtn.backgroundColor = COLOR_YELLOW_FFB400;
        [_quitBtn setTitle:@"放弃此单" forState:UIControlStateNormal];
        [_quitBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _quitBtn.titleLabel.font = kFont_Medium(14.f);
        _quitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_quitBtn addTarget:self action:@selector(onClickQuitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

- (void)onClickQuitBtn:(UIButton *)button
{
    HPLog(@"quit");
    [self.quitView show:YES];
}

- (HPQuitOrderView *)quitView
{
    if (!_quitView) {
        _quitView = [HPQuitOrderView new];
        kWEAKSELF
        _quitView.holderBlock = ^{
            HPLog(@"dfsdg");
            [weakSelf.quitView show:NO];
        };
        
        _quitView.quitBlock = ^{
            HPLog(@"5555");
            [weakSelf getBossCancelOrder];
        };
    }
    return _quitView;
}
#pragma mark - 商家放弃订单o拼租
- (void)getBossCancelOrder
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cancelReason"] = self.quitView.signTextView.text;
    dic[@"orderId"] = _model.order.orderId;
    [HPHTTPSever HPPostServerWithMethod:@"/v1/order/bossCancel" paraments:dic needToken:YES complete:^(id  _Nonnull responseObject) {
        
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self.quitView show:NO];
        }else{
            [HPProgressHUD alertMessage:MSG];

        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
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
        _titleLabel.text = @"订单处理";
    }
    return _titleLabel;
}

- (UIButton *)warningBtn
{
    if (!_warningBtn) {
        _warningBtn = [UIButton new];
        [_warningBtn setImage:ImageNamed(@"laba") forState:UIControlStateNormal];
        [_warningBtn setTitle:@"用户发起新的拼租，请在24小时内进行处理" forState:UIControlStateNormal];
        [_warningBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_warningBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(5.f), 0, 0)];
        _warningBtn.titleLabel.font = kFont_Medium(14.f);
        [_warningBtn addTarget:self action:@selector(onClickLoundBtn:) forControlEvents:UIControlEventTouchUpInside];
        _warningBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _warningBtn;
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
//        [_duringBtn addTarget:self action:@selector(onClickManagerTimesBtn:) forControlEvents:UIControlEventTouchUpInside];
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
        [_priceListBtn setColor:COLOR_GRAY_999999];
        [_priceListBtn setRightSpace: getWidth(-30.f)];
        [_priceListBtn addTarget:self action:@selector(onClickOrderListBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceListBtn;
}

- (UIButton *)predictBtn
{
    if (!_predictBtn) {
        _predictBtn = [UIButton new];
        _predictBtn.backgroundColor = COLOR_RED_EA0000;
        [_predictBtn setTitle:@"确认接单" forState:UIControlStateNormal];
        [_predictBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _predictBtn.titleLabel.font = kFont_Medium(14.f);
        _predictBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_predictBtn addTarget:self action:@selector(onClickPredictBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _predictBtn;
}

- (UIImageView *)cartView
{
    if (!_cartView) {
        _cartView = [UIImageView new];
        _cartView.image = ImageNamed(@"predict_buy");
    }
    return _cartView;
}

- (UILabel *)predictLabel
{
    if (!_predictLabel) {
        _predictLabel = [UILabel new];
        _predictLabel.text = @"拼租预定";
        _predictLabel.textColor = COLOR_GRAY_FFFFFF;
        _predictLabel.textAlignment = NSTextAlignmentLeft;
        _predictLabel.font = kFont_Medium(14.f);
    }
    return _predictLabel;
}

- (UILabel *)confirmLabel
{
    if (!_confirmLabel) {
        _confirmLabel = [UILabel new];
        _confirmLabel.text = @"(请店主确认接单后付款)";
        _confirmLabel.textColor = COLOR_GRAY_FFFFFF;
        _confirmLabel.textAlignment = NSTextAlignmentCenter;
        _confirmLabel.font = kFont_Medium(10.f);
    }
    return _confirmLabel;
}

- (HPOrderInfoListView *)orderListView
{
    if (!_orderListView) {
        _orderListView = [HPOrderInfoListView new];
        
    }
    return _orderListView;
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
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

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
    [[JCHATAlertViewWait ins] showInView];
    __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    [HUD HUDNotHidden:@"正在添加用户..."];
    
    NSString *storeOwnner = [NSString stringWithFormat:@"hepai%@",_model.order.userId];
    kWEAKSELF
    [JMSGConversation createSingleConversationWithUsername:storeOwnner appKey:JPushAppKey completionHandler:^(id resultObject, NSError *error) {
        
        [[JCHATAlertViewWait ins] hidenAll];
        
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

- (void)onClickPredictBtn:(UIControl *)button
{
    
    [self getConfirmReceiveOrderApi];
}

#pragma mark - 确认接单
- (void)getConfirmReceiveOrderApi
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isBoss"] = @([HPSingleton sharedSingleton].identifyTag);
    dic[@"orderId"] = _model.order.orderId;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/order/bossAcceptOrder" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self.predictView show:YES];
            [self.predictView.tipBtn setTitle:@"接单成功" forState:UIControlStateNormal];
            self.predictView.messageLabel.text = @"租客付款后请按预定给租客提供场地";
//            [kNotificationCenter postNotificationName:confirmReceiveOrderMessage object:nil userInfo:@{@"model":self.model}];
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
@end
