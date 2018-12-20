//
//  HPShareSelectedItemView.h
//  HPShareApp
//
//  Created by HP on 2018/12/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
@class HPShareSelectedItemView;
@protocol HPShareSelectedItemViewDelegate <NSObject>

/**
 点击后移除弹框
 */
- (void)clickBtnInShareSelectViewToRemoveView;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HPShareSelectedItemView : HPBaseModalView
@property (nonatomic, strong) UIView *bgview;
@property (nonatomic, weak) id<HPShareSelectedItemViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
