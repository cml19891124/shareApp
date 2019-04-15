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

#import "HPUserReceiveView.h"

#import "HPOperationNumberTool.h"

#import "HPCardsInfoModel.h"

@interface HPWalletViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) HPUserReceiveView *withdrawView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *imageArray;

@property (strong, nonatomic) NSArray *titleArray;

@property (strong, nonatomic) UILabel *accountLabel;

@property (strong, nonatomic) UILabel *balanceLabel;

/**
 余额
 */
@property (nonatomic, copy) NSString *balance;

@property (strong, nonatomic) HPRightImageButton *withdrawBtn;

/**
 已绑定银行卡的数组
 */
@property (strong, nonatomic) NSMutableArray *banksCardArray;

@end

@implementation HPWalletViewController

static NSString *walletCell = @"walletCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    self.imageArray = @[@"mingxi",@"bangding"];
    
    self.titleArray = @[@"账单明细",@"我的银行卡"];
    
    self.banksCardArray = [NSMutableArray array];
    
    [self setUpWalletSubviews];
    
    [self setUpWalletSubviewsMasonry];

    [self getBalanceInfoApi];
    
    [self getCardsInfoListApi];
}

#pragma mark - 获取绑定银行卡列表
- (void)getCardsInfoListApi
{
    [HPHTTPSever HPPostServerWithMethod:@"/v1/bankCard/queryBankCard" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.banksCardArray removeAllObjects];
            NSArray *cardsArray = [HPCardsInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.banksCardArray addObjectsFromArray:cardsArray];
            [self.tableView reloadData];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - 获取余额
- (void)getBalanceInfoApi
{
    [HPHTTPSever HPPostServerWithMethod:@"/v1/account/queryBalance" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSNumber *balance = (NSNumber *)[NSString stringWithFormat:@"%@",responseObject[@"data"][@"balance"]];
            self.balance = [HPOperationNumberTool separateNumberUseCommaWith:[NSString stringWithFormat:@"%ld",[balance integerValue]]];
            
            self.balanceLabel.text = [NSString stringWithFormat:@"%@元",self.balance];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setUpWalletSubviews
{
    
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
        
    NSString *balance = [HPOperationNumberTool separateNumberUseCommaWith:self.balanceLabel.text];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%@.00元",balance];
    
    [self.headerView addSubview:self.accountLabel];
    
    [self.headerView addSubview:self.withdrawBtn];

    [self.headerView addSubview:self.balanceLabel];

    [self.view addSubview:self.tableView];
}

- (void)setUpWalletSubviewsMasonry
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(g_statusBarHeight + 44 + getWidth(136.f));
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
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(26.f));
        make.right.mas_equalTo(getWidth(-25.f));
        make.height.mas_equalTo(getWidth(25.f));
    }];
    
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(self.withdrawBtn.font.pointSize);
        make.width.mas_equalTo(getWidth(50.f));
        make.bottom.mas_equalTo(self.headerView.mas_bottom).offset(getWidth(-50.f));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.bottom.mas_equalTo(self.headerView.mas_bottom).offset(getWidth(-50.f));
        make.right.mas_equalTo(self.withdrawBtn.mas_left).offset(getWidth(-10.f));
        make.height.mas_equalTo(self.balanceLabel.font.pointSize);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
        
    }];
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (HPUserReceiveView *)withdrawView
{
    if (!_withdrawView) {
        
        _withdrawView = [HPUserReceiveView new];
        CGFloat withW = BoundWithSize(@"目前仅支持银行储蓄卡提现", kScreenWidth, 16.f).size.width + 20;
        [_withdrawView.confirmLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(withW);

        }];
        kWEAKSELF
        _withdrawView.noBlock = ^{
            HPLog(@"dfsdg");
            [weakSelf.withdrawView show:NO];
                    };
        _withdrawView.okBlock = ^{
            
            [weakSelf.withdrawView show:NO];
        };
    }
    return _withdrawView;
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
        _accountLabel = [UILabel new];
        _accountLabel.text = @"账户余额 (元)";
        _accountLabel.textColor = COLOR_GRAY_FFF4F3;
        _accountLabel.textAlignment = NSTextAlignmentLeft;
        _accountLabel.font = kFont_Bold(14.f);
        
    }
    return _accountLabel;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [UILabel new];
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
        [_withdrawBtn addTarget:self action:@selector(withdrawClicked:) forControlEvents:UIControlEventTouchUpInside];
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
        _tableView.scrollEnabled = NO;
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
    if (indexPath.row == 1) {
        [self pushVCByClassName:@"HPCardsListViewController"];
    }else{
        [self pushVCByClassName:@"HPDebateRecordsViewController"];
    }
}

- (void)withdrawClicked:(HPRightImageButton *)button
{
    if (self.banksCardArray.count == 0 || !self.banksCardArray) {
        [self.withdrawView show:YES];
        self.withdrawView.confirmLabel.textColor = COLOR_GRAY_666666;
        self.withdrawView.confirmLabel.font = kFont_Medium(16.f);
        [self.withdrawView.noBtn setTitle:@"暂不绑定" forState:UIControlStateNormal];
        [self.withdrawView.okbtn setTitle:@"前往绑定" forState:UIControlStateNormal];
        self.withdrawView.confirmLabel.text = @"目前仅支持银行储蓄卡提现\n    请先绑定银行卡";

    }else{
        [self pushVCByClassName:@"HPWithdrawViewController" withParam:@{@"balance":self.balance}];

    }
    
}
@end
