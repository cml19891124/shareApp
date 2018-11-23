//
//  HPBaseTextInputController.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTextInputController.h"

@interface HPBaseTextInputController ()

@end

@implementation HPBaseTextInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self setReturnWayToAllTextInputAtView:self.view];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/**
 为视图中所有的输入域设置键盘收起方式。

 @param view 需要设置其中输入域的视图 View
 */
- (void)setReturnWayToAllTextInputAtView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:UITextField.class]) {
            [self setInputAccessoryViewOfEditingView:subview];
            [self setReturnKeyDoneOfEditingView:subview];
        }
        else if ([subview isKindOfClass:UITextView.class]) {
            [self setReturnKeyDoneOfEditingView:subview];
        }
        
        [self setReturnWayToAllTextInputAtView:subview];
    }
    
    return;
}

/**
 为输入域添加收起按钮。

 @param view 需要设置的输入域
 */
- (void)setInputAccessoryViewOfEditingView:(UIView *)view {
    UIView *toolbar = [[UIView alloc] init];
    [toolbar setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 30.f)];
    [toolbar setBackgroundColor:[UIColor colorWithRGBArray:@[@209.f, @212.f, @215.f]]];
    
    UIButton *doneBtn = [[UIButton alloc] init];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [doneBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(onClickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.equalTo(toolbar);
        make.width.mas_equalTo(100.f);
    }];
    
    if ([view isKindOfClass:UITextField.class]) {
        UITextField *textField = (UITextField *)view;
        if (textField.keyboardType == UIKeyboardTypeNumberPad || textField.keyboardType == UIKeyboardTypeDecimalPad) {
            [textField setInputAccessoryView:toolbar];
        }
    }
    else if ([view isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView *)view;
        [textView setInputAccessoryView:toolbar];
    }
}

/**
 为输入域设置点击确认按钮收起键盘

 @param view 需要设置的输入域
 */
- (void)setReturnKeyDoneOfEditingView:(UIView *)view {
    if ([view isKindOfClass:UITextField.class]) {
        UITextField *textField = (UITextField *)view;
        if (textField.keyboardType != UIKeyboardTypeNumberPad && textField.keyboardType != UIKeyboardTypeDecimalPad) {
            [textField setReturnKeyType:UIReturnKeyDone];
            if (textField.delegate == nil) {
                [textField setDelegate:self];
            }
        }
    }
    else if ([view isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView *)view;
        [textView setReturnKeyType:UIReturnKeyDone];
        if (textView.delegate == nil) {
            [textView setDelegate:self];
        }
    }
}

/**
 点击确认按钮回调。
 */
- (void)onClickDoneBtn {
    [self.view endEditing:YES];
}

/**
 获取视图中正在输入的输入域 View

 @param view 需要获取输入域的视图
 @return 正在输入的输入域
 */
- (UIView *)getEditingTextInputAtView:(UIView *)view {
    if (view.subviews.count == 0) {
        return nil;
    }
    
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:UITextField.class]) {
            UITextField *textField = (UITextField *)subview;
            if (textField.isEditing) {
                return textField;
            }
        }
        else if ([subview isKindOfClass:UITextView.class]) {
            UITextView *textView = (UITextView *)subview;
            if (textView.isFirstResponder) {
                return textView;
            }
        }
        
        UIView *view = [self getEditingTextInputAtView:subview];
        if (view != nil) {
            return view;
        }
    }
    
    return nil;
}

/**
 获取视图相对 self.view 的 frame

 @param v 需要确定 frame 的视图
 @return 视图相对 self.view 的 frame
 */
- (CGRect)relativeFrameForScreenWithView:(UIView *)v {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIView *view = v;
    CGFloat x = 0.f;
    CGFloat y = 0.f;
    
    while (view.frame.size.height != screenHeight) {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}

/**
 将 scrollView 中的输入域滚动至完全可见的位置。

 @param view 输入域视图
 @param cursorY 输入域视图相对 self.view 的纵轴坐标。
 */
- (void)scrollToVisibleOfView:(UIView *)view atCursorY:(CGFloat)cursorY {
    while (![view isMemberOfClass:UIScrollView.class]) {
        view = view.superview;
    }
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIScrollView *scrollView = (UIScrollView *) view;
    CGFloat deltaY = cursorY - screenHeight + 10.f;
    CGPoint offset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + deltaY);
    [scrollView setContentOffset:offset  animated:NO];
}

#pragma mark - NSNotification

- (void)onKeyboardWillShow:(NSNotification *)notification{
    CGFloat cursorY = 0.f;
    UIView *editingView = [self getEditingTextInputAtView:self.view];
    if (editingView) {
        CGRect rect = [self relativeFrameForScreenWithView:editingView];
        cursorY = CGRectGetMaxY(rect);
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        if (cursorY > screenHeight) {
            [self scrollToVisibleOfView:editingView atCursorY:cursorY];
            cursorY = screenHeight - 10.f;
        }
    }
    
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardY = [value CGRectValue].origin.y;
    CGFloat deltaY = cursorY - keyboardY;
    
    if(deltaY > 0){
        deltaY += 10;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0.f, -deltaY);
        }];
    }
}

- (void)onKeyboardWillHide{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0.f, 0.f);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end

