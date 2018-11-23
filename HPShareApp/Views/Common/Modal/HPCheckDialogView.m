//
//  HPCheckDialogView.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCheckDialogView.h"

@interface HPCheckDialogView ()

/**
 布局对象
 */
@property (nonatomic, strong) HPCheckDialogLayout *layout;

/**
 选项数组
 */
@property (nonatomic, strong) NSArray *itemArray;

/**
 包含选项控件的View
 */
@property (nonatomic, weak) UIView *checkView;

@end

@implementation HPCheckDialogView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithLayout:(HPCheckDialogLayout *)layout itemArray:(NSArray *)itemArray{
    self.layout = layout;
    self.itemArray = itemArray;
    self.selectType = HPCheckDialogSelectTypeSingle;
    self.checkItems = [[NSMutableArray alloc] init];
    self = [super init];
    return self;
}

- (void)setupCustomView:(UIView *)view {
    UIView *checkView = [[UIView alloc] init];
    [view addSubview:checkView];
    self.checkView = checkView;
    [checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).with.offset(self.layout.checkViewLeft);
        make.right.equalTo(view);
    }];
    
    for (int i = 0; i < self.itemArray.count; i ++) {
        NSString *title = self.itemArray[i];
        UIButton *checkBtn = [[UIButton alloc] init];
        [checkBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
        [checkBtn setTitleColor:COLOR_BLACK_444444 forState:UIControlStateNormal];
        [checkBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateSelected];
        [checkBtn setTitle:title forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"renting_and_selling_no_select"] forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"renting_and_selling_select"] forState:UIControlStateSelected];
        [checkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, self.layout.itemSpaceX, 0.f, -self.layout.itemSpaceX)];
        [checkBtn addTarget:self action:@selector(onClickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        [checkView addSubview:checkBtn];
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.and.top.equalTo(checkView);
            }
            else if (i % self.layout.colNum == 0) {
                UIButton *lastRowBtn = checkView.subviews[i - self.layout.colNum];
                make.top.equalTo(lastRowBtn.mas_bottom).with.offset(self.layout.itemSpaceY);
                make.left.equalTo(lastRowBtn);
            }
            else {
                UIButton *lastBtn = checkView.subviews[i - 1];
                make.top.equalTo(lastBtn);
                make.left.equalTo(lastBtn).with.offset(self.layout.colWidth);
            }
            
            make.height.mas_equalTo(15.f);
            
            if (i == self.itemArray.count - 1) {
                make.bottom.equalTo(checkView);
            }
        }];
    }
}

- (void)onClickCheckBtn:(UIButton *)target {
    if (self.selectType == HPCheckDialogSelectTypeMutiple) {
        if (target.selected) {
            [target setSelected:NO];
            [self.checkItems removeObject:target.titleLabel.text];
        }
        else {
            [target setSelected:YES];
            [self.checkItems addObject:target.titleLabel.text];
        }
    }
    else {
        for (UIButton *item in self.checkView.subviews) {
            if (item == target) {
                if (item.selected) {
                    [item setSelected:NO];
                    self.checkItem = @"";
                }
                else {
                    [item setSelected:YES];
                    self.checkItem = item.titleLabel.text;
                }
            }
            else {
                [item setSelected:NO];
            }
        }
    }
}

- (void)clearCheck {
    for (UIButton *item in self.checkView.subviews) {
        [item setSelected:NO];
    }
    
    [self.checkItems removeAllObjects];
}

@end
