//
//  HPGradientUtil.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPGradientUtil.h"

@implementation HPGradientUtil

+ (CGGradientRef) getGradientRefByStartColorHex:(NSString *)startColorHex endColorHex:(NSString *)endColorHex startLoc:(CGFloat)startLoc endLoc:(CGFloat)endLoc {
    CGGradientRef gradientRef;
    CGColorSpaceRef colorSpaceRef;
    CGFloat locs[2] = {startLoc, endLoc};
    
    UIColor *startColor = [UIColor colorWithHexString:startColorHex];
    UIColor *endColor = [UIColor colorWithHexString:endColorHex];
    NSString *startRGBStr = [NSString stringWithFormat:@"%@", startColor];
    NSString *endRGBStr = [NSString stringWithFormat:@"%@", endColor];
    NSArray *startRGBArray = [startRGBStr componentsSeparatedByString:@" "];
    NSArray *endRGBArray = [endRGBStr componentsSeparatedByString:@" "];
    
    CGFloat startR = [startRGBArray[1] floatValue];
    CGFloat startG = [startRGBArray[2] floatValue];
    CGFloat startB = [startRGBArray[3] floatValue];
    CGFloat startA = [startRGBArray[4] floatValue];
    
    CGFloat endR = [endRGBArray[1] floatValue];
    CGFloat endG = [endRGBArray[2] floatValue];
    CGFloat endB = [endRGBArray[3] floatValue];
    CGFloat endA = [endRGBArray[4] floatValue];
    
    CGFloat colors[8] = {startR, startG, startB, startA,  // 前4个为起始颜色的rgba
        endR, endG, endB, endA }; // 后4个为结束颜色的rgba
    colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    gradientRef = CGGradientCreateWithColorComponents (colorSpaceRef, colors,
                                                       locs, 2);
    return gradientRef;
}

+ (CGGradientRef) getGradientRefByStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startLoc:(CGFloat)startLoc endLoc:(CGFloat)endLoc {
    CGGradientRef gradientRef;
    CGColorSpaceRef colorSpaceRef;
    CGFloat locs[2] = {startLoc, endLoc};
    
    NSString *startRGBStr = [NSString stringWithFormat:@"%@", startColor];
    NSString *endRGBStr = [NSString stringWithFormat:@"%@", endColor];
    NSArray *startRGBArray = [startRGBStr componentsSeparatedByString:@" "];
    NSArray *endRGBArray = [endRGBStr componentsSeparatedByString:@" "];
    
    CGFloat startR = [startRGBArray[1] floatValue];
    CGFloat startG = [startRGBArray[2] floatValue];
    CGFloat startB = [startRGBArray[3] floatValue];
    CGFloat startA = [startRGBArray[4] floatValue];
    
    CGFloat endR = [endRGBArray[1] floatValue];
    CGFloat endG = [endRGBArray[2] floatValue];
    CGFloat endB = [endRGBArray[3] floatValue];
    CGFloat endA = [endRGBArray[4] floatValue];
    
    CGFloat colors[8] = {startR, startG, startB, startA,  // 前4个为起始颜色的rgba
        endR, endG, endB, endA }; // 后4个为结束颜色的rgba
    colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    gradientRef = CGGradientCreateWithColorComponents (colorSpaceRef, colors,
                                                       locs, 2);
    return gradientRef;
}


@end
