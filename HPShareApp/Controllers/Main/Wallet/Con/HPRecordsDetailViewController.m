//
//  HPRecordsDetailViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRecordsDetailViewController.h"

@interface HPRecordsDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *moneyView;

@property (strong, nonatomic) UIButton *moneyBtn;

@property (strong, nonatomic) UILabel *moneySubLabel;

@property (strong, nonatomic) UIView *recordInfoView;

@property (strong, nonatomic) UIView *amountView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *nameSubLabel;

@property (strong, nonatomic) UILabel *rentDayLabel;

@property (strong, nonatomic) UILabel *rentDaySubLabel;

@property (strong, nonatomic) UILabel *renterLabel;

@property (strong, nonatomic) UILabel *renterSubLabel;

@property (strong, nonatomic) UILabel *orderLabel;

@property (strong, nonatomic) UILabel *orderSubLabel;

@property (strong, nonatomic) UILabel *amountLabel;

@property (strong, nonatomic) UILabel *amountSubLabel;

@property (strong, nonatomic) UILabel *serverLabel;

@property (strong, nonatomic) UILabel *serverSubLabel;

@property (strong, nonatomic) UILabel *totalLabel;

@property (strong, nonatomic) UILabel *totalSubLabel;


@end

@implementation HPRecordsDetailViewController


- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self setUpRecordsSubviews];
    
    [self setUpRecordsSubviewsMasonry];

}

- (void)setUpRecordsSubviews
{
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.moneyView];

    [self.moneyView addSubview:self.moneyBtn];

    [self.moneyView addSubview:self.moneySubLabel];

    [self.scrollView addSubview:self.recordInfoView];

    [self.recordInfoView addSubview:self.nameLabel];

    [self.recordInfoView addSubview:self.nameSubLabel];

    [self.recordInfoView addSubview:self.rentDayLabel];

    [self.recordInfoView addSubview:self.rentDaySubLabel];

    [self.recordInfoView addSubview:self.renterLabel];

    [self.recordInfoView addSubview:self.renterSubLabel];

    [self.recordInfoView addSubview:self.orderLabel];

    [self.recordInfoView addSubview:self.orderSubLabel];

    [self.scrollView addSubview:self.amountView];

    [self.amountView addSubview:self.amountLabel];

    [self.amountView addSubview:self.amountSubLabel];

    [self.amountView addSubview:self.serverLabel];

    [self.amountView addSubview:self.serverSubLabel];

    [self.amountView addSubview:self.totalLabel];

    [self.amountView addSubview:self.totalSubLabel];

}

- (void)setUpRecordsSubviewsMasonry
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
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight + 44);
    }];
    
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(1);
        make.height.mas_equalTo(getWidth(135.f));
        make.width.mas_equalTo(kScreenWidth);

    }];
    
    [self.moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.moneyView);
        make.top.mas_equalTo(getWidth(40.f));
        make.height.mas_equalTo(self.moneyBtn.titleLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.moneySubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.moneyView);
        make.top.mas_equalTo(self.moneyBtn.mas_bottom).offset(getWidth(20.f));
        make.height.mas_equalTo(self.moneySubLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.recordInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(self.moneyView.mas_bottom).offset(1);
        make.height.mas_equalTo(getWidth(165.f));
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];

    [self.nameSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(self.nameSubLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.rentDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(22.f));
        make.height.mas_equalTo(self.rentDayLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.rentDaySubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(22.f));
        make.height.mas_equalTo(self.rentDaySubLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.renterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(self.rentDayLabel.mas_bottom).offset(getWidth(22.f));
        make.height.mas_equalTo(self.renterLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.renterSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.rentDayLabel.mas_bottom).offset(getWidth(22.f));
        make.height.mas_equalTo(self.renterSubLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(self.renterSubLabel.mas_bottom).offset(getWidth(22.f));
        make.height.mas_equalTo(self.orderLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.orderSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.renterSubLabel.mas_bottom).offset(getWidth(22.f));
        make.height.mas_equalTo(self.orderSubLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
    
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.mas_equalTo(self.recordInfoView);
        make.top.mas_equalTo(self.recordInfoView.mas_bottom);
        make.height.mas_equalTo(getWidth(130.f));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(getWidth(20.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(self.amountLabel.font.pointSize);
    }];
    
    [self.amountSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(getWidth(20.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(self.amountSubLabel.font.pointSize);
    }];
    
    [self.serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(self.amountSubLabel.mas_bottom).offset(getWidth(22.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(self.serverLabel.font.pointSize);
    }];
    
    [self.serverSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.amountSubLabel.mas_bottom).offset(getWidth(22.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(self.serverSubLabel.font.pointSize);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(25.f));
        make.top.mas_equalTo(self.serverSubLabel.mas_bottom).offset(getWidth(22.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(self.totalLabel.font.pointSize);
    }];
    
    [self.totalSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.totalLabel.mas_bottom).offset(getWidth(22.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(self.totalSubLabel.font.pointSize);
    }];
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
        _titleLabel.text = @"交易详情";
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView =[UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)moneyView
{
    if (!_moneyView) {
        _moneyView = [UIView new];
        _moneyView.backgroundColor = COLOR_GRAY_FFFFFF;
        _moneyView.layer.borderColor = COLOR_GRAY_EEEEEE.CGColor;
        _moneyView.layer.borderWidth = 1;
    }
    return _moneyView;
}

- (UIButton *)moneyBtn
{
    if (!_moneyBtn) {
        _moneyBtn = [UIButton new];
        [_moneyBtn setImage:ImageNamed(@"sheng") forState:UIControlStateNormal];
        [_moneyBtn setImage:ImageNamed(@"jiang") forState:UIControlStateNormal];
        [_moneyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        [_moneyBtn setTitle:@"+0.00" forState:UIControlStateNormal];
        _moneyBtn.titleLabel.font = kFont_Bold(30.f);
        [_moneyBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        _moneyBtn.userInteractionEnabled = NO;
    }
    return _moneyBtn;
}

- (UILabel *)moneySubLabel
{
    if (!_moneySubLabel) {
        _moneySubLabel = [UILabel new];
        _moneySubLabel.textColor = COLOR_GRAY_999999;
        _moneySubLabel.font = kFont_Regular(14.f);
        _moneySubLabel.textAlignment = NSTextAlignmentCenter;
        _moneySubLabel.text = [NSString stringWithFormat:@"余额：¥0.00"];
    }
    return _moneySubLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = COLOR_GRAY_666666;
        _nameLabel.font = kFont_Medium(16.f);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = [NSString stringWithFormat:@"交易明细"];
    }
    return _nameLabel;
}

- (UILabel *)nameSubLabel
{
    if (!_nameSubLabel) {
        _nameSubLabel = [UILabel new];
        _nameSubLabel.textColor = COLOR_GRAY_666666;
        _nameSubLabel.font = kFont_Medium(16.f);
        _nameSubLabel.textAlignment = NSTextAlignmentRight;
        _nameSubLabel.text = @"小女当家中科店场地出租";
    }
    return _nameSubLabel;
}

- (UILabel *)rentDayLabel
{
    if (!_rentDayLabel) {
        _rentDayLabel = [UILabel new];
        _rentDayLabel.textColor = COLOR_GRAY_666666;
        _rentDayLabel.font = kFont_Medium(16.f);
        _rentDayLabel.textAlignment = NSTextAlignmentLeft;
        _rentDayLabel.text = @"租用日期";
    }
    return _rentDayLabel;
}

- (UILabel *)rentDaySubLabel
{
    if (!_rentDaySubLabel) {
        _rentDaySubLabel = [UILabel new];
        _rentDaySubLabel.textColor = COLOR_GRAY_666666;
        _rentDaySubLabel.font = kFont_Medium(16.f);
        _rentDaySubLabel.textAlignment = NSTextAlignmentRight;
        _rentDaySubLabel.text = @"2019-4-16";
    }
    return _rentDaySubLabel;
}

- (UILabel *)renterLabel
{
    if (!_renterLabel) {
        _renterLabel = [UILabel new];
        _renterLabel.textColor = COLOR_GRAY_666666;
        _renterLabel.font = kFont_Medium(16.f);
        _renterLabel.textAlignment = NSTextAlignmentLeft;
        _renterLabel.text = @"租客姓名";
    }
    return _renterLabel;
}

- (UILabel *)renterSubLabel
{
    if (!_renterSubLabel) {
        _renterSubLabel = [UILabel new];
        _renterSubLabel.textColor = COLOR_GRAY_666666;
        _renterSubLabel.font = kFont_Medium(16.f);
        _renterSubLabel.textAlignment = NSTextAlignmentRight;
        _renterSubLabel.text = @"陈生";
    }
    return _renterSubLabel;
}

- (UILabel *)orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.textColor = COLOR_GRAY_666666;
        _orderLabel.font = kFont_Medium(16.f);
        _orderLabel.textAlignment = NSTextAlignmentLeft;
        _orderLabel.text = @"订单编号";
    }
    return _orderLabel;
}

- (UILabel *)orderSubLabel
{
    if (!_orderSubLabel) {
        _orderSubLabel = [UILabel new];
        _orderSubLabel.textColor = COLOR_GRAY_666666;
        _orderSubLabel.font = kFont_Medium(16.f);
        _orderSubLabel.textAlignment = NSTextAlignmentRight;
        _orderSubLabel.text = @"HD190311401";
    }
    return _orderSubLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.textColor = COLOR_GRAY_666666;
        _amountLabel.font = kFont_Medium(16.f);
        _amountLabel.textAlignment = NSTextAlignmentLeft;
        _amountLabel.text = @"交易金额";
    }
    return _amountLabel;
}

- (UILabel *)amountSubLabel
{
    if (!_amountSubLabel) {
        _amountSubLabel = [UILabel new];
        _amountSubLabel.textColor = COLOR_GRAY_666666;
        _amountSubLabel.font = kFont_Medium(16.f);
        _amountSubLabel.textAlignment = NSTextAlignmentRight;
        _amountSubLabel.text = @"+¥0.00";
    }
    return _amountSubLabel;
}

- (UILabel *)serverLabel
{
    if (!_serverLabel) {
        _serverLabel = [UILabel new];
        _serverLabel.textColor = COLOR_GRAY_666666;
        _serverLabel.font = kFont_Medium(16.f);
        _serverLabel.textAlignment = NSTextAlignmentLeft;
        _serverLabel.text = @"服务费";
    }
    return _serverLabel;
}

- (UILabel *)serverSubLabel
{
    if (!_serverLabel) {
        _serverLabel = [UILabel new];
        _serverLabel.textColor = COLOR_GRAY_666666;
        _serverLabel.font = kFont_Medium(16.f);
        _serverLabel.textAlignment = NSTextAlignmentRight;
        _serverLabel.text = @"-¥1.00";
    }
    return _serverLabel;
}

- (UILabel *)totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textColor = COLOR_GRAY_666666;
        _totalLabel.font = kFont_Medium(16.f);
        _totalLabel.textAlignment = NSTextAlignmentLeft;
        _totalLabel.text = @"总收入";
    }
    return _totalLabel;
}

- (UILabel *)totalSubLabel
{
    if (!_totalSubLabel) {
        _totalSubLabel = [UILabel new];
        _totalSubLabel.textColor = COLOR_GRAY_666666;
        _totalSubLabel.font = kFont_Medium(16.f);
        _totalSubLabel.textAlignment = NSTextAlignmentRight;
        _totalSubLabel.text = @"+¥0.00";
    }
    return _totalSubLabel;
}

- (UIView *)amountView
{
    if (!_amountView) {
        _amountView = [UIView new];
        _amountView.layer.borderColor = COLOR_GRAY_EEEEEE.CGColor;
        _amountView.layer.borderWidth = 1;
        _amountView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _amountView;
}

- (UIView *)recordInfoView
{
    if (!_recordInfoView) {
        _recordInfoView = [UIView new];
//        _recordInfoView.layer.borderColor = COLOR_GRAY_EEEEEE.CGColor;
//        _recordInfoView.layer.borderWidth = 1;
        _recordInfoView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _recordInfoView;
}
@end
