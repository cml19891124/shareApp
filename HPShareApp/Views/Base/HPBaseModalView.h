//
//  HPBaseModalView.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ModalShowCallBack)(BOOL isShow);

/**
 弹出视图基类。
 */
@interface HPBaseModalView : HPBaseView

/**
 modalView 弹出或隐藏时回调
 */
@property (nonatomic, strong) ModalShowCallBack modalShowCallBack;

/**
 根据设定的父View初始化ModalView。

 @param parent 即将被添加到的父view
 @return HPBaseModalView
 */
- (instancetype)initWithParent:(UIView *)parent;

/**
 弹出或隐藏视图。

 @param isShow 弹出（YES）或隐藏（NO）
 */
- (void)show:(BOOL)isShow;

/**
 布局弹出框，子类可重写该方法。

 @param view 传入弹出框 view
 */
- (void)setupModalView:(UIView *)view;

/**
 设置弹出框动画，子类可重写该方法。

 @param view 传入弹出框 view
 */
- (void)appearAnimationOfModalView:(UIView *)view;

/**
 设置弹出框隐藏动画，子类可重写该方法。

 @param view 传入弹出框 view
 @return 多长时间以后弹出框彻底隐藏，建议该参数为隐藏动画过渡时间，单位为秒
 */
- (double)disappearAnimationOfModalView:(UIView *)view;

/**
 点击弹出框外（背景区域）的触发回调，子类可重写该方法。
 */
- (void)onTapModalOutSide;

@end

NS_ASSUME_NONNULL_END
