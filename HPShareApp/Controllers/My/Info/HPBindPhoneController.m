//
//  HPBindPhoneController.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBindPhoneController.h"

@interface HPBindPhoneController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneNumTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@end

@implementation HPBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"绑定新号码"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:23.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    [titleLabel setText:@"绑定新号码"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateWidth);
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UITextField *phoneNumTextField = [[UITextField alloc] init];
    [phoneNumTextField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [phoneNumTextField setTextColor:COLOR_BLACK_333333];
    [phoneNumTextField setTintColor:COLOR_RED_FF3C5E];
    [phoneNumTextField setKeyboardType:UIKeyboardTypeNumberPad];
    NSMutableAttributedString *phoneNumPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入新手机号"];
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
        make.top.equalTo(titleLabel.mas_bottom).with.offset(75.f * g_rateWidth);
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
        make.top.equalTo(phoneNumLine.mas_bottom).with.offset(30.f * g_rateWidth);
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
    [confirmBtn setTitle:@"确定更改" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLine.mas_bottom).with.offset(45.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
}

- (void)onClickConfirmBtn:(UIButton *)btn {
    if (self.phoneNumTextField.text.length < 11) {
        [HPProgressHUD alertMessage:@"请输入11位手机号"];
    }else if (self.codeTextField.text.length < 6){
        [HPProgressHUD alertMessage:@"请输入6位验证码"];
    }
    if (self.phoneNumTextField.text.length == 11&&self.codeTextField.text.length == 6) {
        [self confirmTochangeBindPhone];
    }
}

- (void)onClickCodeBtn:(UIButton *)btn {
    NSLog(@"onClickCodeBtn");
    [self getCodeNumberInBindPhone];
}

#pragma mark - 获取验证码--
/**
 状态：1：获取验证码的时候
 */
- (void)getCodeNumberInBindPhone
{
    HPLoginModel *model = [HPUserTool account];
    NSDictionary *dict = (NSDictionary *)model.userInfo;
    NSString *mobile = dict[@"mobile"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mobile"] = mobile;
    dic[@"state"] = @"-1";
    
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

/**
 确定更改手机号
 */
- (void)confirmTochangeBindPhone
{
    HPLoginModel *model = [HPUserTool account];
    NSDictionary *dict = (NSDictionary *)model.userInfo;
    NSString *mobile = dict[@"mobile"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mobile"] = mobile;
    dic[@"state"] = @"-1";
    dic[@"code"] = _codeTextField.text;
    
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/verify" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"修改成功"];
            //获取本地用户数据
            HPLoginModel *account = [HPUserTool account];
            NSDictionary *dic = (NSDictionary *)model.userInfo;
            HPLog(@"userInfo original:%@  ",account.userInfo);
            HPUserInfo *userInfo = [[HPUserInfo alloc] init];
            userInfo.avatarUrl = dic[@"avatarUrl"]?:@"";
            userInfo.company = dic[@"company"]?:@"";
            userInfo.password = dic[@"password"]?:@"";
            userInfo.realName = dic[@"realName"]?:@"";
            userInfo.signatureContext = dic[@"signatureContext"]?:@"";
            userInfo.telephone = dic[@"telephone"]?:@"";
            userInfo.title = dic[@"title"]?:@"";
            userInfo.username = dic[@"username"]?:@"";
            userInfo.userId = dic[@"userId"]?:@"";

            userInfo.mobile = weakSelf.phoneNumTextField.text;
            account.userInfo = userInfo;
            HPLog(@"userInfo:%@  ",account.userInfo);
            [HPUserTool saveAccount:account];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSInteger count = self.navigationController.viewControllers.count;
                UIViewController *vc = self.navigationController.viewControllers[count - 3];
                [self.navigationController popToViewController:vc animated:YES];
            });
            
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
    }
    return YES;
}
@end
