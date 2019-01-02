//
//  HPJudgingLoginView.m
//  HPShareApp
//
//  Created by HP on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPJudgingLoginView.h"

@implementation HPJudgingLoginView

//- (void)setupModalView:(UIView *)view {
//    [self setBackgroundColor:[UIColor.blackColor colorWithAlphaComponent:0.6f]];
//
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
//
//    [self setUpBgView];
//}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapModalOutSide:)];
        [self addGestureRecognizer:tap];
        [self setUpBgView];
    }
    return self;
}
- (void)setUpBgView
{
    [self addSubview:self.bgview];
    [self addSubview:self.quitReleaseLabel];
    [self addSubview:self.sureBtn];
    [self addSubview:self.lineView];
    [self setUpSubviewsLayout];

}

- (void)onClickConfirmBtn {
    [self show:NO];
    if (self.confirmCallback) {
        _confirmCallback();
    }
}

- (void)onTapModalOutSide:(UITapGestureRecognizer *)tap {
    if (self.viewTapClickCallback) {
        self.viewTapClickCallback();
    }
    [self show:YES];
}
#pragma mark - 背景视图
- (UIView *)bgview
{
    if (!_bgview) {
        UIView *bgview = [UIView new];
        bgview.backgroundColor = COLOR_GRAY_FFFFFF;
        bgview.layer.cornerRadius = 5.f;
        bgview.clipsToBounds = YES;
        _bgview = bgview;
        
    }
    return _bgview;
}

- (UILabel *)quitReleaseLabel
{
    if (!_quitReleaseLabel) {
        _quitReleaseLabel = [UILabel new];
        _quitReleaseLabel.font = kFont_Bold(16.f);
        _quitReleaseLabel.textColor = COLOR_BLACK_444444;
        _quitReleaseLabel.text = @"您还没有登录哦";
        _quitReleaseLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _quitReleaseLabel;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        _sureBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _sureBtn.layer.cornerRadius = 5.f;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitle:@"前往登录" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _sureBtn.titleLabel.font = kFont_Bold(16.f);
        [_sureBtn addTarget:self action:@selector(onClickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_GRAY_CCCCCC;
        
    }
    return _lineView;
}

- (void)setUpSubviewsLayout
{
    
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(229.f), getWidth(93.f)));
        make.center.mas_equalTo(self);
    }];
    
//    CGSize size = [_quitReleaseLabel sizeThatFits:CGSizeMake(getWidth(229.f), MAXFLOAT)];
//    if (size.height > 30.f) {
//        [_quitReleaseLabel setTextAlignment:NSTextAlignmentLeft];
//    }
//    else {
//        [_quitReleaseLabel setTextAlignment:NSTextAlignmentCenter];
//    }
//    size.height += 40.f;
    [_quitReleaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.bgview);
        make.height.mas_equalTo(getWidth(46.f));
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.bgview);
        make.height.mas_equalTo(getWidth(46.f));
        make.bottom.mas_equalTo(self.bgview.mas_bottom);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.sureBtn);
        make.bottom.mas_equalTo(self.sureBtn.mas_top);
        make.height.mas_equalTo(0.5);
    }];
}
@end
