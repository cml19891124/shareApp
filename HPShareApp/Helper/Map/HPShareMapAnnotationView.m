//
//  HPShareMapAnnotationView.m
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareMapAnnotationView.h"
#import "HPImageUtil.h"
#import "Macro.h"
#import "Masonry.h"

@implementation HPShareMapAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setUpMapSubviewsMasonry];
    }
    return self;
}

- (void)setUpMapSubviewsMasonry
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.imageView);
        make.top.equalTo(self.imageView).with.offset(10.f);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
}

- (void)setupUI {
    UIImage *normalImage = [HPImageUtil getRectangleByStrokeColor:UIColor.whiteColor fillColor:UIColor.whiteColor borderWidth:0.f cornerRadius:16.f inRect:CGRectMake(0.f, 0.f, 167.f, 37.f)];
    UIImage *selectedImage = [HPImageUtil getRectangleByStrokeColor:COLOR_RED_FF3559 fillColor:COLOR_RED_FF3559 borderWidth:0.f cornerRadius:16.f inRect:CGRectMake(0.f, 0.f, 167.f, 37.f)];
    
    _normalImage = normalImage;
    _selectedImage = selectedImage;
    
    [self setImage:_normalImage];
    
    [self.imageView addSubview:self.titleLabel];
//    [self.imageView addSubview:self.subTitleLabel];

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
//    if (selected) {
//        [self.imageView setImage:_selectedImage];
//        [_titleLabel setTextColor:UIColor.whiteColor];
//    }
//    else {
//        [self.imageView setImage:_normalImage];
//        [_titleLabel setTextColor:COLOR_BLACK_333333];
//    }
}

#pragma mark - 初始化子控件
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
        [titleLabel setTextColor:COLOR_BLACK_333333];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:self.annotation.title];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        UILabel *subtitleLabel = [[UILabel alloc] init];
        [subtitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
        [subtitleLabel setTextColor:COLOR_BLACK_333333];
        [subtitleLabel setTextAlignment:NSTextAlignmentCenter];
        [subtitleLabel setText:self.annotation.subtitle];
        _subTitleLabel = subtitleLabel;
    }
    return _subTitleLabel;
}

@end
