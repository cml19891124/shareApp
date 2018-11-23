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

@end

@implementation HPTextDialogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupCustomView:(UIView *)view {
    UILabel *textLabel = [[UILabel alloc] init];
    [textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [textLabel setTextColor:COLOR_BLACK_444444];
    [view addSubview:textLabel];
    self.textLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(view);
    }];
    
    [self setModalTop:258.f * g_rateHeight];
    [self setModalSize:CGSizeMake(210.f * g_rateWidth, 110.f * g_rateWidth)];
    [self setCanecelBtnTitleColor:COLOR_PINK_FF1F5E];
    [self setConfirmBtnTitleColor:COLOR_BLACK_444444];
}

- (void)setText:(NSString *)text {
    [_textLabel setText:text];
}

@end
