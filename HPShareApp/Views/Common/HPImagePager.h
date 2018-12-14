//
//  HPImagePager.h
//  HPShareApp
//
//  Created by Jay on 2018/12/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPImagePager : HPBannerView

- (void)show:(BOOL)isShow;

- (void)scrollToPageAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
