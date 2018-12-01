//
//  HPRightImageButton.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRightImageButton.h"

@interface HPRightImageButton ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation HPRightImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        _space = 10.f;
        _font = [UIFont systemFontOfSize:15.f];
        _color = UIColor.blackColor;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.and.bottom.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    _imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(titleLabel.mas_right).with.offset(self.space);
        make.centerY.equalTo(titleLabel);
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        if (_selectedColor) {
            [_titleLabel setTextColor:_selectedColor];
        }
        
        if (_selectedText) {
            [_titleLabel setText:_selectedText];
        }
    }
    else {
        if (_color) {
            [_titleLabel setTextColor:_color];
        }
        
        if (_text) {
            [_titleLabel setText:_text];
        }
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [_titleLabel setFont:font];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    if (!self.isSelected) {
        [_titleLabel setTextColor:color];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if (self.isSelected) {
        [_titleLabel setTextColor:selectedColor];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    if (!self.isSelected) {
        [_titleLabel setText:text];
    }
}

- (void)setSelectedText:(NSString *)selectedText {
    _selectedText = selectedText;
    if (self.isSelected) {
        [_titleLabel setText:selectedText];
    }
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(space);
    }];
}

- (void)setImage:(UIImage *)image {
    [_imageView setImage:image];
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
    }];
}

@end
