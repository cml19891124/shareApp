//
//  HPTagDialogView.m
//  HPShareApp
//
//  Created by HP on 2018/11/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTagDialogView.h"
#import "HPImageUtil.h"
#import "HPProgressHUD.h"

@interface HPTagDialogView () <UITextFieldDelegate>

@property (nonatomic, weak) UIView *modalView;

@property (nonatomic, weak) UIView *customTagView;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSMutableArray *checkBtns;

@property (nonatomic, weak) UIButton *firstChectBtn;

@property (nonatomic, strong) MASConstraint *topConstraint;


@end

@implementation HPTagDialogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithItems:(NSArray *)items {
    _items = items;
    _checkItems = [[NSMutableArray alloc] init];
    _checkBtns = [[NSMutableArray alloc] init];
    self = [self init];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupModalView:(UIView *)view {
    [super setupModalView:view];
    _modalView = view;
}

- (void)setupCustomView:(UIView *)view {
    UIButton *customBtn = [[UIButton alloc] init];
    [customBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
    [customBtn setTitleColor:COLOR_GRAY_DDDDDD forState:UIControlStateNormal];
    [customBtn setImage:[UIImage imageNamed:@"customizing_business_cards_custom_tags_add_to"] forState:UIControlStateNormal];
    [customBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [customBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 29.f * g_rateWidth, 0.f, -29.f * g_rateWidth)];
    [customBtn setTitle:@"自定义标签" forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(onClickCustomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:customBtn];
    [customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(33.f * g_rateWidth);
        make.top.equalTo(view).with.offset(21.f * g_rateWidth);
        make.width.mas_equalTo(view.mas_width);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [view addSubview:scrollView];
    _scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customBtn.mas_bottom).with.offset(20.f * g_rateWidth);
        make.left.equalTo(customBtn);
        make.right.and.bottom.equalTo(view);
    }];
    
    for (int i = 0; i < _items.count; i ++) {
        NSString *title = _items[i];
        UIImage *rectangle = [HPImageUtil getRectangleByStrokeColor:COLOR_BLACK_666666 fillColor:UIColor.whiteColor borderWidth:2.f cornerRadius:3.f inRect:CGRectMake(0.f, 0.f, 17.f, 17.f)];
        
        UIButton *checkBtn = [[UIButton alloc] init];
        [checkBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
        [checkBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [checkBtn setTitle:title forState:UIControlStateNormal];
        [checkBtn setImage:rectangle forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"customizing_business_cards_selected_ label"] forState:UIControlStateSelected];
        [checkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 26.f * g_rateWidth, 0.f, -26.f * g_rateWidth)];
        [checkBtn addTarget:self action:@selector(onClickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:checkBtn];
        [_checkBtns addObject:checkBtn];
        
        if (i == 0) {
            _firstChectBtn = checkBtn;
        }
        
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(scrollView);
            make.width.mas_equalTo(268.f * g_rateWidth);
            make.height.mas_equalTo(17.f);
            
            if (i == 0) {
                self.topConstraint = make.top.equalTo(scrollView);
            }
            else {
                UIButton *lastBtn = self.checkBtns[i - 1];
                make.top.equalTo(lastBtn.mas_bottom).with.offset(25.f * g_rateWidth);
            }
            
            if (i == self.items.count - 1) {
                make.bottom.equalTo(scrollView).with.offset(-14.f * g_rateWidth);
            }
        }];
    }
}

- (UIButton *)addCheckBtnWithTitle:(NSString *)title {
    UIImage *rectangle = [HPImageUtil getRectangleByStrokeColor:COLOR_BLACK_666666 fillColor:UIColor.whiteColor borderWidth:2.f cornerRadius:3.f inRect:CGRectMake(0.f, 0.f, 17.f, 17.f)];
    
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
    [checkBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [checkBtn setTitle:title forState:UIControlStateNormal];
    [checkBtn setImage:rectangle forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"customizing_business_cards_selected_ label"] forState:UIControlStateSelected];
    [checkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 26.f * g_rateWidth, 0.f, -26.f * g_rateWidth)];
    [checkBtn addTarget:self action:@selector(onClickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:checkBtn];
    [_checkBtns addObject:checkBtn];
    
    [_firstChectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        [self.topConstraint uninstall];
    }];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        self.topConstraint = make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.bottom.equalTo(self.firstChectBtn.mas_top).with.offset(-25.f * g_rateWidth);
        make.width.mas_equalTo(268.f * g_rateWidth);
        make.height.mas_equalTo(17.f);
    }];
    
    _firstChectBtn = checkBtn;
    return checkBtn;
}

#pragma mark - OnClick

- (void)onClickCustomBtn:(UIButton *)btn {
    if (_customTagView == nil) {
        UIView *view = [[UIView alloc] init];
        [view.layer setCornerRadius:8.f];
        [view setBackgroundColor:UIColor.whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(self.modalView);
            make.size.mas_equalTo(CGSizeMake(300.f * g_rateWidth, 125.f * g_rateWidth));
        }];
        
        UILabel *countLabel = [[UILabel alloc] init];
        [countLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
        [countLabel setTextColor:COLOR_GRAY_CCCCCC];
        [countLabel setText:@"0/5"];
        [view addSubview:countLabel];
        _countLabel = countLabel;
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).with.offset(-39.f * g_rateWidth);
            make.top.equalTo(view).with.offset(26.f * g_rateWidth);
            make.height.mas_equalTo(countLabel.font.pointSize);
            make.width.mas_equalTo(35.f);
        }];
        
        UITextField *textField = [[UITextField alloc] init];
        [textField setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
        [textField setTextColor:COLOR_BLACK_333333];
        [textField setTintColor:COLOR_RED_FF3C5E];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setDelegate:self];
        [view addSubview:textField];
        _textField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(25.f * g_rateWidth);
            make.centerY.equalTo(countLabel);
            make.right.equalTo(countLabel.mas_left).with.offset(-10.f);
        }];
        
        UIView *lineV = [UIView new];
        lineV.backgroundColor = COLOR_GRAY_BBBBBB;
        [view addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.mas_equalTo(textField.mas_bottom).offset(getWidth(10.f));
            make.height.mas_equalTo(0.5);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
        UIButton *confirmBtn = [[UIButton alloc] init];
        [confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
        [confirmBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
        [confirmBtn setTitle:@"好" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(onClickOKBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).with.offset(-44.f * g_rateWidth);
            make.bottom.equalTo(view).with.offset(-20.f * g_rateWidth);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
        [cancelBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(onClickHideBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(confirmBtn.mas_left).with.offset(-40.f * g_rateWidth);
            make.centerY.equalTo(confirmBtn);
        }];
        
        _customTagView = view;
    }
    
    [_textField setText:@""];
    [_countLabel setText:@"0/5"];
    [_modalView setHidden:YES];
    [_customTagView setHidden:NO];
    [_textField becomeFirstResponder];
}

- (void)onClickHideBtn {
    [_customTagView endEditing:YES];
    [_customTagView setHidden:YES];
    [_modalView setHidden:NO];
}

- (void)onClickOKBtn {
    [_customTagView endEditing:YES];
    [_customTagView setHidden:YES];
    [_modalView setHidden:NO];
    NSString *title = _textField.text;
    
    [self addCheckBtnWithTitle:title];
}

- (void)onClickCheckBtn:(UIButton *)btn {
    if (btn.isSelected) {
        [btn setSelected:NO];
        [_checkItems removeObject:btn.titleLabel.text];
    }
    else {
        if (_checkItems.count < _maxCheckNum) {
            [btn setSelected:YES];
            [_checkItems addObject:btn.titleLabel.text];
        }
        else {
            [HPProgressHUD alertMessage:[NSString stringWithFormat:@"最多选择 %ld 个", (long)_maxCheckNum]];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField endEditing:YES];
    
    return YES;
}

#pragma mark - NSNotification

- (void)didTextFieldChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    
    // text field 的内容
    NSString *contentText = textField.text;
    
    // 获取高亮内容的范围
    UITextRange *selectedRange = [textField markedTextRange];
    // 这行代码 可以认为是 获取高亮内容的长度
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    // 没有高亮内容时,对已输入的文字进行操作
    if (markedTextLength == 0) {
        // 如果 text field 的内容长度大于我们限制的内容长度
        if (contentText.length > 5) {
            // 截取从前面开始maxLength长度的字符串
            //            textField.text = [contentText substringToIndex:maxLength];
            // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
            NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 5)];
            textField.text = [contentText substringWithRange:rangeRange];
        }
    }
    
    [_countLabel setText:[NSString stringWithFormat:@"%u/5", _textField.text.length - markedTextLength]];
}

#pragma mark - Select

- (void)selectItems:(NSArray *)items {
    if (!items || ![items isKindOfClass:NSArray.class]) {
        return;
    }
    
    for (NSString *item in items) {
        [_checkItems addObject:item];
        BOOL isFound = NO;
        
        for (UIButton *checkBtn in _checkBtns) {
            if ([item isEqualToString:checkBtn.titleLabel.text]) {
                [checkBtn setSelected:YES];
                isFound = YES;
                break;
            }
        }
        
        if (!isFound) {
            UIButton *newCheckBtn = [self addCheckBtnWithTitle:item];
            [newCheckBtn setSelected:YES];
        }
    }
}

@end
