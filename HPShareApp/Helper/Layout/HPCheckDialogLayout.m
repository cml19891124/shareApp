//
//  HPCheckDialogLayout.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCheckDialogLayout.h"

@implementation HPCheckDialogLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _checkViewLeft = 36.f;
        _itemSpaceX = 10.f;
        _itemSpaceY = 34.f;
        _colNum = 1;
        _colWidth = 125.f;
    }
    return self;
}

@end
