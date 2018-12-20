//
//  HPConfigUserNameController.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPConfigUserNameController.h"

@interface HPConfigUserNameController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation HPConfigUserNameController

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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"设置您的用户名"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:23.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    if ([self.param[@"title"] isEqualToString:@"设置您的用户名"]) {
        navigationView = [self setupNavigationBarWithTitle:@"设置您的用户名"];
        [titleLabel setText:@"设置您的用户名"];
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的姓名"]) {
        navigationView = [self setupNavigationBarWithTitle:@"编辑您的姓名"];
        [titleLabel setText:@"编辑您的姓名"];
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的公司名"]) {
        navigationView = [self setupNavigationBarWithTitle:@"编辑您的公司名"];
        [titleLabel setText:@"编辑您的公司名"];
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的联系方式"]) {
        navigationView = [self setupNavigationBarWithTitle:@"编辑您的联系方式"];
        [titleLabel setText:@"编辑您的联系方式"];
    }
    [self.view addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateHeight);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    [textField setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [textField setTextColor:COLOR_BLACK_333333];
    [textField setTintColor:COLOR_RED_FF3C5E];
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.textField = textField;
    NSString *inputstr;
    if ([self.param[@"title"] isEqualToString:@"设置您的用户名"]) {
        inputstr = @"设置您的用户名";
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的姓名"]) {
        inputstr = @"设置您的姓名";
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的公司名"]) {
        inputstr = @"设置您的公司名";
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的联系方式"]) {
        inputstr = @"设置您的联系方式";
    }
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:inputstr];
    [placeholder addAttribute:NSForegroundColorAttributeName
                                value:COLOR_GRAY_CCCCCC
                                range:NSMakeRange(0, inputstr.length)];
    [placeholder addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:FONT_MEDIUM size:16.f]
                                range:NSMakeRange(0, inputstr.length)];
    [textField setAttributedPlaceholder:placeholder];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(75.f * g_rateWidth);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).with.offset(5.f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 1.f));
    }];
    
    [textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.layer setCornerRadius:24.f * g_rateWidth];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [confirmBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(30.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
}

- (void)onClickConfirmBtn:(UIButton *)btn {
    [self.view endEditing:YES];
    if (self.textField.text.length) {
        [self updateUserCardInfo];
    }
}

- (void)updateUserCardInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *method = @"/v1/user/cardInfo";
    NSString *inputstr;
    if ([self.param[@"title"] isEqualToString:@"设置您的用户名"]) {
        inputstr = @"username";
        method = @"/v1/user/updateUser";
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的姓名"]) {
        inputstr = @"realName";
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的公司名"]) {
        inputstr = @"company";
    }else if ([self.param[@"title"] isEqualToString:@"编辑您的联系方式"]) {
        inputstr = @"telephone";
    }
    dic[inputstr] = self.textField.text;
    HPLoginModel *account = [HPUserTool account];
    [HPHTTPSever HPGETServerWithMethod:method isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            
            NSDictionary *result = responseObject[@"data"];
            HPCardInfo *cardInfo = [[HPCardInfo alloc] init];

            NSString *inputstr;
            if ([self.param[@"title"] isEqualToString:@"设置您的用户名"]) {
                inputstr = @"username";
                account.userInfo.username = result[@"username"]?:@"";
            }else if ([self.param[@"title"] isEqualToString:@"编辑您的姓名"]) {
                inputstr = @"realName";
                cardInfo.realName = result[@"realName"]?:@"";

            }else if ([self.param[@"title"] isEqualToString:@"编辑您的公司名"]) {
                inputstr = @"company";
                cardInfo.company = result[@"company"]?:@"";

            }else if ([self.param[@"title"] isEqualToString:@"编辑您的联系方式"]) {
                inputstr = @"telephone";
                cardInfo.telephone = result[@"telephone"]?:@"";
            }
            account.userInfo.avatarUrl = account.userInfo.avatarUrl?:@"";
            account.userInfo.password = account.userInfo.password?:@"";
            account.userInfo.userId = account.userInfo.userId?:@"";
            account.userInfo.mobile = account.userInfo.mobile?:@"";
            
            account.cardInfo.avatarUrl = account.cardInfo.avatarUrl?:@"";
            account.cardInfo.signature = account.cardInfo.signature?:@"";
            account.cardInfo.title = account.cardInfo.title?:@"";
            account.cardInfo.userId = account.cardInfo.userId?:@"";
            [HPUserTool saveAccount:account];
            [HPProgressHUD alertMessage:@"修改成功"];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [self updateUserCardInfo];
    }
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textField) {
        if (textField.text.length <= 0) {
            [HPProgressHUD alertMessage:@"输入内容不能为空"];
        }
    }
    
}
@end
