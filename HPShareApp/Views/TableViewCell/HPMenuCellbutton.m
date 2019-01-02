//
//  HPMenuCellbutton.m
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMenuCellbutton.h"
#import "Macro.h"
#import "HPGlobalVariable.h"

@implementation HPMenuCellbutton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kFont_Medium(13.f);
        [self setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return kRect(5, 0, getWidth(42.f), getWidth(42.f));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0, getWidth(54.f), self.frame.size.width, getWidth(13.f));
}
@end
