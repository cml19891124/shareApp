//
//  HPQuitOrderView.m
//  HPShareApp
//
//  Created by HP on 2019/3/27.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPQuitOrderView.h"

@implementation HPQuitOrderView

- (void)setupModalView:(UIView *)view
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f));
        make.height.mas_equalTo(getWidth(160.f));
        make.top.mas_equalTo(getWidth(203.f));
        make.centerX.mas_equalTo(self);
    }];
    
    [view addSubview:self.bgView];
    
    [self.bgView addSubview:self.signContentView];
    
    [self.signContentView addSubview:self.textView];
    
    [self.bgView addSubview:self.holderBtn];
    
    [self.bgView addSubview:self.quitBtn];
    
    [self.bgView addSubview:self.line];
    
    [self setUpPredictSubViewsMasonry];
}

- (void)setUpPredictSubViewsMasonry
{
//    CGSize size1 = [self sizeWithString:@"Hello" font:kFont_Medium(14.f) width:getWidth(250.f)];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.signContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(15.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(getWidth(120.f));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.signContentView);
    }];
    
    [self.holderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f)/2);
        make.height.mas_equalTo(getWidth(43.f));
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.left.mas_equalTo(self.bgView);
    }];
    
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(280.f)/2);
        make.height.mas_equalTo(getWidth(43.f));
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
        make.right.mas_equalTo(self.bgView);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.holderBtn.mas_top);
        make.left.width.mas_equalTo(self.bgView);
    }];
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

- (UIView *)signContentView
{
    if (!_signContentView) {
        _signContentView = [UIView new];
        _signContentView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _signContentView;
}

- (HPlaceholdTextView *)signTextView
{
    if (!_signTextView) {
        _signTextView = [[HPlaceholdTextView alloc] init];
        _signTextView.backgroundColor = COLOR_GRAY_FFFFFF;
        _signTextView.textLength = 64;
        _signTextView.interception = YES;
        //        _signTextView.placehLab.text = @"0";
        _signTextView.placehTextColor = COLOR_GRAY_999999;
        _signTextView.placehFont = kFont_Medium(14.f);
        _signTextView.delegate = self;
        _signTextView.placehText = @"  请填写放弃此订单原因";
        _signTextView.promptTextColor = COLOR_GRAY_CCCCCC;
        _signTextView.promptFont = kFont_Medium(12.f);
        _signTextView.promptBackground = COLOR_GRAY_F6F6F6;
        _signTextView.promptFrameMaxY = getWidth(-11.f);
        _signTextView.tintColor = COLOR_RED_FF3C5E;
        _signTextView.delegate = self;
        _signTextView.EditChangedBlock = ^{
            
        };
        
    }
    return _signTextView;
}

- (MyTextView *)textView
{
    if (!_textView) {
        _textView = [MyTextView new];
        _textView.backgroundColor = COLOR_GRAY_FFFFFF;
        _textView.textColor = COLOR_GRAY_666666;
        _textView.placeholderColor = COLOR_GRAY_999999;
        _textView.placeholder = @"  请填写放弃此订单原因";
        _textView.font = kFont_Regular(14.f);
        _textView.tintColor = COLOR_RED_FF1213;
    }
    return _textView;
}

- (UIButton *)holderBtn
{
    if (!_holderBtn) {
        _holderBtn = [UIButton new];
        [_holderBtn setTitle:@"暂不取消" forState:UIControlStateNormal];
        _holderBtn.titleLabel.font = kFont_Regular(14.f);
        _holderBtn.backgroundColor = COLOR_RED_EA0000;
        [_holderBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_holderBtn addTarget:self action:@selector(onClickHolderBtn:) forControlEvents:UIControlEventTouchUpInside];
        _holderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _holderBtn;
}

- (UIButton *)quitBtn
{
    if (!_quitBtn) {
        _quitBtn = [UIButton new];
        [_quitBtn setTitle:@"确认取消" forState:UIControlStateNormal];
        _quitBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        [_quitBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        _quitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _quitBtn.titleLabel.font = kFont_Regular(14.f);

        [_quitBtn addTarget:self action:@selector(onClickQuitBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = COLOR_RED_EA0000;
    }
    return _line;
}

- (void)onClickHolderBtn:(UIButton *)button
{
    if (self.holderBlock) {
        self.holderBlock();
    }
}

- (void)onClickQuitBtn:(UIButton *)button
{
    if (self.quitBlock) {
        self.quitBlock();
    }
}

- (void)onTapModalOutSide
{
    [self show:NO];
}

- (void)setKnownBtnText:(NSString *)knowText
{
    _knowText = knowText;
    
    [self.holderBtn setTitle:knowText forState:UIControlStateNormal];
}

- (void)setOnlineText:(NSString *)onlineText
{
    _onlineText = onlineText;
    
    [self.quitBtn setTitle:onlineText forState:UIControlStateNormal];
}

/**
 *  自适应字体
 */
-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font     width:(float)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width,   80000) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

/*
 代理方法里边随着你输入的文字进行修改代码如下：
 */
-(void)textViewDidChange:(UITextView *)textView{
    //获取文本中字体的size
    CGSize size = [self sizeWithString:textView.text font:kFont_Medium(14.f) width:getWidth(250.f)];
    HPLog(@"height = %f",size.height);
    //获取一行的高度
    CGSize size1 = [self sizeWithString:@"Hello" font:kFont_Medium(14.f) width:getWidth(250.f)];
    NSInteger i = size.height/size1.height;
    if (i==1) {
        //设置全局的变量存储数字如果换行就改变这个全局变量
        self.number = i;
    }
    if (self.number!=i) {
        self.number = i;
        HPLog(@"selfnum = %ld",self.number);
        [self.reasonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([text isEqualToString:@"\n"]) //获取键盘中发送事件（回车事件
        
      {
            
      [textView resignFirstResponder];//处理键盘的发送事件
            
      }
    
     return YES;
    
}

@end
