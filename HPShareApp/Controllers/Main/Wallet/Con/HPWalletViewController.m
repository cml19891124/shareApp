//
//  HPWalletViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/9.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPWalletViewController.h"

#import "HPWalletCell.h"

#import "HPRightImageButton.h"

@interface HPWalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) NSArray *titleArray;

@property (strong, nonatomic) UILabel *accountLabel;

@property (strong, nonatomic) UILabel *balanceLabel;

@property (strong, nonatomic) HPRightImageButton *withdrawBtn;

@end

@implementation HPWalletViewController

static NSString *walletCell = @"walletCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    self.imageArray = @[@"mingxi",@"bangding"];
    
    self.titleArray = @[@"账单明细",@"绑定银行卡"];
    
    [self setUpWalletSubviews];
    
    [self setUpWalletSubviewsMasonry];

}

- (void)setUpWalletSubviews
{
    
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.headerView addSubview:self.accountLabel];

    [self.headerView addSubview:self.withdrawBtn];

    [self.headerView addSubview:self.balanceLabel];

    self.accountLabel.text = @"63539853985798";
    
    [self separateNumberUseCommaWith:self.accountLabel.text];
    
    [self.view addSubview:self.tableView];
}

- (void)setUpWalletSubviewsMasonry
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(200.f));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(g_statusBarHeight + 44 + getWidth(26.f));
        make.right.mas_equalTo(getWidth(-25.f));
        make.height.mas_equalTo(self.accountLabel.font.pointSize);
    }];
    /*
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(self.withdrawBtn.font.pointSize);
        make.width.mas_equalTo(getWidth(100.f));
        make.top.mas_equalTo(self.accountLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(self.accountLabel.mas_bottom).offset(getWidth(20.f));
        make.right.mas_equalTo(self.withdrawBtn.mas_left).offset(getWidth(-10.f));
        make.height.mas_equalTo(self.balanceLabel.font.pointSize);
    }];*/
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
        
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
        [_backBtn setImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];
        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_GRAY_FFFFFF;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"钱包";
    }
    return _titleLabel;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel.textColor = COLOR_GRAY_FFF4F3;
        _accountLabel.textAlignment = NSTextAlignmentLeft;
        _accountLabel.font = kFont_Bold(14.f);
        _accountLabel.text = @"账户余额 (元)";
        
    }
    return _accountLabel;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel.textColor = COLOR_GRAY_FFFFFF;
        _balanceLabel.textAlignment = NSTextAlignmentLeft;
        _balanceLabel.font = kFont_Medium(30.f);
        _balanceLabel.text = @"0.00";
        
    }
    return _balanceLabel;
}

- (HPRightImageButton *)withdrawBtn
{
    if (!_withdrawBtn) {
        _withdrawBtn = [HPRightImageButton new];
        _withdrawBtn.image = ImageNamed(@"tixian");
        _withdrawBtn.text = @"提现";
        [_withdrawBtn setSpace:15.f];
        [_withdrawBtn setFont:kFont_Medium(14.f)];
        [_withdrawBtn setColor:COLOR_GRAY_FFFFFF];
    }
    return _withdrawBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:HPWalletCell.class forCellReuseIdentifier:walletCell];
        _tableView.separatorColor = COLOR_GRAY_EEEEEE;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(60.f);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:walletCell];
    cell.iconView.image = ImageNamed(self.imageArray[indexPath.row]);
    cell.nameLabel.text = self.titleArray[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 将数字转为每隔3位整数由逗号“,”分隔的字符串
- (NSString *)separateNumberUseCommaWith:(NSString *)number {
    // 前缀
    NSString *prefix = @"￥";
    // 后缀
    NSString *suffix = @"元";
    // 分隔符
    NSString *divide = @",";
    
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([number containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [number componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = number;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    if (![prefix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",prefix,newNumber];
    }
    if (![suffix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",newNumber,suffix];
    }
    
    return newNumber;
}

@end
