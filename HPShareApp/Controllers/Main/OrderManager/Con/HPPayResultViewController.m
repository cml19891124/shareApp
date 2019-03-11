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

@property (nonatomic, strong) UILabel *trade_state_desc;

@property (nonatomic, strong) UILabel *out_trade_no_label;

@property (nonatomic, strong) UILabel *mechLabel;

@property (nonatomic, strong) UILabel *currencyLabel;

@property (nonatomic, strong) UILabel *flowLabel;

@property (nonatomic, strong) UILabel *end_timeLabel;

@property (nonatomic, strong) UILabel *cash_fee_label;

@end

@implementation HPPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor: COLOR_GRAY_FFFFFF];
    
    [self setupNavigationBarWithTitle:@"支付结果"];
    
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
    
    self.trade_state_desc.text = [NSString stringWithFormat:@"交易结果:%@",model.trade_state_desc];
    
    self.out_trade_no_label.text = [NSString stringWithFormat:@"交易订单号:%@",model.out_trade_no];
    
    self.mechLabel.text = [NSString stringWithFormat:@"商户号:%@",model.mch_id];
    
    self.currencyLabel.text = [NSString stringWithFormat:@"货币类型:%@",model.fee_type];
    
    self.flowLabel.text = [NSString stringWithFormat:@"交易流水:%@",model.transaction_id];
    
    self.end_timeLabel.text = [NSString stringWithFormat:@"交易时间:%@",model.time_end];
    
    self.cash_fee_label.text = [NSString stringWithFormat:@"手续费率:%@",model.cash_fee];
}

- (void)setUpResultSubviews
{
    [self.view addSubview:self.resultImage];
    
    [self.view addSubview:self.trade_state_desc];
    
    [self.view addSubview:self.out_trade_no_label];

    [self.view addSubview:self.mechLabel];

    [self.view addSubview:self.currencyLabel];

    [self.view addSubview:self.flowLabel];

    [self.view addSubview:self.end_timeLabel];
    
    [self.view addSubview:self.cash_fee_label];

}


- (void)setUpResultSubviewsMasonry
{
    [self.resultImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(getWidth(100.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(20.f), getWidth(20.f)));
    }];
    
    [self.trade_state_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resultImage.mas_bottom).offset(getWidth(10.f));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(getWidth(kScreenWidth/3), getWidth(40.f)));
    }];
    
    [self.out_trade_no_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.trade_state_desc.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
    
    [self.mechLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.out_trade_no_label.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
    
    [self.currencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.mechLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
    
    [self.flowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.currencyLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
    
    [self.end_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.flowLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
    
    [self.cash_fee_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.end_timeLabel.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
}

#pragma mark - 初始化控件

- (UIImageView *)resultImage
{
    if (!_resultImage) {
        _resultImage = [UIImageView new];
        _resultImage.image = ImageNamed(@"selected");
    }
    return _resultImage;
}

- (UILabel *)trade_state_desc
{
    if (!_trade_state_desc) {
        _trade_state_desc = [UILabel new];
        _trade_state_desc.textColor = COLOR_RED_EA0000;
        _trade_state_desc.textAlignment = NSTextAlignmentCenter;
        _trade_state_desc.font = kFont_Medium(18.f);
    }
    return _trade_state_desc;
}

- (UILabel *)out_trade_no_label
{
    if (!_out_trade_no_label) {
        _out_trade_no_label = [UILabel new];
        _out_trade_no_label.textColor = COLOR_BLACK_333333;
        _out_trade_no_label.textAlignment = NSTextAlignmentLeft;
        _out_trade_no_label.font = kFont_Medium(13.f);
    }
    return _out_trade_no_label;
}

- (UILabel *)mechLabel
{
    if (!_mechLabel) {
        _mechLabel = [UILabel new];
        _mechLabel.textColor = COLOR_BLACK_333333;
        _mechLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _mechLabel;
}

- (UILabel *)currencyLabel
{
    if (!_currencyLabel) {
        _currencyLabel = [UILabel new];
        _currencyLabel.textColor = COLOR_BLACK_333333;
        _currencyLabel.textAlignment = NSTextAlignmentLeft;
        _currencyLabel.font = kFont_Medium(13.f);
    }
    return _currencyLabel;
}

- (UILabel *)flowLabel
{
    if (!_flowLabel) {
        _flowLabel = [UILabel new];
        _flowLabel.textColor = COLOR_BLACK_333333;
        _flowLabel.textAlignment = NSTextAlignmentLeft;
        _flowLabel.font = kFont_Medium(13.f);
    }
    return _flowLabel;
}

- (UILabel *)end_timeLabel
{
    if (!_end_timeLabel) {
        _end_timeLabel = [UILabel new];
        _end_timeLabel.textColor = COLOR_BLACK_333333;
        _end_timeLabel.textAlignment = NSTextAlignmentLeft;
        _end_timeLabel.font = kFont_Medium(13.f);
        
    }
    return _end_timeLabel;
}

- (UILabel *)cash_fee_label
{
    if (!_cash_fee_label) {
        _cash_fee_label = [UILabel new];
        _cash_fee_label.textColor = COLOR_BLACK_333333;
        _cash_fee_label.textAlignment = NSTextAlignmentLeft;
        _cash_fee_label.font = kFont_Medium(13.f);
    }
    return _cash_fee_label;
}
- (UILabel *)setUpLabel:(NSString *)text
{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = COLOR_BLACK_333333;
    label.font = kFont_Medium(13.f);
    return label;
}
@end
