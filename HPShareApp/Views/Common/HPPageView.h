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

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPPageView : HPBaseView

@property (nonatomic, assign) CGFloat pageMarginLeft;

@property (nonatomic, assign) CGFloat pageWidth;

@property (nonatomic, assign) CGFloat pageSpace;

@property (nonatomic, weak) id <HPPageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
