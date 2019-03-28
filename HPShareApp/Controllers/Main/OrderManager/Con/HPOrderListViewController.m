//
//  HPOrderManagerViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderListViewController.h"

#import "HPShareDetailModel.h"

#import "HPOrderCell.h"

#import "HPChooseItemView.h"

@interface HPOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HPShareDetailModel *model;

@property (nonatomic, strong) NSArray *imageArr;

@property (strong, nonatomic) NSArray *titleArr;

@property (nonatomic, strong) HPChooseItemView *orderItemView;

@end

@implementation HPOrderListViewController

static NSString *orderCell = @"orderCell";

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_EEEEEE];
    
    _model = self.param[@"order"];

    [self setUpListSubviews];
    
    [self setUpListSubviesMasonry];
}

- (void)setUpListSubviews
{
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.view addSubview:self.orderItemView];
    
    [self setupShadowOfPanel:self.orderItemView];

    [self.view addSubview:self.tableView];
}

- (HPChooseItemView *)orderItemView
{
    if (!_orderItemView) {
        _orderItemView = [HPChooseItemView new];
        _orderItemView.backgroundColor = COLOR_GRAY_FFFFFF;
        _orderItemView.block = ^(NSInteger menuItem) {
            HPLog(@"fsgfsg");
        };
    }
    return _orderItemView;
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.image = ImageNamed(@"order_head");
        
    }
    return _headerView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setBackgroundImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
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
        _titleLabel.text = @"我的订单";
    }
    return _titleLabel;
}

- (void)setupShadowOfPanel:(UIView *)view {
    [view.layer setShadowColor:COLOR_GRAY_DDDDDD.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [view.layer setShadowRadius:6.f];
    [view.layer setShadowOpacity:0.9f];
    [view.layer setCornerRadius:6.f];
    [view setBackgroundColor:UIColor.whiteColor];
}

- (void)setUpListSubviesMasonry
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(g_statusBarHeight + 44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(16.f));
        make.width.height.mas_equalTo(getWidth(13.f));
        make.top.mas_equalTo(g_statusBarHeight + 15.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.orderItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
        make.height.mas_equalTo(getWidth(45.f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.orderItemView.mas_bottom);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:HPOrderCell.class forCellReuseIdentifier:orderCell];
        
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    kWEAKSELF
//    cell.payBlock = ^(NSInteger payOrder) {
//        if (payOrder == PayOrderToPay) {
//            [weakSelf onClickConfirmPay];
//
//        }else if(payOrder == PayOrderConsult){
//
//        }else if (payOrder == PayOrderReturn){
//            [self pushVCByClassName:@"HPReturnFundsViewController" withParam:@{}];
//        }
//    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(200.f);

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 确认订单详情

@end
