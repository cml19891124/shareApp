//
//  HPShareAnnotationView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareAnnotationView.h"
#import "HPImageUtil.h"
#import "Macro.h"
#import "Masonry.h"

@interface HPShareAnnotationView ()

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation HPShareAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImage *normalImage = [HPImageUtil getRectangleByStrokeColor:UIColor.whiteColor fillColor:UIColor.whiteColor borderWidth:0.f cornerRadius:16.f inRect:CGRectMake(0.f, 0.f, 167.f, 37.f)];
    UIImage *selectedImage = [HPImageUtil getRectangleByStrokeColor:COLOR_RED_FF3559 fillColor:COLOR_RED_FF3559 borderWidth:0.f cornerRadius:16.f inRect:CGRectMake(0.f, 0.f, 167.f, 37.f)];
    
    _normalImage = normalImage;
    _selectedImage = selectedImage;
    
    [self setImage:_normalImage];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:self.annotation.title];
    [self.imageView addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.imageView);
        make.top.equalTo(self.imageView).with.offset(10.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self.imageView setImage:_selectedImage];
        [_titleLabel setTextColor:UIColor.whiteColor];
    }
    else {
        [self.imageView setImage:_normalImage];
        [_titleLabel setTextColor:COLOR_BLACK_333333];
    }
}

@end
