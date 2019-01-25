//
//  HPUpdateUserNameController.m
//  HPShareApp
//
//  Created by HP on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSignInfoController.h"
#import "HPlaceholdTextView.h"

@interface HPSignInfoController ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITextField *signField;
@property (nonatomic, strong) HPlaceholdTextView *signTextView;
@property (nonatomic, strong) UILabel *titleNumLabel;
/**
 签名标题
 */
@property (nonatomic, copy) NSString *signString;

/**
 签名信息
 */
@property (nonatomic, copy) NSString *signInfoString;
@end

@implementation HPSignInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];

}

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:self.param[@"title"]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:23.f]];
    [titleLabel setTextColor:COLOR_BLACK_444444];
    [titleLabel setText:@"输入您的签名"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25.f * g_rateWidth);
        make.top.equalTo(navigationView.mas_bottom).with.offset(55.f * g_rateHeight);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UIView *signTitleView = [[UIView alloc] init];
    [self.view addSubview:signTitleView];
    [signTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(getWidth(25.f));
        make.right.mas_equalTo(self.view).offset(getWidth(-25.f));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(getWidth(77.f));
        make.height.mas_equalTo(getWidth(30.f));
    }];
    
    UILabel *signTitleLabel = [[UILabel alloc] init];
    [signTitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:17.f]];
    [signTitleLabel setTextColor:COLOR_BLACK_333333];
    [signTitleLabel setText:@"签名标题"];
    [signTitleView addSubview:signTitleLabel];
    [signTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(signTitleView);
        make.width.mas_equalTo(getWidth(85.f));
    }];
    
    UITextField *signField = [[UITextField alloc] init];
    signField.placeholder = @"请输入签名标题";
    [signField setValue:COLOR_GRAY_BBBBBB forKeyPath:@"_placeholderLabel.textColor"];
    [signField setValue:[UIFont boldSystemFontOfSize:17] forKeyPath:@"_placeholderLabel.font"];
    signField.textColor = COLOR_BLACK_333333;
    signField.font = kFont_Medium(17);
    signField.tintColor = COLOR_RED_FF3C5E;
    signField.delegate = self;
    [signField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [signTitleView addSubview:signField];
    self.signField = signField;
    UILabel *titleNumLabel = [[UILabel alloc] init];
    [titleNumLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [titleNumLabel setTextColor:COLOR_GRAY_CCCCCC];
    [titleNumLabel setText:[NSString stringWithFormat:@"%ld/12",self.signString.length]];
    [signTitleView addSubview:titleNumLabel];
    self.titleNumLabel = titleNumLabel;
    [titleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(signTitleView.mas_right).offset(getWidth(-2.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(40), getWidth(14.f)));
        make.centerY.mas_equalTo(signTitleView);
    }];

    self.signField = signField;
    [signField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signTitleLabel.mas_right).offset(getWidth(20.f));
        make.top.bottom.mas_equalTo(signTitleView);
        make.right.mas_equalTo(titleNumLabel.mas_left).offset(-10.f);
    }];
    UILabel *leftView = [[UILabel alloc] init];
    signField.leftView = leftView;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(3.f), getWidth(83.f)));
    }];
    
    UIView *signLine = [[UIView alloc] init];
    signLine.backgroundColor = COLOR_GRAY_EEEEEE;
    [self.view addSubview:signLine];
    [signLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(1.f));
        make.left.width.mas_equalTo(signTitleView);
        make.top.mas_equalTo(signTitleView.mas_bottom).offset(getWidth(10.f));
    }];
    
    UILabel *signTipLabel = [[UILabel alloc] init];
    [signTipLabel setFont:[UIFont fontWithName:FONT_BOLD size:17.f]];
    [signTipLabel setTextColor:COLOR_BLACK_333333];
    [signTipLabel setText:@"签名内容"];
    [self.view addSubview:signTipLabel];
    [signTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signTitleView);
        make.width.mas_equalTo(getWidth(85.f));
        make.height.mas_equalTo(getWidth(30.f));
        make.top.mas_equalTo(signLine.mas_bottom).offset(getWidth(23.f));
        
    }];
    
    UIView *signContentView = [UIView new];
    signContentView.backgroundColor = COLOR_GRAY_F6F6F6;
    [self.view addSubview:signContentView];
    [signContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(signTitleView);
        make.top.mas_equalTo(signTipLabel.mas_bottom).offset(getWidth(17.f));
        make.height.mas_equalTo(getWidth(110.f));
    }];
    
    HPlaceholdTextView *signTextView = [[HPlaceholdTextView alloc] init];
    signTextView.backgroundColor = COLOR_GRAY_F6F6F6;
    signTextView.textLength = 64;
    signTextView.interception = YES;
    signTextView.placehLab.text = @"0";
//    signTextView.holdLabel.backgroundColor = COLOR_GRAY_F6F6F6;
    signTextView.placehTextColor = COLOR_GRAY_CCCCCC;
    signTextView.placehFont = kFont_Medium(12.f);
    signTextView.delegate = self;
    signTextView.placehText = @" 请输入您的公司介绍或者合作愿景。";
    signTextView.promptTextColor = COLOR_GRAY_CCCCCC;
    signTextView.promptFont = kFont_Medium(12.f);
    signTextView.promptBackground = COLOR_GRAY_F6F6F6;
    signTextView.promptFrameMaxY = getWidth(-11.f);
    signTextView.tintColor = COLOR_RED_FF3C5E;
    signTextView.EditChangedBlock = ^{
        
    };
    [signContentView addSubview:signTextView];
    self.signTextView = signTextView;
    [signTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(getWidth(10.f), getWidth(11.f), getWidth(11.f), getWidth(10.f)));
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.layer setCornerRadius:24.f * g_rateWidth];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [confirmBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:COLOR_RED_EA0000];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signContentView.mas_bottom).with.offset(27.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 47.f * g_rateWidth));
    }];
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    HPLog(@"值是---%@",textField.text);
    [self.titleNumLabel setText:[NSString stringWithFormat:@"%ld/12",textField.text.length]];
}
- (void)onClickConfirmBtn:(UIButton *)button
{
    [self.view endEditing:YES];
    if (self.signField.text.length <= 0) {
        [HPProgressHUD alertMessage:@"请输入签名标题"];

    }else if (self.signTextView.text.length <= 0){
        [HPProgressHUD alertMessage:@"请输入签名信息"];
    }else if(self.signField.text.length > 0 && self.signTextView.text.length > 0){
        [self updateUserCardInfo];
    }
}
#pragma mark - 修改签名
- (void)updateUserCardInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"title"] = self.signField.text;
    dic[@"signature"] = self.signTextView.text;

    HPLoginModel *account = [HPUserTool account];
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/cardInfo" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSDictionary *result = responseObject[@"data"];
            account.cardInfo.realName = account.cardInfo.realName?:@"";
            account.cardInfo.company = account.cardInfo.company?:@"";
            account.cardInfo.telephone = account.cardInfo.telephone?:@"";
            account.cardInfo.avatarUrl = account.cardInfo.avatarUrl?:@"";
            account.cardInfo.signature = result[@"signature"]?:@"";
            account.cardInfo.title = result[@"title"]?:@"";
            account.cardInfo.userId = account.cardInfo.userId?:@"";
            [HPUserTool saveAccount:account];
            [HPProgressHUD alertMessage:@"修改成功"];
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

# pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.signTextView) {
        if (textView.text.length <= 0) {
            [HPProgressHUD alertMessage:@"请输入签名信息"];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 64) {
        [HPProgressHUD alertMessage:@"签名信息不得超过64位"];
        _signTextView.text = [text substringToIndex:text.length - 1];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length <= 0) {
        [HPProgressHUD alertMessage:@"请输入签名标题"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 12) {
        [HPProgressHUD alertMessage:@"签名标题不得超过12位"];
        self.signField.text = [textField.text substringToIndex:12];
        return NO;
    }else{
        return YES;
    }
    return YES;
}
@end
