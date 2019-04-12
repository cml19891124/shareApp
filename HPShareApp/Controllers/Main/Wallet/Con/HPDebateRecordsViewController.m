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

#import "HPShareListParam.h"

@interface HPDebateRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,YYLRefreshNoDataViewDelegate>

@property (strong, nonatomic) HPShareListParam *shareListParam;

@property (strong, nonatomic) HPAccountItemView *accountView;


/**
 收入为1，支出为0，全部不传
 */
@property (copy, nonatomic) NSString *type;

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
    
    self.type = @"";
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.shareListParam.page = 1;
        [self getAccountInfoApi:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getAccountInfoApi:NO];
    }];

    
    self.accountArray = [NSMutableArray array];
    
    [self setUpDebetaSubviews];
    
    [self setUpDebetaSubviewsMasonry];
    
    [self getAccountInfoApi:YES];

}

#pragma mark - 获取账务明细
- (void)getAccountInfoApi:(BOOL)isReload
{
    self.shareListParam = [HPShareListParam new];
    
    self.shareListParam.page = 1;
    
    self.shareListParam.pageSize = 20;
    
    if (isReload) {
        _shareListParam.page = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isIncome"] = self.type;
    dic[@"page"] = @(self.shareListParam.page);
    dic[@"pageSize"] = @(self.shareListParam.pageSize);

    [HPHTTPSever HPGETServerWithMethod:@"/v1/userAccountLog/list" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        NSArray *listArray = [HPAccountInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];

        if (listArray) {
            if (isReload) {
                [self.accountArray removeAllObjects];
            }
            
            [self.accountArray addObjectsFromArray:listArray];
        }
        
        if ([responseObject[@"data"][@"total"] integerValue] == 0 || self.accountArray.count == 0) {
            
            self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
            self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"queshengtu");
            self.tableView.refreshNoDataView.tipLabel.text = @"列表空空如也，快去逛逛吧~";
            [self.tableView.refreshNoDataView.tipBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
            [self.tableView.refreshNoDataView.tipBtn setTitleColor:COLOR_RED_FF1213 forState:UIControlStateNormal];
            self.tableView.refreshNoDataView.tipBtn.backgroundColor = COLOR_GRAY_FFFFFF;
            self.tableView.refreshNoDataView.tipBtn.layer.cornerRadius = 6;
            self.tableView.refreshNoDataView.tipBtn.layer.masksToBounds = YES;
            self.tableView.refreshNoDataView.tipBtn.layer.borderColor = COLOR_RED_FF1213.CGColor;
            self.tableView.refreshNoDataView.tipBtn.layer.borderWidth = 1;
            self.tableView.refreshNoDataView.delegate = self;
            self.tableView.refreshNoDataView.hidden = NO;
            
        }
        
        if (listArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
        }
        else {
            self.tableView.refreshNoDataView.hidden = YES;
            
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            self.shareListParam.page ++;
        }
        
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
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
                    weakSelf.type  = @"";
                    [weakSelf getAccountInfoApi:YES];
                    break;
                case HPAccountItemIndexOutcome:
                    weakSelf.type  = @"0";

                    [weakSelf getAccountInfoApi:YES];
                    break;
                case HPAccountItemIndexIncome:
                    weakSelf.type  = @"1";

                    [weakSelf getAccountInfoApi:YES];
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
    return self.accountArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(75.f);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPAccountInfoModel *model = self.accountArray[indexPath.row];
    HPDebeteCell *cell = [tableView dequeueReusableCellWithIdentifier:debeteCell];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HPAccountInfoModel *model = self.accountArray[indexPath.row];

    [self pushVCByClassName:@"HPRecordsDetailViewController" withParam:@{@"model":model}];
    
}

@end
