//
//  HPBanner.m
//  HPShareApp
//
//  Created by HP on 2018/11/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBanner.h"

@interface HPBanner () <UIScrollViewDelegate> {
    BOOL _firstScroll;
    CGFloat _imageWidth;
}

@property (nonatomic, weak) UILabel *pageLabel;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation HPBanner

- (instancetype)init {
    self = [super init];
    if (self) {
        _firstScroll = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setPagingEnabled:YES];
    [scrollView setBounces:NO];
    [scrollView setDelegate:self];
    //    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    for (int i = 0; i < imageArray.count + 1; i ++) {
        UIImage *image;
        
        if (i < imageArray.count) {
            image = imageArray[i];
        }
        else {
            image = imageArray[0];
        }
        
//        UIView *bgView = [[UIView alloc] init];
//        [self.scrollView addSubview:bgView];
//        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.size.equalTo(self);
//
//            if (i == 0) {
//                make.left.equalTo(self.scrollView);
//            }
//            else {
//                UIView *lastView = self.scrollView.subviews[i-1];
//                make.left.equalTo(lastView.mas_right);
//            }
//
//            if (i == imageArray.count) {
//                make.right.equalTo(self.scrollView);
//            }
//        }];
//
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        [bgView addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            CGAffineTransform t = CGAffineTransformMakeScale(g_rateWidth, g_rateWidth);
//            CGSize size = CGSizeApplyAffineTransform(image.size, t);
//            make.size.mas_equalTo(size);
//            make.centerX.and.centerY.equalTo(bgView);
//        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setContentMode:UIViewContentModeCenter];
        [_scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.size.equalTo(self);
            
            if (i == 0) {
                make.left.equalTo(self.scrollView);
            }
            else {
                UIView *lastView = self.scrollView.subviews[i-1];
                make.left.equalTo(lastView.mas_right);
            }
            
            if (i == imageArray.count) {
                make.right.equalTo(self.scrollView);
            }
        }];
    }
    
    [self.pageLabel setText:[NSString stringWithFormat:@"1/%ld", imageArray.count]];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    
}

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_firstScroll) {
        _firstScroll = NO;
        
        [self layoutIfNeeded];
        _imageWidth = self.frame.size.width;
    }
    
    CGPoint contentOffset = scrollView.contentOffset;
    NSInteger index;
    
    if (contentOffset.x >= self.imageArray.count * _imageWidth) {
        [scrollView setContentOffset:CGPointZero];
        index = 0;
    }
    else {
        index = contentOffset.x / _imageWidth;
    }
    
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(banner:didScrollAtIndex:)]) {
            [_delegate banner:self didScrollAtIndex:index];
        }
    }
}

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval {
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onTimerTrigger) userInfo:nil repeats:YES];
}

- (void)stopAutoScroll {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)onTimerTrigger {
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += 375.f;
    
    [self.scrollView setContentOffset:offset animated:YES];
    [self scrollViewDidEndDecelerating:_scrollView];
}

@end

