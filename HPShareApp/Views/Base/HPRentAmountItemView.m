//
//  HPRentAmountItemView.m
//  HPShareApp
//
//  Created by HP on 2018/12/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRentAmountItemView.h"
#define margin  ((kScreenWidth - getWidth(34.f) * 4)/5)
#define buttonW ((kScreenWidth - getWidth(10.f) * 3)/3)
@implementation HPRentAmountItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _rightButtonArray = @[@"（元/小时）",@"（元/天）",@"（元/月）"];

        [self setUpDetailView];
        [self setSubviewsLayout];
    }
    return self;
}

- (void)setUpDetailView
{
    [self addSubview:self.fillView];
    [self addSubview:self.rightView];
    [self setUpButtonSubviews];
    [self addSubview:self.fillField];
    [self addSubview:self.lineView];
    
    [self setUpRentAmmountItemSubviews];
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_GRAY_CCCCCC;
    }
    return _lineView;
}
- (void)setUpButtonSubviews
{
    for (int i = 0;i < self.rightButtonArray.count; i++) {
        UIButton *typeBtn = [UIButton new];
        [typeBtn setTitle:self.rightButtonArray[i] forState:UIControlStateNormal];
        typeBtn.titleLabel.font = kFont_Regular(12.f);
        [typeBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        [typeBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateSelected];
        typeBtn.backgroundColor = COLOR_RED_EA0000;
        typeBtn.layer.cornerRadius = 5.f;
        typeBtn.layer.masksToBounds = YES;
        [self.rightView addSubview:typeBtn];
        _typeBtn = typeBtn;
    }
}
//- (NSMutableArray *)rightButtonArray
//{
//    if (!_rightButtonArray) {
//        _rightButtonArray = [NSMutableArray array];
//    }
//    return _rightButtonArray;
//}
- (void)setSubviewsLayout
{
    [_fillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(getWidth(19.f));
        make.height.mas_equalTo(getWidth(15.f));
    }];
    
    [_fillField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(21.f));
        make.top.bottom.mas_equalTo(self.fillView);
        make.height.mas_equalTo(self.fillField.font.pointSize);
    }];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-24.f));
        make.top.bottom.mas_equalTo(self.fillView);
        make.left.mas_equalTo(getWidth(164.f));
    }];
    for (int j = 0; j < self.rightButtonArray.count; j++) {
        [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo((getWidth(-24.f)-buttonW)*j);
            make.top.bottom.mas_equalTo(self.rightView);
            make.width.mas_equalTo(buttonW);
            make.left.mas_equalTo(getWidth(100.f));
                                   }];
    }
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(335.f), getWidth(0.5f)));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.fillView.mas_bottom).offset(getWidth(14.f));
    }];
}

- (UIView *)fillView
{
    if (!_fillView) {
        UIView *fillView = [UIView new];
        fillView.backgroundColor = COLOR_GRAY_FFFFFF;
        _fillView = fillView;
    }
    return _fillView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _rightView;
}

- (UITextField *)fillField
{
    if (!_fillField) {
        _fillField = [UITextField new];
        _fillField.placeholder = @"不满意参考价格，自己填";
        [_fillField setValue:COLOR_GRAY_999999 forKeyPath:@"_placeholderLabel.textColor"];
        [_fillField setValue:kFont_Regular(12.f) forKeyPath:@"_placeholderLabel.font"];

    }
    return _fillField;
}
- (void)setUpRentAmmountItemSubviews
{
    NSArray *itemAray = @[@"面议",@"100元/天",@"200元/天",@"300元/天"];
    for (int i = 0; i < itemAray.count; i++) {
        UIButton *itemBtn = [UIButton new];
        [itemBtn setTitle:itemAray[i] forState:UIControlStateNormal];
        itemBtn.titleLabel.font = kFont_Regular(12.f);
        [itemBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateSelected];
        [itemBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:[self createImageWithColor:COLOR_GRAY_F6F6F6] forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:[self createImageWithColor:COLOR_RED_EA0000] forState:UIControlStateSelected];
        itemBtn.layer.cornerRadius = 5.f;
        itemBtn.layer.masksToBounds = YES;
        [itemBtn addTarget:self action:@selector(selectRentAmountItem:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.selectedBtn = itemBtn;
        }
        [self addSubview:itemBtn];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset((getWidth(34.f)+margin) * i + margin);
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(getWidth(12.f));
            make.bottom.mas_equalTo(self).offset(getWidth(-11.f));
            make.width.mas_equalTo(getWidth(50.f));
        }];
    }
}

//UIColor转UIImage

- (UIImage*)createImageWithColor:(UIColor*)color

{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,[color CGColor]);
    
    CGContextFillRect(context,rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

- (void)selectRentAmountItem:(UIButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    if (self.rentAmountItemClickBtnBlock) {
        self.rentAmountItemClickBtnBlock(button.currentTitle);
    }
}

@end
