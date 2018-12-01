//
//  HPPageControl.h
//  HPShareApp
//
//  Created by HP on 2018/12/1.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPPageControl : HPBaseView

- (void)setNumberOfPages:(NSInteger)numOfPages;

- (void)setCurrentPage:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
