//
//  HPTotalFeeCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/27.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTotalFeeCell.h"

@implementation HPTotalFeeCell

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
    [self.contentView addSubview:self.totalFeeLabel];
    
    [self.contentView addSubview:self.feeLabel];
}

- (void)setUpOrderInfoSubviewsMasonry
{
    [self.totalFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.totalFeeLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/3);
        
    }];
    
    CGFloat priceW = BoundWithSize(self.feeLabel.text, kScreenWidth, 14.f).size.width + 10;
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.feeLabel.font.pointSize);
        make.width.mas_equalTo(priceW);
        
    }];
}

- (UILabel *)totalFeeLabel
{
    if (!_totalFeeLabel) {
        _totalFeeLabel = [UILabel new];
        _totalFeeLabel.text = @"合计：";
        _totalFeeLabel.textColor = COLOR_GRAY_666666;
        _totalFeeLabel.textAlignment = NSTextAlignmentLeft;
        _totalFeeLabel.font = kFont_Medium(12.f);
    }
    return _totalFeeLabel;
}

- (UILabel *)feeLabel
{
    if (!_feeLabel) {
        _feeLabel = [UILabel new];
        _feeLabel.text = @"";
        _feeLabel.textColor = COLOR_RED_EA0000;
        _feeLabel.textAlignment = NSTextAlignmentRight;
        _feeLabel.font = kFont_Medium(14.f);
    }
    return _feeLabel;
}
@end

