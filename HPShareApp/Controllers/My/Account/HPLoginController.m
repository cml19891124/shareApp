//
//  HPLoginController.m
//  HPShareApp
//
//  Created by HP on 2018/11/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLoginController.h"
#import "HPProgressHUD.h"
#import "HPLoginByPasswordController.h"
#import "HPValidatePhone.h"
#import "HPLoginModel.h"
#import <UserNotifications/UserNotifications.h>
#import "EBBannerView.h"

@interface HPLoginController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *probtn;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *codeTextField;



/**
 手机号是否有效
 */
@property (nonatomic, assign) BOOL isValidate;
@end

@implementation HPLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    HPLog(@"self.navigationController.childViewControllers:%@",self.navigationController.childViewControllers);
    HPLoginModel *model = [HPUserTool account];
    if (model.token && self.navigationController.childViewControllers.count >= 2) {
        [self.navigationController popViewControllerAnimated:NO];
    }
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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:23.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    [titleLabel setText:@"手机快捷登录"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateWidth);
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setText:@"未注册的手机号将自动注册账号"];
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
//    phoneNumTextField.text = @"15817479363";
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
        make.top.equalTo(phoneNumLine.mas_bottom).with.offset(35.f * g_rateWidth);
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
    
    UIView *protocalView = [[UIView alloc] init];
    [protocalView setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:protocalView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkProtocalContent:)];
    [protocalView addGestureRecognizer:tap];
    [protocalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLine.mas_bottom).with.offset(20.f);;
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 25.f * g_rateWidth));
    }];
    
    UIButton *probtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [probtn setBackgroundImage:ImageNamed(@"unselected button") forState:UIControlStateNormal];
    [probtn setBackgroundImage:ImageNamed(@"check_button") forState:UIControlStateSelected];
    [protocalView addSubview:probtn];
    probtn.userInteractionEnabled = NO;
    probtn.selected = YES;
    self.probtn= probtn;
    [probtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(protocalView);
        make.centerY.equalTo(protocalView);
        make.height.width.mas_equalTo(14.f * g_rateWidth);
    }];
    
    NSString *prostr = @"注册/登录即代表同意《合店站用户服务及隐私保护协议》";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:prostr];
    NSRange proRange = [prostr rangeOfString:@"《合店站用户服务及隐私保护协议》"];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:proRange];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_666666 range:NSMakeRange(0, proRange.location)];

    UILabel *proLabel = [[UILabel alloc] init];
    proLabel.font = kFont_Medium(12);
    proLabel.attributedText = attr;
    [protocalView addSubview:proLabel];
    [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(probtn.mas_right).offset(5);
        make.top.bottom.right.mas_equalTo(protocalView);
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
        make.top.equalTo(protocalView.mas_bottom).with.offset(25.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
    
    UIButton *switchBtn = [[UIButton alloc] init];
    [switchBtn.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [switchBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [switchBtn setTitle:@"使用账号密码登录" forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(onClickSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(self.view);
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
#pragma mark - 是否同意协议
- (void)checkProtocalContent:(UITapGestureRecognizer *)tap
{
    HPLog(@"protocal");
    self.probtn.selected = !self.probtn.selected;
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

#pragma mark - OnClick

- (void)onClickLoginBtn:(UIButton *)btn {
    if (self.phoneNumTextField.text.length < 11) {
        [HPProgressHUD alertMessage:@"请输入11位手机号"];
    }else if (self.codeTextField.text.length < 6){
        [HPProgressHUD alertMessage:@"请输入6位验证码"];
    }else
    if (!self.probtn.selected) {
        [HPProgressHUD alertMessage:@"请选择同意协议"];
    }
    if (self.phoneNumTextField.text.length == 11&&self.codeTextField.text.length == 6&&self.probtn.selected) {
        [self isCanLogin];
    }
}

- (void)isCanLogin
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"code"] = _codeTextField.text;
    dic[@"mobile"] = _phoneNumTextField.text;
    dic[@"state"] = @"0";

    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/login" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            HPLoginModel *model = [HPLoginModel mj_objectWithKeyValues:responseObject[@"data"]];
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
                [self.navigationController popViewControllerAnimated:YES];
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

- (void)onClickCodeBtn:(UIButton *)btn {
    NSLog(@"onClickCodeBtn");
    if (_phoneNumTextField.text.length != 11) {
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


- (void)onClickSwitchBtn:(UIButton *)btn {
    HPLoginByPasswordController *vc = [[HPLoginByPasswordController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navigationController setNavigationBarHidden:YES];
    [navigationController.interactivePopGestureRecognizer setDelegate:self.navigationController.viewControllers.firstObject];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onClickThirdPartBtn:(UIButton *)btn {
    if (btn.tag == 0) {
        NSLog(@"onClickThirdPartBtn: QQ");
    }
    else if (btn.tag == 1) {
        NSLog(@"onClickThirdPartBtn: WeChat");
    }
    else if (btn.tag == 2) {
        NSLog(@"onClickThirdPartBtn: Sina");
    }
    
    [self pushVCByClassName:@"HPLoginByPasswordController"];
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
