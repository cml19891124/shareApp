//
//  HPPageControl.m
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPageControl.h"

@implementation HPPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
}


- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    
    [self updateDots];
}

- (void)updateDots{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:i] currPage:i];
        if (i == self.currentPage){
            if (_currentImage) {
                dot.image = _currentImage;
                CGRect rect = dot.frame;
                rect.size = _currentImage.size;
                dot.frame = rect;
            }
        }else{
            if (_inactiveImage) {
                dot.image = _inactiveImage;
                CGRect rect = dot.frame;
                rect.size = _inactiveImage.size;
                dot.frame = rect;
            }
        }
    }
}

- (UIImageView *)imageViewForSubview:(UIView *)view currPage:(int)currPage{
    UIImageView *dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            
            [view addSubview:dot];
        }
    }else {
        dot = (UIImageView *)view;
    }
    
    return dot;
}

@end
