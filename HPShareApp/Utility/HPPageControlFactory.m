//
//  HPPageControlFactory.m
//  HPShareApp
//
//  Created by HP on 2018/12/1.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPageControlFactory.h"
#import "HPCirclePageControl.h"
#import "HPRoundedRectPageControl.h"

@implementation HPPageControlFactory

+ (HPPageControl *)createPageControlByStyle:(HPPageControlStyle)style {
    HPPageControl *pageControl = nil;
    
    switch (style) {
        case HPPageControlStyleCircle:
            pageControl = [[HPCirclePageControl alloc] init];
            break;
        case HPPageControlStyleRoundedRect:
            pageControl = [[HPRoundedRectPageControl alloc] init];
            break;
        default:
            break;
    }
    
    return pageControl;
}

@end
