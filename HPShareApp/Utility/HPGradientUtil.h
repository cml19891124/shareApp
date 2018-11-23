//
//  HPGradientUtil.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Hex.h"

NS_ASSUME_NONNULL_BEGIN

/**
 生成渐变 CGGradientRef 的工具类。
 */
@interface HPGradientUtil : NSObject

/**
 根据Hex颜色字符串，渐变位置生成 CGGradientRef

 @param startColorHex 起始颜色Hex
 @param endColorHex 结束颜色Hex
 @param startLoc 渐变起始位置：0.f ~ 1.f
 @param endLoc 渐变结束位置: 0.f ~ 1.f
 @return 渐变 CGGradientRef
 */
+ (CGGradientRef) getGradientRefByStartColorHex:(NSString *)startColorHex endColorHex:(NSString *)endColorHex startLoc:(CGFloat)startLoc endLoc:(CGFloat)endLoc;

/**
 根据 UIColor，渐变位置生成 CGGradientRef

 @param startColor 起始颜色 UIColor
 @param endColor 结束颜色 UIColor
 @param startLoc 渐变起始位置：0.f ~ 1.f
 @param endLoc 渐变结束位置: 0.f ~ 1.f
 @return 渐变 CGGradientRef
 */
+ (CGGradientRef) getGradientRefByStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startLoc:(CGFloat)startLoc endLoc:(CGFloat)endLoc;

@end

NS_ASSUME_NONNULL_END
