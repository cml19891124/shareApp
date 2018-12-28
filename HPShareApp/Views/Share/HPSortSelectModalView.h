//
//  HPSortSelectView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

@class HPSortSelectModalView;
@protocol HPSortSelectModalViewDelegate <NSObject>

@optional
- (void)sortSelectView:(HPSortSelectModalView *)sortSelectModalView didSelectAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPSortSelectModalView : HPBaseModalView

@property (nonatomic, weak) id <HPSortSelectModalViewDelegate> delegate;

- (instancetype)initWithOptions:(NSArray *)options;

- (void)selectCellAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
