//
//  HPLoginByPasswordController.m
//  HPShareApp
//
//  Created by HP on 2018/11/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLoginByPasswordController.h"
#import "HPValidatePhone.h"
#import "HPMainTabBarController.h"
#import "EBBannerView.h"

@interface HPLoginByPasswordController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *phoneNumTextField;
@property (assign, nonatomic) BOOL isValidate;
@end

@implementation HPLoginByPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)onClickBackBtn:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"登录"];
    
    UIButton *registerBtn = [[UIButton alloc] init];
    [registerBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [registerBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];\
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(onClickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navigationView).with.offset(- 20.f * g_rateWidth);
        make.centerY.equalTo(navigationView);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:ImageNamed(@"icon_back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView).with.offset(20.f * g_rateWidth);
        make.centerY.equalTo(navigationView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:23.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    [titleLabel setText:@"账号密码登录"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateWidth);
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setText:@"支持手机号、用户名等多种方式登录"];
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
    self.phoneNumTextField = phoneNumTextField;
    NSMutableAttributedString *phoneNumPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"手机号/用户名"];
    [phoneNumPlaceholder addAttribute:NSForegroundColorAttributeName
                                value:COLOR_GRAY_CCCCCC
                                range:NSMakeRange(0, 5)];
    [phoneNumPlaceholder addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                                range:NSMakeRange(0, 5)];
    [phoneNumTextField setAttributedPlaceholder:phoneNumPlaceholder];
//    phoneNumTextField.text = @"15817479363";
    [self.view addSubview:phoneNumTextField];
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
    
    [phoneNumTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneNumLine);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    [passwordTextField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [passwordTextField setTextColor:COLOR_BLACK_333333];
    [passwordTextField setTintColor:COLOR_RED_FF3C5E];
    [passwordTextField setSecureTextEntry:YES];
    [passwordTextField setKeyboardType:UIKeyboardTypeAlphabet];
    [passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    passwordTextField.delegate = self;
//    passwordTextField.text = @"aaa123";
    self.passwordTextField = passwordTextField;
    NSMutableAttributedString *passwordPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入密码"];
    [passwordPlaceholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_GRAY_CCCCCC
                            range:NSMakeRange(0, 5)];
    [passwordPlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                            range:NSMakeRange(0, 5)];
    [passwordTextField setAttributedPlaceholder:passwordPlaceholder];
    [self.view addSubview:passwordTextField];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTextField);
        make.top.equalTo(phoneNumLine.mas_bottom).with.offset(35.f * g_rateWidth);
        make.right.equalTo(phoneNumTextField);
    }];
    
    UIView *passwordLine = [[UIView alloc] init];
    [passwordLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:passwordLine];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTextField.mas_bottom).with.offset(5.f);;
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 1.f));
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn.layer setCornerRadius:24.f * g_rateWidth];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [loginBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:COLOR_RED_EA0000];
    [loginBtn addTarget:self action:@selector(onClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLine.mas_bottom).with.offset(25.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
    
    UIButton *switchBtn = [[UIButton alloc] init];
    [switchBtn.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [switchBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [switchBtn setTitle:@"手机快速登录" forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(onClickSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(20.f * g_rateWidth);
        make.left.equalTo(self.view).with.offset(113.f * g_rateWidth);
    }];
    
    UIView *separator = [[UIView alloc] init];
    [separator setBackgroundColor:COLOR_BLACK_666666];
    [self.view addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(switchBtn);
        make.left.equalTo(switchBtn.mas_right).with.offset(11.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(1.f, 13.f));
    }];
    
    UIButton *forgetBtn = [[UIButton alloc] init];
    [forgetBtn.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [forgetBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(onClickForgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separator.mas_right).with.offset(11.f * g_rateWidth);
        make.centerY.equalTo(separator);
    }];
    
//    UILabel *thirdPartLabel = [[UILabel alloc] init];
//    [thirdPartLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
//    [thirdPartLabel setTextColor:COLOR_GRAY_999999];
//    [thirdPartLabel setText:@"使用第三方账号登录"];
//    [self.view addSubview:thirdPartLabel];
//    [thirdPartLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).with.offset(- g_bottomSafeAreaHeight - 42.f * g_rateWidth);
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(thirdPartLabel.font.pointSize);
//    }];
//    
//    UIView *thirdPartView = [[UIView alloc] init];
//    [self.view addSubview:thirdPartView];
//    [thirdPartView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(thirdPartLabel.mas_top).with.offset(-20.f * g_rateWidth);
//        make.centerX.equalTo(self.view);
//    }];
//    [self setupThirdPartView:thirdPartView];
}

- (void)setupThirdPartView:(UIView *)view {
    UIButton *qqBtn = [[UIButton alloc] init];
    [qqBtn setTag:0];
    [qqBtn setImage:[UIImage imageNamed:@"my_qq_icon"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(onClickThirdPartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
    }];
    
    UIButton *wechatBtn = [[UIButton alloc] init];
    [wechatBtn setTag:1];
    [wechatBtn setImage:[UIImage imageNamed:@"my_wechat_icon"] forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(onClickThirdPartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:wechatBtn];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqBtn.mas_right).with.offset(40.f * g_rateWidth);
        make.top.and.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
    }];
    
    UIButton *sinaBtn = [[UIButton alloc] init];
    [sinaBtn setTag:2];
    [sinaBtn setImage:[UIImage imageNamed:@"my_sina_icon"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(onClickThirdPartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sinaBtn];
    [sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechatBtn.mas_right).with.offset(40.f * g_rateWidth);
        make.top.and.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
        make.right.equalTo(view);
    }];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - OnClick
- (void)onClickLoginBtn:(UIButton *)btn {
    if (self.phoneNumTextField.text.length < 11) {
        [HPProgressHUD alertMessage:@"请输入11位手机号"];
    }else if (self.passwordTextField.text.length < 6){
        [HPProgressHUD alertMessage:@"请输入6位验证码"];
    }
    if (self.phoneNumTextField.text.length == 11&&self.passwordTextField.text.length == 6) {
        [self isCanLogin];
    }
}

- (void)isCanLogin
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"password"] = _passwordTextField.text;
    dic[@"mobile"] = _phoneNumTextField.text;
    dic[@"state"] = @"1";
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/login" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            HPLoginModel *model = [HPLoginModel AccountStatusWithDict:responseObject[@"data"]];
            [HPUserTool saveAccount:model];
            [HPProgressHUD alertMessage:@"登录成功"];
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
                [self dismissViewControllerAnimated:NO completion:NULL];
            });
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}



- (void)onClickRegisterBtn:(UIButton *)btn {
    [self pushVCByClassName:@"HPRegisterController"];
}

- (void)onClickSwitchBtn:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickForgetBtn:(UIButton *)btn {
//    [self pushVCByClassName:@"HPForgetPasswordController"];
    [self pushVCByClassName:@"HPForgetPasswordController" withParam:@{@"isForget":@"0"}];

}

- (void)onClickThirdPartBtn:(UIButton *)btn {
    if (btn.tag == 0) {
        HPLog(@"onClickThirdPartBtn: QQ");
    }
    else if (btn.tag == 1) {
        HPLog(@"onClickThirdPartBtn: WeChat");
    }
    else if (btn.tag == 2) {
        HPLog(@"onClickThirdPartBtn: Sina");
    }
}

- (void)onClickBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    }else if (textField == self.passwordTextField){
        if (textField.text.length < 6) {
            [HPProgressHUD alertMessage:@"请输入6位验证码"];
        }else{
            self.passwordTextField.text = [textField.text substringToIndex:6];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTextField) {
        if (textField.text.length >= 11) {
            //            [HPProgressHUD alertMessage:@"请输入11位手机号"];
            self.phoneNumTextField.text = [textField.text substringToIndex:10];
            //[textField resignFirstResponder];
            //            [self.codeTextField becomeFirstResponder];
            _isValidate = [HPValidatePhone validateContactNumber:textField.text];
            
            return YES;
        }
    }else if (textField == self.passwordTextField){
        if (textField.text.length >= 6) {
            //            [HPProgressHUD alertMessage:@"请输入6位验证码"];
            self.passwordTextField.text = [textField.text substringToIndex:6];
            //            [textField resignFirstResponder];
            return YES;
        }
    }
    return YES;
}
@end
