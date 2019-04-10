//
//  HPBindCardsViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBindCardsViewController.h"

#import "HPGradientUtil.h"

#import "HPRowPanel.h"

#import "HPTextFieldPlaceholderRight.h"

#import "HPBanksViewController.h"

#import "HPBanksViewController.h"

typedef NS_ENUM(NSInteger, HPChooseItemIndex) {
    HPChooseItemIndexUserInfo = 5100,
    HPChooseItemIndexBank,
    HPChooseItemIndexArea,
    HPChooseItemIndexCard
};

@interface HPBindCardsViewController ()<BanksInfoDelegate>

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *awakeLabel;

@property (strong, nonatomic) HPTextFieldPlaceholderRight *openAccountField;

@property (strong, nonatomic) UIButton *chooseBankBtn;

@property (strong, nonatomic) UIButton *chooseAreaBtn;

@property (strong, nonatomic) HPTextFieldPlaceholderRight *cardField;

@property (strong, nonatomic) UIButton *commitBtn;

@end

@implementation HPBindCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];

    [self setUpWalletSubviews];
    
    [self setUpWalletSubviewsMasonry];
}

- (void)setUpWalletSubviews
{
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];

    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR_ORANGE_EB0303 endColor:UIColor.clearColor];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.view addSubview:self.colorBtn];
    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.awakeLabel];
    
    for (int i = 0; i < 4; i++) {
        [self setupPanelAtIndex:i ofView:self.view];
    }

    [self.view addSubview:self.commitBtn];

}

#pragma mark - row view
- (void)setupPanelAtIndex:(NSInteger)index ofView:(UIView *)view {
    HPRowPanel *panel = [[HPRowPanel alloc] init];
    [view addSubview:panel];
    if (index == 0) {
        //开户人信息
        [panel addRowView:[self setUpUserInfoView] withHeight:getWidth(52.f)];
        
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.equalTo(self.awakeLabel.mas_bottom).offset(getWidth(40.f));
            make.height.mas_equalTo(getWidth(52.f));
            make.width.mas_equalTo(self.view);
        }];
        
    }
    else if (index == 1) {
        //开户银行
        [panel addRowView:[self setUpOpenAccountBankView] withHeight:getWidth(52.f)];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(52.f * g_rateWidth);
            make.top.equalTo(self.awakeLabel.mas_bottom).offset(getWidth(52.f)+getWidth(40.f));
        }];
        
    }
    else if (index == 2) {
        //开户地区
        [panel addRowView:[self setUpOpenAccountAreaView] withHeight:getWidth(52.f)];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(52.f * g_rateWidth);
            make.top.equalTo(self.awakeLabel.mas_bottom).offset(getWidth(52.f) * 2+getWidth(40.f));
        }];
    }
    else if (index == 3) {
        [panel addRowView:[self setUpBankCardNumberView]];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(52.f * g_rateWidth);
            make.top.equalTo(self.awakeLabel.mas_bottom).offset(getWidth(52.f) * 3+getWidth(40.f));
        }];
        
    }
}

//开户人信息
- (UIView *)setUpUserInfoView
{
    UIView *view = [[UIView alloc] init];

    UIView *topline = [UIView new];
    topline.backgroundColor = COLOR_GRAY_EEEEEE;
    [view addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(0);
    }];
    
    [self setupTitleLabelWithText:@"姓名" ofView:view];
    _openAccountField = (HPTextFieldPlaceholderRight *)[self setupTextFieldWithPlaceholder:@"请输入开户人姓名" ofView:view rightTo:view];
    _openAccountField.font = kFont_Regular(14.f);
    _openAccountField.tintColor = COLOR_RED_EA0000;

    [_openAccountField setValue:COLOR_GRAY_999999 forKeyPath:@"_placeholderLabel.textColor"];
    _openAccountField.textAlignment = NSTextAlignmentRight;
    [kNotificationCenter addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:_openAccountField];
    UIView *bottomline = [UIView new];
    bottomline.backgroundColor = COLOR_GRAY_EEEEEE;
    [view addSubview:bottomline];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    return view;
}

//开户银行
- (UIView *)setUpOpenAccountBankView
{
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"开户银行" ofView:view];
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    UIButton *chooseBankBtn = [[UIButton alloc] init];
    [chooseBankBtn.titleLabel setFont:kFont_Regular(14.f)];
    [chooseBankBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [chooseBankBtn setTitle:@"请选择开户银行" forState:UIControlStateNormal];
    [chooseBankBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
    chooseBankBtn.tag = HPChooseItemIndexBank;
    chooseBankBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [chooseBankBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [chooseBankBtn addTarget:self action:@selector(jumpToBanks:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:chooseBankBtn];
    _chooseBankBtn = chooseBankBtn;
    [chooseBankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.right.equalTo(downIcon.mas_left).with.offset(getWidth(-5.f));
        make.centerY.equalTo(view);
    }];
    UIView *bottomline = [UIView new];
    bottomline.backgroundColor = COLOR_GRAY_EEEEEE;
    [view addSubview:bottomline];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    return view;
}

- (void)jumpToBanks:(UIButton *)button
{
    HPBanksViewController *banks = [HPBanksViewController new];
    banks.delegate = self;
//    [self pushVCByClassName:@"HPBanksViewController"];
    [self.navigationController pushViewController:banks animated:YES];
}

//开户地区
- (UIView *)setUpOpenAccountAreaView
{
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"开户地区" ofView:view];
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    UIButton *chooseAreaBtn = [[UIButton alloc] init];
    [chooseAreaBtn.titleLabel setFont:kFont_Regular(14.f)];
    [chooseAreaBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [chooseAreaBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
    [chooseAreaBtn setTitle:@"请选择开户地区" forState:UIControlStateNormal];
    chooseAreaBtn.tag = HPChooseItemIndexArea;
    [chooseAreaBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [chooseAreaBtn addTarget:self action:@selector(callAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:chooseAreaBtn];
    _chooseAreaBtn = chooseAreaBtn;
    [chooseAreaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.right.equalTo(downIcon.mas_left).with.offset(getWidth(-5.f));
        make.centerY.equalTo(view);
    }];
    UIView *bottomline = [UIView new];
    bottomline.backgroundColor = COLOR_GRAY_EEEEEE;
    [view addSubview:bottomline];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    return view;
}

- (void)callAlertView:(UIButton *)button
{
    
}

//银行卡号
- (UIView *)setUpBankCardNumberView
{
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"银行卡号" ofView:view];
    _cardField = (HPTextFieldPlaceholderRight *)[self setupTextFieldWithPlaceholder:@"请输入银行卡号" ofView:view rightTo:view];
    _cardField.font = kFont_Regular(14.f);
    _cardField.tintColor = COLOR_RED_EA0000;
    [_cardField setValue:COLOR_GRAY_999999 forKeyPath:@"_placeholderLabel.textColor"];
    _cardField.textAlignment = NSTextAlignmentRight;
    if (@available(iOS 10.0, *)) {
        _cardField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    } else {
        // Fallback on earlier versions
    }
    [kNotificationCenter addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:_cardField];
    UIView *bottomline = [UIView new];
    bottomline.backgroundColor = COLOR_GRAY_EEEEEE;
    [view addSubview:bottomline];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    return view;
}

#pragma mark - NSNotification

- (void)didTextFieldChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (textField == _openAccountField) {
        // text field 的内容
        NSString *contentText = textField.text;
        
        // 获取高亮内容的范围
        UITextRange *selectedRange = [textField markedTextRange];
        // 这行代码 可以认为是 获取高亮内容的长度
        NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        // 没有高亮内容时,对已输入的文字进行操作
        if (markedTextLength == 0) {
            // 如果 text field 的内容长度大于我们限制的内容长度
            if (contentText.length > 10) {
                // 截取从前面开始maxLength长度的字符串
                //            textField.text = [contentText substringToIndex:maxLength];
                // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 10)];
                textField.text = [contentText substringWithRange:rangeRange];
                [HPProgressHUD alertMessage:@"开户人姓名不得超过10位"];
            }
        }

    }else{
        // text field 的内容
        NSString *contentText = textField.text;
        
        // 获取高亮内容的范围
        UITextRange *selectedRange = [textField markedTextRange];
        // 这行代码 可以认为是 获取高亮内容的长度
        NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        // 没有高亮内容时,对已输入的文字进行操作
        if (markedTextLength == 0) {
            // 如果 text field 的内容长度大于我们限制的内容长度
            if (contentText.length > 21) {
                // 截取从前面开始maxLength长度的字符串
                //            textField.text = [contentText substringToIndex:maxLength];
                // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, contentText.length)];
                textField.text = [contentText substringWithRange:rangeRange];
                [HPProgressHUD alertMessage:@"银行卡号不得超过21位"];
            }
        }

    }
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:_openAccountField];
}

- (UIButton *)colorBtn
{
    if (!_colorBtn) {
        _colorBtn = [[UIButton alloc] init];
        [_colorBtn.layer setCornerRadius:2.f];
        [_colorBtn.layer setMasksToBounds:YES];
    }
    return _colorBtn;
}

- (void)setUpWalletSubviewsMasonry
{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view);
        make.left.mas_equalTo(getWidth(20.f));
        make.top.mas_equalTo(g_statusBarHeight + getWidth(30.f) + 44);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.width.mas_equalTo(getWidth(60.f));
        make.height.mas_equalTo(3.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.awakeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.top.mas_equalTo(self.colorBtn.mas_bottom).offset(getWidth(25.f));
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(23.f));
        make.right.mas_equalTo(getWidth(-23.f));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(getWidth(-15.f));
        make.height.mas_equalTo(getWidth(44));
    }];
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.image = ImageNamed(@"wallet_Bg");
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
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


- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        _commitBtn.layer.cornerRadius = 6;
        _commitBtn.layer.masksToBounds = YES;
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = kFont_Regular(16.f);
        [_commitBtn setBackgroundColor:COLOR_RED_EA0000];
        [_commitBtn addTarget:self action:@selector(onClickCommitButtom:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commitBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"银行卡绑定";
    }
    return _titleLabel;
}

- (UILabel *)awakeLabel
{
    if (!_awakeLabel) {
        _awakeLabel = [UILabel new];
        _awakeLabel.textColor = COLOR_GRAY_999999;
        _awakeLabel.textAlignment = NSTextAlignmentLeft;
        _awakeLabel.font = kFont_Medium(14.f);
        _awakeLabel.numberOfLines = 0;
        _awakeLabel.text = @"目前仅支持银行储蓄卡提现，我们将严格保密个人信息，请确保绑定信息为本人。";
        [_awakeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _awakeLabel;
}

- (void)onClickCommitButtom:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"请选择开户银行"]) {
        [HPProgressHUD alertMessage:@"请选择开户银行"];
    }
}

#pragma mark - BanksInfoDelegate

- (void)selecetBankRow:(HPBanksViewController *)banks andModel:(HPBanksListModel *)model
{
    [self.chooseBankBtn setTitle:model.bankName forState:UIControlStateNormal];
}
@end
