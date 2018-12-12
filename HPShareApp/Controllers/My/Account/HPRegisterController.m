//
//  HPRegisterController.m
//  HPShareApp
//
//  Created by HP on 2018/11/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRegisterController.h"
#import "HPValidatePhone.h"

@interface HPRegisterController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, assign) BOOL isValidate;

/**
 状态：-1：验证码登录；1：账号密码登录；0：注册
 */
@property (nonatomic, copy) NSString *state;
@end

@implementation HPRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _state = @"0";
    [self setupUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"注册"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:23.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    [titleLabel setText:@"手机注册账户"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateWidth);
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setText:@"进入设置中心可更改绑定手机号"];
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
    phoneNumTextField.text = @"15817479363";
    NSMutableAttributedString *phoneNumPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号"];
    [phoneNumPlaceholder addAttribute:NSForegroundColorAttributeName
                                value:COLOR_GRAY_CCCCCC
                                range:NSMakeRange(0, 5)];
    [phoneNumPlaceholder addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                                range:NSMakeRange(0, 5)];
    [phoneNumTextField setAttributedPlaceholder:phoneNumPlaceholder];
    [self.view addSubview:phoneNumTextField];
    _phoneNumTextField = phoneNumTextField;
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
    _codeTextField = codeTextField;
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTextField);
        make.top.equalTo(phoneNumLine.mas_bottom).with.offset(33.f * g_rateWidth);
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
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    [passwordTextField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [passwordTextField setTextColor:COLOR_BLACK_333333];
    [passwordTextField setTintColor:COLOR_RED_FF3C5E];
    [passwordTextField setSecureTextEntry:YES];
    [passwordTextField setKeyboardType:UIKeyboardTypeAlphabet];
    [passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    passwordTextField.secureTextEntry = YES;
    NSMutableAttributedString *passwordPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入新密码（最少6位）"];
    [passwordPlaceholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_GRAY_CCCCCC
                            range:NSMakeRange(0, 12)];
    [passwordPlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                            range:NSMakeRange(0, 6)];
    [passwordPlaceholder addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:FONT_MEDIUM size:13.f]
                                range:NSMakeRange(6, 6)];
    [passwordTextField setAttributedPlaceholder:passwordPlaceholder];
    [self.view addSubview:passwordTextField];
    _passwordTextField = passwordTextField;
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTextField);
        make.top.equalTo(codeLine.mas_bottom).with.offset(33.f * g_rateWidth);
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
    
    UIButton *registerBtn = [[UIButton alloc] init];
    [registerBtn.layer setCornerRadius:24.f * g_rateWidth];
    [registerBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [registerBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [registerBtn addTarget:self action:@selector(onClickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLine.mas_bottom).with.offset(25.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
    
    UIButton *switchBtn = [[UIButton alloc] init];
    [switchBtn.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [switchBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [switchBtn setTitle:@"已有账号，立即登录" forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(onClickSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerBtn.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - OnClick

- (void)onClickRegisterBtn:(UIButton *)btn {
    NSLog(@"onClickRegisterBtn");
    if (_phoneNumTextField.text.length != 11) {
        [HPProgressHUD alertMessage:@"请输入正确的手机号"];
    }else if (_codeTextField.text.length != 6){
        [HPProgressHUD alertMessage:@"请输入正确的验证码"];
    }else{
        [self regiestHttpServer];
    }
}

- (void)onClickCodeBtn:(UIButton *)btn {
    NSLog(@"onClickCodeBtn");
    if (_phoneNumTextField.text.length != 11) {
        [HPProgressHUD alertMessage:@"请输入正确的手机号"];
    }else{
        [self getCodeNumber];
    }
    
}

#pragma mark - 获取验证码
- (void)getCodeNumber
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mobile"] = self.phoneNumTextField.text;
    dic[@"state"] = _state;
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/getCode" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"发送成功"];
            weakSelf.codeTextField.text = responseObject[@"data"];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        [HPProgressHUD alertMessage:@"网络错误"];
    }];
}


#pragma mark - 注册
- (void)regiestHttpServer
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"code"] = self.codeTextField.text;
    dic[@"mobile"] = self.phoneNumTextField.text;
    dic[@"password"] = self.passwordTextField.text;
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/register" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet

    }];
}
- (void)onClickSwitchBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
            //            [HPProgressHUD alertMessage:@"请输入11位手机号"];
            self.phoneNumTextField.text = [textField.text substringToIndex:11];
            //[textField resignFirstResponder];
            //            [self.codeTextField becomeFirstResponder];
            _isValidate = [HPValidatePhone validateContactNumber:textField.text];
            
            return YES;
        }
    }else if (textField == self.codeTextField){
        if (textField.text.length >= 6) {
            //            [HPProgressHUD alertMessage:@"请输入6位验证码"];
            self.codeTextField.text = [textField.text substringToIndex:6];
            //            [textField resignFirstResponder];
            return YES;
        }
    }
    return YES;
}
@end
