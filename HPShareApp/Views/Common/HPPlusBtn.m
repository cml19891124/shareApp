//
//  HPPlusBtn.m
//  HPShareApp
//
//  Created by HP on 2019/1/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPlusBtn.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#define buttonW  self.frame.size.width
#define buttonH  self.frame.size.height


@implementation HPPlusBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kFont_Medium(10.f);
        [self setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return kRect((buttonW - getWidth(39.f))/2, getWidth(-19.f), getWidth(39.f), getWidth(39.f));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0, buttonH - getWidth(10.f), buttonW, getWidth(10.f));
}

@end
