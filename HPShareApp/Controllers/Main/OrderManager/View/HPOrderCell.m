//
//  HPOrderCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderCell.h"
#import "HPCommonData.h"

@implementation HPOrderCell

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
        
        [self setUpOrderSubviews];
        
        [self setUpOrderSubviewsMasonry];

    }
    return self;
}

- (void)setUpOrderSubviews
{
    [self.contentView addSubview:self.bgView];
    
    [self setupShadowOfPanel:self.bgView];
    
    [self.bgView addSubview:self.orderLabel];
    
    [self.bgView addSubview:self.firstLine];
    
    [self.bgView addSubview:self.contactLabel];
    
    [self.bgView addSubview:self.shopLabel];
    
    [self.bgView addSubview:self.industryLabel];
    
    [self.bgView addSubview:self.payLine];
    
    [self.bgView addSubview:self.returnBtn];
    
    [self.bgView addSubview:self.topayBtn];

    [self.bgView addSubview:self.consultBtn];
    
}

- (void)setUpOrderSubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(7.5f));
        
        make.left.mas_equalTo(self.contentView).offset(getWidth(15.f));;
        
        make.right.mas_equalTo(self.contentView).offset(getWidth(-15.f));;

        make.bottom.mas_equalTo(getWidth(-7.5f));
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.bgView).offset(getWidth(10.f));
        make.right.mas_equalTo(self.bgView).offset(getWidth(-10.f));
        make.height.mas_equalTo(self.orderLabel.font.pointSize);
    }];
    
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgView);
        
        make.top.mas_equalTo(self.orderLabel.mas_bottom).offset(getWidth(10.f));
        
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.orderLabel);
        
        make.top.mas_equalTo(self.firstLine.mas_bottom).offset(getWidth(10.f));
    }];
    
    [self.shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.orderLabel);
        make.top.mas_equalTo(self.contactLabel.mas_bottom).offset(getWidth(10.f));
    }];
    
    [self.industryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.orderLabel);
        make.top.mas_equalTo(self.shopLabel.mas_bottom).offset(getWidth(10.f));
    }];
    
    [self.payLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.firstLine);
        
        make.top.mas_equalTo(self.industryLabel.mas_bottom).offset(getWidth(10.f));
    }];
    
    CGFloat returnW = BoundWithSize(@"我要退款", kScreenWidth, 15.f).size.width + 10.f;
    
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView).offset(getWidth(-15.f));
        
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(getWidth(-10.f));
        
        make.width.mas_equalTo(returnW);
        
        make.height.mas_equalTo(self.orderLabel.font.pointSize + getWidth(10.f));
    }];
    
    CGFloat topayW = BoundWithSize(@"待支付", kScreenWidth, 15.f).size.width + 10.f;

    [self.topayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.returnBtn.mas_left).offset(getWidth(-10.f));
        
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(getWidth(-10.f));
        
        make.width.mas_equalTo(topayW);

        make.height.mas_equalTo(self.orderLabel.font.pointSize + getWidth(10.f));
    }];
    
    CGFloat consultW = BoundWithSize(@"订单查询", kScreenWidth, 15.f).size.width + 10.f;

    [self.consultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topayBtn.mas_left).offset(getWidth(-10.f));
        
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(getWidth(-10.f));
        
        make.width.mas_equalTo(consultW);

        make.height.mas_equalTo(self.orderLabel.font.pointSize + getWidth(10.f));
    }];
}


- (void)setupShadowOfPanel:(UIView *)view {
    [view.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [view.layer setShadowRadius:6.f];
    [view.layer setShadowOpacity:0.3f];
    [view.layer setCornerRadius:6.f];
    [view setBackgroundColor:UIColor.whiteColor];
}

#pragma mark - 初始化控件

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UILabel *)orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.textColor = COLOR_BLACK_333333;
        _orderLabel.textAlignment = NSTextAlignmentLeft;
        _orderLabel.font = kFont_Medium(14.f);
    }
    return _orderLabel;
}

- (UIView *)firstLine
{
    if (!_firstLine) {
        _firstLine = [UIView new];
        [_firstLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    }
    return _firstLine;
}

- (UIView *)payLine
{
    if (!_payLine) {
        _payLine = [UIView new];
        [_payLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    }
    return _payLine;
}

- (UILabel *)contactLabel
{
    if (!_contactLabel) {
        _contactLabel = [UILabel new];
        _contactLabel.textColor = COLOR_BLACK_333333;
        _contactLabel.font = kFont_Medium(15.f);
        _contactLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contactLabel;
}

- (UILabel *)shopLabel
{
    if (!_shopLabel) {
        _shopLabel = [UILabel new];
        _shopLabel.textColor = COLOR_BLACK_333333;
        _shopLabel.font = kFont_Medium(15.f);

        _shopLabel.textAlignment = NSTextAlignmentLeft;
        _shopLabel.numberOfLines = 2;
        [_shopLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _shopLabel;
}

- (UILabel *)industryLabel
{
    if (!_industryLabel) {
        _industryLabel = [UILabel new];
        _industryLabel.textColor = COLOR_BLACK_333333;
        _industryLabel.font = kFont_Medium(15.f);

        _industryLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _industryLabel;
}

- (UIButton *)consultBtn
{
    if (!_consultBtn) {
        _consultBtn = [UIButton new];
        _consultBtn.tag = PayOrderConsult;
        _consultBtn.layer.cornerRadius = 5.f;
        _consultBtn.layer.masksToBounds = YES;
        _consultBtn.titleLabel.font = kFont_Medium(13.f);

        [_consultBtn setTitle:@"订单查询" forState:UIControlStateNormal];
        _consultBtn.backgroundColor = COLOR_BLUE_0E78f6;
        [_consultBtn setTitleColor:COLOR_GRAY_F4F4F4 forState:UIControlStateNormal];
        [_consultBtn addTarget:self action:@selector(clickManagerFunds:) forControlEvents:UIControlEventTouchUpInside];
        _consultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_consultBtn sizeToFit];
    }
    return _consultBtn;
}

- (UIButton *)topayBtn
{
    if (!_topayBtn) {
        _topayBtn = [UIButton new];
        _topayBtn.tag = PayOrderToPay;
        _topayBtn.layer.cornerRadius = 5.f;
        _topayBtn.layer.masksToBounds = YES;
        _topayBtn.titleLabel.font = kFont_Medium(13.f);
        _topayBtn.backgroundColor = COLOR_RED_EA0000;
        [_topayBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_topayBtn setTitleColor:COLOR_GRAY_F4F4F4 forState:UIControlStateNormal];
        [_topayBtn addTarget:self action:@selector(clickManagerFunds:) forControlEvents:UIControlEventTouchUpInside];
        _topayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

        [_topayBtn sizeToFit];

    }
    return _topayBtn;
}

- (UIButton *)returnBtn
{
    if (!_returnBtn) {
        _returnBtn = [UIButton new];
        _returnBtn.tag = PayOrderReturn;
        _returnBtn.layer.cornerRadius = 5.f;
        _returnBtn.layer.masksToBounds = YES;
        _returnBtn.titleLabel.font = kFont_Medium(13.f);
        [_returnBtn setTitle:@"我要退款" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(clickManagerFunds:) forControlEvents:UIControlEventTouchUpInside];
        _returnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _returnBtn.backgroundColor = COLOR_GRAY_EEEEEE;
        [_returnBtn sizeToFit];

    }
    return _returnBtn;
}
- (void)setModel:(HPShareDetailModel *)model
{
    _model = model;
    
    _orderLabel.text = [NSString stringWithFormat:@"订单管理：%ld",(arc4random() % 4654475678858657546) + 100];
    
    _contactLabel.text = [NSString stringWithFormat:@"联系人:%@",_model.contactMobile];
    
    _shopLabel.text = [NSString stringWithFormat:@"店铺名称:%@",_model.title];

    _industryLabel.text = [NSString stringWithFormat:@"经营行业:%@ %@",[HPCommonData getIndustryNameById:_model.industryId],[HPCommonData getIndustryNameById:_model.subIndustryId]];

}

- (void)clickManagerFunds:(UIButton *)button
{
    if (self.payBlock) {
        self.payBlock(button.tag);
    }
}
@end
