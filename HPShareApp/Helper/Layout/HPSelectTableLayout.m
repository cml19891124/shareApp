//
//  HPSelectTableLayout.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSelectTableLayout.h"
#import "Macro.h"

@implementation HPSelectTableLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.xSpace = 27.f;
        self.ySpace = 11.f;
        self.itemBorderWidth = 1.f;
        self.itemCornerRadius = 4.f;
        self.itemSize = CGSizeMake(70.f, 25.f);
        self.normalFont = [UIFont fontWithName:FONT_MEDIUM size:12.f];
        self.selectedFont = [UIFont fontWithName:FONT_BOLD size:12.f];
        self.normalTextColor = COLOR_BLACK_444444;
        self.selectTextColor = UIColor.whiteColor;
        self.normalBgColor = UIColor.whiteColor;
        self.selectedBgColor = COLOR_RED_F93362;
        self.normalBorderColor = COLOR_GRAY_999999;
        self.selectedBorderColor = COLOR_RED_F93362;
        self.colNum = 1;
    }
    return self;
}

@end
