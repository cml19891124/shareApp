//
//  HPImagePager.m
//  HPShareApp
//
//  Created by Jay on 2018/12/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPImagePager.h"
#import "HPPageControlFactory.h"

@interface HPImagePager ()

@property (nonatomic, weak) HPPageControl *pageControl;

@end

@implementation HPImagePager

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
        [self setShowImagePagerEnabled:YES];
        [self setImageContentMode:UIViewContentModeScaleAspectFit];
        self.alpha = 0.f;
        
        HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleCircle];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(- (getHeight(20.f) + g_bottomSafeAreaHeight));
            make.centerX.equalTo(self);
        }];
        [_pageControl setHidden:YES];
    }
    return self;
}

- (void)setImages:(NSArray *)images {
    [super setImages:images];
    
    if (images.count > 1) {
        [_pageControl setHidden:NO];
        [_pageControl setNumberOfPages:images.count];
        [_pageControl setCurrentPage:0];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.alpha == 0.f) {
        return nil;
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)show:(BOOL)isShow {
    [UIView animateWithDuration:0.4 animations:^{
        if (isShow)
            self.alpha = 1.f;
        else
            self.alpha = 0.f;
    }];
}

- (void)scrollToPageAtIndex:(NSInteger)index {
    self.currentPage = index;
    
    if (!_pageControl.isHidden) {
        [_pageControl setCurrentPage:index];
    }
    
    [self refreshPageItem];
}

#pragma mark - HPPageViewDelegate

- (void)pageView:(HPPageView *)pageView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

- (UIView *)pageView:(HPPageView *)pageView viewAtPageIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:self.imageContentMode];
    UIImage *image = self.images[index];

    if (image && [image isKindOfClass:UIImage.class]) {
        [imageView setImage:self.images[index]];
    }

    return imageView;
}

- (void)pageView:(HPPageView *)pageView didClickPageItem:(UIView *)item atIndex:(NSInteger)index {
    [self show:NO];
}

@end
