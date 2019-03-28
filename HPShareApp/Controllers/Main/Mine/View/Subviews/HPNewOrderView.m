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

    [view addSubview:self.closed_order_btn];

}

- (void)setUpNewOrderSubviews
{

    
    [self.bgView addSubview:self.headView];

    [self.headView addSubview:self.tipLabel];

    [self.headView addSubview:self.timeLabel];

    [self.userInfoView addSubview:self.nameInfoLabel];

    [self.userInfoView addSubview:self.nameInfoView];
    
    [self.userInfoView addSubview:self.nameLabel];

    [self.userInfoView addSubview:self.phoneLabel];

    [self.bgView addSubview:self.rentDaysView];

    [self.rentDaysView addSubview:self.rentDaysLabel];

    [self.rentDaysView addSubview:self.daysLabel];

    [self.rentDaysView addSubview:self.calendBtn];

    [self.bgView addSubview:self.rentDesView];

    [self.rentDesView addSubview:self.rentDesLabel];

    [self.rentDesView addSubview:self.rentInfoLabel];

    [self.bgView addSubview:self.communicateBtn];
    
    [self.bgView addSubview:self.receiveBtn];


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
@end
