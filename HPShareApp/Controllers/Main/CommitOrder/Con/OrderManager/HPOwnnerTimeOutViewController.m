//
//  HPOwnnerTimeOutViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/3.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "HPSingleton.h"

#import "HPOwnnerTimeOutViewController.h"

#import "HOOrderListModel.h"

#import "HPSingleton.h"

#import "HPAttributeLabel.h"

@interface HPOwnnerTimeOutViewController ()<UIScrollViewDelegate>
/**
 室内、室外
 */
@property (strong, nonatomic) UILabel *rentOutsideLabel;

@property (strong, nonatomic) UILabel *timeoutLabel;

@property (strong, nonatomic) UIView *timeOutView;

@property (strong, nonatomic) UIImageView *timeOutImageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

/**
 联系商家的view
 */
@property (nonatomic, strong) UIView *communicateView;

@property (nonatomic, strong) UIImageView *thumbView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *spaceInfoLabel;

@property (nonatomic, strong) UIView *contactLine;

@property (nonatomic, strong) UIButton *consumerBtn;

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

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) UIButton *focusBtn;

@end

@implementation HPOwnnerTimeOutViewController

- (UILabel *)timeoutLabel
{
    if (!_timeoutLabel) {
        _timeoutLabel = [UILabel new];
        _timeoutLabel.text = @"支付超时，交易关闭。";
        _timeoutLabel.font = kFont_Bold(14.f);
        _timeoutLabel.textColor = COLOR_BLACK_333333;
        _timeoutLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeoutLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.text = @"";
        _priceLabel.font = kFont_Bold(14.f);
        _priceLabel.textColor = COLOR_RED_EA0000;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

- (UIView *)timeOutView
{
    if (!_timeOutView) {
        _timeOutView = [UIView new];
        _timeOutView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _timeOutView;
}

- (UIImageView *)timeOutImageView
{
    if (!_timeOutImageView) {
        _timeOutImageView = [UIImageView new];
        _timeOutImageView.image = ImageNamed(@"timeout_pic");
        _timeOutImageView.backgroundColor = COLOR_GRAY_CCCCCC;
    }
    return _timeOutImageView;
}


- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if ([HPSingleton sharedSingleton].identifyTag == 1) {
        
        [self.cancelBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        self.cancelBtn.layer.borderColor= COLOR_RED_EA0000.CGColor;
        [self.payBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else{
        [self.cancelBtn setTitleColor:COLOR_GRAY_666666 forState:UIControlStateNormal];
        self.cancelBtn.layer.borderColor= COLOR_GRAY_666666.CGColor;
        [self.payBtn setTitle:@"重新下单" forState:UIControlStateNormal];
        [self.payBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        self.payBtn.layer.borderColor= COLOR_RED_EA0000.CGColor;
    }
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",_model.spaceDetail.address];
    
    self.phoneSubLabel.text = _model.spaceDetail.contactMobile;
    
    self.ownnerSubLabel.text = _model.spaceDetail.contact?_model.spaceDetail.contact:@"--";
    
    self.toPaySubLabel.text = _model.spaceDetail.rent;
    
    self.createOrderSubLabel.text = _model.order.createTime;

    self.orderSubLabel.text = _model.order.orderNo;
    
    self.locationLabel.text = [NSString stringWithFormat:@"拼租位置：%@",_model.spaceDetail.address];
    
    if (_model.spaceDetail.rentOutside.integerValue == 0) {
        [self.rentOutsideLabel setText:@"室外"];
    }else{
        [self.rentOutsideLabel setText:@"室内"];
        
    }
    
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

    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",_model.order.totalFee];
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
    
    [self.scrollView addSubview:self.timeOutView];
    
    [self.timeOutView addSubview:self.timeOutImageView];
    
    [self.timeOutView addSubview:self.timeoutLabel];

    [self.scrollView addSubview:self.communicateView];
    
    [self.communicateView addSubview:self.thumbView];
    
    [self.communicateView addSubview:self.nameLabel];
    
    [self.communicateView addSubview:self.locationLabel];
    
    [self.communicateView addSubview:self.rentOutsideLabel];

    [self.communicateView addSubview:self.spaceInfoLabel];
    
    [self.communicateView addSubview:self.addressLabel];
    
    [self.communicateView addSubview:self.contactLine];
    
    [self.communicateView addSubview:self.consumerBtn];
    
    [self.communicateView addSubview:self.phoneBtn];
    
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
    
    [self.bottomView addSubview:self.priceLabel];

    
    [self.bottomView addSubview:self.payBtn];
    
    [self.bottomView addSubview:self.cancelBtn];

    [self.view addSubview:self.focusBtn];
    
}

-(void)setUpCommitSubviewsMasonry
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-g_bottomSafeAreaHeight + getWidth(-60.f));
    }];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, g_statusBarHeight + 44));
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
    
    [self.timeOutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, getWidth(140.f)));
        make.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
    
    [self.timeOutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(118.f), getWidth(82.f)));
        make.centerX.mas_equalTo(self.headerView);
        make.top.mas_equalTo(getWidth(22.f));
    }];
    
    [self.timeoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, self.timeoutLabel.font.pointSize));
        make.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.timeOutImageView.mas_bottom);
    }];
    
    [self.communicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(getWidth(345.f));
        make.height.mas_equalTo(getWidth(133.f));
        make.top.mas_equalTo(self.timeOutView.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(getWidth(85.f));
        make.top.left.mas_equalTo(getWidth(15.f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.left.mas_equalTo(self.thumbView.mas_right).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        
    }];
    
    __block CGFloat locW = BoundWithSize(_model.spaceDetail.rentPlace?_model.spaceDetail.rentPlace:@"拼租位置:--", kScreenWidth, 14.f).size.width + 50;
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
        make.left.mas_equalTo(self.locationLabel.mas_right).offset(getWidth(2.f));
        make.top.mas_equalTo(self.locationLabel.mas_top);
        make.height.mas_equalTo(self.rentOutsideLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(30.f));
    }];
    
    [self.spaceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.spaceInfoLabel.font.pointSize);
        make.left.mas_equalTo(self.thumbView.mas_right).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.spaceInfoLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.addressLabel.font.pointSize);
        make.left.mas_equalTo(self.thumbView.mas_right).offset(getWidth(10.f));
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
        make.left.mas_equalTo(getWidth(40.f));
        make.width.mas_equalTo(getWidth(345.f)/3);
        
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.communicateView.mas_bottom).offset(getWidth(-10.f));
        make.top.mas_equalTo(self.contactLine.mas_bottom).offset(getWidth(10.f));
        make.right.mas_equalTo(getWidth(-40.f));
        make.width.mas_equalTo(getWidth(345.f)/3);
    }];
    
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
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    CGFloat payW = BoundWithSize(self.payBtn.currentTitle, kScreenWidth, 12.f).size.width + 30;
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(30.f));
        make.centerY.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(payW);
        make.right.mas_equalTo(self.bottomView).offset(getWidth(-15));
    }];

    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(30.f));
        make.width.mas_equalTo(payW);
        make.centerY.mas_equalTo(self.bottomView); make.right.mas_equalTo(self.payBtn.mas_left).offset(getWidth(-15.f));
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
        _cancelBtn.layer.cornerRadius = 15.f;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = COLOR_GRAY_CCCCCC.CGColor;
        [_cancelBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont_Medium(12.f);
        _cancelBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)payBtn
{
    if (!_payBtn) {
        _payBtn = [UIButton new];
        _payBtn.layer.cornerRadius = 15.f;
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.borderWidth = 1;
        _payBtn.layer.borderColor = COLOR_RED_EA0000.CGColor;
        [_payBtn setTitle:@"重新下单" forState:UIControlStateNormal];
        [_payBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        _payBtn.titleLabel.font = kFont_Medium(12.f);
        _payBtn.backgroundColor = COLOR_GRAY_FFFFFF;
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
        _titleLabel.text = @"交易关闭";
    }
    return _titleLabel;
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

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.textColor = COLOR_GRAY_999999;
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = kFont_Regular(14.f);
        _locationLabel.text = @"租期：7天";
    }
    return _locationLabel;
}

- (UILabel *)spaceInfoLabel
{
    if (!_spaceInfoLabel) {
        _spaceInfoLabel = [UILabel new];
        _spaceInfoLabel.textColor = COLOR_GRAY_999999;
        _spaceInfoLabel.textAlignment = NSTextAlignmentLeft;
        _spaceInfoLabel.font = kFont_Regular(14.f);
        _spaceInfoLabel.text = @"入离店：09:00-18:00";
    }
    return _spaceInfoLabel;
}

- (UIView *)contactLine
{
    if (!_contactLine) {
        _contactLine = [UIView new];
        _contactLine.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _contactLine;
}

- (UIButton *)consumerBtn
{
    if (!_consumerBtn) {
        _consumerBtn = [UIButton new];
        [_consumerBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        _consumerBtn.titleLabel.font = kFont_Medium(14.f);
        [_consumerBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [_consumerBtn setImage:ImageNamed(@"communicate_serve") forState:UIControlStateNormal];
        [_consumerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(6.f), 0, 0)];
        _consumerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_consumerBtn addTarget:self action:@selector(onClickConsumerBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _consumerBtn;
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

- (void)onClickPhoneBtn:(UIButton *)button
{
    
}

- (void)onClickConsumerBtn:(UIButton *)button
{
    
}

- (void)onClickLoundBtn:(UIButton *)button
{
    
}

- (void)onClickCancelBtn:(UIButton *)button
{
    
    [self deleteOrderFromList:_model];
}


- (void)deleteOrderFromList:(HOOrderListModel *)model
{
    NSString *method;
    if ([HPSingleton sharedSingleton].identifyTag == 0) {
        method = @"/v1/order/delete";//租客删除
    }else{
        method = @"/v1/order/bossCancel";//店主删除
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isBoss"] = @([HPSingleton sharedSingleton].identifyTag);
    dic[@"orderId"] = model.order.orderId;
    [HPHTTPSever HPGETServerWithMethod:method isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
//重新下单
- (void)onClickPayBtn:(UIButton *)button
{
    HPLog(@"重新下单");
    if ([button.currentTitle isEqualToString:@"重新下单"]) {
        [self pushVCByClassName:@"HPShareShopListController"];

    }
}

- (void)onClickAddOrderBtn:(UIButton *)button
{
    button.selected = !button.selected;
    
}


#pragma mark - 取消下拉  允许上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.scrollView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.scrollView.contentOffset = offset;
}
@end
