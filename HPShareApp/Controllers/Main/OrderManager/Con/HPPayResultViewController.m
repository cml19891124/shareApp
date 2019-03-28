//
//  HPPayResultViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPayResultViewController.h"

#import "HPPayResultModel.h"

@interface HPPayResultViewController ()

@property (nonatomic, strong) HPPayResultModel *model;

@property (nonatomic, strong) UIImageView *resultImage;

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UILabel *congulationLabel;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation HPPayResultViewController

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor: COLOR_GRAY_EEEEEE];
    
    [self getConsultResult];
    
    [self setUpResultSubviews];
    
    [self setUpResultSubviewsMasonry];

}

#pragma mark - 订单查询请求
- (void)getConsultResult
{
    NSString *orderNo = self.param[@"orderNo"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"outTradeNo"] = orderNo;
    [HPHTTPSever HPPostServerWithMethod:@"/v1/wxpay/queryOrder" paraments:dic needToken:NO complete:^(id  _Nonnull responseObject) {
        
        if (CODE == 200) {
            self.model = [HPPayResultModel mj_objectWithKeyValues:DATA];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
        
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setModel:(HPPayResultModel *)model
{
    _model = model;
    
//    self.trade_state_desc.text = [NSString stringWithFormat:@"交易结果:%@",model.trade_state_desc];
//
//    self.out_trade_no_label.text = [NSString stringWithFormat:@"交易订单号:%@",model.out_trade_no];
//
//    self.mechLabel.text = [NSString stringWithFormat:@"商户号:%@",model.mch_id];
//
//    self.currencyLabel.text = [NSString stringWithFormat:@"货币类型:%@",model.fee_type];
//
//    self.flowLabel.text = [NSString stringWithFormat:@"交易流水:%@",model.transaction_id];
//
//    self.end_timeLabel.text = [NSString stringWithFormat:@"交易时间:%@",model.time_end];
//
//    self.cash_fee_label.text = [NSString stringWithFormat:@"手续费率:%@",model.cash_fee];
}

- (void)setUpResultSubviews
{
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.headerView addSubview:self.backBtn];

    [self.view addSubview:self.resultView];
    
    [self.resultView addSubview:self.resultImage];

    [self.resultView addSubview:self.resultLabel];

    [self.resultView addSubview:self.congulationLabel];

    [self.view addSubview:self.confirmBtn];

}


- (void)setUpResultSubviewsMasonry
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
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
        make.height.mas_equalTo(getWidth(230.f));
    }];
    
    [self.resultImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(57.f));
        make.top.mas_equalTo(getWidth(46.f));
        make.height.mas_equalTo(getWidth(53.f));
        make.centerX.mas_equalTo(self.resultView);
    }];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.resultView);
        make.top.mas_equalTo(self.resultImage.mas_bottom).offset(getWidth(20.f));
        make.height.mas_equalTo(self.resultLabel.font.pointSize);
        make.centerX.mas_equalTo(self.resultView);
    }];
    
    [self.congulationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.resultView);
        make.top.mas_equalTo(self.resultLabel.mas_bottom).offset(getWidth(24.f));
        make.height.mas_equalTo(self.congulationLabel.font.pointSize);
        make.centerX.mas_equalTo(self.resultView);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(getWidth(330.f), getWidth(44.f)));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(getWidth(-10.f));
    }];
}

#pragma mark - 初始化控件

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn setTitle:@"回到首页" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = COLOR_RED_EA0000;
        _confirmBtn.layer.cornerRadius = 6.f;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (void)onClickConfirmBtn:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UILabel *)congulationLabel{
    if (!_congulationLabel) {
        _congulationLabel = [UILabel new];
        _congulationLabel.textColor = COLOR_GRAY_999999;
        _congulationLabel.textAlignment = NSTextAlignmentCenter;
        _congulationLabel.font = kFont_Bold(16.f);
        _congulationLabel.text = @"请在指定日期前往拼租，祝您拼租愉快！";
    }
    return _congulationLabel;
}

- (UILabel *)resultLabel{
    if (!_resultLabel) {
        _resultLabel = [UILabel new];
        _resultLabel.textColor = COLOR_BLACK_333333;
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = kFont_Bold(16.f);
        _resultLabel.text = @"支付成功";
    }
    return _resultLabel;
}

- (UIImageView *)resultImage
{
    if (!_resultImage) {
        _resultImage = [UIImageView new];
        _resultImage.image = ImageNamed(@"resultImage");
    }
    return _resultImage;
}

- (UIView *)resultView
{
    if (!_resultView) {
        _resultView = [UIView new];
        _resultView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _resultView;
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
        _titleLabel.text = @"支付成功";
    }
    return _titleLabel;
}

@end
