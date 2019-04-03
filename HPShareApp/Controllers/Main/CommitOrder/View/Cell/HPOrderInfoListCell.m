//
//  HPOrderInfoListCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/26.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderInfoListCell.h"

@implementation HPOrderInfoListCell

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
        [self setUpOrderInfoSubviews];
        
        [self setUpOrderInfoSubviewsMasonry];

    }
    return self;
}

- (void)setUpOrderInfoSubviews
{
    [self.contentView addSubview:self.dateLabel];
    
    [self.contentView addSubview:self.priceLabel];
}

- (void)setUpOrderInfoSubviewsMasonry
{
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.dateLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);

    }];
    
    CGFloat priceW = BoundWithSize(self.priceLabel.text, kScreenWidth, 14.f).size.width + 20;
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.priceLabel.font.pointSize);
        make.width.mas_equalTo(priceW);
        
    }];
}

- (UILabel *)dateLabel
{
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.text = @"03月21日  周四";
        _dayLabel.textColor = COLOR_GRAY_666666;
        _dayLabel.textAlignment = NSTextAlignmentLeft;
        _dayLabel.font = kFont_Medium(12.f);
    }
    return _dayLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.text = @"¥ 99.00";
        _priceLabel.textColor = COLOR_RED_EA0000;
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = kFont_Medium(14.f);
    }
    return _priceLabel;
}
@end
