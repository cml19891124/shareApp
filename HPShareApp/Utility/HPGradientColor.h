//
//  HPGradientColor.h
//  HPShareApp
//
//  Created by HP on 2018/12/7.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface HPGradientColor : NSObject
+ (CAGradientLayer *)getGradientColorFromStartPoint:(CGPoint)startPoint toEndColor:(CGPoint)endPoint inRect:(CGRect)frame withColors:(NSArray *)colors atCornerRadius:(CGFloat)cornerRadius;
@end

NS_ASSUME_NONNULL_END
