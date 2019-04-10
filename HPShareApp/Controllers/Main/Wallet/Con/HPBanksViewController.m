//
//  HPBanksViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBanksViewController.h"


@interface HPBanksViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *banksNameArray;

@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation HPBanksViewController

static NSString *banksCell = @"banksCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    self.banksNameArray = [NSMutableArray array];
    
    [self setUpBanksSubviews];
    
    [self setUpBanksSubviewsMasonry];
    
    [self getbBanksInfoApi];
}

#pragma mark - 查询银行列表
- (void)getbBanksInfoApi
{
    [HPHTTPSever HPGETServerWithMethod:@"/v1/bankCard/queryBankList" isNeedToken:YES paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *banksNameArray = [HPBanksListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"banks"]];
            [self.banksNameArray addObjectsFromArray:banksNameArray];
            [self.tableView reloadData];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setUpBanksSubviews
{
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.tableView];

}

- (void)setUpBanksSubviewsMasonry
{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-20.f));
        make.left.mas_equalTo(getWidth(20.f));
        make.top.mas_equalTo(g_statusBarHeight);
        make.height.mas_equalTo(44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(g_statusBarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
        
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
        _titleLabel.text = @"选择银行";
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:HPBanksCell.class forCellReuseIdentifier:banksCell];
        _tableView.separatorColor = COLOR_GRAY_EEEEEE;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.banksNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(60.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPBanksListModel *model = self.banksNameArray[indexPath.row];
    HPBanksCell *cell = [tableView dequeueReusableCellWithIdentifier:banksCell];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HPBanksListModel *model = self.banksNameArray[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(selecetBankRow:andModel:)]) {
        [self.delegate selecetBankRow:self andModel:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
