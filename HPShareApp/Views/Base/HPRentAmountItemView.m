//
//  HPRentAmountItemView.m
//  HPShareApp
//
//  Created by HP on 2018/12/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRentAmountItemView.h"
#define margin  ((kScreenWidth - getWidth(34.f) * 4)/5)
#define buttonW ((kScreenWidth - getWidth(10.f) * 5)/4)
#define fillW   (BoundWithSize(self.fillField.placeholder, kScreenWidth, 12.f).size.width + 10)

@implementation HPRentAmountItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [kNotificationCenter addObserver:self selector:@selector(rectTypeModelNoti:) name:@"rectType" object:nil];
        _rightButtonArray = @[@"(元/小时)",@"(元/天)",@"(元/月)"];
        _itemArray = @[@"面议",@"9.9元/小时",@"20元/小时",@"30元/小时"];
        [self setUpDetailView];
        [self setSubviewsLayout];
        [self setUpRentAmmountItemSubviews];
    }
    return self;
}

- (void)rectTypeModelNoti:(NSNotification *)noti
{
//    HPLog(@"noti:%@",noti);
    self.rectTypeArr = noti.userInfo[@"rectType"];
    UIButton *currBtn;
    if ([self.rectTypeArr containsObject:@"按年起租"]&&self.rectTypeArr.count >= 1&&self.rectTypeArr.count <= 4){//年的优先级最高
        [self.typeBtnYear setTitle:@"(元/年)" forState:UIControlStateNormal];
        currBtn = self.typeBtnYear;
    }else if ([self.rectTypeArr containsObject:@"按月起租"]&&self.rectTypeArr.count >= 1&&self.rectTypeArr.count <= 3){
        [self.typeBtnMonth setTitle:@"(元/月)" forState:UIControlStateNormal];
        currBtn = self.typeBtnMonth;
        
    }else if ([self.rectTypeArr containsObject:@"按天起租"]&&self.rectTypeArr.count >= 1&&self.rectTypeArr.count >= 1&&self.rectTypeArr.count <= 2){
        [self.typeBtnDay setTitle:@"(元/天)" forState:UIControlStateNormal];
        currBtn = self.typeBtnDay;
    }else if ([self.rectTypeArr containsObject:@"按小时起租"]&&self.rectTypeArr.count == 1) {
        [self.typeBtnHour setTitle:@"(元/小时)" forState:UIControlStateNormal];
        currBtn = self.typeBtnHour;
    }
    [self changePriceBlockClick:currBtn];
}
- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}
- (void)setUpDetailView
{
    [self addSubview:self.fillView];
    //右边价格选项按钮父视图
    [self.fillView addSubview:self.rightView];
    [self.rightView addSubview:self.typeBtn];
    //底部价格选项按钮
    [self setUpButtonSubviews];
    [self addSubview:self.fillField];
    [self addSubview:self.lineView];
    
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
        [typeBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
        typeBtn.backgroundColor = UIColor.clearColor;
        typeBtn.layer.cornerRadius = 5.f;
        typeBtn.layer.masksToBounds = YES;
        [typeBtn addTarget:self action:@selector(changePriceBlockClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.selectedBtn = typeBtn;
            _typeBtnHour = typeBtn;
        }else if (i == 1){
            _typeBtnDay = typeBtn;
        }else if (i == 2){
            _typeBtnMonth = typeBtn;
        }
        [self.rightView addSubview:typeBtn];
        _typeBtn = typeBtn;
        CGFloat priceW = ((kScreenWidth - fillW - getWidth(21.f) * 2) - getWidth(10.f) * 4)/3+5;
        [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.rightView);
            make.width.mas_equalTo(priceW);
            make.left.mas_equalTo((getWidth(10.f)+priceW)*i);
        }];
    }
}

- (void)changePriceBlockClick:(UIButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    if ([button.currentTitle isEqualToString:@"(元/小时)"]) {
        _itemArray = @[@"面议",@"9.9元/小时",@"20元/小时",@"30元/小时"];
    }else if ([button.currentTitle isEqualToString:@"(元/天)"]){
        _itemArray = @[@"面议",@"10元/天",@"20元/天",@"30元/天"];
    }else if ([button.currentTitle isEqualToString:@"(元/月)"]||[button.currentTitle isEqualToString:@"(元/年)"]){
        _itemArray = @[@"面议",@"100元/天",@"200元/天",@"300元/天"];
    }
    for (int i = 0;i < _itemArray.count; i++) {
        [_itemBtn setTitle:_itemArray[0] forState:UIControlStateNormal];
        [_itemBtnOne setTitle:_itemArray[1] forState:UIControlStateNormal];
        [_itemBtnTwo setTitle:_itemArray[2] forState:UIControlStateNormal];
        [_itemBtnThree setTitle:_itemArray[3] forState:UIControlStateNormal];

    }

}

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
        make.width.mas_equalTo(fillW);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-24.f));
        make.top.bottom.mas_equalTo(self.fillView);
    make.left.mas_equalTo(self.fillField.mas_right).offset(getWidth(10.f));
    }];
   
    
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
        _fillField.returnKeyType = UIReturnKeyDone;
        _fillField.delegate = self;
        _fillField.tintColor = COLOR_RED_EA0000;
    }
    return _fillField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length) {
        _fillField.text = [NSString stringWithFormat:@"%@(元/小时)",textField.text];
    }
    return YES;
}
- (void)setUpRentAmmountItemSubviews
{
    for (int i = 0; i < _itemArray.count; i++) {
        UIButton *itemBtn = [UIButton new];
        [itemBtn setTitle:_itemArray[i] forState:UIControlStateNormal];
        itemBtn.titleLabel.font = kFont_Regular(12.f);
        [itemBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateSelected];
        [itemBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:[self createImageWithColor:COLOR_GRAY_F6F6F6] forState:UIControlStateNormal];
        [itemBtn setBackgroundImage:[self createImageWithColor:COLOR_RED_EA0000] forState:UIControlStateSelected];
        itemBtn.layer.cornerRadius = 5.f;
        itemBtn.layer.masksToBounds = YES;
        [itemBtn addTarget:self action:@selector(selectRentAmountItem:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.selectedItemBtn = itemBtn;
            _itemBtn = itemBtn;
        }else if (i == 1){
            _itemBtnOne = itemBtn;
        }else if (i == 2){
            _itemBtnTwo = itemBtn;
        }else if (i == 3){
            _itemBtnThree = itemBtn;
        }
        [self addSubview:itemBtn];
        _itemBtn = itemBtn;
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset((buttonW+getWidth(10.f)) * i + getWidth(10.f));
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(getWidth(12.f));
            make.bottom.mas_equalTo(self).offset(getWidth(-11.f));
            make.width.mas_equalTo(buttonW);
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

/**
 选择的单位价格
 */
- (void)selectRentAmountItem:(UIButton *)button
{
    self.selectedItemBtn.selected = NO;
    button.selected = YES;
    self.selectedItemBtn = button;
    if (self.rentAmountItemClickBtnBlock) {
        self.rentAmountItemClickBtnBlock(button.currentTitle);
    }
}

@end
