//
//  HPChangePasswordController.m
//  HPShareApp
//
//  Created by HP on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPChangePasswordController.h"

@interface HPChangePasswordController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UITextField *PassNewTextField;
@end

@implementation HPChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"修改密码"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kFont_Bold(23);
    titleLabel.textColor = COLOR_BLACK_444444;
    titleLabel.text = @"修改密码";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(g_statusBarHeight + getHeight(100.f));
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    UITextField *phoneNumTextField = [[UITextField alloc] init];
    [phoneNumTextField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [phoneNumTextField setTextColor:COLOR_BLACK_333333];
    [phoneNumTextField setTintColor:COLOR_RED_FF3C5E];
    [phoneNumTextField setKeyboardType:UIKeyboardTypeNumberPad];
    phoneNumTextField.delegate = self;
    phoneNumTextField.text = @"15817479363";
    self.phoneNumTextField = phoneNumTextField;
    NSMutableAttributedString *phoneNumPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号"];
    [phoneNumPlaceholder addAttribute:NSForegroundColorAttributeName
                                value:COLOR_GRAY_CCCCCC
                                range:NSMakeRange(0, 5)];
    [phoneNumPlaceholder addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                                range:NSMakeRange(0, 5)];
    [phoneNumTextField setAttributedPlaceholder:phoneNumPlaceholder];
    [self.view addSubview:phoneNumTextField];
    [phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(83.f * g_rateWidth);
    }];
    
    UIView *phoneNumLine = [[UIView alloc] init];
    [phoneNumLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:phoneNumLine];
    [phoneNumLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumTextField.mas_bottom).with.offset(12.f);
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
    
    self.codeTextField = codeTextField;
    NSMutableAttributedString *codePlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码"];
    [codePlaceholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_GRAY_CCCCCC
                            range:NSMakeRange(0, 5)];
    [codePlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                            range:NSMakeRange(0, 5)];
    [codeTextField setAttributedPlaceholder:codePlaceholder];
    [self.view addSubview:codeTextField];
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTextField);
        make.top.equalTo(phoneNumLine.mas_bottom).with.offset(33.f * g_rateWidth);
        make.right.equalTo(phoneNumTextField);
    }];
    
    UIView *codeLine = [[UIView alloc] init];
    [codeLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:codeLine];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).with.offset(6.f);;
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 1.f));
    }];
    
    UITextField *newPassTextField = [[UITextField alloc] init];
    [newPassTextField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [newPassTextField setTextColor:COLOR_BLACK_333333];
    [newPassTextField setTintColor:COLOR_RED_FF3C5E];
    [newPassTextField setKeyboardType:UIKeyboardTypeNumberPad];
    newPassTextField.delegate = self;
    [newPassTextField setKeyboardType:UIKeyboardTypeAlphabet];
    [newPassTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    NSMutableAttributedString *passPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入密码(最少6位)"];
    [passPlaceholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_GRAY_CCCCCC
                            range:NSMakeRange(0, 4)];
    [passPlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                            range:NSMakeRange(0, 4)];
    
    [passPlaceholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_GRAY_CCCCCC
                            range:NSMakeRange(5, 6)];
    [passPlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:FONT_MEDIUM size:13.f]
                            range:NSMakeRange(5, 6)];
    [newPassTextField setAttributedPlaceholder:passPlaceholder];
    [self.view addSubview:newPassTextField];
    self.PassNewTextField = newPassTextField;
    [newPassTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTextField);
        make.top.equalTo(codeLine.mas_bottom).with.offset(32.f * g_rateWidth);
        make.right.equalTo(phoneNumTextField);
    }];
    
    UIView *passLine = [[UIView alloc] init];
    [passLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:passLine];
    [passLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newPassTextField.mas_bottom).with.offset(12.f);;
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 1.f));
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn.layer setCornerRadius:24.f * g_rateWidth];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [loginBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [loginBtn addTarget:self action:@selector(onClickCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passLine.mas_bottom).with.offset(25.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
}
- (void)onClickCodeBtn:(UIButton *)button
{
    [self getChangeCodeNumber];
}

- (void)onClickCompleteBtn:(UIButton *)button
{
    if (self.phoneNumTextField.text.length < 11) {
        [HPProgressHUD alertMessage:@"请输入11位手机号"];
    }else if (self.codeTextField.text.length < 6){
        [HPProgressHUD alertMessage:@"请输入6位验证码"];
    }else if (self.PassNewTextField.text.length < 6) {
        [HPProgressHUD alertMessage:@"请输入密码"];
    }
    if (self.phoneNumTextField.text.length == 11&&self.codeTextField.text.length == 6&&self.PassNewTextField.text.length >= 6) {
        [self onClickCompleteChangehandle];
    }
}
#pragma mark - 完成修改密码操作
- (void)onClickCompleteChangehandle
{
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *dict = (NSDictionary *)account.userInfo;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"avatarUrl"] = dict[@"avatarUrl"];
    dic[@"company"] = dict[@"company"];
    dic[@"createTime"] = dict[@"createTime"];
    dic[@"deleteTime"] = dict[@"deleteTime"];
    dic[@"email"] = dict[@"email"];
    dic[@"mobile"] = dict[@"mobile"];
    dic[@"password"] = _PassNewTextField.text;
    dic[@"realName"] = dict[@"realName"];
    dic[@"signature"] = dict[@"signatureContext"];
    dic[@"realName"] = dict[@"realName"];
    dic[@"code"] = _codeTextField.text;

    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/updateUser" paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            account.userInfo = [HPUserInfo mj_objectWithKeyValues:responseObject[@"data"][@"userInfo"]];
            [HPUserTool saveAccount:account];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
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
    }else if (textField == self.PassNewTextField){
        if (textField.text.length < 6) {
            [HPProgressHUD alertMessage:@"请输入6位验证码"];
        }else{
//            self.codeTextField.text = [textField.text substringToIndex:6];
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
//            _isValidate = [HPValidatePhone validateContactNumber:textField.text];
            
            return YES;
        }
    }else if (textField == self.codeTextField){
        if (textField.text.length >= 6) {
            //            [HPProgressHUD alertMessage:@"请输入6位验证码"];
            self.codeTextField.text = [textField.text substringToIndex:6];
            //            [textField resignFirstResponder];
            return YES;
        }
    }else if (textField == self.PassNewTextField){
        if (textField.text.length >= 6) {
            //            [HPProgressHUD alertMessage:@"请输入6位验证码"];
//            self.codeTextField.text = [textField.text substringToIndex:6];
            //            [textField resignFirstResponder];
            return YES;
        }
    }
    return YES;
}

#pragma mark - 获取验证码--
/**
 状态：1：账号密码登录；0：验证码登录
 */
- (void)getChangeCodeNumber
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mobile"] = self.phoneNumTextField.text;
    dic[@"state"] = @"1";
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/getCode" paraments:dic complete:^(id  _Nonnull responseObject) {
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


@end
