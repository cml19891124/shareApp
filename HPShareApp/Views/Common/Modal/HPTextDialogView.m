//
//  HPTextDialogView.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTextDialogView.h"

@interface HPTextDialogView ()

/**
 提示语label
 */
@property (nonatomic, weak) UILabel *textLabel;

@property (nonatomic, weak) UIView *customView;

@property (nonatomic, weak) UIView *modalView;

@end

@implementation HPTextDialogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupModalView:(UIView *)view {
    _modalView = view;
    [super setupModalView:view];
}

- (void)setupCustomView:(UIView *)view {
    _customView = view;
    UILabel *textLabel = [[UILabel alloc] init];
    [textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [textLabel setTextColor:COLOR_BLACK_444444];
    [textLabel setNumberOfLines:0];
    [view addSubview:textLabel];
    self.textLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(view);
        make.width.mas_equalTo(190.f);
    }];
    
    [self setCanecelBtnTitleColor:COLOR_PINK_FF1F5E];
    [self setConfirmBtnTitleColor:COLOR_BLACK_444444];
    
    [_modalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.width.mas_equalTo(210.f);
    }];
}

- (void)setText:(NSString *)text {
    [_textLabel setText:text];
    CGSize size = [_textLabel sizeThatFits:CGSizeMake(190.f, MAXFLOAT)];
    if (size.height > 30.f) {
        [_textLabel setTextAlignment:NSTextAlignmentLeft];
    }
    else {
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    size.height += 40.f;
    [_customView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}

@end
