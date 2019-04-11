//
//  HPCardInfoCell.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCardInfoCell.h"

#import "HPGradientUtil.h"

@implementation HPCardInfoCell

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
        
        self.backgroundColor = COLOR(61, 72, 86, 1);
        
        [self setUpSubviews];
        
        [self setUpSubviewsMasonry];
        
    }
    return self;
}

- (void)setUpSubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(335.f));
        make.height.mas_equalTo(getWidth(115.f));
        make.center.mas_equalTo(self);
    }];
    
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(20.f));
        make.width.height.mas_equalTo(getWidth(35.f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(getWidth(15.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2);
        make.top.mas_equalTo(self.iconView.mas_top);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(getWidth(15.f));
        make.height.mas_equalTo(self.typeLabel.font.pointSize);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView);
        make.height.mas_equalTo(self.cardLabel.font.pointSize);
        make.right.mas_equalTo(self.bgView.mas_right).offset(getWidth(-15.f));
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(getWidth(20.f));
    }];
}

- (void)setUpSubviews
{
    CGSize btnSize = CGSizeMake(getWidth(335.f), getWidth(115.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR(254, 138, 115, 1) endColor:COLOR(254, 83, 99, 1)];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.colorBtn];

    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];

    [self.bgView addSubview:self.iconView];
    
    [self.bgView addSubview:self.nameLabel];
    
    [self.bgView addSubview:self.typeLabel];

    [self.bgView addSubview:self.cardLabel];

}

- (UIButton *)colorBtn
{
    if (!_colorBtn) {
        _colorBtn = [[UIButton alloc] init];
        [_colorBtn.layer setCornerRadius:2.f];
        [_colorBtn.layer setMasksToBounds:YES];
        _colorBtn.userInteractionEnabled = NO;
    }
    return _colorBtn;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = UIColor.clearColor;
    }
    return _bgView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.layer.cornerRadius = getWidth(35.f)/2;
        _iconView.layer.borderColor = COLOR_GRAY_FFFFFF.CGColor;
        _iconView.layer.borderWidth = 3.5;
        _iconView.layer.masksToBounds = YES;
        _iconView.image = ImageNamed(@"mingxi");
        
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = COLOR_GRAY_FFFFFF;
        _nameLabel.font = kFont_Bold(18.f);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        _typeLabel.textColor = COLOR_GRAY_FFFFFF;
        _typeLabel.font = kFont_Bold(12.f);
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

- (UILabel *)cardLabel
{
    if (!_cardLabel) {
        _cardLabel = [UILabel new];
        _cardLabel.textColor = COLOR_GRAY_FFFFFF;
        _cardLabel.font = kFont_Regular(22.f);
        _cardLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cardLabel;
}

- (void)setModel:(HPCardsInfoModel *)model
{
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.logUrl] placeholderImage:ImageNamed(@"")];
    
    self.nameLabel.text = model.bankName;
    
//    if (model.shareBankCardId.integerValue == 0) {
//        self.typeLabel.text = [NSString stringWithFormat:@"储蓄卡"];
//    }else{
//        self.typeLabel.text = [NSString stringWithFormat:@"信用卡"];
//    }
    self.typeLabel.text = @"储蓄卡";

    self.cardLabel.text = model.accountNo;
}
@end
