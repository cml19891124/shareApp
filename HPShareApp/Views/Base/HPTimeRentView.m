//
//  HPTimeRentView.m
//  HPShareApp
//
//  Created by caominglei on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTimeRentView.h"
#import "HPTimeRentButton.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"
#define viewW   self.frame.size.width
#define viewH   self.frame.size.height

@implementation HPTimeRentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpTimeRentSubviews];
    }
    return self;
}

- (void)setUpTimeRentSubviews
{
    for (int i = 0; i < 4; i++) {
        HPTimeRentButton *rentBtn = [HPTimeRentButton new];
        [rentBtn setImage:ImageNamed(@"customizing_business_cards_owner's_head_portrait") forState:UIControlStateNormal];
        [rentBtn setTitle:@"sdfg" forState:UIControlStateNormal];
        [self addSubview:rentBtn];
        [rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(viewW/4 * i);
            make.top.bottom.mas_equalTo(self);
        }];
    }
}
@end
