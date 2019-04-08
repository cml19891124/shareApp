//
//  HPUserNewOrderView.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/6.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUserNewOrderView.h"

@implementation HPUserNewOrderView

- (void)setupModalView:(UIView *)view
{
    self.view = view;

    [view addSubview:self.bgView];

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(320.f));
        make.height.mas_equalTo(getWidth(240.f));
        make.center.mas_equalTo(self);
    }];
    
    [self setUpSubviews];
    
    [self setUpSubviewsMasonry];

}

- (void)setUpSubviews
{
    
    [self.bgView addSubview:self.headView];
    
    [self.headView addSubview:self.tipLabel];
    
    [self.headView addSubview:self.timeLabel];

    [self.view addSubview:self.rentInfoView];
    
    [self.rentInfoView addSubview:self.storeView];
    
    [self.rentInfoView addSubview:self.nameLabel];

    [self.rentInfoView addSubview:self.locationLabel];

    [self.rentInfoView addSubview:self.rentOutsideLabel];

    [self.rentInfoView addSubview:self.rentDaysLabel];

    [self.rentInfoView addSubview:self.toPayLabel];

    [self.view addSubview:self.communicateBtn];
    
    [self.view addSubview:self.payBtn];

}

- (void)setUpSubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(340.f));
        make.top.mas_equalTo(getWidth(180.f));

    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(getWidth(45.f));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-100.f));
        make.height.mas_equalTo(self.tipLabel.font.pointSize);
        make.centerY.mas_equalTo(self.headView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headView);
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(self.tipLabel.mas_right);
        make.height.mas_equalTo(self.timeLabel.font.pointSize);
    }];
    
    [self.rentInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(getWidth(136.f));
    }];
    
    [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(15.f));
        make.width.height.mas_equalTo(getWidth(85.f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storeView.mas_top);
        make.right.mas_equalTo(getWidth(-10.f));
        make.left.mas_equalTo(getWidth(10.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
    }];
    
    CGFloat locW = BoundWithSize(self.locationLabel.text, kScreenWidth, 12).size.width;
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15));
        make.width.mas_equalTo(locW);
        make.left.mas_equalTo(getWidth(10.f));
        make.height.mas_equalTo(self.locationLabel.font.pointSize);
    }];
    
    [self.rentOutsideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationLabel.mas_top);
        make.width.mas_equalTo(getWidth(40.f));
        make.left.mas_equalTo(self.locationLabel.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.rentOutsideLabel.font.pointSize);
    }];
    
    [self.rentDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationLabel.mas_bottom).offset(getWidth(10));
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(self.storeView.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.rentDaysLabel.font.pointSize);
    }];
    
    [self.toPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rentDaysLabel.mas_bottom).offset(getWidth(10));
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(self.storeView.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.toPayLabel.font.pointSize);
    }];
    
    [self.communicateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(getWidth(-20));
        make.width.mas_equalTo(getWidth(320 - 50.f)/2);
        make.left.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(getWidth(40));
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(getWidth(-20));
        make.width.mas_equalTo(getWidth(320 - 50.f)/2);
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(getWidth(40));
    }];
    
    [self.closed_order_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(60.f));
        make.width.mas_equalTo(getWidth(23.f));
        
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 6.f;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = COLOR_GRAY_FFFFFF;
        _bgView.layer.cornerRadius = 4.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = COLOR_YELLOW_FFB400;
    }
    return _headView;
}

-(UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textColor = COLOR_GRAY_FFFFFF;
        _tipLabel.font = kFont_Medium(14.f);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.text = @"您的订单已同意，请及时前往付款";
    }
    return _tipLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = COLOR_GRAY_FFFFFF;
        _timeLabel.font = kFont_Medium(12.f);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"1分钟前";
    }
    return _timeLabel;
}

- (UIView *)rentInfoView
{
    if (!_rentInfoView) {
        _rentInfoView = [UIView new];
        _rentInfoView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _rentInfoView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"小女当家场地拼租";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = kFont_Bold(16.f);
        _nameLabel.textColor = COLOR_BLACK_333333;
    }
    return _nameLabel;
}


- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.text = @"拼租位置：正门扶手梯旁";
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.font = kFont_Medium(12.f);
        _locationLabel.textColor = COLOR_GRAY_999999;
    }
    return _locationLabel;
}

- (UILabel *)rentOutsideLabel
{
    if (!_rentOutsideLabel) {
        _rentOutsideLabel = [UILabel new];
        _rentOutsideLabel.layer.cornerRadius = 2.f;
        _rentOutsideLabel.layer.masksToBounds = YES;
        _rentOutsideLabel.textColor = COLOR_GRAY_FFFFFF;
        _rentOutsideLabel.backgroundColor = COLOR_RED_EA0000;
        _rentOutsideLabel.font = kFont_Medium(12.f);
        _rentOutsideLabel.text = @"室内";
        _rentOutsideLabel.textAlignment = NSTextAlignmentCenter;
        _rentOutsideLabel.numberOfLines = 0;
        [_rentOutsideLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _rentOutsideLabel;
}

- (UILabel *)rentDaysLabel
{
    if (!_rentDaysLabel) {
        _rentDaysLabel = [UILabel new];
        _rentDaysLabel.text = @"租期：7天";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_rentDaysLabel.text];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 3)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_EA0000 range:NSMakeRange(3, _rentDaysLabel.text.length - 3)];
        
        _rentDaysLabel.textAlignment = NSTextAlignmentLeft;
        _rentDaysLabel.font = kFont_Medium(12.f);
        _rentDaysLabel.textColor = COLOR_GRAY_999999;
    }
    return _rentDaysLabel;
}

- (UILabel *)toPayLabel
{
    if (!_toPayLabel) {
        _toPayLabel = [UILabel new];
        _toPayLabel.text = @"待付款：¥1036";
        _toPayLabel.textAlignment = NSTextAlignmentLeft;
        _toPayLabel.font = kFont_Medium(12.f);
        _toPayLabel.textColor = COLOR_GRAY_999999;
    }
    return _toPayLabel;
}

- (UIImageView *)storeView
{
    if (!_storeView) {
        _storeView = [UIImageView new];
        _storeView.layer.cornerRadius = 4.f;
        _storeView.layer.masksToBounds = YES;
        _storeView.image = ImageNamed(@"");
    }
    return _storeView;
}

- (UIButton *)communicateBtn
{
    if (!_communicateBtn) {
        _communicateBtn = [UIButton new];
        _communicateBtn.layer.cornerRadius = 2.f;
        _communicateBtn.layer.masksToBounds = YES;
        _communicateBtn.tag = UserNewOrderStateCommunicate;
        _communicateBtn.backgroundColor = COLOR_YELLOW_FFB400;
        [_communicateBtn setTitle:@"在线沟通" forState:UIControlStateNormal];
        [_communicateBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _communicateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_communicateBtn addTarget:self action:@selector(onClickNewOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _communicateBtn;
}

- (UIButton *)payBtn
{
    if (!_payBtn) {
        _payBtn = [UIButton new];
        _payBtn.tag = UserNewOrderStateReceive;
        _payBtn.backgroundColor = COLOR_YELLOW_FF531E;
        _payBtn.layer.cornerRadius = 2.f;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn setTitle:@"前往接单" forState:UIControlStateNormal];
        [_payBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _payBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_payBtn addTarget:self action:@selector(onClickNewOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (void)onClickNewOrderBtn:(UIButton *)button
{
    if (self.newBlock) {
        self.newBlock(button.tag);
    }
}

- (void)onTapModalOutSide{
    [self show:NO];
}


- (UIButton *)closed_order_btn
{
    if (!_closed_order_btn) {
        _closed_order_btn = [UIButton new];
        _closed_order_btn.tag = UserNewOrderStateCloseOrder;
        [_closed_order_btn setBackgroundImage:ImageNamed(@"closed_orderbtn") forState:UIControlStateNormal];
        [_closed_order_btn addTarget:self action:@selector(onClickNewOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closed_order_btn;
}
@end
