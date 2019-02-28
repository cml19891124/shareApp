//
//  HPShareListParam.m
//  HPShareApp
//
//  Created by Jay on 2018/12/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareListParam.h"

@implementation HPShareListParam

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageSize = 20;
        _type = @"1";
    }
    return self;
}

@end
