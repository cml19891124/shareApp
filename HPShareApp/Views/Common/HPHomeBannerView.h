#import "HPPageView.h"

@class HPHomeBannerView;
@protocol HPHomeBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(HPHomeBannerView *)bannerView didScrollAtIndex:(NSInteger)index;

- (void)pageView:(HPPageView *)pageView didClickPageItem:(UIView *)item atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_BEGIN

@interface HPHomeBannerView : HPPageView <HPPageViewDelegate>

@property (nonatomic, weak) id <HPHomeBannerViewDelegate> bannerViewDelegate;

@property (nonatomic, assign) UIViewContentMode imageContentMode;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, assign) BOOL showImagePagerEnabled;

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval;

- (void)stopAutoScroll;

- (void)pauseAutoScroll;

- (void)continueAutoScroll;

- (void)setImages:(NSArray * _Nonnull)images;

- (void)setImageViews:(NSArray * _Nonnull)imageViews;

//- (void)onTapPageView:(UITapGestureRecognizer *)tapGest;

@end

NS_ASSUME_NONNULL_END
