//
//  HPOwnnerHeaderCell.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/3.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOwnnerHeaderCell.h"

@implementation HPOwnnerHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_RED_EA0000;
        self.businessNameArray = @[@"店铺",@"订单",@"钱包",@"名片"];
        self.orderNameArray = @[@"待接单",@"待付款",@"待拼租",@"退款/售后",@"待评价"];
        self.businessImageArray = @[@"me_business_store",@"me_business_order",@"me_bussness_wallet",@"me_business_name"];

        [self setUpCellSubviewsMasonry];
    }
    return self;
}

- (void)setUpCellSubviews
{
    HPLoginModel *account = [HPUserTool account];
    
    [self.contentView addSubview:self.bgImageView];
    
    [self.contentView addSubview:self.iconImageView];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.userInfo.avatarUrl] placeholderImage:ImageNamed(@"personal_center_not_login_head")];
    
    [self.contentView addSubview:self.phoneBtn];
    
    [self.contentView addSubview:self.identifiLabel];
    
    [self.contentView addSubview:self.editBtn];
    
    [self.contentView addSubview:self.myInfoView];
    
    CGFloat orderBtnW = 60.f;
    
    CGFloat space = (kScreenWidth - orderBtnW * 4)/5;
    
    for (int i = 0; i < self.orderNameArray.count; i++) {
        self.orderBtn = [HPOrderBtn new];
        self.orderBtn.nameLabel.text = self.orderNameArray[i];
        self.orderBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        self.orderBtn.nameLabel.font = kFont_Medium(13.f);
        self.orderBtn.tag = 4000 + i;
        [self.myInfoView addSubview:self.orderBtn];
        [self.orderBtn addTarget:self action:@selector(onClickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(space + i * (orderBtnW + space));
            make.top.mas_equalTo(getWidth(2.f));
            make.width.mas_equalTo(orderBtnW);
            make.height.mas_equalTo(getWidth(60.f));
        }];
    }
    
    [self.contentView addSubview:self.rentView];
    
    [self.rentView addSubview:self.orderTipLabel];
    
    for (int i = 0; i < self.businessNameArray.count; i ++) {
        self.busiBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(self.businessNameArray[i])];
        [self.busiBtn setText:self.businessNameArray[i]];
        self.busiBtn.tag = 4500 + i;
        [self.busiBtn addTarget:self action:@selector(onClickedRentOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.rentView addSubview:self.busiBtn];
        [self.busiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(20.f) + i * getWidth(68.f));
            make.width.height.mas_equalTo(getWidth(40.f));
            make.top.mas_equalTo(self.orderTipLabel.mas_bottom).offset(getWidth(30.f));
            make.bottom.mas_equalTo(getWidth(-17.f));
            
        }];
    }
    
    [self.contentView addSubview:self.optionalBtn];
    
}


- (void)setUpCellSubviewsMasonry
{
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(220.f));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(getWidth(50.f));
        make.left.mas_equalTo(getWidth(16.f));
        make.top.mas_equalTo(getWidth(46.f));
    }];
    
    CGFloat phoneW = BoundWithSize(self.phoneBtn.currentTitle, kScreenWidth, 18.f).size.width + 10;
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(phoneW);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(getWidth(11.f));
        make.top.mas_equalTo(getWidth(54.f));
        make.height.mas_equalTo(self.phoneBtn.titleLabel.font.pointSize);
    }];
    
    [self.identifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth/3);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(getWidth(11.f));
        make.top.mas_equalTo(self.phoneBtn.mas_bottom).offset(getWidth(9.f));
        make.height.mas_equalTo(self.identifiLabel.font.pointSize);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(20.f));
        make.left.mas_equalTo(self.phoneBtn.mas_right).offset(getWidth(9.f));
        make.top.mas_equalTo(self.phoneBtn);
        make.height.mas_equalTo(getWidth(20.f));
    }];
    
    [self.optionalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(50.f));
        make.right.mas_equalTo(self.contentView);
        make.width.mas_equalTo(getWidth(90.f));
        make.height.mas_equalTo(getWidth(25.f));
    }];

    [_optionalBtn setCornerRadius:13.f addRectCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft];
    
    [self.orderStatesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(getWidth(30.f));
        make.height.mas_equalTo(getWidth(60.f));
    }];
    
    [self.businessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(getWidth(-28.f));
        make.height.mas_equalTo(getWidth(95.f));
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    CGFloat orderBtnW = 60.f;
    
    CGFloat space = (kScreenWidth - orderBtnW * 5)/6;
    
    for (int i = 0; i < self.orderNameArray.count; i++) {
        self.orderBtn = [HPOrderBtn new];
        self.orderBtn.nameLabel.text = self.orderNameArray[i];
        self.orderBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
        self.orderBtn.nameLabel.font = kFont_Medium(13.f);
        self.orderBtn.tag = 4600 + i;
        if (i == 4600) {
            self.receiveBtn = self.orderBtn;
        }else if (i == 4601) {
            self.topayBtn = self.orderBtn;
        }else if (i == 4602) {
            self.toRentBtn = self.orderBtn;
        }else if (i == 4603) {
            self.returnBtn = self.orderBtn;
        }else if (i == 4604) {
            self.commentBtn = self.orderBtn;
        }
        [self.orderStatesView addSubview:self.orderBtn];
        [self.orderBtn addTarget:self action:@selector(onClickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(space + i * (orderBtnW + space));
            make.top.mas_equalTo(getWidth(2.f));
            make.width.mas_equalTo(orderBtnW);
            make.height.mas_equalTo(getWidth(60.f));
        }];
    }
    
    for (int j = 0; j < self.businessNameArray.count; j ++) {
        self.busiBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(self.businessImageArray[j])];
        [self.busiBtn setText:self.businessNameArray[j]];
        self.busiBtn.tag = 4100 + j;
        [self.busiBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.myInfoView addSubview:self.busiBtn];
        [self.busiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(30.f) + j * getWidth(80.f));
            make.width.height.mas_equalTo(getWidth(40.f));
            make.top.mas_equalTo(getWidth(15.f));
            make.bottom.mas_equalTo(getWidth(-15.f));
            
        }];
    }

}

#pragma mark - 初始化控件

- (UIView *)orderStatesView
{
    if (!_orderStatesView) {
        _orderStatesView = [UIView new];
        [_orderStatesView setBackgroundColor:UIColor.clearColor];
    }
    return _orderStatesView;
}

- (UIView *)myInfoView
{
    if (!_myInfoView) {
        _myInfoView = [UIView new];
        [_myInfoView setBackgroundColor:UIColor.clearColor];
    }
    return _myInfoView;
}

- (HPAlignCenterButton *)busiBtn
{
    if (!_busiBtn) {
        _busiBtn = [HPAlignCenterButton new];
    }
    return _busiBtn;
}

- (HPOrderBtn *)orderBtn
{
    if (!_orderBtn) {
        _orderBtn = [HPOrderBtn new];
    }
    return _orderBtn;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = ImageNamed(@"me_red_head");
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.layer.cornerRadius = getWidth(50.f)/2;
        _iconImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHeaderView:)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton new];
        [_phoneBtn setTitle:@"15817479363" forState:UIControlStateNormal];
        [_phoneBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(onClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        _phoneBtn.titleLabel.font = kFont_Medium(18.f);
        _phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _phoneBtn;
}

- (UILabel *)identifiLabel
{
    if (!_identifiLabel) {
        _identifiLabel = [UILabel new];
        _identifiLabel.textColor = COLOR_GRAY_FFFFFF;
        _identifiLabel.text = @"";
        _identifiLabel.font = kFont_Medium(12.f);
        _identifiLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _identifiLabel;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton new];
        [_editBtn setBackgroundImage:ImageNamed(@"me_business_edit") forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(onClickedEditProfileInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)optionalBtn
{
    if (!_optionalBtn) {
        _optionalBtn = [UIButton new];
        [_optionalBtn setImage:ImageNamed(@"optional") forState:UIControlStateNormal];
        _optionalBtn.backgroundColor = COLOR_BLACK_333333;
        _optionalBtn.alpha = 0.4;

        _optionalBtn.titleLabel.font = kFont_Medium(10.f);
        [_optionalBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal|UIControlStateSelected];
        [_optionalBtn addTarget:self action:@selector(onClickedOptionalBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _optionalBtn;
}

- (UIView *)rentView
{
    if (!_rentView) {
        _rentView = [UIView new];
        _rentView.backgroundColor = COLOR_GRAY_FFFFFF;
        _rentView.layer.cornerRadius = 2.f;
        _rentView.layer.masksToBounds = YES;
    }
    return _rentView;
}

- (UILabel *)orderTipLabel
{
    if (!_orderTipLabel) {
        _orderTipLabel = [UILabel new];
        _orderTipLabel.text = @"拼租流程";
        _orderTipLabel.textColor = COLOR_BLACK_333333;
        _orderTipLabel.textAlignment = NSTextAlignmentLeft;
        _orderTipLabel.font = kFont_Bold(16.f);
    }
    return _orderTipLabel;
}

- (UIView *)rentLineView
{
    if (!_rentLineView) {
        _rentLineView = [UIView new];
        _rentLineView.backgroundColor = COLOR_GRAY_FAFAFA;
        _rentLineView.layer.cornerRadius = 2.f;
        _rentLineView.layer.masksToBounds = YES;
    }
    return _rentLineView;
}

- (void)onClickedEditProfileInfo:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onClicked:EditProfileInfoBtn:)]) {
        [self.delegate onClicked:self EditProfileInfoBtn:button];
    }
}

- (void)onClickedOptionalBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onClicked:OptionalBtn:)]) {
        [self.delegate onClicked:self OptionalBtn:button];
    }
}

- (void)onClickLoginBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onClicked:LoginBtn:)]) {
        [self.delegate onClicked:self LoginBtn:button];
    }
}

- (void)onTapHeaderView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(onTapped:HeaderView:)]) {
        [self.delegate onTapped:self HeaderView:tap];
    }
}


- (void)onClickedRentOrderBtn:(UIButton *)button
{
//    if (self.onlineBlock) {
//        self.onlineBlock(button.tag);
//    }
}

@end
