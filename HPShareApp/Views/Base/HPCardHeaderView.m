//
//  HPCardHeaderView.m
//  HPShareApp
//
//  Created by caominglei on 2018/12/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCardHeaderView.h"

@implementation HPCardHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"fgsdfgdshsfh";
    [self addSubview:label];
}
@end
