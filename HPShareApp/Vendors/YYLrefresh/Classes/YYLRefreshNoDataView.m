//
//  RCRefreshNoDataView.m
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import "YYLRefreshNoDataView.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
@implementation YYLRefreshNoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tipImageView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipBtn];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tipImageView.frame = CGRectMake((self.bounds.size.width - getWidth(229.f))/2, getWidth(162.f),getWidth(229.f), getWidth(266.f));
    self.tipLabel.frame = CGRectMake(0, self.tipImageView.frame.origin.y + getWidth(208.f), self.frame.size.width, getWidth(12.f));

    self.tipBtn.frame = CGRectMake((self.bounds.size.width - getWidth(103.f))/2, self.tipImageView.frame.origin.y + getWidth(268.f), getWidth(103.f), getWidth(29.f));
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        
        _tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RefreshTableView.bundle/refreshtableview_defaultnodata" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil]];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.text = @"暂无数据";
        _tipLabel.font = kFont_Medium(12.f);
        _tipLabel.textColor = COLOR_GRAY_999999;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [UIColor clearColor];
    }
    return _tipLabel;
}

- (UIButton *)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_tipBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
        _tipBtn.titleLabel.font = kFont_Medium(14.f);
        [_tipBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _tipBtn.backgroundColor = COLOR_RED_FF3C5E;
        _tipBtn.layer.cornerRadius = 6.f;
        _tipBtn.layer.masksToBounds = YES;
        [_tipBtn addTarget:self action:@selector(checkForRequirements:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}
- (void)checkForRequirements:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickToCheckSTHForRequirments)]) {
        [self.delegate clickToCheckSTHForRequirments];
    }
}
@end
