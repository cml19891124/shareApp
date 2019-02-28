//
//  HPNearbyShareView.m
//  HPShareApp
//
//  Created by HP on 2018/12/7.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPNearbyShareView.h"

@implementation HPNearbyShareView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scanBtn.userInteractionEnabled = NO;
    [scanBtn setBackgroundImage:ImageNamed(@"scan_map") forState:UIControlStateNormal];
    [self addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(56.f), getWidth(57.f)));
        make.right.mas_equalTo(self.mas_right).offset(getWidth(-28.f));
        make.top.mas_equalTo(self.mas_top).offset(17.f);

    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"金嘉味黄金铺位拼租";
    titleLabel.font = [UIFont fontWithName:FONT_BOLD size:14];
    titleLabel.textColor = COLOR_BLACK_333333;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(getHeight(16.f));
        make.width.mas_equalTo(kScreenWidth * 0.7);
        make.height.mas_equalTo(getHeight(14.f));
    }];
    
    UILabel *futureLabel = [UILabel new];
    futureLabel.text = @"期望价格 50/天";
    futureLabel.font = [UIFont fontWithName:FONT_MEDIUM size:10];
    [self addSubview:futureLabel];
    [futureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(16.f));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(getHeight(19.f));
        make.width.mas_equalTo(kScreenWidth * 0.7);
        make.height.mas_equalTo(getHeight(13.f));
    }];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:futureLabel.text];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GREEN_7B929F range:NSMakeRange(0, 4)];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(4, futureLabel.text.length - 4)];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MEDIUM size:10] range:NSMakeRange(0, 4)];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_BOLD size:16] range:NSMakeRange(4, futureLabel.text.length - 6)];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_BOLD size:9] range:NSMakeRange(futureLabel.text.length - 2, 2)];
    futureLabel.attributedText = attr;
    
    UILabel *distanceLabel = [UILabel new];
    distanceLabel.text = @"该拼租空间距您 50m";
    [self addSubview:distanceLabel];
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(futureLabel.mas_bottom).offset(getHeight(10.f));
        make.width.mas_equalTo(kScreenWidth * 0.7);
        make.height.mas_equalTo(getHeight(10.f));
    }];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:distanceLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_GREEN_7B929F range:NSMakeRange(0, 7)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_BLUE_259BFF range:NSMakeRange(7, distanceLabel.text.length - 7)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_MEDIUM size:10] range:NSMakeRange(0, 7)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_BOLD size:11] range:NSMakeRange(7, distanceLabel.text.length - 7)];
    distanceLabel.attributedText = attrStr;
}
@end
