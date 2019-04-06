//
//  HPOwnnerItemView.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/6.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOwnnerItemView.h"

@implementation HPOwnnerItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpOwnnerSubviews];
        
        [self setUpOwnnerSubviewsMasonry];

    }
    return self;
}

- (void)setUpOwnnerSubviews
{
    [self addSubview:self.toReceiveBtn];

    [self addSubview:self.toPayBtn];

    [self addSubview:self.toGetBtn];

    [self addSubview:self.compelteBtn];

    [self addSubview:self.businessView];

    [self.businessView addSubview:self.storeBtn];

    [self.businessView addSubview:self.orderBtn];

    [self.businessView addSubview:self.walletBtn];

    [self.businessView addSubview:self.creditCardBtn];

}

- (void)setUpOwnnerSubviewsMasonry
{
    CGFloat orderBtnW = 60.f;
    
    CGFloat space = (kScreenWidth - orderBtnW * 4)/5;
    [self.toReceiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(space + (orderBtnW + space));
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.toPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toReceiveBtn.mas_right).offset(space);
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.toGetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toPayBtn.mas_right).offset(space);
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.compelteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toGetBtn.mas_right).offset(space);
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.businessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.toReceiveBtn.mas_bottom);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(30.f));
        make.width.height.mas_equalTo(getWidth(40.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderBtn.mas_right).offset(getWidth(40.f));
        make.width.height.mas_equalTo(getWidth(40.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.walletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderBtn.mas_right).offset(getWidth(40.f));
        make.width.height.mas_equalTo(getWidth(40.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.creditCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.walletBtn.mas_right).offset(getWidth(40.f));
        make.width.height.mas_equalTo(getWidth(40.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
    }];
}

- (HPOrderBtn *)toReceiveBtn
{
    if (!_toReceiveBtn) {
        _toReceiveBtn = [HPOrderBtn new];
        _toReceiveBtn.nameLabel.text = @"待接单";
        _toReceiveBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _toReceiveBtn.nameLabel.font = kFont_Medium(13.f);
        _toReceiveBtn.tag = 4600;
        [_toReceiveBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _toReceiveBtn;
}

- (HPOrderBtn *)toPayBtn
{
    if (!_toPayBtn) {
        _toPayBtn = [HPOrderBtn new];
        _toPayBtn.nameLabel.text = @"待付款";
        _toPayBtn.tag = 4601;
        _toPayBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _toPayBtn.nameLabel.font = kFont_Medium(13.f);
        [_toPayBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _toPayBtn;
}

- (HPOrderBtn *)toGetBtn
{
    if (!_toGetBtn) {
        _toGetBtn = [HPOrderBtn new];
        _toGetBtn.nameLabel.text = @"待收货";
        _toGetBtn.tag = 4602;
        _toGetBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _toGetBtn.nameLabel.font = kFont_Medium(13.f);
        [_toGetBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _toGetBtn;
}

- (HPOrderBtn *)compelteBtn
{
    if (!_compelteBtn) {
        _compelteBtn = [HPOrderBtn new];
        _compelteBtn.nameLabel.text = @"已完成";
        _toGetBtn.tag = 4603;
        _compelteBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _compelteBtn.nameLabel.font = kFont_Medium(13.f);
        [_compelteBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _compelteBtn;
}

- (UIView *)businessView
{
    if (!_businessView) {
        _businessView = [UIView new];
        _businessView.backgroundColor = COLOR_GRAY_FFFFFF;
        _businessView.layer.cornerRadius = 4.f;
        _businessView.layer.masksToBounds = YES;
        
    }
    return _businessView;
}

- (HPAlignCenterButton *)storeBtn
{
    if (!_storeBtn) {
        _storeBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"me_business_store")];
        [_storeBtn setText:@"店铺"];
        _storeBtn.tag = 4100;
        [_storeBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeBtn;
}

- (HPAlignCenterButton *)orderBtn
{
    if (!_orderBtn) {
        _orderBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"me_business_store")];
        [_orderBtn setText:@"订单"];
        _orderBtn.tag = 4101;
        [_orderBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBtn;
}

- (HPAlignCenterButton *)walletBtn
{
    if (!_walletBtn) {
        _walletBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"me_business_store")];
        [_walletBtn setText:@"钱包"];
        _walletBtn.tag = 4102;
        [_walletBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _walletBtn;
}

- (HPAlignCenterButton *)creditCardBtn
{
    if (!_creditCardBtn) {
        _creditCardBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"me_business_store")];
        [_creditCardBtn setText:@"名片"];
        _creditCardBtn.tag = 4103;
        [_creditCardBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _creditCardBtn;
}


- (void)onClickedBusinessbtn:(UIButton *)button
{
    if (self.busiBlock) {
        self.busiBlock(button.tag);
    }
}
@end
