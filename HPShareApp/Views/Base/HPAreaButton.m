//
//  HPAreaButton.m
//  HPShareApp
//
//  Created by HP on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAreaButton.h"
#define viewW   self.frame.size.width
#define viewH   self.frame.size.height
@implementation HPAreaButton


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
    return kRect(viewW - getWidth(13.f),(viewH - getWidth(8.f))/2,getWidth(13.f),getWidth(8.f));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0,(viewH - getWidth(20.f))/2,viewW - getWidth(13.f),getWidth(20.f));
}

@end
