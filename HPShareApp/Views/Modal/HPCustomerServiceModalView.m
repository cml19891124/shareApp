//
//  HPCustomerServiceModalView CustomerService.m
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCustomerServiceModalView.h"

#define TEL @"0755-86713128"

@implementation HPCustomerServiceModalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupModalView:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).with.offset(-20.f * g_rateWidth);
    }];
    
    UIView *callView = [[UIView alloc] init];
    [callView.layer setCornerRadius:5.f];
    [callView.layer setMasksToBounds:YES];
    [callView setBackgroundColor:UIColor.whiteColor];
    [view addSubview:callView];
    [callView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.width.equalTo(view);
        if ([self.phone isEqualToString:TEL]) {
            make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 90.f));
        }else{
            make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 45.f));
        }
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_CCCCCC];
    if ([self.phone isEqualToString:TEL]) {
        line.hidden = NO;
    }else{
        line.hidden = YES;
    }
    [callView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(callView);
        make.centerY.equalTo(callView);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView *descView = [[UIView alloc] init];
    [callView addSubview:descView];
    [descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(callView);
        make.bottom.equalTo(line.mas_top);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [descLabel setTextColor:COLOR_GRAY_CCCCCC];
    [descLabel setText:@"周一至周日 9:00-20:00"];
    if ([_phone isEqualToString:TEL]) {
        descLabel.hidden = NO;
    }else{
        descLabel.hidden = YES;
    }
    [descView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(descView);
    }];
    
    UIButton *callBtn = [[UIButton alloc] init];
    [callBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:18.f]];
    [callBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [callBtn setTitle:[NSString stringWithFormat:@"呼叫 %@", TEL] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(onClickCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    [callView addSubview:callBtn];
    _callBtn = callBtn;
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(callView);
        if ([self.phone isEqualToString:TEL]) {
            make.top.equalTo(line);
        }else{
            make.top.equalTo(callView);
        }
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn.layer setCornerRadius:5.f];
    [cancelBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:17.f]];
    [cancelBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:UIColor.whiteColor];
    [cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(view);
        make.top.equalTo(callView.mas_bottom).with.offset(10.f);
        make.height.mas_equalTo(45.f);
    }];
}

- (void)onClickCallBtn:(UIButton *)btn {
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@", self.phone];
    
    NSURL *aURL = [NSURL URLWithString: telNumber];
    
    if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
        [[UIApplication sharedApplication] openURL:aURL];
    }
    
}

- (void)onClickCancelBtn:(UIButton *)btn {
    [self show:NO];
}

- (void)setPhoneString:(NSString *)phone
{
    [_callBtn setTitle:phone forState:UIControlStateNormal];
}
@end
