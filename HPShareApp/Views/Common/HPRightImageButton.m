//
//  HPRightImageButton.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRightImageButton.h"

@interface HPRightImageButton ()

@property (nonatomic, weak) UIView *centerView;

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
        _alignMode = HPRightImageBtnAlignModeLeftOrRight;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *centerView = [[UIView alloc] init];
    [self addSubview:centerView];
    _centerView = centerView;
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.and.bottom.equalTo(self);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [centerView addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.and.bottom.equalTo(centerView);
        make.centerY.equalTo(self);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [centerView addSubview:imageView];
    _imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView);
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
            [_titleLabel setText:_selectedText ? _selectedText : _text];
        }
        
        if (_selectedImage) {
            [self setSelectedImage:_selectedImage];
        }
    }
    else {
        if (_color) {
            [_titleLabel setTextColor:_color];
        }
        
        if (_text) {
            [_titleLabel setText:_text];
        }
        
        if (_image) {
            [self setImage:_image];
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
    _image = image;
    if (!self.isSelected) {
        [_imageView setImage:image];
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
        }];
    }
}

- (void)setSelectedImage:(UIImage *)image {
    _selectedImage = image;
    if (self.isSelected) {
        [_imageView setImage:image];
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(image.size);
        }];
    }
}

- (void)setAlignMode:(HPRightImageBtnAlignMode)alignMode {
    if (alignMode == HPRightImageBtnAlignModeLeftOrRight) {
        [_centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
    }
    else if (alignMode == HPRightImageBtnAlignModeCenter) {
        [_centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self;
    }
    
    return nil;
}

@end
