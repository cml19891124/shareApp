//
//  HPBannerView.m
//  HPShareApp
//
//  Created by HP on 2018/12/3.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBannerView.h"
#import "HPImagePager.h"

@interface HPBannerView ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *imageViews;

@property (nonatomic, weak) HPImagePager *imagePager;

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
        _showImagePagerEnabled = NO;
    }
    return self;
}

- (void)dealloc {
    [self stopAutoScroll];
    
    for (UIImageView *imageView in _imageViews) {
        [imageView removeObserver:self forKeyPath:@"image"];
    }
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
    _images = [NSMutableArray arrayWithArray:images];
    
}

- (void)setImageViews:(NSArray *)imageViews {
    _imageViews = imageViews;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageViews.count; i ++) {
        UIImageView *imageView = imageViews[i];
        [imageView setTag:i];
        [imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        if (imageView.image) {
            [array addObject:imageView.image];
        }
        else
            [array addObject:[UIImage new]];
    }
    _images = array;
    
    [self refreshPageItem];
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

- (void)pageView:(HPPageView *)pageView didClickPageItem:(UIView *)item atIndex:(NSInteger)index {
    if (!_showImagePagerEnabled) {
        return;
    }
    
    if (_imagePager == nil) {
        HPImagePager *imagePager = [[HPImagePager alloc] init];
        [imagePager setBackgroundColor:UIColor.blackColor];
        [imagePager setImages:_images];
        UIView *currentView = [UIViewController getCurrentVC].view;
        [currentView addSubview:imagePager];
        [imagePager mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(currentView);
        }];
        
        _imagePager = imagePager;
    }
    
    [_imagePager scrollToPageAtIndex:self.currentPage];
    [_imagePager show:YES];
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
    
    if ([self pointInside:point withEvent:event]) {
        return self.scrollView;
    }
    else
        return nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIImageView *imageView = (UIImageView *)object;
    NSInteger index = imageView.tag;
    UIImage *newImage = [change objectForKey:NSKeyValueChangeNewKey];
    [_images replaceObjectAtIndex:index withObject:newImage];
    [self refreshPageItem];
}

@end
