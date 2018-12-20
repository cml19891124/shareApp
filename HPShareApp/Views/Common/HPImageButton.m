//
//  HPImageButton.m
//  HPShareApp
//
//  Created by Jay on 2018/12/19.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPImageButton.h"

@implementation HPImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/**
 根据UIButton的大小确定UIImageVIew大小，然后拉伸图片
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    [self.imageView setFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
}

@end
