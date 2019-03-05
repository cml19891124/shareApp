//
//  HPUpdateVersionView.m
//  HPShareApp
//
//  Created by HP on 2019/2/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUpdateVersionView.h"
#import "HPGradientUtil.h"

@implementation HPUpdateVersionView

//默认情况下，UitextView显示,文字不是从开头显示的，我们希望看到的是，进入第一眼看到的是第一行文字，滚动条应该在顶部,加上如下代码
- (void)layoutMarginsDidChange
{
    [super layoutMarginsDidChange];
    [self.desLabel setContentOffset:CGPointZero animated:NO];

}

- (void)setupModalView:(UIView *)view
{
    [self setBackgroundColor:[UIColor.blackColor colorWithAlphaComponent:0.7f]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kAppleId]];
    NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [file dataUsingEncoding:NSUTF8StringEncoding];
    // 判断是否取到信息
    if (![data isKindOfClass:[NSData class]]) {
        return ;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //获得上线版本号
    NSString *version = [[[dic objectForKey:@"results"]firstObject]objectForKey:@"version"];
    NSString *updateInfo = [[[dic objectForKey:@"results"]firstObject]objectForKey:@"releaseNotes"];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [view addSubview:self.bgView];
    
    [view addSubview:self.bgImageView];
    
    [self.bgView addSubview:self.titleLabel];
    
    [view addSubview:self.versionLabel];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",version];
    
    [view addSubview:self.desLabel];
    
    if (updateInfo.length == 0 || !updateInfo) {
        self.desLabel.text = @"新版本将具有全新的特性，华丽的界面～";
    }else{
        self.desLabel.text = updateInfo;
    }
    
    [view addSubview:self.updateBtn];
    
    [view addSubview:self.whiteLine];
    
    [view addSubview:self.deleteBtn];
    
    [self setConfig];
    
    [self setUpSubviewsMasonry];
}

- (void)setConfig
{
    CGSize btnSize = CGSizeMake(183.f, 33.f);
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(btnSize.width, 0.f) endPoint:CGPointMake(0.f, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR_RED_FA532E endColor:COLOR_RED_EC8249];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.updateBtn.layer setCornerRadius:16.f];
    [self.updateBtn.layer setMasksToBounds:YES];
    [self.updateBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:10.f]];
    [self.updateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.updateBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self.updateBtn addTarget:self action:@selector(onClickUpdateVersion:) forControlEvents:UIControlEventTouchUpInside];
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(183.f, 33.f));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(getWidth(-10.f));
        make.centerX.mas_equalTo(self.bgImageView);
    }];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_GRAY_FFFFFF;
        _bgView.layer.cornerRadius = 5.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = ImageNamed(@"gengxin_beijing");
    }
    return _bgImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"发现新版本";
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.font = kFont_Bold(14.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        //高度自适应，前提不设置宽度，高度自适应
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _titleLabel.numberOfLines = 0;
        //宽度自适应
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UITextView *)desLabel{
    if (!_desLabel) {
        _desLabel = [UITextView new];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.textColor = COLOR_GRAY_999999;
        _desLabel.font = kFont_Medium(12.f);
        _desLabel.userInteractionEnabled = NO;
        _desLabel.showsVerticalScrollIndicator = NO;
        _desLabel.showsHorizontalScrollIndicator = NO;
    }
    return _desLabel;
}

- (UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [UILabel new];
        _versionLabel.backgroundColor = COLOR_RED_F36B3B;
        _versionLabel.layer.cornerRadius = 3.f;
        _versionLabel.font = kFont_Medium(10.f);
        _versionLabel.layer.masksToBounds = YES;
        _versionLabel.textColor = COLOR_GRAY_FFFFFF;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        [_versionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _versionLabel;
}

- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton new];
    }
    return _updateBtn;
}

- (UIView *)whiteLine{
    if (!_whiteLine) {
        _whiteLine = [UIView new];
        _whiteLine.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _whiteLine;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setBackgroundImage:ImageNamed(@"gengxin_guanbi") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(closeUpdateVeiw:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)setUpSubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(257.f), getWidth(312.f)));
        make.top.mas_equalTo(getWidth(173.f));
        make.centerX.mas_equalTo(self);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(getWidth(195.f), getWidth(154.f)));
        make.top.mas_equalTo(self.bgView).offset(getWidth(8.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(getWidth(143.f));
        make.left.right.mas_equalTo(self.bgImageView);
        make.height.mas_equalTo(getWidth(14.f));
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(getWidth(2.f));
        make.height.mas_equalTo(getWidth(13.f));
        make.centerX.mas_equalTo(self.bgImageView);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.versionLabel.mas_bottom).offset(getWidth(10.f));
        make.left.mas_equalTo(self.bgView).offset(getWidth(22.f));
        make.right.mas_equalTo(self.bgView).offset(getWidth(-22.f));
        make.bottom.mas_equalTo(self.updateBtn.mas_top).offset(getWidth(-10.f));
    }];
    
    [self.whiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom);
        make.width.mas_equalTo(getWidth(1.f));
        make.height.mas_equalTo(getWidth(47.f));
        make.centerX.mas_equalTo(self.bgImageView);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(23.f), getWidth(23.f)));
        make.centerX.mas_equalTo(self.bgImageView);
        make.top.mas_equalTo(self.whiteLine.mas_bottom);
    }];
}

- (void)onClickUpdateVersion:(UIButton *)button
{
    if (self.updateBlock) {
        self.updateBlock();
    }
}

- (void)closeUpdateVeiw:(UIButton *)button
{
    if (self.closeBlcok) {
        self.closeBlcok();
    }
}

//- (void)show:(BOOL)isShow
//{
//    if ([self.delegate respondsToSelector:@selector(setUpdateView)]) {
//        [self.delegate setUpdateView];
//    }
//}
@end
