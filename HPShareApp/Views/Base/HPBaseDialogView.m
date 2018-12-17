//
//  HPBaseDialogView.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"
#import "HPImageUtil.h"

@interface HPBaseDialogView () {
    CGFloat _modalTop;
    CGSize _modalSize;
    CGFloat _buttonHeight;
}

/**
 对话框
 */
@property (nonatomic, weak) UIView *modalView;

/**
 取消按钮
 */
@property (nonatomic, weak) UIButton *cancelBtn;

/**
 确认按钮
 */
@property (nonatomic, weak) UIButton *confirmBtn;

/**
 按钮区域和非按钮区域的分割线
 */
@property (nonatomic, weak) UIView *horizontalLine;

@end

@implementation HPBaseDialogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGFloat)modalTop {
    if (_modalTop == 0.f) {
        return -1.f;
    }
    else {
        return _modalTop;
    }
}

- (CGSize)modalSize {
    if (CGSizeEqualToSize(_modalSize, CGSizeZero)) {
        return CGSizeMake(210.f * g_rateWidth, 110.f * g_rateWidth);
    }
    else {
        return _modalSize;
    }
}

- (CGFloat)buttonHeight {
    if (_buttonHeight == 0.f) {
        return 41.f;
    }
    else {
        return _buttonHeight;
    }
}

- (void)setupModalView:(UIView *)view {
    self.modalView = view;
    [view.layer setCornerRadius:5.f];
    [view.layer setMasksToBounds:YES];
    [view setBackgroundColor:UIColor.whiteColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(self.modalSize);
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(self.modalSize);
    }];
    
    UIView *horizontalLine = [[UIView alloc] init];
    [horizontalLine setBackgroundColor:COLOR_GRAY_DBDBDB];
    [view addSubview:horizontalLine];
    self.horizontalLine = horizontalLine;
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.bottom.equalTo(view).with.offset(-self.buttonHeight);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView *verticalLine = [[UIView alloc] init];
    [verticalLine setBackgroundColor:COLOR_GRAY_DBDBDB];
    [view addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.equalTo(view);
        make.top.equalTo(horizontalLine.mas_bottom);
        make.width.mas_equalTo(1.f);
    }];
    
    CGRect rect = CGRectMake(0.f, 0.f, 105.f, 41.f);
    UIImage *highlightedImage = [HPImageUtil getImageByColor:COLOR_PINK_FF1F5E inRect:rect];
    UIImage *normalImage = [HPImageUtil getImageByColor:UIColor.whiteColor inRect:rect];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16.f]];
    [cancelBtn setTitleColor:COLOR_BLACK_444444 forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [cancelBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(view);
        make.top.equalTo(horizontalLine.mas_bottom);
        make.right.equalTo(verticalLine.mas_left);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16.f]];
    [confirmBtn setTitleColor:COLOR_PINK_FF1F5E forState:UIControlStateNormal];
    [confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [confirmBtn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [confirmBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right);
        make.top.equalTo(horizontalLine.mas_bottom);
        make.right.and.bottom.equalTo(view);
    }];
    
    UIView *customView = [[UIView alloc] init];
    [view addSubview:customView];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.width.equalTo(view);
        make.bottom.equalTo(horizontalLine.mas_top);
    }];
    [self setupCustomView:customView];
}

- (void)setupCustomView:(UIView *)view {}

- (void)setModalTop:(CGFloat)modalTop {
    _modalTop = modalTop;
    [self.modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(modalTop);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(self.modalSize);
    }];
}

- (void)setModalSize:(CGSize)modalSize {
    _modalSize = modalSize;
    [self.modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.modalTop == -1.f) {
            make.centerY.equalTo(self);
        }
        else {
            make.top.equalTo(self).with.offset(self.modalTop);
        }
        
        make.centerX.equalTo(self);
        make.size.mas_equalTo(modalSize);
    }];
}

- (void)setCanecelBtnTitleColor:(UIColor *)color {
    [self.cancelBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)setConfirmBtnTitleColor:(UIColor *)color {
    [self.confirmBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)setButtonHeight:(CGFloat)buttonHeight {
    _buttonHeight = buttonHeight;
    [self.horizontalLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.modalView).with.offset(-self.buttonHeight);
    }];
}

- (void)onClickCancelBtn {
    [self show:NO];
    if (self.cancelCallback) {
        _cancelCallback();
    }
}

- (void)onClickConfirmBtn {
    [self show:NO];
    if (self.confirmCallback) {
        _confirmCallback();
    }
}

- (void)onTapModalOutSide {
    [self onClickCancelBtn];
}
/**
 设置取消按钮文字。
 */
- (void)setCanecelBtnTitle:(NSString *)cancelTitle
{
    [_cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = kFont_Bold(18.f);
}

/**
 设置确认按钮文字
 */
- (void)setConfirmBtnTitle:(NSString *)sureTitle
{
    [_confirmBtn setTitle:sureTitle forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = kFont_Medium(18.f);
}
@end
