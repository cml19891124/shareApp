//
//  HPCustomAnnotationCalloutView.m
//  HPShareApp
//
//  Created by HP on 2019/1/8.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCustomAnnotationCalloutView.h"

@implementation HPCustomAnnotationCalloutView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titlelabel];
        
//        NSArray *titleArr = [self.titlelabel.text componentsSeparatedByString:@"-"];;
//        NSRange range = [self.titlelabel.text rangeOfString:titleArr.firstObject];
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.titlelabel.text];
//        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:NSMakeRange(0, range.length)];
//        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(range.length + 1, self.titlelabel.text.length - range.length - 1)];
//        [attr addAttribute:NSFontAttributeName value:kFont_Medium(14.f) range:NSMakeRange(0, range.length)];
//        [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(range.length + 1, self.titlelabel.text.length - range.length - 1)];
//        self.titlelabel.attributedText = attr;
        
        [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(getWidth(kScreenWidth - 26.f), getWidth(50.f)));
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [UILabel new];
        _titlelabel.numberOfLines = 0;
        _titlelabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}
@end
