//
//  HPAccountItemView.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAccountItemView.h"

@implementation HPAccountItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.buttonArray = [NSMutableArray array];
        
        [self setUpAccountItemSubviews];
        
        [self setUpAccountItemSubviewsMasonry];

    }
    return self;
}

- (void)setUpAccountItemSubviews
{
    [self addSubview:self.allBtn];
    
    [self.buttonArray addObject:self.allBtn];

    [self addSubview:self.outcomeBtn];

    [self.buttonArray addObject:self.outcomeBtn];

    [self addSubview:self.incomBtn];

    [self.buttonArray addObject:self.incomBtn];

    [self onClickAccountBtn:self.allBtn];
}


- (void)setUpAccountItemSubviewsMasonry
{
    CGFloat btnW = BoundWithSize(self.allBtn.currentTitle, kScreenWidth, 14.f).size.width + 10;
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(getWidth(17.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(getWidth(btnW));
    }];
    
    [self.outcomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.allBtn.mas_right).offset(getWidth(30.f));
        make.top.mas_equalTo(getWidth(17.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(getWidth(btnW));
    }];
    
    [self.incomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outcomeBtn.mas_right).offset(getWidth(30.f));
        make.top.mas_equalTo(getWidth(17.f));
        make.bottom.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(getWidth(btnW));
    }];
}

- (UIButton *)allBtn
{
    if (!_allBtn) {
        _allBtn = [UIButton new];
        _allBtn.titleLabel.font = kFont_Medium(14.f);
        _allBtn.tag = HPAccountItemIndexAll;

        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allBtn setTitleColor:COLOR_ORANGE_EB0303 forState:UIControlStateSelected];
        [_allBtn setTitleColor:COLOR_GRAY_666666  forState:UIControlStateNormal];

        [_allBtn addTarget:self action:@selector(onClickAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}

- (UIButton *)outcomeBtn
{
    if (!_outcomeBtn) {
        _outcomeBtn = [UIButton new];
        _outcomeBtn.titleLabel.font = kFont_Medium(14.f);
        _outcomeBtn.tag = HPAccountItemIndexOutcome;

        [_outcomeBtn setTitle:@"支出" forState:UIControlStateNormal];
        [_outcomeBtn setTitleColor:COLOR_ORANGE_EB0303 forState:UIControlStateSelected];
        [_outcomeBtn setTitleColor:COLOR_GRAY_666666  forState:UIControlStateNormal];

        [_outcomeBtn addTarget:self action:@selector(onClickAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outcomeBtn;
}

- (UIButton *)incomBtn
{
    if (!_incomBtn) {
        _incomBtn = [UIButton new];
        _incomBtn.titleLabel.font = kFont_Medium(14.f);
        _incomBtn.tag = HPAccountItemIndexIncome;
        [_incomBtn setTitle:@"收入" forState:UIControlStateNormal];
        [_incomBtn setTitleColor:COLOR_GRAY_666666 forState:UIControlStateNormal];
        [_incomBtn setTitleColor:COLOR_ORANGE_EB0303  forState:UIControlStateSelected];

        [_incomBtn addTarget:self action:@selector(onClickAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _incomBtn;
}

- (UIView *)lineViewTemp
{
    if (!_lineViewTemp) {
        _lineViewTemp = [UIView new];
        _lineViewTemp.backgroundColor = COLOR_ORANGE_EB0303;
    }
    return _lineViewTemp;
}

- (void)onClickAccountBtn:(UIButton *)button
{
    if (self.accountBlock) {
        self.accountBlock(button.tag);
    }
    
    if (button.tag == HPAccountItemIndexAll) {
        button.selected = YES;
        self.selectedBtn = button;

        //line
//设置默认第一个选中
        [self addSubview:self.lineViewTemp];
        CGFloat btnW = BoundWithSize(self.allBtn.currentTitle, kScreenWidth, 14.f).size.width + 10;

        [self.lineViewTemp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnW);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(2);
            make.centerX.mas_equalTo(self.allBtn);
        }];
        
    }
    
    [self layoutIfNeeded];

    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = (UIButton *)[[button superview]viewWithTag:5300 + i];
        [btn setSelected:NO];
        btn.titleLabel.font = kFont_Medium(14.f);
        
    }
    UIButton *btn = (UIButton *)button;
    [btn setSelected:YES];
    btn.titleLabel.font = kFont_Bold(16.f);
    [self scrolling:btn.tag];
}

- (void)scrolling:(NSInteger)tag
{
    UIButton *button = self.buttonArray[tag - 5300];
    
    [UIView animateWithDuration:1.5 animations:^{//这里要用remake 因为约束的对象变化了，之前的约束对象还在，需要重新进行布局
        [self.lineViewTemp mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(getWidth(26.f));
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(2);
            make.centerX.mas_equalTo(button);
        }];
        
    }];
}

@end
