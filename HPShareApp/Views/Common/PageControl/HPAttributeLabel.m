//
//  HPAttributeLabel.m
//  HPShareApp
//
//  Created by HP on 2019/1/24.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAttributeLabel.h"

@implementation HPAttributeLabel

+ (HPAttributeLabel *)getTitle:(NSString *)title andFromFont:(UIFont *)fromFont andToFont:(UIFont *)toFont andFromColor:(UIColor *)fromColor andToColor:(UIColor *)toColor andFromRange:(NSRange)fromRange andToRange:(NSRange)toRange andLineSpace:(float)lineSpace andNumbersOfLine:(NSInteger)numbersOfLine andTextAlignment:(NSTextAlignment)textAlignment andLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    HPAttributeLabel *lb = [[HPAttributeLabel alloc]init];
    lb.numberOfLines = numbersOfLine;
    lb.textAlignment = textAlignment;
    lb.lineBreakMode = lineBreakMode;
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:fromColor range:fromRange];
    [attributeStr addAttribute:NSFontAttributeName value:fromFont range:fromRange];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:toColor range:toRange];
    [attributeStr addAttribute:NSFontAttributeName value:toFont range:toRange];
    
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,title.length)];
    lb.attributedText = attributeStr;
    
    return lb;
}

@end
