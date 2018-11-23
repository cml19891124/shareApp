//
//  HPBaseModalView.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
#import "UIViewController+Helper.h"

@interface HPBaseModalView () <UIGestureRecognizerDelegate>

/**
 弹出框视图
 */
@property (nonatomic, weak) UIView *modalView;

@end

@implementation HPBaseModalView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        UIView *currentVCView = [UIViewController getCurrentVC].view;
        [currentVCView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(currentVCView);
        }];
        
        [self setupUI];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGest];
        [tapGest setDelegate:self];
        
        [self layoutIfNeeded];
    }
    return self;
}

- (instancetype)initWithParent:(UIView *)parent {
    self = [self init];
    if (self) {
        [self removeFromSuperview];
        [parent addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parent);
        }];
        
        [self layoutIfNeeded];
    }
    return self;
}

- (void)setupUI {
    [self setBackgroundColor:COLOR_BLACK_TRANS_1111119b];
    UIView *modalView = [[UIView alloc] init];
    [self addSubview:modalView];
    self.modalView = modalView;
    [self setupModalView:modalView];
    [self setHidden:YES];
}

- (void)setupModalView:(UIView *)view {}

- (void)appearAnimationOfModalView:(UIView *)view {}

- (double)disappearAnimationOfModalView:(UIView *)view {
    return 0.0;
}

- (void)show:(BOOL)isShow {
    if (isShow) {
        [self setHidden:NO];
        [self appearAnimationOfModalView:_modalView];
    }
    else {
        double delay = [self disappearAnimationOfModalView:_modalView];
        if (delay > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setHidden:YES];
            });
        }
        else {
            [self setHidden:YES];
        }
    }
}

- (void)onTap:(UITapGestureRecognizer *)gest {
    if (!CGRectContainsPoint(self.modalView.frame, [gest locationInView:self])) {
        [self onTapModalOutSide];
    }
}

- (void)onTapModalOutSide {}

# pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (CGRectContainsPoint(self.modalView.frame, [touch locationInView:self])) {
        return NO;
    }
    
    return YES;
}

@end
