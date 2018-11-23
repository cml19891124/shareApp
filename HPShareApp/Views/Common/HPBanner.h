//
//  HPBanner.h
//  HPShareApp
//
//  Created by HP on 2018/11/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

@class HPBanner;
@protocol HPBannerDelegate <NSObject>

- (void)banner:(HPBanner *)banner didScrollAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPBanner : HPBaseView

@property (nonatomic, weak) id<HPBannerDelegate> delegate;

@property (nonatomic, strong) NSArray *imageArray;

- (void)startAutoScrollWithInterval:(NSTimeInterval)interval;

- (void)stopAutoScroll;

@end

NS_ASSUME_NONNULL_END
