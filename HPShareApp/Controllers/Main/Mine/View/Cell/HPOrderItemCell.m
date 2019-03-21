//
//  HPOrderItemCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderItemCell.h"

@implementation HPOrderItemCell

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
        self.contentView.backgroundColor = COLOR_GRAY_f9fafd;

        [self setUpCellSubviews];
        
        [self setUpCellSubviewsMasonry];
    }
    return self;
}

- (void)setUpCellSubviews
{
    [self.contentView addSubview:self.orderView];
    
    [self.orderView addSubview:self.orderTipLabel];
    
    [self.orderView addSubview:self.allOrderLabel];

}

- (void)setUpCellSubviewsMasonry
{
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.orderTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.top.mas_equalTo(getWidth(13.f));
    }];
    
    [self.allOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(self.orderTipLabel.mas_right);
        make.height.mas_equalTo(self.allOrderLabel.font.pointSize);
    }];
}

- (UIView *)orderView
{
    if (!_orderView) {
        _orderView = [UIView new];
        _orderView.backgroundColor = COLOR_GRAY_FFFFFF;
        _orderView.layer.cornerRadius = 2.f;
        _orderView.layer.masksToBounds = YES;
    }
    return _orderView;
}

- (UILabel *)orderTipLabel
{
    if (!_orderTipLabel) {
        _orderTipLabel = [UILabel new];
        _orderTipLabel.text = @"拼租流程";
        _orderTipLabel.textColor = COLOR_GRAY_FFFFFF;
        _orderTipLabel.textAlignment = NSTextAlignmentLeft;
        _orderTipLabel.font = kFont_Bold(16.f);
    }
    return _orderTipLabel;
}

- (UILabel *)allOrderLabel
{
    if (!_allOrderLabel) {
        _allOrderLabel = [UILabel new];
        _allOrderLabel.text = @"全部订单";
        _allOrderLabel.textColor = COLOR_GRAY_666666;
        _allOrderLabel.textAlignment = NSTextAlignmentRight;
        _allOrderLabel.font = kFont_Medium(14.f);
    }
    return _allOrderLabel;
}
@end
