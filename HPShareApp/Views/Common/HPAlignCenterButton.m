//
//  HPAlignCenterButton.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAlignCenterButton.h"

@interface HPAlignCenterButton ()

/**
 按钮图标View
 */
@property (nonatomic, weak) UIImageView *iconView;

/**
 按钮标题Label
 */
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation HPAlignCenterButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithImage:(UIImage *)image {
    self = [self init];
    if (self) {
        _space = -1.f;
        _textFont = [UIFont fontWithName:FONT_BOLD size:13.f];
        _textColor = COLOR_BLACK_444444;
        _text = @"";
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:iconView];
        _iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:_textFont];
        [titleLabel setTextColor:_textColor];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:_text];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return self;
}

- (void)updateConstraints {
    [_iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
        make.bottom.equalTo(self);
        
        if (self.space != -1.f) {
            make.top.equalTo(self.iconView.mas_bottom).with.offset(self.space);
        }
    }];
    
    [super updateConstraints];
}

- (void)setText:(NSString *)text {
    _text = text;
    [_titleLabel setText:text];
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    
    [self setNeedsUpdateConstraints];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [_titleLabel setFont:textFont];
    
    [self setNeedsUpdateConstraints];
}

- (void)setTextColor:(UIColor *)textColor {
    [_titleLabel setTextColor:textColor];
}

@end
