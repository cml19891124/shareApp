//
//  HPAttributeLabel.h
//  HPShareApp
//
//  Created by HP on 2019/1/24.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPAttributeLabel : UILabel

+ (HPAttributeLabel *)getTitle:(NSString *)title andFromFont:(UIFont *)fromFont andToFont:(UIFont *)toFont andFromColor:(UIColor *)fromColor andToColor:(UIColor *)toColor andFromRange:(NSRange)fromRange andToRange:(NSRange)toRange andLineSpace:(float)lineSpace andNumbersOfLine:(NSInteger)numbersOfLine andTextAlignment:(NSTextAlignment)textAlignment andLineBreakMode:(NSLineBreakMode)lineBreakMode;
@end

NS_ASSUME_NONNULL_END
