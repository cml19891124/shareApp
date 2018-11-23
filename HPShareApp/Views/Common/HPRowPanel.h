//
//  HPRowPanel.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 可包含，添加多行视图并用分割线分隔的panel
 */
@interface HPRowPanel : HPBaseView

/**
 单行的高度，默认45.f * g_rateWidth
 */
@property (nonatomic) CGFloat rowHeight;

/**
 分割线的宽度，默认335.f * g_rateWidth
 */
@property (nonatomic) CGFloat lineWidth;

/**
 分割线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 为panel添加一行 view 并与上一行 view 用分割线分隔

 @param view 要添加的单行view
 */
- (void)addRowView:(UIView *)view;

/**
 为panel添加一行高为 height 的 view，并与上一行view用分割线分隔

 @param view 要添加的单行view
 @param height 要添加单行的高度
 */
- (void)addRowView:(UIView *)view withHeight:(CGFloat)height;

/**
 将第start行到end行的 view 折叠起来

 @param start 折叠起始位置
 @param end 折叠结束位置（折叠包括该行）
 */
- (void)shrinkFrom:(int)start to:(int)end;

/**
 展开折叠的视图
 */
- (void)expand;

@end

NS_ASSUME_NONNULL_END
