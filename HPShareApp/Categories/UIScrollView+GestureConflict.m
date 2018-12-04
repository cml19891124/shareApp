//
//  UIScrollView+GestureConflict.m
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "UIScrollView+GestureConflict.h"
#import "HPBannerView.h"

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
        if ([parentView isMemberOfClass:UIScrollView.class] || [parentView isMemberOfClass:UITableView.class]) {
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

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.superview isMemberOfClass:HPBannerView.class]) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.superview isMemberOfClass:HPBannerView.class]) {
        [super touchesEnded:touches withEvent:event];
    }
}

@end
