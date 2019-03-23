//
//  HPHeaderViewCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHeaderViewCell.h"

#import "UIView+Corner.h"

@implementation HPHeaderViewCell

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
        self.orderNameArray = @[@"待接单",@"待付款",@"待拼租",@"退款/售后",@"待评价"];
        
        self.businessImageArray = @[@"me_business_store",@"me_business_order",@"me_bussness_wallet",@"me_business_name"];

        self.businessNameArray = @[@"店铺",@"订单",@"钱包",@"名片"];
        
        self.myInfoArray = @[@"收藏",@"关注",@"足迹",@"卡券"];

        self.rentImageArray = @[@"find_store",@"send_query",@"receive_order",@"rentPay",@"start_rent"];
        
        self.rentArray = @[@"线上找店",@"发送请求",@"店主接单",@"拼租付款",@"开始拼租"];

        self.contentView.backgroundColor = COLOR_GRAY_f9fafd;
        
        [self setUpCellSubviews];
        
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

    if (self.identifyTag == 0) {//租客的
        [self.contentView addSubview:self.myInfoView];

        CGFloat orderBtnW = 60.f;
        
        CGFloat space = (kScreenWidth - orderBtnW * 4)/5;
        
        for (int i = 0; i < self.myInfoArray.count; i++) {
            HPOrderBtn *orderBtn = [HPOrderBtn new];
            orderBtn.nameLabel.text = self.myInfoArray[i];
            orderBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
            orderBtn.nameLabel.font = kFont_Medium(13.f);
            orderBtn.tag = 4000 + i;
            [self.myInfoView addSubview:orderBtn];
            [orderBtn addTarget:self action:@selector(onClickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(space + i * (orderBtnW + space));
                make.top.mas_equalTo(getWidth(2.f));
                make.width.mas_equalTo(orderBtnW);
                make.height.mas_equalTo(getWidth(60.f));
            }];
        }
        
        [self.contentView addSubview:self.rentView];
        
        [self.rentView addSubview:self.orderTipLabel];
        
        for (int i = 0; i < self.rentImageArray.count; i ++) {
            HPAlignCenterButton *busiBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(self.rentImageArray[i])];
            [busiBtn setText:self.rentArray[i]];
            busiBtn.tag = 4500 + i;
            [busiBtn addTarget:self action:@selector(onClickedRentOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.rentView addSubview:busiBtn];
            [busiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(getWidth(20.f) + i * getWidth(68.f));
                make.width.height.mas_equalTo(getWidth(40.f));
                make.top.mas_equalTo(self.orderTipLabel.mas_bottom).offset(getWidth(30.f));
                make.bottom.mas_equalTo(getWidth(-17.f));
                
            }];
        }
        
    }

    [self.contentView addSubview:self.optionalBtn];
    
}

- (void)onClickedOrderBtn:(HPAlignCenterButton *)button
{
    if (self.orderBlock) {
        self.orderBlock(button.tag);
    }
}

- (void)onClickedBusinessbtn:(UIButton *)button
{
    if (self.busiBlock) {
        self.busiBlock(button.tag);
    }
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
    
    CGFloat identifiW = BoundWithSize(self.identifiLabel.text, kScreenWidth, 12.f).size.width + 10;

    [self.identifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(identifiW);
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

    if (self.identifyTag == 0) {//租客的
        
        [self.myInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(getWidth(30.f));
            make.height.mas_equalTo(getWidth(60.f));
        }];
        
        [self.rentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(getWidth(-28.f));
            make.height.mas_equalTo(getWidth(142.f));
            make.right.mas_equalTo(getWidth(-15.f));
        }];
        
        [self.orderTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(getWidth(13.f));
            make.height.mas_equalTo(self.orderTipLabel.font.pointSize);
            make.right.mas_equalTo(getWidth(-15.f));
        }];
        
    }
}

#pragma mark - 初始化控件

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
//        _iconImageView.image = ImageNamed(@"personal_center_not_login_head");
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
        _identifiLabel.text = @"租客信息，资质认证";
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

- (UIButton *)optionalBtn
{
    if (!_optionalBtn) {
        _optionalBtn = [UIButton new];
        [_optionalBtn setImage:ImageNamed(@"optional") forState:UIControlStateNormal];
        _optionalBtn.backgroundColor = COLOR_BLACK_333333;
        _optionalBtn.alpha = 0.4;
        [_optionalBtn setTitle:@"切换为租客" forState:UIControlStateNormal];
        [_optionalBtn setTitle:@"切换为店主" forState:UIControlStateSelected];
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
    if (self.onlineBlock) {
        self.onlineBlock(button.tag);
    }
}

- (void)setIdentifyTag:(NSInteger)identifyTag
{
    _identifyTag = identifyTag;
    
    [self updateSubviewsUI];
    
    [self updateSubviewsUIMasonry];
}

- (void)updateSubviewsUI
{
    if (self.identifyTag == 0) {//租客的
        
        self.orderStatesView.hidden = YES;
        
        self.myInfoView.hidden = NO;
        
        self.rentView.hidden = NO;

        [self.contentView addSubview:self.myInfoView];
        
        CGFloat orderBtnW = 60.f;
        
        CGFloat space = (kScreenWidth - orderBtnW * 4)/5;
        
        for (int i = 0; i < self.myInfoArray.count; i++) {
            HPOrderBtn *orderBtn = [HPOrderBtn new];
            orderBtn.nameLabel.text = self.myInfoArray[i];
            orderBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
            orderBtn.nameLabel.font = kFont_Medium(13.f);
            orderBtn.tag = 4000 + i;
            [self.myInfoView addSubview:orderBtn];
            [orderBtn addTarget:self action:@selector(onClickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(space + i * (orderBtnW + space));
                make.top.mas_equalTo(getWidth(2.f));
                make.width.mas_equalTo(orderBtnW);
                make.height.mas_equalTo(getWidth(60.f));
            }];
        }
        
        [self.contentView addSubview:self.rentView];
        
        [self.rentView addSubview:self.orderTipLabel];
        
        for (int i = 0; i < self.rentImageArray.count; i ++) {
            HPAlignCenterButton *busiBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(self.rentImageArray[i])];
            [busiBtn setText:self.rentArray[i]];
            busiBtn.tag = 4500 + i;
            [busiBtn addTarget:self action:@selector(onClickedRentOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.rentView addSubview:busiBtn];
            [busiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(getWidth(20.f) + i * getWidth(68.f));
                make.width.height.mas_equalTo(getWidth(40.f));
                make.top.mas_equalTo(self.orderTipLabel.mas_bottom).offset(getWidth(30.f));
                make.bottom.mas_equalTo(getWidth(-17.f));
                
            }];
        }
        
    }else{//店主的
        
        self.myInfoView.hidden = YES;

        self.orderStatesView.hidden = NO;

        self.rentView.hidden = YES;

        [self.contentView addSubview:self.orderStatesView];
        
        [self.contentView addSubview:self.businessView];
        
        CGFloat orderBtnW = 60.f;
        
        CGFloat space = (kScreenWidth - orderBtnW * 5)/6;
        
        for (int i = 0; i < self.orderNameArray.count; i++) {
            HPOrderBtn *orderBtn = [HPOrderBtn new];
            orderBtn.nameLabel.text = self.orderNameArray[i];
            orderBtn.nameLabel.textColor = COLOR_GRAY_FFFFFF;
            orderBtn.nameLabel.font = kFont_Medium(13.f);
            orderBtn.tag = 4600 + i;
            [self.orderStatesView addSubview:orderBtn];
            [orderBtn addTarget:self action:@selector(onClickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(space + i * (orderBtnW + space));
                make.top.mas_equalTo(getWidth(2.f));
                make.width.mas_equalTo(orderBtnW);
                make.height.mas_equalTo(getWidth(60.f));
            }];
        }
        
        for (int j = 0; j < self.businessNameArray.count; j ++) {
            HPAlignCenterButton *busiBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(self.businessImageArray[j])];
            [busiBtn setText:self.businessNameArray[j]];
            busiBtn.tag = 4100 + j;
            [busiBtn addTarget:self action:@selector(onClickedBusinessbtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.businessView addSubview:busiBtn];
            [busiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(getWidth(30.f) + j * getWidth(80.f));
                make.width.height.mas_equalTo(getWidth(40.f));
                make.top.mas_equalTo(getWidth(15.f));
                make.bottom.mas_equalTo(getWidth(-15.f));
                
            }];
        }
    }
    
}

- (void)updateSubviewsUIMasonry
{
    if (self.identifyTag == 0) {//租客的
        
        [self.myInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(getWidth(30.f));
            make.height.mas_equalTo(getWidth(60.f));
        }];
        
        [self.rentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(getWidth(-28.f));
            make.height.mas_equalTo(getWidth(142.f));
            make.right.mas_equalTo(getWidth(-15.f));
        }];
        
        [self.orderTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(getWidth(13.f));
            make.height.mas_equalTo(self.orderTipLabel.font.pointSize);
            make.right.mas_equalTo(getWidth(-15.f));
        }];
        
    }else{//店主的
        
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
        
    }
    
}
@end