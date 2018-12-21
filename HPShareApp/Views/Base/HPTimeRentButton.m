//
//  HPTimeRentButton.m
//  HPShareApp
//
//  Created by caominglei on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTimeRentButton.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#define margin  getWidth(10.f)
#define viewW   self.frame.size.width
#define viewH   self.frame.size.height

@implementation HPTimeRentButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = kFont_Regular(13.f);
        [self setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
        [self setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return kRect(margin, margin, (viewW - 2 * margin), (viewW - 5 * margin)/4);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0, margin + (viewW - 2 * margin), viewW, 25);
}
@end
