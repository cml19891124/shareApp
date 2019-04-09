//
//  HPWalletCell.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/9.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPWalletCell.h"

@implementation HPWalletCell

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

        [self setUpSubviews];
        
        [self setUpSubviewsMasonry];

    }
    return self;
}

- (void)setUpSubviewsMasonry
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.width.height.mas_equalTo(getWidth(16.f));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)setUpSubviews
{
    [self.contentView addSubview:self.iconView];
    
    [self.contentView addSubview:self.nameLabel];
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.image = ImageNamed(@"mingxi");
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = COLOR_BLACK_333333;
        _nameLabel.font = kFont_Medium(14.f);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
@end
