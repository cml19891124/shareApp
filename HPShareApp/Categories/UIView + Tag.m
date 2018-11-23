//
//  UIView + Tag.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "UIView + Tag.h"
#import <objc/runtime.h>

static void *strKey = &strKey;

@implementation UIView (Tag)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTagStr:(NSString *)tagStr {
    objc_setAssociatedObject(self, & strKey, tagStr, OBJC_ASSOCIATION_COPY);
}

- (NSString *)tagStr {
    return objc_getAssociatedObject(self, &strKey);
}

@end
