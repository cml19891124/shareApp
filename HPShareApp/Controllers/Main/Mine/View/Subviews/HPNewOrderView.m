//
//  HPNewOrderView.m
//  HPShareApp
//
//  Created by HP on 2019/3/28.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPNewOrderView.h"

@implementation HPNewOrderView

- (void)setupModalView:(UIView *)view
{
    self.view = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(320.f));
        make.height.mas_equalTo(getWidth(440.f));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(getWidth(-90.f));
    }];
    
    [view addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(view);
        make.height.mas_equalTo(getWidth(340.f));
    }];
    [self setUpNewOrderSubviews];
    
    [self setUpNewOrderSubviewsMasonry];

}

- (void)setUpNewOrderSubviews
{
    
    [self.bgView addSubview:self.headView];

    [self.headView addSubview:self.tipLabel];

    [self.headView addSubview:self.timeLabel];

    [self.bgView addSubview:self.userInfoView];

    [self.userInfoView addSubview:self.nameInfoLabel];

    [self.userInfoView addSubview:self.nameInfoView];
    
    [self.nameInfoView addSubview:self.nameLabel];

    [self.nameInfoView addSubview:self.phoneLabel];

    [self.bgView addSubview:self.rentDaysView];

    [self.rentDaysView addSubview:self.rentDaysLabel];

    [self.rentDaysView addSubview:self.daysView];

    [self.daysView addSubview:self.daysLabel];

    [self.daysView addSubview:self.calendBtn];

    [self.bgView addSubview:self.rentDesView];

    [self.rentDesView addSubview:self.rentDesLabel];

    [self.rentDesView addSubview:self.rentInfoLabel];

    [self.bgView addSubview:self.communicateBtn];
    
    [self.bgView addSubview:self.receiveBtn];

    [_view addSubview:self.closed_order_btn];

}

- (void)setUpNewOrderSubviewsMasonry
{
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
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.right.mas_equalTo(getWidth(-20.f));
        make.left.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(getWidth(75.f));
    }];
    
    [self.nameInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(20.f));
        make.left.right.mas_equalTo(self.userInfoView);
        make.height.mas_equalTo(self.nameInfoLabel.font.pointSize);
    }];
    
    [self.nameInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameInfoLabel.mas_bottom).offset(getWidth(7.f));
        make.left.right.mas_equalTo(self.userInfoView);
        make.height.mas_equalTo(getWidth(35.f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameInfoView);
        make.right.mas_equalTo(getWidth(-7.f));
        make.left.mas_equalTo(getWidth(7.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameInfoView);
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(getWidth(25.f));
        make.height.mas_equalTo(self.phoneLabel.font.pointSize);
    }];
    
    [self.rentDaysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userInfoView.mas_bottom);
        make.right.mas_equalTo(getWidth(-20.f));
        make.left.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(getWidth(70.f));
    }];
    
    [self.rentDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(15.f));
        make.left.right.mas_equalTo(self.rentDaysView);
        make.left.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(self.rentDaysLabel.font.pointSize);
    }];
    
    [self.daysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rentDaysLabel.mas_bottom).offset(getWidth(7.f));
        make.left.right.mas_equalTo(self.rentDaysView);
        make.height.mas_equalTo(getWidth(35.f));
    }];
    
    [self.calendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.daysView);
        make.right.mas_equalTo(getWidth(-10.f));
        make.width.height.mas_equalTo(getWidth(18.f));
    }];
    
    [self.daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(12.f));
        make.left.mas_equalTo(getWidth(7.f));
        make.right.mas_equalTo(self.calendBtn.mas_left).offset(getWidth(-24.f));
        make.height.mas_equalTo(self.daysLabel.font.pointSize);
    }];
    
    [self.rentDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rentDaysView.mas_bottom);
        make.right.mas_equalTo(getWidth(-20.f));
        make.left.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(getWidth(70.f));
    }];
    
    [self.rentDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(15.f));
        make.left.right.mas_equalTo(self.rentDesView);
        make.height.mas_equalTo(self.rentDesLabel.font.pointSize);
    }];
    
    [self.rentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rentDesLabel.mas_bottom).offset(getWidth(7.f));
        make.left.right.mas_equalTo(self.rentDesView);
        make.height.mas_equalTo(self.rentInfoLabel.font.pointSize);
    }];
    
    [self.communicateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rentDesView.mas_bottom).offset(getWidth(20.f));
        make.left.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(getWidth(40.f));
        make.width.mas_equalTo(getWidth(130.f));

    }];
    
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rentDesView.mas_bottom).offset(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.height.mas_equalTo(getWidth(40.f));
        make.width.mas_equalTo(getWidth(130.f));
        
    }];
    
    [self.closed_order_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(60.f));
        make.width.mas_equalTo(getWidth(23.f));
        
    }];
}

- (UIButton *)closed_order_btn
{
    if (!_closed_order_btn) {
        _closed_order_btn = [UIButton new];
        _closed_order_btn.tag = HPNewOrderStateCloseOrder;
        [_closed_order_btn setBackgroundImage:ImageNamed(@"closed_orderbtn") forState:UIControlStateNormal];
        [_closed_order_btn addTarget:self action:@selector(onClickNewOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closed_order_btn;
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
        _tipLabel.text = @"新订单提醒（小女当家场地拼租）";
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

- (UIView *)userInfoView
{
    if (!_userInfoView) {
        _userInfoView = [UIView new];
        _userInfoView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _userInfoView;
}

- (UILabel *)nameInfoLabel
{
    if (!_nameInfoLabel) {
        _nameInfoLabel = [UILabel new];
        _nameInfoLabel.text = @"下单人信息";
        _nameInfoLabel.textAlignment = NSTextAlignmentLeft;
        _nameInfoLabel.textColor = COLOR_BLACK_333333;
        _nameInfoLabel.font = kFont_Bold(14.f);
    }
    return _nameInfoLabel;
}

- (UIView *)nameInfoView
{
    if (!_nameInfoView) {
        _nameInfoView = [UIView new];
        _nameInfoView.backgroundColor = COLOR_GRAY_F8F8F8;
        
    }
    return _nameInfoView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"姓名：陈俊烨";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = COLOR_GRAY_666666;
        _nameLabel.font = kFont_Medium(12.f);
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.text = @"电话：18311159265";
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel.textColor = COLOR_GRAY_666666;
        _phoneLabel.font = kFont_Medium(12.f);
    }
    return _phoneLabel;
}

- (UIView *)rentDaysView
{
    if (!_rentDaysView) {
        _rentDaysView = [UIView new];
        _rentDaysView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _rentDaysView;
}


- (UILabel *)rentDaysLabel
{
    if (!_rentDaysLabel) {
        _rentDaysLabel = [UILabel new];
        _rentDaysLabel.text = @"拼租日期（共七天）";
        _rentDaysLabel.textAlignment = NSTextAlignmentLeft;
        _rentDaysLabel.textColor = COLOR_BLACK_333333;
        _rentDaysLabel.font = kFont_Bold(14.f);
    }
    return _rentDaysLabel;
}

- (UIView *)daysView
{
    if (!_daysView) {
        _daysView = [UIView new];
        _daysView.backgroundColor = COLOR_GRAY_F8F8F8;
        
    }
    return _daysView;
}

- (UILabel *)daysLabel
{
    if (!_daysLabel) {
        _daysLabel = [UILabel new];
        _daysLabel.text = @"3月21、3月22、3月23、3月25、3月27...";
        _daysLabel.textAlignment = NSTextAlignmentLeft;
        _daysLabel.textColor = COLOR_GRAY_666666;
        _daysLabel.font = kFont_Medium(12.f);
    }
    return _daysLabel;
}

- (UIButton *)calendBtn
{
    if (!_calendBtn) {
        _calendBtn = [UIButton new];
        _calendBtn.tag = HPNewOrderStateCalender;
        [_calendBtn setBackgroundImage:ImageNamed(@"days_select") forState:UIControlStateNormal];
    }
    return _calendBtn;
}

- (UIView *)rentDesView
{
    if (!_rentDesView) {
        _rentDesView = [UIView new];
        _rentDesView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _rentDesView;
}


- (UILabel *)rentDesLabel
{
    if (!_rentDesLabel) {
        _rentDesLabel = [UILabel new];
        _rentDesLabel.text = @"拼租说明";
        _rentDesLabel.textAlignment = NSTextAlignmentLeft;
        _rentDesLabel.textColor = COLOR_BLACK_333333;
        _rentDesLabel.font = kFont_Bold(14.f);
    }
    return _rentDesLabel;
}

- (UILabel *)rentInfoLabel
{
    if (!_rentInfoLabel) {
        _rentInfoLabel = [UILabel new];
        _rentInfoLabel.text = @"我想用来做做推广，奶茶免费试喝";
        _rentInfoLabel.textAlignment = NSTextAlignmentLeft;
        _rentInfoLabel.textColor = COLOR_GRAY_666666;
        _rentInfoLabel.backgroundColor = COLOR_GRAY_F8F8F8;
        _rentInfoLabel.font = kFont_Medium(12.f);
    }
    return _rentInfoLabel;
}

- (UIButton *)communicateBtn
{
    if (!_communicateBtn) {
        _communicateBtn = [UIButton new];
        _communicateBtn.layer.cornerRadius = 2.f;
        _communicateBtn.layer.masksToBounds = YES;
        _communicateBtn.tag = HPNewOrderStateCommunicate;
        _communicateBtn.backgroundColor = COLOR_YELLOW_FFB400;
        [_communicateBtn setTitle:@"在线沟通" forState:UIControlStateNormal];
        [_communicateBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _communicateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_communicateBtn addTarget:self action:@selector(onClickNewOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _communicateBtn;
}

- (UIButton *)receiveBtn
{
    if (!_receiveBtn) {
        _receiveBtn = [UIButton new];
        _receiveBtn.tag = HPNewOrderStateCommunicate;
        _receiveBtn.backgroundColor = COLOR_YELLOW_FF531E;
        _receiveBtn.layer.cornerRadius = 2.f;
        _receiveBtn.layer.masksToBounds = YES;
        [_receiveBtn setTitle:@"前往接单" forState:UIControlStateNormal];
        [_receiveBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _receiveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_receiveBtn addTarget:self action:@selector(onClickNewOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
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
@end
