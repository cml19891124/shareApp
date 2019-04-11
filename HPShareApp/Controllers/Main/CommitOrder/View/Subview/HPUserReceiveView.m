//
//  HPUserReceiveView.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/3.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUserReceiveView.h"

@implementation HPUserReceiveView

- (void)setupModalView:(UIView *)view
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f));
        make.height.mas_equalTo(getWidth(160.f));
        make.center.mas_equalTo(self);
    }];
    
    [view addSubview:self.bgView];
    
    [self.bgView addSubview:self.confirmLabel];
    
    [self.bgView addSubview:self.lineView];
    
    [self.bgView addSubview:self.noBtn];
    
    [self.bgView addSubview:self.okbtn];
    
    [self.bgView addSubview:self.lineView];
    
    [self setUpReceiveSubViewsMasonry];
    
}

- (void)setUpReceiveSubViewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    CGFloat conW = BoundWithSize(@"确认收货后商家即可到账", kScreenWidth, 16).size.width;
    [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(30.f));
        make.width.mas_equalTo(conW);
        make.centerX.mas_equalTo(self.bgView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.okbtn.mas_top);
    }];
    
    [self.noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.bgView);
        make.width.mas_equalTo(getWidth(140));
        make.height.mas_equalTo(getWidth(43.f));
    }];
    
    [self.okbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.bgView);
        make.width.mas_equalTo(getWidth(140));
        make.height.mas_equalTo(getWidth(43.f));
    }];
}

- (UILabel *)confirmLabel
{
    if (!_confirmLabel) {
        _confirmLabel = [UILabel new];
        _confirmLabel.text = @"确认收货后商家即可到账\n    请确保拼租完成!";

        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:_confirmLabel.text];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_666666 range:NSMakeRange(0, _confirmLabel.text.length)];
        [attributeStr addAttribute:NSFontAttributeName value:kFont_Medium(16.f) range:NSMakeRange(0, _confirmLabel.text.length)];
        //设置行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;;
        [paragraphStyle setLineSpacing:24.f];
        _confirmLabel.attributedText = attributeStr;
        _confirmLabel.numberOfLines = 0;
        [_confirmLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _confirmLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_RED_FF1213;
    }
    return _lineView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_GRAY_FFFFFF;
        _bgView.layer.cornerRadius = 4.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)noBtn
{
    if (!_noBtn) {
        _noBtn = [UIButton new];
        [_noBtn setTitle:@"再想一想" forState:UIControlStateNormal];
        _noBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        [_noBtn setTitleColor:COLOR_RED_FF1213 forState:UIControlStateNormal];
        _noBtn.titleLabel.font = kFont_Regular(16.f);
        [_noBtn addTarget:self action:@selector(onClickNoBtn:) forControlEvents:UIControlEventTouchUpInside];
        _noBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _noBtn;
}

- (UIButton *)okbtn
{
    if (!_okbtn) {
        _okbtn = [UIButton new];
        [_okbtn setTitle:@"确认收货" forState:UIControlStateNormal];
        _okbtn.backgroundColor = COLOR_RED_FF1213;
        [_okbtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _okbtn.titleLabel.font = kFont_Regular(16.f);
        _okbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_okbtn addTarget:self action:@selector(onClickOkBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okbtn;
}

- (void)onClickNoBtn:(UIButton *)button
{
    if (self.noBlock) {
        self.noBlock();
    }
    [self show:NO];
}

- (void)onClickOkBtn:(UIButton *)button
{
    if (self.okBlock) {
        self.okBlock();
    }
}

- (void)onTapModalOutSide
{
    [self show:NO];
}
@end
