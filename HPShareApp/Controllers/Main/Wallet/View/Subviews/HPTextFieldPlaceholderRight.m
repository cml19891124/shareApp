//
//  placeholderColor.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTextFieldPlaceholderRight.h"

#import "Macro.h"

@implementation HPTextFieldPlaceholderRight

- (CGRect)placeholderRectForBounds:(CGRect)bounds{

    CGRect newbounds = bounds;
    
    CGSize size = [[self placeholder]sizeWithAttributes:
                   
                   @{NSFontAttributeName:self.font}];
    
    CGFloat width =bounds.size.width- size.width;
    
    newbounds.origin.x= width ;
    
    newbounds.size.width= size.width;
    
    return newbounds;
    
}


@end
