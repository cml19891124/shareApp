//
//  HPImageUtil.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 生成 UIImage 的工具类。
 */
@interface HPImageUtil : NSObject

/**
 根据 UIColor 生成纯色的 UIImage。

 @param color UIImage 的颜色
 @param rect UIImage 的 CGRect
 @return UIImage
 */
+ (UIImage *)getImageByColor:(UIColor *)color inRect:(CGRect)rect;

/**
 根据提供参数生成长方形的 UIImage。

 @param strokeColor 轮廓颜色
 @param fillColor 填充颜色
 @param borderWidth 轮廓线宽
 @param radius 轮廓圆角
 @param rect 长方形大小
 @return UIImage
 */
+ (UIImage *)getRectangleByStrokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)radius inRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
