//
//  HPSearchVerbBtnView.m
//  HPShareApp
//
//  Created by HP on 2019/2/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSearchVerbBtnView.h"
#import "Macro.h"
#import "Masonry.h"
#import "HPImageUtil.h"

@implementation HPSearchVerbBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    NSMutableArray *testArray = [NSMutableArray array];
    [testArray addObject:@"服装门店"];
    [testArray addObject:@"大户型商铺"];
    [testArray addObject:@"小商店"];
    [testArray addObject:@"超级大大的店面"];
    [testArray addObject:@"服装批发大开间"];
    [testArray addObject:@"各种大一点的门店"];
    
    CGFloat startX = 10;
    CGFloat startY = getWidth(15.f);
    CGFloat buttonHeight = getWidth(25.f);
    
    for(int i = 0; i < testArray.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_GRAY_F6F6F6] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_GRAY_F6F6F6] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = kFont_Medium(12.f);
        [btn setTitle:testArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectedSearchItem:) forControlEvents:UIControlEventTouchUpInside];
        CGSize titleSize = [testArray[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        
        titleSize.height = 20;
        titleSize.width += 20;
        
        if(startX + titleSize.width > kScreenWidth - getWidth(30.f)){
            startX = 10;
            startY = startY + buttonHeight + 10;
        }
        btn.frame = CGRectMake(startX, startY, titleSize.width, buttonHeight);
        startX = CGRectGetMaxX(btn.frame) + 10;
        [self addSubview:btn];
        self.searchbtn = btn;
    }
}

- (void)selectedSearchItem:(UIButton *)button
{
    if (self.searchBlock) {
        self.searchBlock(button.currentTitle);
    }
}
@end
