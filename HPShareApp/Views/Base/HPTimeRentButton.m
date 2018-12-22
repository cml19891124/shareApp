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
#define viewW   self.frame.size.width
#define viewH   self.frame.size.height

@implementation HPTimeRentButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = kFont_Medium(10.f);
        [self setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        [self setTitleColor:COLOR_BLUE_83A4FF forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return kRect(getWidth(8.f), getWidth(12.f),getWidth(34.f),getWidth(37.f));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0,getWidth(46.f), viewW, getWidth(25.f));
}
@end
