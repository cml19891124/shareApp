//
//  HPBannerView.m
//  HPShareApp
//
//  Created by HP on 2018/12/3.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBannerView.h"

@interface HPBannerView () <HPPageViewDelegate>

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HPBannerView

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
        [self setDelegate:self];
        [self setBackgroundColor:UIColor.clearColor];
    }
    return self;
}

- (void)dealloc {
    [self stopAutoScroll];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIGestureRecognizer *gestureRecognizer in self.scrollView.gestureRecognizers) {
        [gestureRecognizer setCancelsTouchesInView:NO];
    }
}

- (void)setDelegate:(id<HPPageViewDelegate>)delegate {
    NSAssert(delegate == self, @"Not Allowed, Please use setBannerViewDelegate");
    
    [super setDelegate:delegate];
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
    [self layoutIfNeeded];
}

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onTimerTrigger) userInfo:nil repeats:YES];
    }
    else if (interval != _timer.timeInterval) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onTimerTrigger) userInfo:nil repeats:YES];
    }
}

- (void)stopAutoScroll {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)pauseAutoScroll {
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)continueAutoScroll {
    if (_timer) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timer.timeInterval]];
    }
}

- (void)onTimerTrigger {
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += self.pageWidth + self.pageSpace;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:offset];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

#pragma mark - HPPageViewDelegate

- (UIView *)pageView:(HPPageView *)pageView viewAtPageIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:self.imageContentMode];
    UIImage *image = _images[index];
    
    if (image && [image isKindOfClass:UIImage.class]) {
        [imageView setImage:_images[index]];
    }
    
    return imageView;
}

- (NSInteger)pageNumberOfPageView:(HPPageView *)pageView {
    return _images.count;
}

- (void)pageView:(HPPageView *)pageView didScrollAtIndex:(NSInteger)index {
    if (_bannerViewDelegate && [_bannerViewDelegate respondsToSelector:@selector(bannerView:didScrollAtIndex:)]) {
        [_bannerViewDelegate bannerView:self didScrollAtIndex:index];
    }
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self pauseAutoScroll];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self continueAutoScroll];
    [super touchesEnded:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self.scrollView;
}

@end
