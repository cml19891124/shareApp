//
//  HPWithdrawViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPWithdrawViewController.h"

#import "HPSwitchCardsViewController.h"

#import "HPAcceptView.h"

#import "HPCardsInfoModel.h"

#import "HPOperationNumberTool.h"

@interface HPWithdrawViewController ()<BankCardsInfoDelegate>

@property (strong, nonatomic) HPAcceptView *accpetView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UIView *tipView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (strong, nonatomic) UIView *bankView;

@property (strong, nonatomic) UIImageView *bankIcon;

@property (strong, nonatomic) UILabel *bankLabel;

@property (strong, nonatomic) UIButton *rowBtn;

@property (strong, nonatomic) UIView *withdrawView;

@property (strong, nonatomic) UILabel *inputLabel;

@property (strong, nonatomic) UITextField *inputField;

@property (strong, nonatomic) UILabel *withdrawLabel;

@property (strong, nonatomic) UIButton *tipBtn;

@property (strong, nonatomic) UIButton *commitBtn;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIButton *warnBtn;

@property (strong, nonatomic) HPCardsInfoModel *model;

@property (strong, nonatomic) NSMutableArray *banksCardArray;

@property (nonatomic, copy) NSString *shareBankCardId;
@end

@implementation HPWithdrawViewController

- (HPAcceptView *)accpetView
{
    if (!_accpetView ) {
        kWEAKSELF
        _accpetView = [HPAcceptView new];
        _accpetView.kownBlock = ^{
            [weakSelf.accpetView show:NO];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _accpetView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.banksCardArray = [NSMutableArray array];
    
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self setUpRecordsSubviews];
    
    [self setUpRecordsSubviewsMasonry];
    
    [self getCardsInfoListApi];
}

- (void)getCardsInfoListApi
{
    [HPHTTPSever HPPostServerWithMethod:@"/v1/bankCard/queryBankCard" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.banksCardArray removeAllObjects];
            
            NSArray *cardsArray = [HPCardsInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            [self.banksCardArray addObjectsFromArray:cardsArray];
            
            HPCardsInfoModel *model = self.banksCardArray[0];
            self.model = model;
            [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:model.logUrl] placeholderImage:ImageNamed(@"")];
            
            self.bankLabel.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,[model.accountNo substringFromIndex:model.accountNo.length - 4]];
            
            self.shareBankCardId = self.model.shareBankCardId;

        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setUpRecordsSubviews
{
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.tipView];

    [self.tipView addSubview:self.tipLabel];
    
    [self.view addSubview:self.bankView];

    [self.bankView addSubview:self.bankIcon];

    [self.bankView addSubview:self.bankLabel];

    [self.bankView addSubview:self.rowBtn];

    [self.view addSubview:self.withdrawView];
    
    NSString *input = [HPOperationNumberTool separateNumberUseCommaWith:self.inputField.text];
    
    self.inputField.text = [NSString stringWithFormat:@"%@",input];

    [self.withdrawView addSubview:self.inputLabel];

    [self.withdrawView addSubview:self.inputField];

    [self.withdrawView addSubview:self.withdrawLabel];
    
    self.withdrawLabel.text = [NSString stringWithFormat:@"可提现余额：%@.00元",self.param[@"balance"]];

    [self.withdrawView addSubview:self.lineView];

    [self.withdrawView addSubview:self.tipBtn];
    
    [self.view addSubview:self.warnBtn];

    [self.withdrawView addSubview:self.commitBtn];

}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _lineView;
}

- (UIButton *)warnBtn
{
    if (!_warnBtn) {
        _warnBtn = [UIButton new];
        [_warnBtn setTitle:@"可提现余额=账户总余额-已申请提现金额 \n我们将在1-3个工作日内完成提现申请受\n理，请耐心等候。" forState:UIControlStateNormal];
        [_warnBtn setBackgroundImage:ImageNamed(@"dikaung") forState:UIControlStateNormal];
        [_warnBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _warnBtn.titleLabel.font = kFont_Regular(12.f);
        _warnBtn.hidden = YES;
        [_warnBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _warnBtn.titleLabel.numberOfLines = 0;
    }
    return _warnBtn;
}

- (void)setUpRecordsSubviewsMasonry
{
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.right.left.mas_equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.top.bottom.mas_equalTo(self.tipView);
    }];
    
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(60.f));
        make.top.mas_equalTo(self.tipView.mas_bottom);
    }];
    
    [self.bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.height.width.mas_equalTo(getWidth(24.f));
        make.centerY.mas_equalTo(self.bankView);
    }];
    
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bankIcon.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.bankLabel.font.pointSize);
        make.centerY.mas_equalTo(self.bankView);
    }];
    
    [self.rowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-25.f));
        make.height.mas_equalTo(getWidth(13.f));
        make.width.mas_equalTo(getWidth(8.f));
        make.centerY.mas_equalTo(self.bankView);
    }];
    
    [self.withdrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(235.f));
        make.top.mas_equalTo(self.bankView.mas_bottom);
    }];
    
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(self.inputLabel.font.pointSize);
        make.top.mas_equalTo(getWidth(10.f));
    }];
    
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));

        make.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(self.inputLabel.mas_bottom).offset(getWidth(30.f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.inputField);
        make.top.mas_equalTo(self.inputField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    CGFloat withW = BoundWithSize(self.withdrawLabel.text, kScreenWidth, 14.f).size.width;
    [self.withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputField);
        make.width.mas_equalTo(withW);
        
        make.height.mas_equalTo(self.withdrawLabel.font.pointSize);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.withdrawLabel.mas_right).offset(getWidth(10));
        make.width.height.mas_equalTo(getWidth(13.f));
        make.centerY.mas_equalTo(self.withdrawLabel);
    }];
    
    [self.warnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.bottom.mas_equalTo(self.lineView.mas_bottom).offset(getWidth(7.f));
        make.width.mas_equalTo(getWidth(250.f));
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-23.f));
        make.left.mas_equalTo(getWidth(23.f));

        make.top.mas_equalTo(self.withdrawLabel.mas_bottom).offset(getWidth(40.f));
        make.height.mas_equalTo(getWidth(44.f));
        
    }];
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:ImageNamed(@"fanhui") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];
        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"提交申请";
    }
    return _titleLabel;
}

- (UIView *)tipView
{
    if (!_tipView) {
        _tipView = [UIView new];
        _tipView.backgroundColor = COLOR_GRAY_F9FAFD;
    }
    return _tipView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textColor = COLOR_BLACK_333333;
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.font = kFont_Bold(16.f);
        _tipLabel.text = @"提现到银行卡";
    }
    return _tipLabel;
}

- (UIView *)bankView
{
    if (!_bankView) {
        _bankView = [UIView new];
        _bankView.backgroundColor = COLOR_GRAY_FFFFFF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedWithBank:)];
        [_bankView addGestureRecognizer:tap];
    }
    return _bankView;
}

- (UIButton *)rowBtn
{
    if (!_rowBtn) {
        _rowBtn = [UIButton new];
        [_rowBtn setBackgroundImage:ImageNamed(@"shouye_gengduo") forState:UIControlStateNormal];
        
    }
    return _rowBtn;
}

- (UIImageView *)bankIcon
{
    if (!_bankIcon) {
        _bankIcon = [UIImageView new];
        _bankIcon.image = ImageNamed(@"");
    }
    return _bankIcon;
}

- (UILabel *)bankLabel
{
    if (!_bankLabel) {
        _bankLabel = [UILabel new];
        _bankLabel.text = @"请选择提现银行卡";
        _bankLabel.textColor = COLOR_BLACK_333333;
        _bankLabel.textAlignment = NSTextAlignmentLeft;
        _bankLabel.font = kFont_Medium(16.f);
    }
    return _bankLabel;
}

- (UIView *)withdrawView
{
    if (!_withdrawView) {
        _withdrawView = [UIView new];
        _withdrawView.backgroundColor = COLOR_GRAY_FFFFFF;
        _withdrawView.layer.borderColor = COLOR_GRAY_EEEEEE.CGColor;
        _withdrawView.layer.borderWidth = 1;
    }
    return _withdrawView;
}

- (UILabel *)inputLabel
{
    if (!_inputLabel) {
        _inputLabel = [UILabel new];
        _inputLabel.text = @"输入提取金额";
        _inputLabel.textColor = COLOR_BLACK_333333;
        _inputLabel.textAlignment = NSTextAlignmentLeft;
        _inputLabel.font = kFont_Bold(14.f);
    }
    return _inputLabel;
}

- (UITextField *)inputField
{
    if (!_inputField ) {
        _inputField = [UITextField new];
        _inputField.tintColor = COLOR_RED_EA0000;
        if (@available(iOS 10.0, *)) {
            _inputField.keyboardType = UIKeyboardTypeDecimalPad;
        } else {
            // Fallback on earlier versions
        }
        _inputField.textColor = COLOR_BLACK_333333;
        _inputField.font = kFont_Medium(36.f);
    }
    return _inputField;
}

- (UILabel *)withdrawLabel
{
    if (!_withdrawLabel) {
        _withdrawLabel = [UILabel new];
        _withdrawLabel.text = @"可提现余额：¥0.00";
        _withdrawLabel.textColor = COLOR_GRAY_999999;
        _withdrawLabel.textAlignment = NSTextAlignmentLeft;
        _withdrawLabel.font = kFont_Medium(14.f);
    }
    return _withdrawLabel;
}

- (UIButton *)tipBtn
{
    if (!_tipBtn) {
        _tipBtn = [UIButton new];
        [_tipBtn setBackgroundImage:ImageNamed(@"zhushi") forState:UIControlStateNormal];
        [_tipBtn addTarget:self action:@selector(alertViewWarnView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}

- (void)alertViewWarnView:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.warnBtn.hidden = NO;
    }else{
        self.warnBtn.hidden = YES;
    }
}

- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        _commitBtn.backgroundColor = COLOR_RED_FF1213;
        [_commitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = kFont_Regular(16.f);
        [_commitBtn addTarget:self action:@selector(onclickWithdrawApply:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 6;
        _commitBtn.layer.masksToBounds = YES;
    }
    return _commitBtn;
}

- (void)selectedWithBank:(UITapGestureRecognizer *)tap
{
    HPSwitchCardsViewController *cards = [HPSwitchCardsViewController new];
    
    cards.cardsDelegate = self;
    
    [self.navigationController pushViewController:cards animated:YES];
}

- (void)onclickWithdrawApply:(UIButton *)button
{
    if (self.bankLabel.text.length == 0 || [self.bankLabel.text isEqualToString:@"请选择提现银行卡"]) {
        [HPProgressHUD alertMessage:@"请选择提现银行卡"];
        return;
    }
    if (_inputField.text.length <= 1) {
        [HPProgressHUD alertMessage:@"请输入提现金额"];
        return;
    }
    if ([_inputField.text substringFromIndex:1].integerValue < 500) {
        [HPProgressHUD alertMessage:@"提现金额不得小于5元"];
        return;
    }
    [self getAvailableWithdrawApi];
}

- (void)onClickBank:(HPSwitchCardsViewController *)cards andCardsModel:(HPCardsInfoModel *)model
{
    self.model = model;
    
    [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:model.logUrl] placeholderImage:ImageNamed(@"")];
    
    self.bankLabel.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,[model.accountNo substringFromIndex:model.accountNo.length - 4]];
    
    self.shareBankCardId = model.shareBankCardId;
}

- (void)getAvailableWithdrawApi
{
    [self.inputField resignFirstResponder];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"amount"] = [self.inputField.text substringFromIndex:1];
    dic[@"shareBankCardId"] = self.model.shareBankCardId;

    [HPHTTPSever HPPostServerWithMethod:@"/v1/account/withdrawDeposits" paraments:dic needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
//            [HPProgressHUD alertMessage:@"提现成功"];
            [self.accpetView show:YES];
            
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
@end
