//
//  HPOrderDetailViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/27.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "HPRightImageButton.h"

#import "HPOrderDetailViewController.h"

#import "HOOrderListModel.h"

#import "HPSingleton.h"

#import "HPAttributeLabel.h"

#import "HPQuitOrderView.h"

#import <JMessage/JMessage.h>

#import "JCHATConversationViewController.h"

@interface HPOrderDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *warningBtn;

@property (strong, nonatomic) HPQuitOrderView *quitView;

/**
 剩余时间
 */
@property (nonatomic, strong) HPAttributeLabel *leftLabel;

/**
 联系商家的view
 */
@property (nonatomic, strong) UIView *communicateView;

@property (nonatomic, strong) UIImageView *thumbView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *rentDaysLabel;

@property (nonatomic, strong) UILabel *duringDayslabel;

@property (nonatomic, strong) UIView *contactLine;

@property (nonatomic, strong) HPRightImageButton *consumerBtn;

@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) HOOrderListModel *model;

@property (nonatomic, strong) UIView *ownnerView;

@property (nonatomic, strong) UILabel *ownnerLabel;

@property (nonatomic, strong) UILabel *ownnerSubLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *phoneSubLabel;

@property (nonatomic, strong) UIView *orderView;

@property (nonatomic, strong) UILabel *orderIdLabel;

@property (nonatomic, strong) UILabel *createOrderLabel;

@property (nonatomic, strong) UILabel *payOrderLabel;

@property (nonatomic, strong) UILabel *orderSubLabel;

@property (nonatomic, strong) UILabel *createOrderSubLabel;

@property (nonatomic, strong) UILabel *paySubLabel;

@property (nonatomic, strong) UIView *rentAmountView;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *amountSubLabel;

/**
 押金
 */
@property (nonatomic, strong) UILabel *depositLabel;

@property (nonatomic, strong) UILabel *depositSubLabel;

/**
 支付view
 */
@property (nonatomic, strong) UIView *payView;

@property (nonatomic, strong) UILabel *toPayLabel;

@property (nonatomic, strong) UILabel *toPaySubLabel;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) UIButton *focusBtn;

@end

@implementation HPOrderDetailViewController


- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        
        self.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
    [self.view setBackgroundColor:COLOR_GRAY_F9FAFD];
    
    self.model = self.param[@"model"];

    [self setUpCommitSubviews];
    
    [self setUpCommitSubviewsMasonry];
    
    [self loadData];

}

- (void)loadData
{
    [self.thumbView sd_setImageWithURL:[NSURL URLWithString:_model.spaceDetail.picture.url] placeholderImage:ImageNamed(@"loading_logo_small")];
    
    self.nameLabel.text = _model.spaceDetail.title;
    
    NSArray *daysArray = [_model.order.days componentsSeparatedByString:@","];

    self.rentDaysLabel.text = [NSString stringWithFormat:@"租期:%lu天",(unsigned long)daysArray.count];
    
    self.duringDayslabel.text = [NSString stringWithFormat:@"入离店:%@",_model.spaceDetail.shareTime];
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",_model.spaceDetail.address];
    
    self.ownnerSubLabel.text = _model.spaceDetail.contact;
    
    self.phoneSubLabel.text = _model.spaceDetail.contactMobile;
    
    self.orderSubLabel.text = _model.order.orderNo;
    
    self.createOrderSubLabel.text = _model.order.createTime;
    
    self.amountSubLabel.text = _model.spaceDetail.rent;
    
    self.toPaySubLabel.text = [NSString stringWithFormat:@"¥%@",_model.order.totalFee];

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

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.text = @"地址：南山科苑粤兴四道中科纳大厦";
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.font = kFont_Medium(12.f);
        _addressLabel.textColor = COLOR_GRAY_999999;
    }
    return _addressLabel;
}

- (void)setUpCommitSubviews
{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.headerView addSubview:self.warningBtn];

    NSString *leftTime = [NSString stringWithFormat:@"剩余:%@", [HPTimeString gettimeInternalFromPassedTimeToNowDate:_model.order.admitTime]];
    self.leftLabel = [HPAttributeLabel getTitle:leftTime andFromFont:kFont_Medium(12.f) andToFont:kFont_Bold(14.f) andFromColor:COLOR_GRAY_FFFFFF andToColor:COLOR_GRAY_FFFFFF andFromRange:NSMakeRange(0, 3) andToRange:NSMakeRange(3,leftTime.length - 3) andLineSpace:0 andNumbersOfLine:0 andTextAlignment:NSTextAlignmentCenter andLineBreakMode:NSLineBreakByWordWrapping];
    
    [self.headerView addSubview:self.leftLabel];

    [self.scrollView addSubview:self.communicateView];

    [self.communicateView addSubview:self.thumbView];

    [self.communicateView addSubview:self.nameLabel];

    [self.communicateView addSubview:self.rentDaysLabel];

    [self.communicateView addSubview:self.duringDayslabel];
    
    [self.communicateView addSubview:self.addressLabel];
    
    [self.communicateView addSubview:self.contactLine];

    [self.communicateView addSubview:self.consumerBtn];
    
//    [self.communicateView addSubview:self.phoneBtn];

    [self.scrollView addSubview:self.ownnerView];

    [self.ownnerView addSubview:self.ownnerLabel];

    [self.ownnerView addSubview:self.ownnerSubLabel];

    [self.ownnerView addSubview:self.phoneLabel];
    
    [self.ownnerView addSubview:self.phoneSubLabel];
    
    [self.scrollView addSubview:self.orderView];
    
    [self.orderView addSubview:self.orderIdLabel];
    
    [self.orderView addSubview:self.orderSubLabel];

    [self.orderView addSubview:self.createOrderLabel];

    [self.orderView addSubview:self.createOrderSubLabel];
    
    [self.orderView addSubview:self.payOrderLabel];
    
    [self.orderView addSubview:self.paySubLabel];

    [self.scrollView addSubview:self.rentAmountView];
    
    [self.rentAmountView addSubview:self.amountLabel];
    
    [self.rentAmountView addSubview:self.amountSubLabel];
    
    [self.rentAmountView addSubview:self.depositLabel];
    
    [self.rentAmountView addSubview:self.depositSubLabel];
    
    [self.scrollView addSubview:self.payView];
    
    [self.payView addSubview:self.toPayLabel];
    
    [self.payView addSubview:self.toPaySubLabel];
    
    [self.view addSubview:self.bottomView];

    [self.bottomView addSubview:self.cancelBtn];

    [self.bottomView addSubview:self.payBtn];

    [self.view addSubview:self.focusBtn];

}

-(void)setUpCommitSubviewsMasonry
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-g_bottomSafeAreaHeight + getWidth(-75.f));
    }];
    
    CGFloat height = 0.00;
    if (IPHONE_HAS_NOTCH) {
        height = getWidth(130.f);
    }else if(kScreenHeight == 568){
        
    }else{
        height = getWidth(110.f);
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
        make.centerX.mas_equalTo(self.scrollView);
        make.width.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
    [self.warningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(13.f));
        make.height.mas_equalTo(self.warningBtn.titleLabel.font.pointSize);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(self.warningBtn.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.leftLabel.font.pointSize);
    }];
    
    [self.communicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(getWidth(345.f));
        make.height.mas_equalTo(getWidth(133.f));
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(getWidth(65.f));
        make.top.left.mas_equalTo(getWidth(15.f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(18.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.left.mas_equalTo(self.thumbView.mas_right).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));

    }];
    
    CGFloat rentW = BoundWithSize(self.rentDaysLabel.text, kScreenWidth, 14.f).size.width;
    [self.rentDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.rentDaysLabel.font.pointSize);
        make.left.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(rentW);
    }];
    
    [self.duringDayslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.duringDayslabel.font.pointSize);
        make.left.mas_equalTo(self.rentDaysLabel.mas_right).offset(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rentDaysLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.duringDayslabel.font.pointSize);
        make.left.mas_equalTo(self.rentDaysLabel);
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.contactLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.thumbView.mas_bottom).offset(getWidth(13.f));
        make.height.mas_equalTo(1);
        make.right.left.mas_equalTo(self.communicateView);
    }];
    
    [self.consumerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contactLine.mas_bottom).offset(getWidth(10.f));
        make.bottom.mas_equalTo(self.communicateView.mas_bottom).offset(getWidth(-10.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));

    }];
    
//    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.communicateView.mas_bottom).offset(getWidth(-10.f));
//        make.top.mas_equalTo(self.contactLine.mas_bottom).offset(getWidth(10.f));
//        make.right.mas_equalTo(getWidth(-40.f));
//        make.width.mas_equalTo(getWidth(345.f)/3);
//    }];
    
    [self.ownnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.communicateView.mas_bottom).offset(getWidth(15.f));
        make.left.width.mas_equalTo(self.communicateView);
        make.height.mas_equalTo(getWidth(77.f));
    }];
    
    CGFloat nameW = BoundWithSize(@"联系方式", kScreenWidth, 14.f).size.width + 20;
    [self.ownnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(nameW);
        make.height.mas_equalTo(self.ownnerLabel.font.pointSize);
    }];
    
    [self.ownnerSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ownnerLabel.mas_right).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(self.ownnerSubLabel.font.pointSize);
        make.top.mas_equalTo(self.ownnerLabel);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.ownnerLabel);
        make.height.mas_equalTo(self.phoneLabel.font.pointSize);
        make.top.mas_equalTo(self.ownnerLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.phoneSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.ownnerSubLabel);
        make.height.mas_equalTo(self.phoneSubLabel.font.pointSize);
        make.top.mas_equalTo(self.ownnerLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.ownnerView);
        make.height.mas_equalTo(getWidth(110.f));
        make.top.mas_equalTo(self.ownnerView.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(nameW);
        make.height.mas_equalTo(self.orderIdLabel.font.pointSize);
        make.top.mas_equalTo(getWidth(15.f));
    }];
    
    [self.createOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderIdLabel);
        make.width.mas_equalTo(nameW);
        make.height.mas_equalTo(self.createOrderLabel.font.pointSize);
        make.top.mas_equalTo(self.orderIdLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.payOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderIdLabel);
        make.width.mas_equalTo(nameW);
        make.height.mas_equalTo(self.payOrderLabel.font.pointSize);
        make.top.mas_equalTo(self.createOrderLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.orderSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderIdLabel.mas_right).offset(getWidth(12.f));
        make.height.mas_equalTo(self.orderSubLabel.font.pointSize);
        make.top.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.createOrderSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.createOrderLabel.mas_right).offset(getWidth(12.f));
        make.height.mas_equalTo(self.createOrderSubLabel.font.pointSize);
        make.top.mas_equalTo(self.orderIdLabel.mas_bottom).offset(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.paySubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.payOrderLabel.mas_right).offset(getWidth(12.f));
        make.height.mas_equalTo(self.paySubLabel.font.pointSize);
        make.top.mas_equalTo(self.payOrderLabel.mas_top);
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.rentAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.orderView);
        make.height.mas_equalTo(getWidth(77.f));
        make.top.mas_equalTo(self.orderView.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.amountLabel.font.pointSize);
        make.width.mas_equalTo(nameW);
    }];
    
    [self.amountSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountLabel.mas_right).offset(getWidth(15.f));
        make.height.mas_equalTo(self.amountSubLabel.font.pointSize);
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(getWidth(15.f));
    }];
    
    [self.depositLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountLabel);
        make.height.mas_equalTo(self.depositLabel.font.pointSize);
        make.width.mas_equalTo(nameW);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(getWidth(20.f));

    }];
    
    [self.depositSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.depositLabel.mas_right).offset(getWidth(15.f));
        make.height.mas_equalTo(self.depositSubLabel.font.pointSize);
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.orderView);
        make.height.mas_equalTo(getWidth(45.f));
        make.top.mas_equalTo(self.rentAmountView.mas_bottom).offset(getWidth(5.f));
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
    }];
    
    [self.toPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.toPaySubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toPayLabel.mas_right).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(50.f));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.height.mas_equalTo(getWidth(25));
    }];
}

- (UIButton *)focusBtn
{
    if (!_focusBtn) {
        _focusBtn = [UIButton new];
        _focusBtn.backgroundColor = COLOR_YELLOW_FBF8D9;
        [_focusBtn setImage:ImageNamed(@"button_unselected") forState:UIControlStateNormal];
        [_focusBtn setImage:ImageNamed(@"button_unselected") forState:UIControlStateHighlighted];
        [_focusBtn setImage:ImageNamed(@"button_select") forState:UIControlStateSelected];
        [_focusBtn setTitle:@"付款前请先阅读并同意《下单须知》" forState:UIControlStateNormal];
        [_focusBtn setTitleColor:COLOR_YELLOW_DF6F23 forState:UIControlStateNormal];
        [_focusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, getWidth(15.f), 0, 0)];
        [_focusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(21.f), 0, 0)];
        [_focusBtn addTarget:self action:@selector(onClickAddOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        _focusBtn.titleLabel.font = kFont_Regular(12.f);
        _focusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _focusBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = COLOR_YELLOW_FFB400;
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)payBtn
{
    if (!_payBtn) {
        _payBtn = [UIButton new];
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        _payBtn.backgroundColor = COLOR_RED_EA0000;
        _payBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_payBtn addTarget:self action:@selector(onClickPayBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _payBtn;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
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
        _titleLabel.text = @"订单详情";
    }
    return _titleLabel;
}

- (UIButton *)warningBtn
{
    if (!_warningBtn) {
        _warningBtn = [UIButton new];
        [_warningBtn setImage:ImageNamed(@"laba") forState:UIControlStateNormal];
        [_warningBtn setTitle:@"商家已接单，付款后即可准备拼租" forState:UIControlStateNormal];
        [_warningBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_warningBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(5.f), 0, 0)];
        _warningBtn.titleLabel.font = kFont_Medium(14.f);
        [_warningBtn addTarget:self action:@selector(onClickLoundBtn:) forControlEvents:UIControlEventTouchUpInside];
        _warningBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _warningBtn;
}

- (UIView *)communicateView
{
    if (!_communicateView) {
        _communicateView = [UIView new];
        _communicateView.backgroundColor = COLOR_GRAY_FFFFFF;
        _communicateView.layer.cornerRadius = 2.f;
        _communicateView.layer.masksToBounds = YES;
    }
    return _communicateView;
}

- (UIImageView *)thumbView
{
    if (!_thumbView ) {
        _thumbView = [UIImageView new];
        _thumbView.image = ImageNamed(@"");
    }
    return _thumbView;
}

- (UILabel *)rentDaysLabel
{
    if (!_rentDaysLabel) {
        _rentDaysLabel = [UILabel new];
        _rentDaysLabel.textColor = COLOR_GRAY_999999;
        _rentDaysLabel.textAlignment = NSTextAlignmentLeft;
        _rentDaysLabel.font = kFont_Regular(14.f);
        _rentDaysLabel.text = @"租期：7天";
    }
    return _rentDaysLabel;
}

- (UILabel *)duringDayslabel
{
    if (!_duringDayslabel) {
        _duringDayslabel = [UILabel new];
        _duringDayslabel.textColor = COLOR_GRAY_999999;
        _duringDayslabel.textAlignment = NSTextAlignmentLeft;
        _duringDayslabel.font = kFont_Regular(14.f);
        _duringDayslabel.text = @"入离店：09:00-18:00";
    }
    return _duringDayslabel;
}

- (UIView *)contactLine
{
    if (!_contactLine) {
        _contactLine = [UIView new];
        _contactLine.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _contactLine;
}

- (HPRightImageButton *)consumerBtn
{
    if (!_consumerBtn) {
        _consumerBtn = [HPRightImageButton new];
        [_consumerBtn setTintColor:COLOR_GREEN_2DC22A];
        [_consumerBtn setText:@"联系客服"];
        [_consumerBtn setFont:kFont_Bold(14.f)];
        [_consumerBtn setImage:ImageNamed(@"communicate_serve")];
        [_consumerBtn addTarget:self action:@selector(createConversationWithFriend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _consumerBtn;
}

#pragma mark - 开启会话
- (void)createConversationWithFriend:(UIButton *)button
{
    __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    [HUD HUDNotHidden:@"正在添加用户..."];
    
    NSString *storeOwnner = [NSString stringWithFormat:@"hepai%@",_model.order.userId];
    kWEAKSELF
    [JMSGConversation createSingleConversationWithUsername:storeOwnner appKey:JPushAppKey completionHandler:^(id resultObject, NSError *error) {
        
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

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton new];
        [_phoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        [_phoneBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [_phoneBtn setImage:ImageNamed(@"call_phone") forState:UIControlStateNormal];
        [_phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(6.f), 0, 0)];
        _phoneBtn.titleLabel.font = kFont_Medium(14.f);
        _phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_phoneBtn addTarget:self action:@selector(onClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UIView *)ownnerView
{
    if (!_ownnerView) {
        _ownnerView = [UIView new];
        _ownnerView.backgroundColor = COLOR_GRAY_FFFFFF;
        _ownnerView.layer.cornerRadius = 2.f;
        _ownnerView.layer.masksToBounds = YES;
    }
    return _ownnerView;
}

- (UILabel *)ownnerLabel
{
    if (!_ownnerLabel) {
        _ownnerLabel = [UILabel new];
        _ownnerLabel.textColor = COLOR_BLACK_333333;
        _ownnerLabel.textAlignment = NSTextAlignmentLeft;
        _ownnerLabel.font = kFont_Bold(14.f);
        _ownnerLabel.text = @"姓      名：";
    }
    return _ownnerLabel;
}

- (UILabel *)ownnerSubLabel
{
    if (!_ownnerSubLabel) {
        _ownnerSubLabel = [UILabel new];
        _ownnerSubLabel.textColor = COLOR_GRAY_666666;
        _ownnerSubLabel.textAlignment = NSTextAlignmentLeft;
        _ownnerSubLabel.font = kFont_Regular(14.f);
        _ownnerSubLabel.text = @"袁成燕";
    }
    return _ownnerSubLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.textColor = COLOR_BLACK_333333;
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.font = kFont_Bold(14.f);
        _phoneLabel.text = @"联系方式：";
    }
    return _phoneLabel;
}

- (UILabel *)phoneSubLabel
{
    if (!_phoneSubLabel) {
        _phoneSubLabel = [UILabel new];
        _phoneSubLabel.textColor = COLOR_GRAY_666666;
        _phoneSubLabel.textAlignment = NSTextAlignmentLeft;
        _phoneSubLabel.font = kFont_Regular(14.f);
        _phoneSubLabel.text = @"183 1115 9215";
    }
    return _phoneSubLabel;
}

- (UIView *)orderView
{
    if (!_orderView) {
        _orderView = [UIView new];
        _orderView.backgroundColor = COLOR_GRAY_FFFFFF;
        _orderView.layer.cornerRadius = 2.f;
        _orderView.layer.masksToBounds = YES;
    }
    return _orderView;
}

- (UILabel *)orderIdLabel
{
    if (!_orderIdLabel) {
        _orderIdLabel = [UILabel new];
        _orderIdLabel.textColor = COLOR_BLACK_333333;
        _orderIdLabel.textAlignment = NSTextAlignmentLeft;
        _orderIdLabel.font = kFont_Bold(14.f);
        _orderIdLabel.text = @"订单编号：";
    }
    return _orderIdLabel;
}

- (UILabel *)orderSubLabel
{
    if (!_orderSubLabel) {
        _orderSubLabel = [UILabel new];
        _orderSubLabel.textColor = COLOR_GRAY_666666;
        _orderSubLabel.textAlignment = NSTextAlignmentLeft;
        _orderSubLabel.font = kFont_Regular(14.f);
        _orderSubLabel.text = @"HD190321103";
    }
    return _orderSubLabel;
}

- (UILabel *)createOrderLabel
{
    if (!_createOrderLabel) {
        _createOrderLabel = [UILabel new];
        _createOrderLabel.textColor = COLOR_BLACK_333333;
        _createOrderLabel.textAlignment = NSTextAlignmentLeft;
        _createOrderLabel.font = kFont_Bold(14.f);
        _createOrderLabel.text = @"下单时间：";
    }
    return _createOrderLabel;
}

- (UILabel *)createOrderSubLabel
{
    if (!_createOrderSubLabel) {
        _createOrderSubLabel = [UILabel new];
        _createOrderSubLabel.textColor = COLOR_GRAY_666666;
        _createOrderSubLabel.textAlignment = NSTextAlignmentLeft;
        _createOrderSubLabel.font = kFont_Regular(14.f);
        _createOrderSubLabel.text = @"2019-03-21  09:21:12";
    }
    return _createOrderSubLabel;
}

- (UILabel *)payOrderLabel
{
    if (!_payOrderLabel) {
        _payOrderLabel = [UILabel new];
        _payOrderLabel.textColor = COLOR_BLACK_333333;
        _payOrderLabel.textAlignment = NSTextAlignmentLeft;
        _payOrderLabel.font = kFont_Bold(14.f);
        _payOrderLabel.text = @"支付方式：";
    }
    return _payOrderLabel;
}

- (UILabel *)paySubLabel
{
    if (!_paySubLabel) {
        _paySubLabel = [UILabel new];
        _paySubLabel.textColor = COLOR_GRAY_666666;
        _paySubLabel.textAlignment = NSTextAlignmentLeft;
        _paySubLabel.font = kFont_Regular(14.f);
        _paySubLabel.text = @"在线支付";
    }
    return _paySubLabel;
}

- (UIView *)rentAmountView
{
    if (!_rentAmountView) {
        _rentAmountView = [UIView new];
        _rentAmountView.backgroundColor = COLOR_GRAY_FFFFFF;
        _rentAmountView.layer.cornerRadius = 2.f;
        _rentAmountView.layer.masksToBounds = YES;
    }
    return _rentAmountView;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.textColor = COLOR_BLACK_333333;
        _amountLabel.textAlignment = NSTextAlignmentLeft;
        _amountLabel.font = kFont_Bold(14.f);
        _amountLabel.text = @"租金总额：";
    }
    return _amountLabel;
}

- (UILabel *)amountSubLabel
{
    if (!_amountSubLabel) {
        _amountSubLabel = [UILabel new];
        _amountSubLabel.textColor = COLOR_GRAY_666666;
        _amountSubLabel.textAlignment = NSTextAlignmentRight;
        _amountSubLabel.font = kFont_Regular(14.f);
        _amountSubLabel.text = @"¥ 10000";
    }
    return _amountSubLabel;
}

- (UILabel *)depositLabel
{
    if (!_depositLabel) {
        _depositLabel = [UILabel new];
        _depositLabel.textColor = COLOR_BLACK_333333;
        _depositLabel.textAlignment = NSTextAlignmentLeft;
        _depositLabel.font = kFont_Medium(14.f);
        _depositLabel.text = @"押      金：";
    }
    return _depositLabel;
}

- (UILabel *)depositSubLabel
{
    if (!_depositSubLabel) {
        _depositSubLabel = [UILabel new];
        _depositSubLabel.textColor = COLOR_RED_EA0000;
        _depositSubLabel.textAlignment = NSTextAlignmentRight;
        _depositSubLabel.font = kFont_Regular(14.f);
        _depositSubLabel.text = @"+¥ 0";
    }
    return _depositSubLabel;
}

- (UIView *)payView
{
    if (!_payView) {
        _payView = [UIView new];
        _payView.backgroundColor = COLOR_GRAY_FFFFFF;
        _payView.layer.cornerRadius = 2.f;
        _payView.layer.masksToBounds = YES;
    }
    return _payView;
}

- (UILabel *)toPayLabel
{
    if (!_toPayLabel) {
        _toPayLabel = [UILabel new];
        _toPayLabel.textColor = COLOR_BLACK_333333;
        _toPayLabel.textAlignment = NSTextAlignmentLeft;
        _toPayLabel.font = kFont_Bold(14.f);
        _toPayLabel.text = @"需付款：";
    }
    return _toPayLabel;
}

- (UILabel *)toPaySubLabel
{
    if (!_toPaySubLabel) {
        _toPaySubLabel = [UILabel new];
        _toPaySubLabel.textColor = COLOR_RED_FF1213;
        _toPaySubLabel.textAlignment = NSTextAlignmentRight;
        _toPaySubLabel.font = kFont_Medium(15.f);
        _toPaySubLabel.text = @"¥ 1036";
    }
    return _toPaySubLabel;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _bottomView;
}

- (void)onClickPhoneBtn:(HPRightImageButton *)button
{
    
}

- (void)onClickConsumerBtn:(UIButton *)button
{
    HPLog(@"联系客服");

}

- (void)onClickLoundBtn:(UIButton *)button
{

}

- (void)onClickCancelBtn:(UIButton *)button
{
    kWEAKSELF
    [self.view addSubview:weakSelf.quitView];
    self.quitView.textView.placeholder = @"  请填写取消此订单原因";
    
    [self.quitView show:YES];
    self.quitView.quitBlock = ^{
        HPLog(@"5555");
        [weakSelf.quitView show:NO];
        [weakSelf cancelOrder:weakSelf.model];
        
    };
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
        
    }
    return _quitView;
}

//租客取消订单
- (void)cancelOrder:(HOOrderListModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cancelReason"] = self.quitView.signTextView.text;
    dic[@"orderId"] = model.order.orderId;
    
    [HPHTTPSever HPPostServerWithMethod:@"/v1/order/tenantCancel" paraments:dic needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
        }else{
            [HPProgressHUD alertMessage:MSG];
            
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
- (void)onClickPayBtn:(UIButton *)button
{
    if (self.focusBtn.selected) {
        [self pushVCByClassName:@"HPOrderPayViewController" withParam:@{@"model":_model}];

    }else{
        [HPProgressHUD alertMessage:@"请先阅读下单须知"];
    }
}

- (void)onClickAddOrderBtn:(UIButton *)button
{
    button.selected = !button.selected;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    HPLog(@"dsD:%f",scrollView.contentOffset.y);
}
@end
