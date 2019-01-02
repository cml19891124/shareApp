//
//  HPUploadButton.m
//  HPShareApp
//
//  Created by HP on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUploadButton.h"

@implementation HPUploadButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = COLOR_GRAY_999999;
        self.titleLabel.font = kFont_Medium(11.f);
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (self.titleLabel.text.length) {
        return kRect(getWidth(27.f), getWidth(12.f), getWidth(23.f), getWidth(20.f));
    }else{
        return kRect(getWidth(27.f), getWidth(23.f), getWidth(23.f), getWidth(20.f));
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0, getWidth(44.f), self.frame.size.width, getWidth(11.f));
}
@end
