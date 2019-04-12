//
//  HPSwitchCardsViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSwitchCardsViewController.h"

@interface HPSwitchCardsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UIView *tipView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *banksCardArray;

@property (strong, nonatomic) UIButton *commitBtn;

@property (strong, nonatomic) HPCardsInfoModel *model;

@property (strong, nonatomic) HPCardsInfoModel *selectedModel;
//选中的row
@property (assign, nonatomic) NSInteger selectedRow;

@end

@implementation HPSwitchCardsViewController

static NSString *banksInfoCell = @"banksInfoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];

    self.selectedRow = 0;
    
    self.banksCardArray = [NSMutableArray array];
    
    [self setUpSwitchCardsView];
    
    [self setUpSwitchCardsViewMasonry];

    [self getCardsInfoListApi];

}

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

 - (void)setUpSwitchCardsView
{
    
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.tipView];
    
    [self.tipView addSubview:self.tipLabel];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.commitBtn];
}

- (void)setUpSwitchCardsViewMasonry
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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tipView.mas_bottom);
        make.bottom.mas_equalTo(getWidth(-74.f));
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-23.f));
        make.left.mas_equalTo(getWidth(23.f));
        
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(44.f));
        
    }];
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [UIButton new];
        _commitBtn.backgroundColor = COLOR_RED_FF1213;
        [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = kFont_Regular(16.f);
        [_commitBtn addTarget:self action:@selector(onclickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 6;
        _commitBtn.layer.masksToBounds = YES;
    }
    return _commitBtn;
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
        _titleLabel.text = @"更换银行卡";
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
        _tipLabel.text = @"请选择";
    }
    return _tipLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:HPBanksInfoCell.class forCellReuseIdentifier:banksInfoCell];
        _tableView.separatorColor = COLOR_GRAY_EEEEEE;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.banksCardArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(60.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPCardsInfoModel *model = self.banksCardArray[indexPath.row];
    HPBanksInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:banksInfoCell];
    if (_selectedRow == indexPath.row) {
        cell.selectedButton.selected = YES;
    }else{
        cell.selectedButton.selected = NO;
        
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedRow = indexPath.row;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

    self.selectedModel = self.banksCardArray[indexPath.row];

}

- (void)onclickConfirmBtn:(UIButton *)button
{
    if (!self.model) {
        self.model = self.banksCardArray[0];
    }else{
        
    }

    if ([self.cardsDelegate respondsToSelector:@selector(onClickBank:andCardsModel:)]) {
        [self.cardsDelegate onClickBank:self andCardsModel:self.model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
