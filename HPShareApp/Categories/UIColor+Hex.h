//
//  UIColor+Hex.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 为 UIColor 添加转Hex字符串，RGB数组成UIColor的方法。
 */
@interface UIColor (Hex)

/**
 转Hex字符串成 UIColor。

 @param color 代表颜色的Hex字符串
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 转RGB数组成 UIColor

 @param rgbArray 代表颜色的rgb数组或rgba数组
 @return UIColor
 */
+ (UIColor *)colorWithRGBArray:(NSArray *)rgbArray;

@end

NS_ASSUME_NONNULL_END
