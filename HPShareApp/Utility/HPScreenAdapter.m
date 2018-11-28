//
//  HPScreenAdapter.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPScreenAdapter.h"
#import "Macro.h"

@implementation HPScreenAdapter

+ (CGFloat)rateForWidth {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    return screenWidth/375.f;
}

+ (CGFloat)rateForHeight {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    return screenHeight/667.f;
}

+ (CGFloat)statusBarHeight {
    if (IPHONE_HAS_NOTCH) {
        return 44.f;
    }
    else {
        return 20.f;
    }
}

+ (CGFloat)navigationBarHeight {
    if (IPHONE_HAS_NOTCH) {
        return 88.f;
    }
    else {
        return 64.f;
    }
}

+ (CGFloat)tabBarHeight {
    if (IPHONE_HAS_NOTCH) {
        return 83.f;
    }
    else {
        return 49.f;
    }
}

+ (CGFloat)bottomSafeAreaHeight {
    if (IPHONE_HAS_NOTCH) {
        return 34.f;
    }
    else {
        return 0.f;
    }
}

@end
