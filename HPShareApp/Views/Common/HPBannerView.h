//
//  HPBannerView.h
//  HPShareApp
//
//  Created by HP on 2018/12/3.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPageView.h"

@class HPBannerView;
@protocol HPBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPBannerView : HPPageView <HPPageViewDelegate>

@property (nonatomic, weak) id <HPBannerViewDelegate> bannerViewDelegate;

@property (nonatomic, assign) UIViewContentMode imageContentMode;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, assign) BOOL showImagePagerEnabled;

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval;

- (void)stopAutoScroll;

- (void)pauseAutoScroll;

- (void)continueAutoScroll;

- (void)setImages:(NSArray * _Nonnull)images;

- (void)setImageViews:(NSArray * _Nonnull)imageViews;

- (void)onTapPageView:(UITapGestureRecognizer *)tapGest;

@end

NS_ASSUME_NONNULL_END
