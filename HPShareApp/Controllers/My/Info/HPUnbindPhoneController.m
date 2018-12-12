//
//  HPUnbindPhoneController.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUnbindPhoneController.h"

@interface HPUnbindPhoneController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *codeTextField;
@end

@implementation HPUnbindPhoneController

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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"更改绑定手机"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:23.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    [titleLabel setText:@"身份验证"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateHeight);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    HPLoginModel *model = [HPUserTool account];
    NSDictionary *dic = (NSDictionary *)model.userInfo;
    NSString *mobile = dic[@"mobile"];
    NSString *rangeStr = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setText:[NSString stringWithFormat:@"请使用当前绑定手机号+86 %@接收验证码",rangeStr]];
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.left.equalTo(titleLabel);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    [textField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [textField setTextColor:COLOR_BLACK_333333];
    [textField setTintColor:COLOR_RED_FF3C5E];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    textField.delegate = self;
    self.codeTextField = textField;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"请输入验证码"];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:COLOR_GRAY_CCCCCC
                        range:NSMakeRange(0, 5)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                        range:NSMakeRange(0, 5)];
    [textField setAttributedPlaceholder:placeholder];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(descLabel.mas_bottom).with.offset(48.f * g_rateWidth);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).with.offset(5.f);
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
        make.right.equalTo(line);
        make.centerY.equalTo(textField);
        make.width.mas_equalTo(80.f);
    }];
    
    [textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeBtn.mas_left).with.offset(-5.f);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.layer setCornerRadius:24.f * g_rateWidth];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [confirmBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [confirmBtn setTitle:@"验证" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(30.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
}

- (void)onClickCodeBtn:(UIButton *)btn {
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
    dic[@"state"] = @"1";
    dic[@"code"] = _codeTextField.text;

    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/getCode" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"发送成功"];
            weakSelf.codeTextField.text = responseObject[@"data"];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
- (void)onClickConfirmBtn:(UIButton *)btn {
    if (_codeTextField.text.length == 6) {
        [self pushVCByClassName:@"HPBindPhoneController"];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.codeTextField){
        if (textField.text.length < 6) {
            [HPProgressHUD alertMessage:@"请输入6位验证码"];
        }else{
            self.codeTextField.text = [textField.text substringToIndex:6];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.codeTextField){
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
