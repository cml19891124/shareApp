//
//  HPHeaderTableView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHeaderTableView.h"

@implementation HPHeaderTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    NSLog(@"gestureRecognizer");
//    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
//        UIPanGestureRecognizer *panGest = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint translation = [panGest translationInView:touch.view];
////        NSLog(@"translation: %f", translation.y);
//        BOOL contentOffsetUp = translation.y < 0;
////        NSLog(@"contentOffsetY: %f", self.contentOffset.y);
//
//        if ([self.superview isKindOfClass:UIScrollView.class]) {
//            UIScrollView *scrollView = (UIScrollView *)self.superview;
//            if (scrollView.contentOffset.y <= _headerHeight) {
//                if (contentOffsetUp) {
////                    return NO;
//                }
//            }
//        }
//    }
//
//    return YES;
//}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        _canScroll = YES;
        NSLog(@"init+++++++++++");
//        for (UIGestureRecognizer *gest in self.gestureRecognizers) {
//            if ([gest isKindOfClass:UIPanGestureRecognizer.class]) {
//                [gest setCancelsTouchesInView:NO];
//                NSLog(@"setCancelsTouchesInView");
//            }
//        }
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if (!_canScroll) {
//        return NO;
//    }
    
    return YES;
}

@end
