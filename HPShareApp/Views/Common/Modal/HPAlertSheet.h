//
//  HPAlertSheet.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
#import "HPAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

/**
 底部选项弹窗，仿iOS alertSheet
 */
@interface HPAlertSheet : HPBaseModalView

/**
 选项行高
 */
@property (nonatomic) CGFloat rowHeight;

/**
 选项分割线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 取消按钮与选项区域的分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 取消按钮与选项区域的分割线高
 */
@property (nonatomic) CGFloat separatorHeight;

/**
 曲线按钮的标题颜色
 */
@property (nonatomic, strong) UIColor *cancelTextColor;

/**
 取消按钮的标题字体
 */
@property (nonatomic, strong) UIFont *cancelTextFont;

/**
 选项字体颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 选项字体
 */
@property (nonatomic, strong) UIFont *textFont;

@property (strong, nonatomic) UIButton *cancelBtn;

/**
 已添加的HPAlertAction数组
 */
@property (nonatomic, strong) NSMutableArray *alertActions;
/**
 添加选项

 @param action 选项定义对象
 */
- (void)addAction:(HPAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
