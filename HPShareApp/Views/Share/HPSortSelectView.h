//
//  HPSortSelectView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

@class HPSortSelectView;
@protocol HPSortSelectViewDelegate <NSObject>

@optional
- (void)sortSelectView:(HPSortSelectView *)sortSelectView didSelectAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPSortSelectView : HPBaseView

- (instancetype)initWithOptions:(NSArray *)options;

@property (nonatomic, weak) id <HPSortSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
