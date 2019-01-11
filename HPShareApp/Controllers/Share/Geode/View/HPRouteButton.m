//
//  HPRouteButton.m
//  HPShareApp
//
//  Created by HP on 2019/1/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRouteButton.h"

@implementation HPRouteButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.font = kFont_Medium(10.f);
        [self setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (!self.currentTitle || [self.currentTitle isEqualToString:@""]) {
        return kRect((self.frame.size.width - getWidth(32.f))/2,(self.frame.size.height - getWidth(32.f))/2,getWidth(32.f),getWidth(32.f));
    }else{
        return kRect((self.frame.size.width - getWidth(32.f))/2, getWidth(12.f),getWidth(32.f),getWidth(32.f));
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (!self.currentTitle || [self.currentTitle isEqualToString:@""]) {
        return CGRectZero;
    }else{
        return kRect(0,getWidth(46.f), self.frame.size.width, getWidth(25.f));
    }
}
@end
