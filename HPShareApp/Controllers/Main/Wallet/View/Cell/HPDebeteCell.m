//
//  HPDebeteCell.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPDebeteCell.h"

@implementation HPDebeteCell

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
        
        [self setUpDebeteSubviews];
        
        [self setUpDebeteSubviewsMasnory];
        
    }
    return self;
}

- (void)setUpDebeteSubviews
{
    [self.contentView addSubview:self.iconView];
    
    [self.contentView addSubview:self.nameLabel];
    
    [self.contentView addSubview:self.nameSubLabel];
    
    [self.contentView addSubview:self.amountLabel];
    
    [self.contentView addSubview:self.amountSubLabel];

}

- (void)setUpDebeteSubviewsMasnory
{
   
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(getWidth(26.f));
        make.width.mas_equalTo(getWidth(20.f));
        make.height.mas_equalTo(getWidth(22.f));

    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2);
        make.top.mas_equalTo(getWidth(20.f));
    }];
    
    [self.nameSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.nameSubLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(12.f));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(self.amountLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/4);
        make.top.mas_equalTo(self.nameLabel.mas_top);
    }];
    
    [self.amountSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.amountLabel);
        make.height.mas_equalTo(self.amountSubLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/4);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(getWidth(13.f));
    }];
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
        _nameLabel.textColor = COLOR_BLACK_333333;
        _nameLabel.font = kFont_Medium(16.f);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)nameSubLabel
{
    if (!_nameSubLabel) {
        _nameSubLabel = [UILabel new];
        _nameSubLabel.textColor = COLOR_BLACK_333333;
        _nameSubLabel.font = kFont_Medium(12.f);
        _nameSubLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameSubLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.textColor = COLOR_BLACK_333333;
        _amountLabel.font = kFont_Bold(16.f);
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

- (UILabel *)amountSubLabel
{
    if (!_amountSubLabel) {
        _amountSubLabel = [UILabel new];
        _amountSubLabel.text = @"余额：¥0.00";
        _amountSubLabel.textColor = COLOR_GRAY_999999;
        _amountSubLabel.font = kFont_Regular(12.f);
        _amountSubLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountSubLabel;
}

- (void)setModel:(HPAccountInfoModel *)model
{
    _model = model;
}
@end
