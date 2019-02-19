//
//  HPHistoryViewCell.m
//  HPShareApp
//
//  Created by HP on 2019/2/19.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHistoryViewCell.h"

@implementation HPHistoryViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    [self.contentView addSubview:self.historyLabel];
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(17.f));
        make.right.mas_equalTo(getWidth(-17.f));
        make.height.top.mas_equalTo(self);
    }];
}

- (UILabel *)historyLabel
{
    if (!_historyLabel) {
        _historyLabel = [UILabel new];
        _historyLabel.text = @"服装店";
        _historyLabel.textColor = COLOR_BLACK_333333;
        _historyLabel.font = kFont_Medium(12.f);
        _historyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _historyLabel;
}
@end
