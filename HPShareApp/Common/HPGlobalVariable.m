//
//  HPGlobalVariable.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPGlobalVariable.h"
#import "HPScreenAdapter.h"

BOOL g_isLogin;
CGFloat g_rateWidth;
CGFloat g_rateHeight;
CGFloat g_statusBarHeight;
CGFloat g_navigationBarHeight;
CGFloat g_tabBarHeight;

@implementation HPGlobalVariable

+ (void)initVariable {
    g_isLogin = NO;
    g_rateWidth = [HPScreenAdapter rateForWidth];
    g_rateHeight = [HPScreenAdapter rateForHeight];
    g_statusBarHeight = [HPScreenAdapter statusBarHeight];
    g_navigationBarHeight = [HPScreenAdapter navigationBarHeight];
    g_tabBarHeight = [HPScreenAdapter tabBarHeight];
}

@end
