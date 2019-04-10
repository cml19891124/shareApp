//
//  HPDistrictItemView.m
//  HPShareStore
//
//  Created by HP on 2019/3/4.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPChooseItemView.h"
#import "HPSingleton.h"

@implementation HPChooseItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:COLOR_GRAY_FFFFFF];
        NSString *lastObj;
        if ([HPSingleton sharedSingleton].identifyTag == 1) {
            lastObj = @"已完成";
        }else{
            lastObj = @"待评价";

        }
        self.areaArray = @[@"全部",@"待接单",@"待付款",@"待收货",lastObj];
        
        self.buttonArray = @[].mutableCopy;
        
        [self setUpAreaItemsSubviews];
    }
    return self;
}

- (void)setUpAreaItemsSubviews
{
    for (int i = 0; i < self.areaArray.count; i++) {
        UIButton *btn = [UIButton new];
        btn.backgroundColor = COLOR_GRAY_FFFFFF;
        btn.titleLabel.font = kFont_Medium(14.f);
        btn.tag = i + 2200;
        [btn setTitle:self.areaArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_GRAY_666666 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.selected = NO;
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
        self.btn = btn;
        
        float itemW = (kScreenWidth - getWidth(30.f) - getWidth(35.f) * 4)/5;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(5.f) + (itemW + getWidth(35.f)) * i);
            make.top.mas_equalTo(self);
            make.width.mas_equalTo(itemW + getWidth(35.f));
            make.height.mas_equalTo(getWidth(45.f));
        }];
        
        self.bottomView = [UIView new];
        self.bottomView.backgroundColor = UIColor.clearColor;
        [self addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(getWidth(15.f));
            make.centerX.mas_equalTo(self.btn);
        }];
        
        [self layoutIfNeeded];

        if (i == 0) {
            //line
            UIView * lineView = [[UIView alloc] init];
            lineView.layer.cornerRadius = 2;
            lineView.layer.masksToBounds = YES;
            //设置默认第一个选中
            lineView.backgroundColor = COLOR_RED_EA0000;
            [self addSubview:lineView];
            self.lineViewTemp = lineView;

            [self.lineViewTemp mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(itemW);
                make.bottom.mas_equalTo(self);
                make.height.mas_equalTo(2);
                make.centerX.mas_equalTo(btn);
            }];

            btn.selected = YES;
            self.selectedBtn = btn;
//            [self clickItemBtn:btn];
        }
    }
}

//同下一个方法，故封装

- (void)scrolling:(NSInteger)tag
{
    UIButton *button = self.buttonArray[tag - 2200];
    
    [UIView animateWithDuration:1.5 animations:^{//这里要用remake 因为约束的对象变化了，之前的约束对象还在，需要重新进行布局
        [self.lineViewTemp mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(getWidth(15.f));
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(2);
            make.centerX.mas_equalTo(button);
        }];

    }];
}

-(void)clickItemBtn:(UIButton *)button{
    
    if (self.block) {
        self.block(button.tag);
    }
    
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;

    for (int i = 0; i < self.areaArray.count; i++) {
        UIButton *btn = (UIButton *)[[button superview]viewWithTag:2200 + i];
        [btn setSelected:NO];
        btn.titleLabel.font = kFont_Medium(14.f);

    }
    UIButton *btn = (UIButton *)button;
    [btn setSelected:YES];
    btn.titleLabel.font = kFont_Bold(16.f);
    [self scrolling:btn.tag];
}

@end
