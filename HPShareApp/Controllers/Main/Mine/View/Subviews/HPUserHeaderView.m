//
//  HPUserHeaderView.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/6.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUserHeaderView.h"

@implementation HPUserHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUserSubviews];
        
        [self setUpUserSubviewsMasonry];
        
    }
    return self;
}

- (void)setUpUserSubviews
{
    [self addSubview:self.collectionBtn];
    
    [self addSubview:self.focusBtn];
    
    [self addSubview:self.footerBtn];
    
    [self addSubview:self.couperBtn];
    
    [self addSubview:self.userView];
    
    [self.userView addSubview:self.tipLabel];

    [self.userView addSubview:self.findStoreBtn];
    
    [self.userView addSubview:self.questBtn];
    
    [self.userView addSubview:self.receiveOrderBtn];
    
    [self.userView addSubview:self.rentToPayBtn];
    
    [self.userView addSubview:self.beginRentBtn];

}
- (void)setUpUserSubviewsMasonry
{
    CGFloat orderBtnW = (kScreenWidth - getWidth(30.f))/4;
    
    CGFloat space = 0;//(kScreenWidth - orderBtnW * 4)/5;
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(space);
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.collectionBtn.mas_right).offset(space);
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.focusBtn.mas_right).offset(space);
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.couperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.footerBtn.mas_right).offset(space);
        make.top.mas_equalTo(getWidth(2.f));
        make.width.mas_equalTo(orderBtnW);
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.couperBtn.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(112.f));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(getWidth(13.f));
        make.height.mas_equalTo(self.tipLabel.font.pointSize);
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    CGFloat fowSpace = getWidth(28.f);
    [self.findStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.width.mas_equalTo(getWidth(40.f));
        make.height.mas_equalTo(getWidth(95.f));
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(getWidth(30.f));
        make.bottom.mas_equalTo(getWidth(-17.f));
        
    }];
    
    [self.questBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.findStoreBtn.mas_right).offset(fowSpace);
        make.width.mas_equalTo(getWidth(40.f));
        make.height.mas_equalTo(getWidth(95.f));        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(getWidth(30.f));
        make.bottom.mas_equalTo(getWidth(-17.f));
    }];
    
    [self.receiveOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.questBtn.mas_right).offset(fowSpace);
        make.width.mas_equalTo(getWidth(40.f));
        make.height.mas_equalTo(getWidth(95.f));        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(getWidth(30.f));
        make.bottom.mas_equalTo(getWidth(-17.f));
    }];
    
    [self.rentToPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiveOrderBtn.mas_right).offset(fowSpace);
        make.width.mas_equalTo(getWidth(40.f));
        make.height.mas_equalTo(getWidth(95.f));        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(getWidth(30.f));
        make.bottom.mas_equalTo(getWidth(-17.f));
    }];
    
    [self.beginRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rentToPayBtn.mas_right).offset(fowSpace);
        make.width.mas_equalTo(getWidth(40.f));
        make.height.mas_equalTo(getWidth(95.f));        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(getWidth(30.f));
        make.bottom.mas_equalTo(getWidth(-17.f));
    }];
}

- (HPOrderBtn *)collectionBtn
{
    if (!_collectionBtn) {
        _collectionBtn = [HPOrderBtn new];
        _collectionBtn.nameLabel.text = @"收藏";
        _collectionBtn.numLabel.text = @"--";
        _collectionBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _collectionBtn.nameLabel.font = kFont_Medium(13.f);
        _collectionBtn.tag = 4000;
        [_collectionBtn addTarget:self action:@selector(onClickedProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _collectionBtn;
}

- (HPOrderBtn *)focusBtn
{
    if (!_focusBtn) {
        _focusBtn = [HPOrderBtn new];
        _focusBtn.nameLabel.text = @"关注";
        _focusBtn.numLabel.text = @"--";
        _focusBtn.tag = 4001;
        _focusBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _focusBtn.nameLabel.font = kFont_Medium(13.f);
        [_focusBtn addTarget:self action:@selector(onClickedProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _focusBtn;
}

- (HPOrderBtn *)footerBtn
{
    if (!_footerBtn) {
        _footerBtn = [HPOrderBtn new];
        _footerBtn.nameLabel.text = @"足迹";
        _footerBtn.numLabel.text = @"--";
        _footerBtn.tag = 4002;
        _footerBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _footerBtn.nameLabel.font = kFont_Medium(13.f);
        [_footerBtn addTarget:self action:@selector(onClickedProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _footerBtn;
}

- (HPOrderBtn *)couperBtn
{
    if (!_couperBtn) {
        _couperBtn = [HPOrderBtn new];
        _couperBtn.nameLabel.text = @"卡券";
        _couperBtn.numLabel.text = @"--";
        _couperBtn.tag = 4003;
        _couperBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _couperBtn.nameLabel.font = kFont_Medium(13.f);
        [_couperBtn addTarget:self action:@selector(onClickedProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _couperBtn;
}

- (UIView *)userView
{
    if (!_userView) {
        _userView = [UIView new];
        _userView.backgroundColor = COLOR_GRAY_FFFFFF;
        _userView.layer.cornerRadius = 4.f;
        _userView.layer.masksToBounds = YES;
        
    }
    return _userView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"拼租流程";
        _tipLabel.textColor = COLOR_BLACK_333333;
        _tipLabel.font = kFont_Bold(16.f);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tipLabel;
}

- (HPAlignCenterButton *)findStoreBtn
{
    if (!_findStoreBtn) {
        _findStoreBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"find_store")];
        [_findStoreBtn setText:@"线上找店"];
        [_findStoreBtn setTextColor:COLOR_GRAY_666666];
        [_findStoreBtn setTextFont:kFont_Regular(12.f)];
        _findStoreBtn.tag = 4600;
        [_findStoreBtn addTarget:self action:@selector(onClickedUserBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _findStoreBtn;
}

- (HPAlignCenterButton *)questBtn
{
    if (!_questBtn) {
        _questBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"send_query")];
        [_questBtn setText:@"发送请求"];
        [_questBtn setTextColor:COLOR_GRAY_666666];
        [_questBtn setTextFont:kFont_Regular(12.f)];
        _questBtn.tag = 4601;
        [_questBtn addTarget:self action:@selector(onClickedUserBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _questBtn;
}

- (HPAlignCenterButton *)receiveOrderBtn
{
    if (!_receiveOrderBtn) {
        _receiveOrderBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"receive_order")];
        [_receiveOrderBtn setText:@"店主接单"];
        [_receiveOrderBtn setTextColor:COLOR_GRAY_666666];
        [_receiveOrderBtn setTextFont:kFont_Regular(12.f)];
        _receiveOrderBtn.tag = 4602;
        [_receiveOrderBtn addTarget:self action:@selector(onClickedUserBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveOrderBtn;
}

- (HPAlignCenterButton *)rentToPayBtn
{
    if (!_rentToPayBtn) {
        _rentToPayBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"rentPay")];
        [_rentToPayBtn setText:@"拼租付款"];
        [_rentToPayBtn setTextColor:COLOR_GRAY_666666];
        [_rentToPayBtn setTextFont:kFont_Regular(12.f)];
        _rentToPayBtn.tag = 4603;
        [_rentToPayBtn addTarget:self action:@selector(onClickedUserBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rentToPayBtn;
}

- (HPAlignCenterButton *)beginRentBtn
{
    if (!_beginRentBtn) {
        _beginRentBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"start_rent")];
        [_beginRentBtn setText:@"开始拼租"];
        [_beginRentBtn setTextColor:COLOR_GRAY_666666];
        [_beginRentBtn setTextFont:kFont_Regular(12.f)];
        _beginRentBtn.tag = 4604;
        [_beginRentBtn addTarget:self action:@selector(onClickedUserBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginRentBtn;
}

- (void)onClickedUserBtn:(UIButton *)button
{
    if (self.userBlock) {
        self.userBlock(button.tag);
    }
}


- (void)onClickedProfileBtn:(UIButton *)button
{
    if (self.profileBlock) {
        self.profileBlock(button.tag);
    }
}
@end
