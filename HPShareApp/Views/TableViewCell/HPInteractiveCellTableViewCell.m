//
//  HPInteractiveCellTableViewCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/6.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPInteractiveCell.h"

@implementation HPInteractiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _isCheck = NO;
//        [self setIsSingle:NO];
        [self setBackgroundColor:UIColor.clearColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
        [titleLabel setTextColor:COLOR_BLACK_444444];
        [titleLabel setHighlightedTextColor:COLOR_RED_FC4865];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(47.f * g_rateWidth);
            make.centerY.equalTo(self);
        }];
        
        UIButton *checkBtn = [[UIButton alloc] init];
        [checkBtn setImage:[UIImage imageNamed:@"find_shop_pair_number"] forState:UIControlStateSelected];
        [checkBtn setImage:nil forState:UIControlStateNormal];
        [self addSubview:checkBtn];
        self.checkBtn = checkBtn;
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-28.f * g_rateWidth);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
