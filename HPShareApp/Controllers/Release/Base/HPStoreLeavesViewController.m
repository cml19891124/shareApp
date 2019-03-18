//
//  HPStoreLeavesViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/24.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPStoreLeavesViewController.h"
#import "HPlaceholdTextView.h"

@interface HPStoreLeavesViewController ()
@property (nonatomic, strong) UILabel *leavesLabel;
@property (nonatomic, strong) UIView *navTilteView;

@property (nonatomic, strong) UIView *leavesView;

@property (nonatomic, strong) HPlaceholdTextView *leavesPlaceView;

/**
 清空按钮
 */
@property (nonatomic, strong) UIButton *placehButton;


/**
 留言类型选项view
 */
@property (nonatomic, strong) UIView *leavesItemView;

@property (nonatomic, strong) UIView *bottomContainerView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *sureBtn;

/**
 选中的留言类型 记录按钮
 */
@property (nonatomic, strong) UIButton *selectedBtn;
/**
 选中的留言类型
 */
@property (nonatomic, strong) UIButton *currentLeavesBtn;

@property (nonatomic, strong) NSMutableArray *leavesArray;
@end

@implementation HPStoreLeavesViewController
- (void)onClickBackBtn
{
    if ([self.delegate respondsToSelector:@selector(backVcIn:andLeaves:)]) {
        [self.delegate backVcIn:self andLeaves:self.leavesPlaceView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leavesArray = [NSMutableArray array];

    UIView *navTilteView = [self setupNavigationBarWithTitle:@"完善店铺拼租信息"];

    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    [self.view addSubview:self.leavesLabel];
    [self.leavesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(navTilteView.mas_bottom).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.leavesLabel.font.pointSize);
    }];
    
    [self setUpLeavesSubViews];
    [self setUpLeavesSubviewsFrame];
}

- (UIView *)bottomContainerView
{
    if (!_bottomContainerView) {
        _bottomContainerView = [UIView new];
        _bottomContainerView.backgroundColor = COLOR_GRAY_F6F6F6;
    }
    return _bottomContainerView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _bottomView;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn.layer setCornerRadius:7.f];
        [_sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:COLOR_RED_EA0000];
        [_sureBtn.titleLabel setFont:kFont_Bold(16.f)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_sureBtn addTarget:self action:@selector(onClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)setUpLeavesSubViews
{
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.bottomContainerView];
    [self.bottomContainerView addSubview:self.bottomView];
    [self.bottomView addSubview:self.sureBtn];
    [self.view addSubview:self.leavesView];
    [self.leavesView addSubview:self.leavesPlaceView];
    [self.leavesView addSubview:self.placehButton];
    [self.view addSubview:self.leavesItemView];
    
    
    NSMutableArray *testArray = [NSMutableArray array];
    [testArray addObject:@"我们只提供场地，请自带相关设备"];
    [testArray addObject:@"可提供桌椅"];
    [testArray addObject:@"可以寄存小件货物"];
    [testArray addObject:@"诚信合作，非诚勿扰"];
    [testArray addObject:@"长短租均可"];
    [testArray addObject:@"长租需要签约"];
    [testArray addObject:@"有意向可实地面聊"];
    
    CGFloat startX = 15;
    CGFloat startY = 0;
    CGFloat buttonHeight = getWidth(31.f);
    
    for(int i = 0; i < testArray.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_GRAY_F1F1F1] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_RED_EA0000] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 2.f;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = kFont_Regular(12.f);
        [btn setTitle:testArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectedLeavesItem:) forControlEvents:UIControlEventTouchUpInside];
        CGSize titleSize = [testArray[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        
        titleSize.height = 20;
        titleSize.width += 20;
        
        if(startX + titleSize.width > kScreenWidth - getWidth(41.f)){
            startX = 10;
            startY = startY + buttonHeight + 10;
        }
        btn.frame = CGRectMake(startX, startY, titleSize.width, buttonHeight);
        startX = CGRectGetMaxX(btn.frame) + 10;
        [self.leavesItemView addSubview:btn];
        self.currentLeavesBtn = btn;
    }

}

#pragma mark - 选中的留言类型
- (void)selectedLeavesItem:(UIButton *)button
{
    self.leavesPlaceView.placehText = @"";
//    self.selectedBtn.selected = NO;
//    button.selected = YES;
//    self.selectedBtn = button;
    button.selected = !button.selected;
    if (button.selected) {
        if (![_leavesArray containsObject:button.currentTitle]) {
            [_leavesArray addObject:button.currentTitle];
        }
    }else{
        if ([_leavesArray containsObject:button.currentTitle]) {
            [_leavesArray removeObject:button.currentTitle];
        }
    }
//    if (![leavesArray containsObject:button.currentTitle]) {
//        [leavesArray addObject:button.currentTitle];
//    }else{
//        [leavesArray removeObject:button.currentTitle];
//    }
    if (self.leavesPlaceView.text.length == 0) {
        self.leavesPlaceView.text = [_leavesArray componentsJoinedByString:@","];
    }else{
        self.leavesPlaceView.text = [_leavesArray componentsJoinedByString:@";"];//[self.leavesPlaceView.text stringByAppendingString:[NSString stringWithFormat:@";%@",button.currentTitle]];
    }
}
- (void)setUpLeavesSubviewsFrame
{
    
    [self.leavesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(self.leavesLabel.mas_bottom).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-23.f));
        make.height.mas_equalTo(getWidth(195.f));
    }];
    
    [self.leavesPlaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.leavesView);
        make.bottom.mas_equalTo(self.leavesView.mas_bottom).offset(getWidth(-30.f));
    }];
    
    CGSize size = BoundWithSize(@"清空", kScreenWidth, 12.f).size;
    [self.placehButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.right.mas_equalTo(self.leavesView).offset(getWidth(-11.f));
        make.bottom.mas_equalTo(self.leavesView.mas_bottom).offset(getWidth(-11.f));
    }];
    
    [self.leavesItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(self.leavesView.mas_bottom).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-23.f));
        make.bottom.mas_equalTo(self.bottomContainerView.mas_top);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(45.f));
        make.left.top.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-21.f));
    }];
    
    [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, getWidth(118.f) + g_bottomSafeAreaHeight));
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomContainerView);
        make.centerX.equalTo(self.bottomContainerView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, getWidth(83.f)));
    }];
}

- (UIView *)leavesItemView
{
    if (!_leavesItemView) {
        _leavesItemView = [UIView new];
        _leavesItemView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _leavesItemView;
}

- (UILabel *)leavesLabel
{
    if (!_leavesLabel) {
        _leavesLabel = [UILabel new];
        _leavesLabel.font = kFont_Medium(15.f);
        _leavesLabel.textColor = COLOR_BLACK_333333;
        _leavesLabel.textAlignment = NSTextAlignmentLeft;
        _leavesLabel.text = @"备注信息";
    }
    return _leavesLabel;
}

- (UIButton *)placehButton
{
    if (!_placehButton) {
        _placehButton = [UIButton new];
        _placehButton.backgroundColor = UIColor.clearColor;
        _placehButton.titleLabel.font = kFont_Medium(12.f);
        [_placehButton setTitle:@"清空" forState:UIControlStateNormal];
        [_placehButton setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        _placehButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_placehButton addTarget:self action:@selector(cleanLeavesView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placehButton;
}

- (void)cleanLeavesView:(UIButton *)button
{
    self.leavesPlaceView.text = @"";
    self.leavesPlaceView.textLength = 200;
    self.leavesPlaceView.promptLab.text = @"0/200";
}

- (UIView *)leavesView
{
    if (!_leavesView) {
        _leavesView = [UIView new];
        _leavesView.backgroundColor = COLOR_GRAY_F6F6F6;
        _leavesView.layer.cornerRadius = 5.f;
        _leavesView.layer.masksToBounds = YES;
    }
    return _leavesView;
}
- (HPlaceholdTextView *)leavesPlaceView
{
    if(!_leavesPlaceView)
    {
        HPlaceholdTextView *leavesView = [[HPlaceholdTextView alloc] init];
        leavesView.layer.cornerRadius = 5.f;
        leavesView.layer.masksToBounds = YES;
        leavesView.backgroundColor = COLOR_GRAY_F6F6F6;
        leavesView.textLength = 200;
        leavesView.interception = YES;
        leavesView.placehTextColor = COLOR_GRAY_CCCCCC;
        leavesView.placehFont = kFont_Medium(12.f);
        leavesView.delegate = self;
        leavesView.placehText = @" 请输入您的需求，点击下面热门备注信息快速填写。";
        leavesView.promptTextColor = COLOR_BLACK_333333;
        leavesView.promptFont = kFont_Medium(12.f);
        leavesView.promptBackground = COLOR_GRAY_F6F6F6;
        leavesView.promptFrameMaxY = getWidth(1.f);
        leavesView.tintColor = COLOR_RED_FF3C5E;
        leavesView.EditChangedBlock = ^{
            
        };
        self.leavesPlaceView = leavesView;
    }
    return _leavesPlaceView;
}


#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 200) {
        [HPProgressHUD alertMessage:@"备注信息不得超过200位"];
        _leavesPlaceView.text = [text substringToIndex:text.length - 1];
        return NO;
    }else{
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [HPProgressHUD alertMessage:@"备注信息不能为空"];
    }
}

- (void)onClickSureBtn:(UIButton *)button
{
    if (self.leavesPlaceView.text.length && self.currentLeavesBtn.currentTitle) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
