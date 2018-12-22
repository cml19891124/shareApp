//
//  HPTimeRentView.m
//  HPShareApp
//
//  Created by caominglei on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTimeRentView.h"

#define margin  ((kScreenWidth - getWidth(34.f) * 4)/5)
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
    NSArray *imageArray = @[@"hour_normal",@"day_normal",@"month_normal",@"year_normal"];
    NSArray *imageSelectArray = @[@"hour_select",@"day_select",@"month_select",@"year_select"];
    NSArray *typeAray = @[@"按小时起租",@"按天起租",@"按月起租",@"按年起租"];
    for (int i = 0; i < typeAray.count; i++) {
        HPTimeRentButton *rentBtn = [HPTimeRentButton new];
        [rentBtn setImage:ImageNamed(imageArray[i]) forState:UIControlStateNormal];
        [rentBtn setImage:ImageNamed(imageSelectArray[i]) forState:UIControlStateSelected];
        [rentBtn setTitle:typeAray[i] forState:UIControlStateNormal];
        [rentBtn addTarget:self action:@selector(selectButtonChooseRentType:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 0) {
//            self.selectedBtn = rentBtn;
//        }
        [self addSubview:rentBtn];
        [rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset((getWidth(34.f)+margin) * i + margin);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(getWidth(-11.f));
            make.width.mas_equalTo(getWidth(50.f));
        }];
    }
}

- (void)selectButtonChooseRentType:(HPTimeRentButton *)button
{
//    self.selectedBtn.selected = NO;
//    button.selected = YES;
//    self.selectedBtn = button;
    button.selected = !button.selected;
//    [self.rentItemView.rightButtonArray removeAllObjects];
    if (![self.rentItemView.rightButtonArray containsObject:button.currentTitle]) {
//        [self.rentItemView.rightButtonArray addObject:button.currentTitle];
    }
    if (self.rentTypeClickBtnBlock) {
        self.rentTypeClickBtnBlock(button.currentTitle);
    }
}
@end
