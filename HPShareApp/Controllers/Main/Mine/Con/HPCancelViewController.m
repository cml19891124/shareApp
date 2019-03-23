//
//  HPCancelViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/23.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCancelViewController.h"

#import "HPGradientUtil.h"

#import "HPlaceholdTextView.h"

@interface HPCancelViewController ()

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UILabel *accountCancelLabel;

@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UILabel *cancelReasonLabel;

@property (nonatomic, strong) UIView *signContentView;

@property (nonatomic, strong) HPlaceholdTextView *signTextView;

@property (nonatomic, strong) UIButton *userBtn;

@property (nonatomic, strong) UIButton *applyBtn;

@end

@implementation HPCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    _navTitleView = [self setupNavigationBarWithTitle:@"账号注销"];
    
    [self.view addSubview:self.accountCancelLabel];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR_ORANGE_EB0303 endColor:UIColor.clearColor];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.view addSubview:self.colorBtn];
    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];

    [self.view addSubview:self.cancelReasonLabel];

    [self.view addSubview:self.signContentView];
    
    [self.signContentView addSubview:self.signTextView];
    
    [self.view addSubview:self.userBtn];

    [self.view addSubview:self.applyBtn];

    [self setUpSubviewsMasonry];
}

- (void)setUpSubviewsMasonry
{
    [self.accountCancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navTitleView.mas_bottom).offset(19.f * g_rateWidth);
        make.left.mas_equalTo(15.f * g_rateWidth);
        make.right.mas_equalTo(-15.f * g_rateWidth);
        make.height.mas_equalTo(self.accountCancelLabel.font.pointSize);
    }];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));

    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.top.equalTo(self.accountCancelLabel.mas_bottom).offset(getWidth(12.f));
        make.size.mas_equalTo(btnSize);
    }];

    [self.cancelReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.colorBtn.mas_bottom).offset(getWidth(50.f));
        make.left.mas_equalTo(getWidth(18.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(self.cancelReasonLabel.font.pointSize);
    }];

    [self.signContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cancelReasonLabel.mas_bottom).offset(getWidth(18.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(getWidth(120.f));
    }];
    
    [_signTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(getWidth(10.f), getWidth(11.f), getWidth(11.f), getWidth(10.f)));
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(getWidth(-15.f)-g_bottomSafeAreaHeight);
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo((kScreenWidth - getWidth(45.f))/2);
        make.height.mas_equalTo(getWidth(44.f));
    }];
    
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(getWidth(-15.f)-g_bottomSafeAreaHeight);
        make.right.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(self.userBtn);
        make.height.mas_equalTo(getWidth(44.f));
    }];
}

- (UILabel *)accountCancelLabel
{
    if (!_accountCancelLabel) {
        _accountCancelLabel = [[UILabel alloc] init];
        [_accountCancelLabel setFont:kFont_Bold(18.f)];
        [_accountCancelLabel setTextColor:COLOR_BLACK_333333];
        [_accountCancelLabel setText:@"账号注销申请"];
        
    }
    return _accountCancelLabel;
}

- (UIButton *)colorBtn
{
    if (!_colorBtn) {
        _colorBtn = [[UIButton alloc] init];
        [_colorBtn.layer setCornerRadius:2.f];
        [_colorBtn.layer setMasksToBounds:YES];
    }
    return _colorBtn;
}

- (UILabel *)cancelReasonLabel
{
    if (!_cancelReasonLabel) {
        _cancelReasonLabel = [UILabel new];
        [_cancelReasonLabel setFont:kFont_Bold(16.f)];
        [_cancelReasonLabel setTextColor:COLOR_BLACK_333333];
        [_cancelReasonLabel setText:@"请填写注销申请原因"];
    }
    return _cancelReasonLabel;
}

- (UIView *)signContentView
{
    if (!_signContentView) {
        _signContentView = [UIView new];
        _signContentView.backgroundColor = COLOR_GRAY_F6F6F6;

    }
    return _signContentView;
}

- (HPlaceholdTextView *)signTextView
{
    if (!_signTextView) {
        _signTextView = [[HPlaceholdTextView alloc] init];
        _signTextView.backgroundColor = COLOR_GRAY_F6F6F6;
        _signTextView.textLength = 64;
        _signTextView.interception = YES;
//        _signTextView.placehLab.text = @"0";
        _signTextView.placehTextColor = COLOR_GRAY_CCCCCC;
        _signTextView.placehFont = kFont_Medium(12.f);
        _signTextView.delegate = self;
        _signTextView.placehText = @"  账号注销后，正在进行中的交易以及所有账户信息将不再保存";
        _signTextView.promptTextColor = COLOR_GRAY_CCCCCC;
        _signTextView.promptFont = kFont_Medium(12.f);
        _signTextView.promptBackground = COLOR_GRAY_F6F6F6;
        _signTextView.promptFrameMaxY = getWidth(-11.f);
        _signTextView.tintColor = COLOR_RED_FF3C5E;
        _signTextView.EditChangedBlock = ^{
            
        };
        
    }
    return _signTextView;
}

- (UIButton *)userBtn
{
    if (!_userBtn) {
        _userBtn = [UIButton new];
        [_userBtn setTitle:@"再用用看" forState:UIControlStateNormal];
        [_userBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _userBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _userBtn.backgroundColor = COLOR_RED_EA0000;
        _userBtn.layer.cornerRadius = 6;
        _userBtn.layer.masksToBounds= YES;
    }
    return _userBtn;
}

- (UIButton *)applyBtn
{
    if (!_applyBtn) {
        _applyBtn = [UIButton new];
        [_applyBtn setTitle:@"狠心申请" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        _applyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _applyBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        [_applyBtn addTarget:self action:@selector(applyCancelAccount:) forControlEvents:UIControlEventTouchUpInside];
        _applyBtn.layer.cornerRadius = 6;
        _applyBtn.layer.masksToBounds= YES;
    }
    return _applyBtn;
}

- (void)applyCancelAccount:(UIButton *)button
{
    
}
@end