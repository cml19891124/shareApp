//
//  HPRouteTypeMenu.m
//  HPShareApp
//
//  Created by HP on 2019/1/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRouteTypeMenu.h"


@implementation HPRouteTypeMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.routeImageArray = @[@"man",@"ride",@"bus",@"car"];
        
        [self setUpMenuSubviews];

    }
    return self;
}

- (void)setUpMenuSubviews{
    CGFloat margin = (kScreenWidth - getWidth(96.f) * 3)/4;
    for (int i = 0; i < self.routeImageArray.count; i ++) {
        HPRouteButton *btn = [HPRouteButton new];
        [btn setImage:self.routeImageArray[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HPImageUtil createImageWithColor:UIColor.clearColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_BLUE_0E78f6] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickRouteBtnChangeColor:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.btn = btn;
        if (i == 0) {
            self.selectBtn = btn;
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(32.f) * i + margin);
            make.width.height.mas_equalTo(getWidth(32.f));
            make.top.mas_equalTo(self);
        }];
    }
}

- (void)clickRouteBtnChangeColor:(UIButton *)button
{
    self.selectBtn.selected = NO;
    button.selected = YES;
    self.selectBtn = button;
    if (self.routeBtnBlock) {
        self.routeBtnBlock();
    }
}
@end
