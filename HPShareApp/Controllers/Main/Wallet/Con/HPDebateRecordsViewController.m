//
//  HPDebateRecordsViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPDebateRecordsViewController.h"

#import "HPDebeteCell.h"

#import "HPAccountItemView.h"

@interface HPDebateRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) HPAccountItemView *accountView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *accountArray;

@end

@implementation HPDebateRecordsViewController

static NSString *debeteCell = @"HPDebeteCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    self.accountArray = [NSMutableArray array];
    
    [self setUpDebetaSubviews];
    
    [self setUpDebetaSubviewsMasonry];
    
    [self getAccountInfoApi];
}

#pragma mark - 获取账务明细
- (void)getAccountInfoApi
{
    
}

- (void)setUpDebetaSubviews
{
    
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.accountView];

    [self.view addSubview:self.tableView];

}

- (void)setUpDebetaSubviewsMasonry
{
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.left.mas_equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(45.f));
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.accountView.mas_bottom);
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

- (HPAccountItemView *)accountView
{
    if (!_accountView) {
        _accountView = [HPAccountItemView new];
        _accountView.backgroundColor = COLOR_GRAY_FFFFFF;
        _accountView.layer.borderColor = COLOR_GRAY_EEEEEE.CGColor;
        _accountView.layer.borderWidth = 1;
        kWEAKSELF
        _accountView.accountBlock = ^(NSInteger accountIndex) {
            switch (accountIndex) {
                case HPAccountItemIndexAll:
                    [weakSelf getAccountInfoApi];
                    break;
                case HPAccountItemIndexOutcome:
                    [weakSelf getAccountInfoApi];
                    break;
                case HPAccountItemIndexIncome:
                    [weakSelf getAccountInfoApi];
                    break;
                default:
                    break;
            }
        };
    }
    return _accountView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"账单明细";
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:HPDebeteCell.class forCellReuseIdentifier:debeteCell];
        _tableView.separatorColor = COLOR_GRAY_EEEEEE;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(75.f);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HPAccountInfoModel *model = self.accountArray[indexPath.row];
    HPDebeteCell *cell = [tableView dequeueReusableCellWithIdentifier:debeteCell];
//    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self pushVCByClassName:@"HPRecordsDetailViewController"];
    
}

@end
