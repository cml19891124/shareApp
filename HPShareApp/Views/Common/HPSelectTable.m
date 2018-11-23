//
//  HPSelectTable.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSelectTable.h"
#import "HPImageUtil.h"

@interface HPSelectTable ()

@property (nonatomic, weak) UIButton *lastBtn;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, strong) HPSelectTableLayout *layout;

@end

@implementation HPSelectTable

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithOptions:(NSArray *)options {
    self = [self init];
    if (self) {
        self.btnArray = [[NSMutableArray alloc] init];
        for (NSString *text in options) {
            UIImage *selectedImage = [HPImageUtil getImageByColor:COLOR_RED_F93362 inRect:CGRectMake(0.f, 0.f, 70.f, 25.f)];
            UIImage *normalImage = [HPImageUtil getImageByColor:UIColor.whiteColor inRect:CGRectMake(0, 0, 70.f, 25.f)];
            
            UIButton *btn = [[UIButton alloc] init];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setBorderWidth:1.f];
            [btn.layer setBorderColor:COLOR_GRAY_999999.CGColor];
            [btn.layer setCornerRadius:4.f];
            [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f]];
            [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
            [btn setTitleColor:COLOR_BLACK_444444 forState:UIControlStateNormal];
            [btn setTitle:text forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.btnArray addObject:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.lastBtn) {
                    make.top.equalTo(self.lastBtn.mas_bottom).with.offset(15.f * g_rateWidth);
                }
                else {
                    make.top.and.left.and.right.equalTo(self);
                }
                
                if (btn == self.btnArray.lastObject) {
                    make.bottom.equalTo(self);
                }
                
                make.size.mas_equalTo(CGSizeMake(70.f, 25.f));
            }];
            self.lastBtn = btn;
        }
    }
    return self;
}

- (instancetype)initWithOptions:(NSArray *)options layout:(HPSelectTableLayout *)layout {
    self = [self init];
    if (self) {
        self.btnArray = [[NSMutableArray alloc] init];
        self.layout = layout;
        UIImage *selectedImage = [HPImageUtil getImageByColor:layout.selectedBgColor inRect:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
        UIImage *normalImage = [HPImageUtil getImageByColor:layout.normalBgColor inRect:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
        
        for (int i = 0; i < options.count; i ++) {
            NSString *text = options[i];
            UIButton *btn = [[UIButton alloc] init];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setBorderWidth:layout.itemBorderWidth];
            [btn.layer setBorderColor:layout.normalBorderColor.CGColor];
            [btn.layer setCornerRadius:layout.itemCornerRadius];
            [btn.titleLabel setFont:layout.normalFont];
            [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
            [btn setTitleColor:layout.selectTextColor forState:UIControlStateSelected];
            [btn setTitleColor:layout.normalTextColor forState:UIControlStateNormal];
            [btn setTitle:text forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.btnArray addObject:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.and.top.equalTo(self);
                }
                else if (i < layout.colNum) {
                    UIButton *lastBtn = self.btnArray[i - 1];
                    make.left.equalTo(lastBtn.mas_right).with.offset(layout.xSpace);
                    make.top.equalTo(lastBtn);
                }
                else {
                    UIButton *lastRowBtn = self.btnArray[i - layout.colNum];
                    make.left.equalTo(lastRowBtn);
                    make.top.equalTo(lastRowBtn.mas_bottom).with.offset(layout.ySpace);
                }
                
                if (i == options.count - 1) {
                    make.right.and.bottom.equalTo(self);
                }
                
                make.size.mas_equalTo(layout.itemSize);
            }];
        }
    }
    return self;
}

- (void)onSelectBtn:(UIButton *)btn {
    for (int i = 0; i < self.btnArray.count; i ++) {
        UIButton *item = self.btnArray[i];
        if (item == btn) {
            [self setBtn:item selected:YES];
            if (_delegate) {
                if ([((NSObject *)_delegate) respondsToSelector:@selector(selectTable:didSelectText:atIndex:)]) {
                    [_delegate selectTable:self didSelectText:btn.titleLabel.text atIndex:i];
                }
            }
        }
        else {
            [self setBtn:item selected:NO];
        }
    }
}

- (void)setBtn:(UIButton *)btn selected:(BOOL)selected {
    if (selected) {
        if (self.layout) {
            [btn.layer setBorderColor:self.layout.selectedBorderColor.CGColor];
            [btn.titleLabel setFont:self.layout.selectedFont];
            [btn setSelected:YES];
        }
        else {
            [btn.layer setBorderColor:COLOR_RED_F93362.CGColor];
            [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12.f]];
            [btn setSelected:YES];
        }
    }
    else {
        if (self.layout) {
            [btn.layer setBorderColor:self.layout.normalBorderColor.CGColor];
            [btn.titleLabel setFont:self.layout.normalFont];
            [btn setSelected:NO];
        }
        else {
            [btn.layer setBorderColor:COLOR_GRAY_999999.CGColor];
            [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f]];
            [btn setSelected:NO];
        }
    }
}

- (void)setBtnAtIndex:(NSInteger)index selected:(BOOL)selected {
    for (int i = 0; i < self.btnArray.count; i ++) {
        UIButton *btn = self.btnArray[i];
        if (i == index) {
            [self setBtn:btn selected:YES];
        }
        else {
            [self setBtn:btn selected:NO];
        }
    }
}

@end

