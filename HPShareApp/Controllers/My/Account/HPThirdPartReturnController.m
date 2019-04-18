//
//  HPThirdPartReturnController.m
//  HPShareApp
//
//  Created by HP on 2018/11/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPThirdPartReturnController.h"

#import "EBBannerView.h"

@interface HPThirdPartReturnController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *loginType;

@end

@implementation HPThirdPartReturnController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _code = self.param[@"code"];

    _loginType = self.param[@"login"];
    [self setupUI];
}


- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"绑定手机号"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:21.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    NSString *title;
    if ([_loginType isEqualToString:@"wx"]) {
        title = @"您的微信账号“合派科技”已通过验证";
        
    }else if ([_loginType isEqualToString:@"QQ"]){
        title = @"您的QQ账号“合派科技”已通过验证";

    }else{
        title = @"您的微博账号“合派科技”已通过验证";

    }
    [titleLabel setText:title];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateWidth);
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setText:@"绑定手机号同步账号信息，登录更方便"];
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.left.equalTo(titleLabel);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UITextField *phoneNumTextField = [[UITextField alloc] init];
    [phoneNumTextField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [phoneNumTextField setTextColor:COLOR_BLACK_333333];
    [phoneNumTextField setTintColor:COLOR_RED_FF3C5E];
    [phoneNumTextField setKeyboardType:UIKeyboardTypeNumberPad];
    phoneNumTextField.delegate = self;
    NSMutableAttributedString *phoneNumPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号"];
    [phoneNumPlaceholder addAttribute:NSForegroundColorAttributeName
                                value:COLOR_GRAY_CCCCCC
                                range:NSMakeRange(0, 5)];
    [phoneNumPlaceholder addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                                range:NSMakeRange(0, 5)];
    [phoneNumTextField setAttributedPlaceholder:phoneNumPlaceholder];
    [self.view addSubview:phoneNumTextField];
    self.phoneNumTextField = phoneNumTextField;
    [phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(descLabel.mas_bottom).with.offset(57.f * g_rateWidth);
    }];
    
    UIView *phoneNumLine = [[UIView alloc] init];
    [phoneNumLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:phoneNumLine];
    [phoneNumLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumTextField.mas_bottom).with.offset(5.f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 1.f));
    }];
    
    UIButton *codeBtn = [[UIButton alloc] init];
    [codeBtn.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:15.f]];
    [codeBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(onClickCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneNumLine);
        make.centerY.equalTo(phoneNumTextField);
        make.width.mas_equalTo(80.f);
    }];
    
    [phoneNumTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeBtn.mas_left).with.offset(-5.f);
    }];
    
    UITextField *codeTextField = [[UITextField alloc] init];
    [codeTextField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [codeTextField setTextColor:COLOR_BLACK_333333];
    [codeTextField setTintColor:COLOR_RED_FF3C5E];
    [codeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    codeTextField.delegate = self;

    NSMutableAttributedString *codePlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码"];
    [codePlaceholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_GRAY_CCCCCC
                            range:NSMakeRange(0, 5)];
    [codePlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                            range:NSMakeRange(0, 5)];
    [codeTextField setAttributedPlaceholder:codePlaceholder];
    [self.view addSubview:codeTextField];
    self.codeTextField = codeTextField;
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTextField);
        make.top.equalTo(phoneNumLine.mas_bottom).with.offset(35.f * g_rateWidth);
        make.right.equalTo(phoneNumTextField);
    }];
    
    UIView *codeLine = [[UIView alloc] init];
    [codeLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:codeLine];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).with.offset(5.f);;
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 1.f));
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.layer setCornerRadius:24.f * g_rateWidth];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [confirmBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [confirmBtn setTitle:@"绑定手机号" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLine.mas_bottom).with.offset(25.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
}

#pragma mark - OnClick

- (void)onClickConfirmBtn:(UIButton *)btn {
    HPLog(@"nClickConfirmBtn");
    if (_code) {
        [self bindPhone];
    }
    
}

- (void)bindPhone
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mobile"] = self.phoneNumTextField.text;//@"18316227457";//
    dic[@"code"] = _code;//@"071FrSaG11agj807uWbG1iKZaG1FrSai";//
    dic[@"mobileCode"] = self.codeTextField.text;//@"717420";//
    [HPHTTPSever HPGETServerWithMethod:@"/v1/wechatUser/bindMobile" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"绑定成功"];
            
            [self getPramfromWechatApi:self.code];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        [HPProgressHUD alertMessage:@"网络错误"];
    }];
}

#pragma mark - 微信登录
- (void)getPramfromWechatApi:(NSString *)code
{
    [HPHTTPSever HPGETServerWithMethod:@"/v1/wechatUser/login" isNeedToken:NO paraments:@{@"code":code} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            HPLoginModel *model = [HPLoginModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [HPUserTool saveAccount:model];
            //⭐️5.iOS 11 style (iOS 11 样式)
            EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                make.style = 11;
                make.icon = [UIImage imageNamed:@"icon"];
                make.title = @"登录成功";
                make.content = @"欢迎加入合店站，合店站有你更精彩。";
                //                make.date = @"2017 10 19";
            }];
            [banner show];
            [kNotificationCenter postNotificationName:@"login" object:nil userInfo:@{@"date":[HPTimeString getNowTimeTimestamp],@"title":@"登录成功",@"content":@"欢迎加入合店站，合店站有你更精彩。"}];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)onClickCodeBtn:(UIButton *)btn {
    HPLog(@"onClickCodeBtn");
    
    if (_phoneNumTextField.text.length < 11) {
        
        [HPProgressHUD alertMessage:@"请输入正确的手机号"];
    }else{
        [self getCodeNumber];
    }
    
}

#pragma mark - 获取验证码--
/**
 状态：1：账号密码登录；0：验证码登录
 */
- (void)getCodeNumber
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mobile"] = self.phoneNumTextField.text;

    [HPHTTPSever HPGETServerWithMethod:@"/v1/mobile/code" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"发送成功"];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        [HPProgressHUD alertMessage:@"网络错误"];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneNumTextField) {
        if (textField.text.length < 11) {
            [HPProgressHUD alertMessage:@"请输入11位手机号"];
        }else{
            self.phoneNumTextField.text = [textField.text substringToIndex:11];
        }
    }else if (textField == self.codeTextField){
        if (textField.text.length < 6) {
            [HPProgressHUD alertMessage:@"请输入6位验证码"];
        }else{
            self.codeTextField.text = [textField.text substringToIndex:6];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTextField) {
        if (textField.text.length >= 11) {
            
            self.phoneNumTextField.text = [self.phoneNumTextField.text substringToIndex:10];
            
//            _isValidate = [HPValidatePhone validateContactNumber:textField.text];
            
            return YES;
        }
    }else if (textField == self.codeTextField){
        if (textField.text.length >= 6) {
            
            self.codeTextField.text = [textField.text substringToIndex:6];
            
            return YES;
        }
    }
    return YES;
}

@end
