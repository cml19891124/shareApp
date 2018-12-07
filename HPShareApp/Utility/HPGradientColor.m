//
//  HPGradientColor.m
//  HPShareApp
//
//  Created by HP on 2018/12/7.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPGradientColor.h"

@implementation HPGradientColor
+ (CAGradientLayer *)getGradientColorFromStartPoint:(CGPoint)startPoint toEndColor:(CGPoint)endPoint inRect:(CGRect)frame withColors:(NSArray *)colors atCornerRadius:(CGFloat)cornerRadius
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    gradient.frame = frame;
    gradient.colors = colors;
    gradient.cornerRadius = cornerRadius;
    return gradient;
}
@end
