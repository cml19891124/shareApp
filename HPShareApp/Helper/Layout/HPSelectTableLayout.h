//
//  HPSelectTableLayout.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 selectTabel（单选矩阵表，类似checkBox）布局对象
 */
@interface HPSelectTableLayout : NSObject

/**
 选项水平间距，默认27.f
 */
@property (nonatomic) CGFloat xSpace;

/**
 选项纵向间距，默认11.f
 */
@property (nonatomic) CGFloat ySpace;

/**
 选项轮廓线宽度，默认1.f
 */
@property (nonatomic) CGFloat itemBorderWidth;

/**
 选项轮廓线圆角，默认4.f
 */
@property (nonatomic) CGFloat itemCornerRadius;

/**
 选项列数，默认1
 */
@property (nonatomic) NSInteger colNum;

/**
 选项大小，默认(70.f, 25.f)
 */
@property (nonatomic) CGSize itemSize;

/**
 非选中状态选项字体，默认 (FONT_MEDIUM, 12.f)
 */
@property (nonatomic, strong) UIFont *normalFont;

/**
 选中状态选项字体，默认 (FONT_BOLD, 12.f)
 */
@property (nonatomic, strong) UIFont *selectedFont;

/**
 非选中状态字体颜色，默认 COLOR_BLACK_444444
 */
@property (nonatomic, strong) UIColor *normalTextColor;

/**
 选中状态字体颜色，默认 UIColor.whiteColor
 */
@property (nonatomic, strong) UIColor *selectTextColor;

/**
 非选中状态选项背景色， 默认 UIColor.whiteColor
 */
@property (nonatomic, strong) UIColor *normalBgColor;

/**
 选中状态选项背景色，默认 COLOR_RED_F93362
 */
@property (nonatomic, strong) UIColor *selectedBgColor;

/**
 非选中状态轮廓线颜色，默认 COLOR_GRAY_999999
 */
@property (nonatomic, strong) UIColor *normalBorderColor;

/**
 选中状态轮廓线颜色，默认 COLOR_RED_F93362
 */
@property (nonatomic, strong) UIColor *selectedBorderColor;

@end

NS_ASSUME_NONNULL_END
