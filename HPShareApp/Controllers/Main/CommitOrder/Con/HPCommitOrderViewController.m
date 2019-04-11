//
//  HPCommitOrderViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "HPTimeString.h"

#import "HPCommitOrderViewController.h"

#import "HPShareDetailModel.h"

#import "HPAttributeLabel.h"

#import "HPRightImageButton.h"

#import "YZXCalendarView.h"

#import "YZXSelectDateViewController.h"

#import "YZXCalendarHelper.h"

#import "HPRentDuringView.h"

#import "HPOrderInfoListView.h"

#import "HPPredictView.h"

#import "HPShareShopListController.h"

#import "JCHATAlertViewWait.h"

#import "JCHATConversationViewController.h"

#import "HPSingleton.h"

#import "HPCalenderView.h"


@interface HPCommitOrderViewController ()

@property (strong, nonatomic) NSMutableArray *rentDaysArray;

@property (strong, nonatomic) NSMutableArray *hasOrderArray;

@property (strong, nonatomic) NSMutableArray *fianlOrderArray;

@property (strong, nonatomic) NSMutableArray *verbDaysArray;

@property (nonatomic, copy) NSString *arriveTime;

@property (nonatomic, copy) NSString *leaveTime;

@property (nonatomic, strong) HPCalenderView *calenderView;

@property (nonatomic, strong) HPOrderInfoListView *orderListView;

@property (nonatomic, strong) HPRentDuringView *picker;

@property (nonatomic, strong) HPPredictView *predictView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *storeInfoView;

@property (nonatomic, strong) UIImageView *storeView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (strong, nonatomic) UILabel *rentOutsideLabel;

@property (nonatomic, strong) UILabel *spaceInfoLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) HPShareDetailModel *model;

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

@property (nonatomic, strong) UIControl *predictBtn;

@property (nonatomic, strong) UIImageView *cartView;

@property (nonatomic, strong) UILabel *predictLabel;

@property (nonatomic, strong) UILabel *confirmLabel;


@property (nonatomic, strong) YZXCalendarView             *calendarView;

@property (nonatomic, assign) YZXTimeToChooseType         selectedType;

@property (nonatomic, copy) NSString             *startDate;

@property (nonatomic, copy) NSString             *endDate;

@end

@implementation HPCommitOrderViewController

- (HPCalenderView *)calenderView
{
    if (!_calenderView) {
        _calenderView = [HPCalenderView new];
        kWEAKSELF
        _calenderView.confirmTheDateBlock = ^(NSString *startDate, NSString *endDate, YZXTimeToChooseType selectedType) {
            
            weakSelf.startDate = startDate;
            weakSelf.endDate = endDate;
            NSArray *selectedDays = [[weakSelf verbSelectedDaysArray] componentsSeparatedByString:@","];
            weakSelf.rentDaysLabel.text = [NSString stringWithFormat:@"拼租日期（共%ld天）",selectedDays.count];
            weakSelf.orderListView.days = selectedDays;
            weakSelf.orderListView.dayRent = weakSelf.model.rent;

            weakSelf.rentStartDayLabel.text = [startDate substringFromIndex:5];
            if (endDate) {
                weakSelf.rentEndDayLabel.text = [endDate substringFromIndex:5];
                weakSelf.rentLineLabel.hidden = NO;
                weakSelf.rentEndDayLabel.hidden = NO;
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
    
    self.fianlOrderArray = [NSMutableArray array];

    [self getHasPredictOrderApi];
    
    [self.view addSubview:self.calenderView];

    [self.calenderView show:YES];
    
}

#pragma mark - 获取已经预定的订单
- (void)getHasPredictOrderApi
{
    NSString *method = [NSString stringWithFormat:@"/v1/order/spaceId/%@/orderedDays",_model.spaceId];
    [HPHTTPSever HPGETServerWithMethod:method isNeedToken:YES paraments:@{@"spaceId":_model.spaceId?@([_model.spaceId integerValue]):@""} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *orderArray = responseObject[@"data"];
            for (int i = 0; i < orderArray.count; i++) {
                if (![self.hasOrderArray containsObject:orderArray[i]]) {
                    [self.hasOrderArray addObject:orderArray[i]];
//                    NSString *date = [HPTimeString noPortraitLineToDateStr:orderArray[i]];
//
//                    if (![self.fianlOrderArray containsObject:date]) {
//                        [self.fianlOrderArray addObject:date];
//
//                    }
                }
            }
            if (orderArray.count == 0) {
                HPLog(@"暂无已预订的数据");
            }else{
                [kNotificationCenter postNotificationName:lastCarlenderhasOrderArrayName object:nil userInfo:@{@"lastArray":self.hasOrderArray}];

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
    
    self.rentDaysArray = [NSMutableArray array];
    
    [self.view setBackgroundColor:COLOR_GRAY_F9FAFD];
    
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
    self.nameLabel.text = _model.title;
    
    self.locationLabel.text = [NSString stringWithFormat:@"拼租位置:%@",_model.rentPlace?_model.rentPlace:@"--"];

    [self.storeView sd_setImageWithURL:[NSURL URLWithString:_model.pictures[0].url] placeholderImage:ImageNamed(@"loading_logo_small")];
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",_model.address];
    
    self.ownnerField.delegate = self;

    self.phoneField.delegate = self;
    
    HPLoginModel *account = [HPUserTool account];
    
    self.phoneField.text = account.userInfo.mobile;
    
    self.ownnerField.text = account.userInfo.username;

    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",_model.rent];
    if (_model.area && ![_model.area isEqualToString:@"0"]) {
        if ([_model.areaRange intValue] == 1) {
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"不限"]];
        }else if ([_model.areaRange intValue] == 2){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"小于5㎡"]];
        }else if ([_model.areaRange intValue] == 3){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"5-10㎡"]];
        }else if ([_model.areaRange intValue] == 4){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"10-20㎡"]];
        }else if ([_model.areaRange intValue] == 5){
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:%@",@"20㎡以上"]];
        }else {
            [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:面议"]];
        }
    }
    else{
        [self.spaceInfoLabel setText:[NSString stringWithFormat:@"场地规格:不限"]];
    }
    
    if (_model.rentOutside.integerValue == 1) {
        self.rentOutsideLabel.text = @"室内";
    }else
    {
        self.rentOutsideLabel.text = @"室外";
    }
}
- (void)setUpCommitSubviews
{
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.headerView];
    
    [self.scrollView addSubview:self.backBtn];
    
    [self.scrollView addSubview:self.titleLabel];

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

    [self.contactInfoView addSubview:self.contactView];

    [self.contactView addSubview:self.contactStarBtn];
    
    [self.contactView addSubview:self.ownnerLabel];
    
    [self.contactView addSubview:self.ownnerField];
    
    [kNotificationCenter addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:self.ownnerField];

    
    [self.contactInfoView addSubview:self.phoneInfoView];
    
    [self.phoneInfoView addSubview:self.phoneStarBtn];
    
    [self.phoneInfoView addSubview:self.phoneLabel];
    
    [self.phoneInfoView addSubview:self.phoneField];
    
    [kNotificationCenter addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:self.phoneField];

    [self.scrollView addSubview:self.desView];

    [self.desView addSubview:self.desLabel];

    [self.desView addSubview:self.desField];

    [self.view addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.priceLabel];
    
    [self.bottomView addSubview:self.priceListBtn];
    
    [self.bottomView addSubview:self.predictBtn];
    //预定按钮
    [self.predictBtn addSubview:self.cartView];
    
    [self.predictBtn addSubview:self.predictLabel];
    
    [self.predictBtn addSubview:self.confirmLabel];
    //明细列表
    [self.scrollView addSubview:self.orderListView];
//预定
    [self.view addSubview:self.predictView];
    
    [self.predictView show:NO];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:self.ownnerField];
    [kNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:self.phoneField];

}

#pragma mark - NSNotification

- (void)didTextFieldChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    
    // text field 的内容
    NSString *contentText = textField.text;
    
    // 获取高亮内容的范围
    UITextRange *selectedRange = [textField markedTextRange];
    // 这行代码 可以认为是 获取高亮内容的长度
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    // 没有高亮内容时,对已输入的文字进行操作
    if (markedTextLength == 0) {
        // 如果 text field 的内容长度大于我们限制的内容长度

        if (contentText.length > 11 && textField == self.phoneField) {
            // 截取从前面开始maxLength长度的字符串
            //            textField.text = [contentText substringToIndex:maxLength];
            // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
            NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 12)];
            textField.text = [contentText substringWithRange:rangeRange];
            [HPProgressHUD alertMessage:@"手机号码不得超过11位"];
        }
    }
}

-(void)setUpCommitSubviewsmasonry
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(g_bottomSafeAreaHeight + getWidth(60.f));
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(107.f));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.storeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.left.mas_equalTo(getWidth(15.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(345.f), getWidth(115.f)));
        make.top.mas_equalTo(g_statusBarHeight + 44 + getWidth(4.f));
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
    
    __block CGFloat locW = BoundWithSize(_model.rentPlace?_model.rentPlace:@"拼租位置：--", kScreenWidth, 12.f).size.width;
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        if (locW > kScreenWidth/3) {
            locW = kScreenWidth/3;
        }
        make.width.mas_equalTo(locW);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.locationLabel.font.pointSize);
    }];
    
    [self.rentOutsideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationLabel.mas_right).offset(getWidth(15.f));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.rentOutsideLabel.font.pointSize);
        make.width.mas_equalTo(30.f);
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
    
    [self.duringBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-10.f));
        make.centerY.mas_equalTo(self.inStoreDuringView);
        make.height.width.mas_equalTo(getWidth(18.f));
    }];
    
    [self.contactInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.rentInfoView);
        make.top.mas_equalTo(self.rentInfoView.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(140.f));
    }];
    
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.contactLabel.font.pointSize);
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
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.ownnerField);
        make.centerY.mas_equalTo(self.phoneInfoView);
    }];
    
    [self.desView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.rentInfoView);
        make.height.mas_equalTo(getWidth(45.f));
        make.top.mas_equalTo(self.contactInfoView.mas_bottom).offset(getWidth(15.f));
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
        make.left.bottom.width.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(getWidth(60.f));
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.priceListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.priceLabel.mas_right);
        make.width.mas_equalTo(kScreenWidth/5);
    }];
    
    [self.predictBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.priceListBtn.mas_right);
    }];
    
    CGFloat predictW = BoundWithSize(@"拼租预定", kScreenWidth, 14.f).size.width;
    [self.predictLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cartView);
        make.centerX.mas_equalTo(self.predictBtn);
        make.height.mas_equalTo(self.predictLabel.font.pointSize);
        make.width.mas_equalTo(predictW);
    }];
    
    [self.cartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(self.predictLabel.mas_left).offset(getWidth(-3.f));
        make.width.height.mas_equalTo(getWidth(13.f));

    }];
    
    [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.predictLabel.mas_bottom).offset(getWidth(10.f));
        make.left.right.bottom.mas_equalTo(self.predictBtn);
    }];
    
    [self.orderListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(getWidth(-60.f));
    }];
    
    [self.predictView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
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
        _titleLabel.text = @"提交订单";
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
        _nameLabel.font = kFont_Medium(16.f);
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
        _rentOutsideLabel.layer.cornerRadius = 2;
        _rentOutsideLabel.layer.masksToBounds= YES;
        _rentOutsideLabel.backgroundColor = COLOR_RED_EA0000;
        _rentOutsideLabel.text = @"室外";
        _rentOutsideLabel.textAlignment = NSTextAlignmentCenter;
        _rentOutsideLabel.font = kFont_Medium(12.f);
        _rentOutsideLabel.textColor = COLOR_GRAY_FFFFFF;
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
        _rentDaysLabel.text = @"拼租日期（共0天）";
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
        _rentStartDayLabel.textColor = COLOR_BLACK_333333;
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
        _rentEndDayLabel.textColor = COLOR_BLACK_333333;
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
        _contactLabel.text = @"收货人";
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

- (UITextField *)phoneField
{
    if (!_phoneField) {
        _phoneField = [UITextField new];
        _phoneField.textColor = COLOR_BLACK_333333;
        _phoneField.textAlignment = NSTextAlignmentLeft;
        _phoneField.tintColor = COLOR_RED_EA0000;
        _phoneField.placeholder = @"请输入手机号码";
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
        _priceLabel.text = @"¥ 99.00";
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = kFont_Medium(13.f);
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

        [_priceListBtn setRightSpace: getWidth(-20.f)];
        [_priceListBtn addTarget:self action:@selector(onClickOrderListBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceListBtn;
}

- (UIControl *)predictBtn
{
    if (!_predictBtn) {
        _predictBtn = [UIControl new];
        _predictBtn.backgroundColor = COLOR_RED_EA0000;
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

- (HPPredictView *)predictView
{
    if (!_predictView) {
        _predictView = [HPPredictView new];
        kWEAKSELF
        _predictView.knownBlock = ^{
            for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                if ([controller isKindOfClass:[HPShareShopListController class]]) {
                    [weakSelf.navigationController popToViewController:controller animated:YES];
                }
            }
            
        };
        
        _predictView.onlineBlock = ^{
            [weakSelf createConversationWithFriend:nil];
        };
    }
    return _predictView;
}

#pragma mark - 开启会话
- (void)createConversationWithFriend:(UIButton *)button
{
    [[JCHATAlertViewWait ins] showInView];
    __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    [HUD HUDNotHidden:@"正在添加用户..."];
    
    NSString *storeOwnner = [NSString stringWithFormat:@"hepai%@",_model.userId];
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
    
    [self createSpaceRentOrder];
}

- (void)onClickSelectedDaysbtn:(UIButton *)button
{
    [self.calenderView show:YES];
}

- (HPRentDuringView *)picker{
    if (!_picker) {
        kWEAKSELF
        _picker = [HPRentDuringView new];
        _picker.timeBlock = ^(NSString *startTime, NSString *endTime) {
            
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
            
            [weakSelf.arrivalLabel setText:[NSString stringWithFormat:@"入店：%@",startTime]];
            [weakSelf.leaveLabel setText:[NSString stringWithFormat:@"离店：%@",endTime]];
            
        };
    }
    return _picker;
}

- (void)onClickManagerTimesBtn:(UIButton *)button
{
    [self.view addSubview:self.picker];
    [self.picker show:YES];
}

- (void)onClickOrderListBtn:(HPRightImageButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        _priceListBtn.selectedImage = ImageNamed(@"arrow_up");
        NSArray *verbDaysArray = [[self verbSelectedDaysArray] componentsSeparatedByString:@","];
        
        if (verbDaysArray.count == 1 && [verbDaysArray.firstObject isEqualToString:@""]) {
            [HPProgressHUD alertMessage:@"请选择拼租日期"];
            return;
        }
        if (verbDaysArray.count >= 1) {
            self.orderListView.days = verbDaysArray;
            
            NSString *dayRent;
            if (self.model.rent.length != 0 && self.model.type == 1) {
                if ([_model.rent isEqualToString:@"0"]) {
                    dayRent = @"面议";
                }
                if (_model.rentType == 1) {
                    dayRent = [NSString stringWithFormat:@"%.2f",_model.rent.floatValue/24.0];

                }else if (_model.rentType == 2){
                    dayRent = [NSString stringWithFormat:@"%.2f",_model.rent.floatValue];
                }else if (_model.rentType == 3){
                    dayRent = [NSString stringWithFormat:@"%.2f",_model.rent.floatValue/30.0];
                }else if (_model.rentType == 4){
                    dayRent = [NSString stringWithFormat:@"%.2f",_model.rent.floatValue/12/30.0];
                }else {
                    dayRent = @"面议";
                }
            }
            self.orderListView.dayRent = dayRent;
            [self.orderListView show:YES];
        }else{
            [HPProgressHUD alertMessage:@"请选择日期"];
        }

    }else{
        _priceListBtn.selectedImage = ImageNamed(@"arrow_down");
        [self.orderListView show:NO];
    }
}

- (void)createSpaceRentOrder
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *closeTimeArr = [self.leaveTime componentsSeparatedByString:@":"];
    NSString *closeTime = [NSString stringWithFormat:@"%@%@",closeTimeArr.firstObject?closeTimeArr.firstObject:@"18",closeTimeArr.lastObject?closeTimeArr.lastObject:@"00"];
    
    NSArray *openTimeArr = [self.arriveTime componentsSeparatedByString:@":"];

    NSString *openTime = [NSString stringWithFormat:@"%@%@",openTimeArr.firstObject?openTimeArr.firstObject:@"09",openTimeArr.lastObject?openTimeArr.lastObject:@"00"];
    
    if (_rentStartDayLabel.text.length == 0) {
        [HPProgressHUD alertMessage:@"请选择拼租日期"];
        return;
    }
    if (self.ownnerField.text.length == 0) {
        [HPProgressHUD alertMessage:@"请填写收货人姓名"];
        return;
    }
    if (self.phoneField.text.length == 0) {
        [HPProgressHUD alertMessage:@"请填写收货人联系方式"];
        return;
    }
//    NSString *resultDays = [self verbSelectedDaysArray];
    
    dic[@"closeTime"] = closeTime?closeTime:@"18:00";
    dic[@"contact"] = self.ownnerField.text;
    dic[@"contactMobile"] = self.phoneField.text;
    dic[@"days"] = [self verbSelectedDaysArray];
    dic[@"openTime"] = openTime?openTime:@"09:00";
    dic[@"remark"] = self.desField.text;
    dic[@"shareOrder"] = @"";
    dic[@"spaceId"] = _model.spaceId;
    dic[@"totalFee"] = @(1);//@([_model.rent integerValue]);
    dic[@"unitFee"] = @(1);//@(1/[rentDays componentsSeparatedByString:@","].count);
    [HPHTTPSever HPPostServerWithMethod:@"/v1/order" paraments:dic needToken:YES complete:^(id  _Nonnull responseObject) {

        if (CODE == 200) {
            [self.predictView show:YES];
            [HPProgressHUD alertMessage:MSG];


        }else
        {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}


/**
 对勾选的日期进行去重和格式化处理
 */
- (NSString *)verbSelectedDaysArray
{
    NSString *rentDays;
    if (_endDate.length == 0) {
        if (!_startDate) {
            return @"";
        }
        rentDays = [HPTimeString getNeedDateFormatter:_startDate];
    }else{
        
        NSString *startFormatter = [HPTimeString getNeedLineDateFormatter:_startDate];
        
        NSString *endFormatter = [HPTimeString getNeedLineDateFormatter:_endDate];
        
        NSTimeInterval startSecond = [HPTimeString dateStrToSeconds:startFormatter];
        
        NSTimeInterval endSecond = [HPTimeString dateStrToSeconds:endFormatter];
        
        NSString *selectRentDays = [HPTimeString getDatesStringWithStartTime:startSecond andEndTime:endSecond];
        NSArray *rentDaysArray = [selectRentDays componentsSeparatedByString:@","];
        
        NSArray *resultDaysArray = [rentDaysArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
        [self.verbDaysArray addObjectsFromArray:resultDaysArray];
        for (NSString *date in self.hasOrderArray) {
            if ([self.verbDaysArray containsObject:date]) {
                [self.verbDaysArray removeObject:date];
            }
        }
        NSArray *array = [self.verbDaysArray valueForKeyPath:@"@distinctUnionOfObjects.self"];

        rentDays = [array componentsJoinedByString:@","];

    }

    return rentDays;
}

- (NSMutableArray *)verbDaysArray
{
    if (!_verbDaysArray) {
        _verbDaysArray = [NSMutableArray array];

    }
    return _verbDaysArray;
}
@end
