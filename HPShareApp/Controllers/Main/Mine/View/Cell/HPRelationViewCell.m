//
//  HPRelationViewCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRelationViewCell.h"

@implementation HPRelationViewCell

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
        
        [self setUpViews];
        
        [self setUpViewsMasonry];

    }
    return self;
}

- (void)setUpViewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(-0.5f);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(getWidth(15.f));
        make.width.height.mas_equalTo(getWidth(16.f));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(getWidth(16.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(getWidth(-20.f));
        make.height.mas_equalTo(getWidth(11.f));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(getWidth(6.f));
    }];
}

- (void)setUpViews
{
    
    [self.contentView addSubview:self.bgView];

    [self.bgView addSubview:self.iconView];
    
    [self.bgView addSubview:self.titleLabel];
    
    [self.bgView addSubview:self.arrowImage];

}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        [_bgView setBackgroundColor:COLOR_GRAY_FFFFFF];
    }
    return _bgView;
}

 - (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = kFont_Bold(14.f);
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"fdsgs";
    }
    return _titleLabel;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        _arrowImage = [UIImageView new];
        _arrowImage.image = ImageNamed(@"shouye_gengduo");
    }
    return _arrowImage;
}
@end
