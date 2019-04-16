//
//  HPAlertSheet.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAlertSheet.h"

@interface HPAlertSheet ()

/**
 弹窗视图
 */
@property (nonatomic, weak) UIView *sheetView;

/**
 取消按钮与选项区域的分割线
 */
@property (nonatomic, weak) UIView *separator;

/**
 取消按钮与选项区域的分割线与最后一个选项的底部约束（最后一个选项在分割线上面）
 */
@property (nonatomic, strong) MASConstraint *bottomConstraint;



@end

@implementation HPAlertSheet

- (void)onTapModalOutSide{
    [self show:NO];
}

- (instancetype)init {
    _rowHeight = 50.f;
    _separatorHeight = 10.f;
    _lineColor = COLOR_GRAY_D7D7E1;
    _separatorColor = COLOR_GRAY_D7D7E1;
    _cancelTextFont = [UIFont fontWithName:FONT_BOLD size:17.f];
    _cancelTextColor = UIColor.redColor;
    _textColor = COLOR_BLACK_444444;
    _textFont = [UIFont fontWithName:FONT_BOLD size:17.f];
    [self setBackgroundColor:COLOR_BLACK_TRANS_1111119b];
    self.alertActions = [[NSMutableArray alloc] init];
    [self setHidden:YES];
    self = [super init];
    return self;
}

- (void)setupModalView:(UIView *)view {
    [view setBackgroundColor:UIColor.whiteColor];
    _sheetView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn.titleLabel setFont:_cancelTextFont];
    [cancelBtn setTitleColor:_cancelTextColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickSheetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.bottom.equalTo(view);
        make.height.mas_equalTo(self.rowHeight);
    }];
    
    UIView *separator = [[UIView alloc] init];
    [separator setBackgroundColor:_separatorColor];
    [view addSubview:separator];
    _separator = separator;
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.height.mas_equalTo(self.separatorHeight);
        make.bottom.equalTo(cancelBtn.mas_top);
    }];
}

- (void)addAction:(HPAlertAction *)action {
    UIButton *actionBtn = [[UIButton alloc] init];
    [actionBtn.titleLabel setFont:_textFont];
    [actionBtn setTitleColor:_textColor forState:UIControlStateNormal];
    [actionBtn setTitle:action.title forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(onClickSheetBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.alertActions.count == 0) {
        [self.sheetView addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(self.sheetView);
            make.height.mas_equalTo(self.rowHeight);
            self.bottomConstraint = make.bottom.equalTo(self.separator.mas_top);
            make.top.equalTo(self.sheetView);
        }];
    }
    else {
        UIButton *lastActionBtn = self.sheetView.subviews[self.sheetView.subviews.count - 1];
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:_lineColor];
        [self.sheetView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(self.sheetView);
            make.height.mas_equalTo(1.f);
            make.top.equalTo(lastActionBtn.mas_bottom);
        }];
        
        [lastActionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(line.mas_top);
            [self.bottomConstraint uninstall];
        }];
        
        [self.sheetView addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(self.sheetView);
            make.height.mas_equalTo(self.rowHeight);
            make.top.equalTo(line.mas_bottom);
            self.bottomConstraint = make.bottom.equalTo(self.separator.mas_top);
        }];
    }
    
    [self.alertActions addObject:action];
    [self show:NO];
}

- (void)onClickSheetBtn:(UIButton *)btn {
    [self show:NO];
    
    for (HPAlertAction *action in self.alertActions) {
        if ([action.title isEqualToString:btn.titleLabel.text]) {
            if (action.completion) {
                action.completion();
            }
            
            break;
        }
    }
}

- (void)setCancelTextColor:(UIColor *)cancelTextColor
{
    _cancelTextColor = cancelTextColor;
    [self.cancelBtn setTitleColor:cancelTextColor forState:UIControlStateNormal];
}

- (void)setCancelTextFont:(UIFont *)cancelTextFont
{
    _cancelTextFont = cancelTextFont;
    self.cancelBtn.titleLabel.font = cancelTextFont;

}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    [_separator setBackgroundColor:separatorColor];
}
@end

