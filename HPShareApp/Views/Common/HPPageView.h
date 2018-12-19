//
//  HPPageView.h
//  HPShareApp
//
//  Created by HP on 2018/12/1.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

@class HPPageView;
@protocol HPPageViewDelegate <NSObject>

@required
- (NSInteger)pageNumberOfPageView:(HPPageView *)pageView;

- (UIView *)pageView:(HPPageView *)pageView viewAtPageIndex:(NSInteger)index;

@optional
- (void)pageView:(HPPageView *)pageView didScrollAtIndex:(NSInteger)index;

- (void)pageView:(HPPageView *)pageView didClickPageItem:(UIView *)item atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPPageView : HPBaseView <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat pageMarginLeft;

@property (nonatomic, assign) CGFloat pageWidth;

@property (nonatomic, assign) CGFloat pageSpace;

@property (nonatomic, assign) CGSize pageItemSize;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, weak) id <HPPageViewDelegate> delegate;

@property (nonatomic, weak, readonly) UIScrollView *scrollView;

- (void)refreshPageItem;

@end

NS_ASSUME_NONNULL_END
