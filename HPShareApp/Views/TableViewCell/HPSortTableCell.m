//
//  HPSelectTableCell.m
//  HPShareApp
//
//  Created by Jay on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSortTableCell.h"

@interface HPSortTableCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *checkBtn;

@end

@implementation HPSortTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCheck:(BOOL)isCheck {
    _isCheck = isCheck;
    [self.titleLabel setHighlighted:isCheck];
    [self.checkBtn setSelected:isCheck];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _isCheck = NO;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:UIColor.clearColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [titleLabel setTextColor:COLOR_BLACK_666666];
    [titleLabel setHighlightedTextColor:COLOR_RED_FF3455];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(25.f * g_rateWidth);
        make.centerY.equalTo(self);
    }];
    
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateSelected];
    [checkBtn setImage:nil forState:UIControlStateNormal];
    [self addSubview:checkBtn];
    self.checkBtn = checkBtn;
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).with.offset(16.f * g_rateWidth);
        make.centerY.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (NSString *)title {
    return self.titleLabel.text;
}

@end
