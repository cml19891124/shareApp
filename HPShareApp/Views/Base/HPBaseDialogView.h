//
//  HPBaseDialogView.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^BtnClickCallback)(void);

NS_ASSUME_NONNULL_BEGIN

/**
 含有取消和确认按钮的对话框基类。
 */
@interface HPBaseDialogView : HPBaseModalView

/**
 对话框与视图顶部的距离，默认为 -1.f,即居中。
 */
@property (nonatomic, assign) CGFloat modalTop;

/**
 对话框的大小。
 */
@property (nonatomic, assign) CGSize modalSize;

/**
 底部按钮区域的高度。
 */
@property (nonatomic, assign) CGFloat buttonHeight;

/**
 取消按钮点击回调。
 */
@property (nonatomic, copy) BtnClickCallback cancelCallback;

/**
 确认按钮点击回调。
 */
@property (nonatomic, copy) BtnClickCallback confirmCallback;

/**
 布局对话框中的非按钮区域（按钮区域上方），子类可重写该方法。

 @param view 传入对话框 view
 */
- (void)setupCustomView:(UIView *)view;

/**
 设置取消按钮字体颜色。

 @param color 按钮字体颜色
 */
- (void)setCanecelBtnTitleColor:(UIColor *)color;

/**
 设置确认按钮字体颜色

 @param color 按钮字体颜色
 */
- (void)setConfirmBtnTitleColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
