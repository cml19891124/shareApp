//
//  UIScrollView+GestureConflict.m
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "UIScrollView+GestureConflict.h"

@implementation UIScrollView (GestureConflict)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *parentView = touch.view;
    
    while (parentView != nil) {
        if ([parentView isKindOfClass:UIScrollView.class]) {
            if (parentView == self) {
                return YES;
            }
            else {
                return NO;
            }
        }
        
        parentView = parentView.superview;
    }
    
    return YES;
}

@end
