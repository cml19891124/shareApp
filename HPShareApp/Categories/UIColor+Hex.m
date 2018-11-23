//
//  UIColor+Hex.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //hexString应该6到8个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    //如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    //RGB转换
    NSRange range = NSMakeRange(0, 2);
    
    //R
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    NSString *aString;
    if ([cString length] == 8) {
        range.location = 6;
        aString = [cString substringWithRange:range];
    }
    else {
        aString = @"ff";
    }
    
    //
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
}

+ (UIColor *)colorWithRGBArray:(NSArray *)rgbArray {
    if (rgbArray.count == 3) {
        NSNumber *rNum = rgbArray[0];
        NSNumber *gNum = rgbArray[1];
        NSNumber *bNum = rgbArray[2];
        if ([rNum isKindOfClass:NSNumber.class] && [gNum isKindOfClass:NSNumber.class] && [bNum isKindOfClass:NSNumber.class]) {
            CGFloat r = rNum.floatValue;
            CGFloat g = gNum.floatValue;
            CGFloat b = bNum.floatValue;
            
            r = r < 0 ? 0.f : r;
            r = r > 255 ? 255.f : r;
            g = g < 0 ? 0.f : g;
            g = g > 255 ? 255.f : g;
            b = b < 0 ? 0.f : b;
            b = b > 255 ? 255.f : b;
            
            return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f];
        }
    }
    else if (rgbArray.count == 4) {
        NSNumber *rNum = rgbArray[0];
        NSNumber *gNum = rgbArray[1];
        NSNumber *bNum = rgbArray[2];
        NSNumber *aNum = rgbArray[3];
        if ([rNum isKindOfClass:NSNumber.class] && [gNum isKindOfClass:NSNumber.class] && [bNum isKindOfClass:NSNumber.class] && [aNum isKindOfClass:NSNumber.class]) {
            CGFloat r = rNum.floatValue;
            CGFloat g = gNum.floatValue;
            CGFloat b = bNum.floatValue;
            CGFloat a = aNum.floatValue;
            
            r = r < 0 ? 0.f : r;
            r = r > 255 ? 255.f : r;
            g = g < 0 ? 0.f : g;
            g = g > 255 ? 255.f : g;
            b = b < 0 ? 0.f : b;
            b = b > 255 ? 255.f : b;
            a = a < 0 ? 0.f : a;
            a = a > 255 ? 255.f : a;
            
            return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f];
        }
    }
    
    return UIColor.clearColor;
}

@end
