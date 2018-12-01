//
//  HPPageControl.h
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPRoundedRectPageControl : HPPageControl

- (void)setNumberOfPages:(NSInteger)numOfPages;

- (void)setCurrentPage:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
