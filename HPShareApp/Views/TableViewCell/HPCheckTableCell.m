//
//  HPCheckTableCell.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCheckTableCell.h"

@interface HPCheckTableCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *checkBtn;

@end

@implementation HPCheckTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}

- (void)setCheck:(BOOL)isCheck {
    _isCheck = isCheck;
    [self.titleLabel setHighlighted:isCheck];
    [self.checkBtn setSelected:isCheck];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isCheck = NO;
        [self setIsSingle:NO];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:UIColor.clearColor];
        [self initProperties];
        [self setupUI];
    }
    return self;
}

- (void)initProperties {
    _textMarginLeft = 47.f * g_rateWidth;
    
    _selectedIconMarginRight = 28.f * g_rateWidth;
    
    _selectedIcon = [UIImage imageNamed:@"find_shop_pair_number"];
    
    _textFont = [UIFont fontWithName:FONT_MEDIUM size:16.f];
    
    _textColor = COLOR_BLACK_444444;
    
    _textSelectedColor = COLOR_RED_FC4865;
}

- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:_textFont];
    [titleLabel setTextColor:_textColor];
    [titleLabel setHighlightedTextColor:_textSelectedColor];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(self.textMarginLeft);
        make.centerY.equalTo(self);
    }];
    
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setImage:_selectedIcon forState:UIControlStateSelected];
    [checkBtn setImage:nil forState:UIControlStateNormal];
    [self addSubview:checkBtn];
    self.checkBtn = checkBtn;
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-self.selectedIconMarginRight);
        make.centerY.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [_titleLabel setFont:textFont];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [_titleLabel setTextColor:textColor];
}

- (void)setTextSelectedColor:(UIColor *)textSelectedColor {
    _textSelectedColor = textSelectedColor;
    [_titleLabel setHighlightedTextColor:textSelectedColor];
}

- (void)setTextMarginLeft:(CGFloat)textMarginLeft {
    _textMarginLeft = textMarginLeft;
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(textMarginLeft);
    }];
}

- (void)setSelectedIcon:(UIImage *)selectedIcon {
    _selectedIcon = selectedIcon;
    [_checkBtn setImage:selectedIcon forState:UIControlStateSelected];
}

- (void)setSelectedIconMarginRight:(CGFloat)selectedIconMarginRight {
    _selectedIconMarginRight = selectedIconMarginRight;
    [_checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-selectedIconMarginRight);
    }];
}

@end

