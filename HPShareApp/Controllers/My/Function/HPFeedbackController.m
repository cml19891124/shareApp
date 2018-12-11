//
//  HPFeedbackController.m
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPFeedbackController.h"
#import "HPSelectTable.h"
#import "MBProgressHUD.h"

#define TEXT_VIEW_PLACEHOLDER @"请输入您反馈的具体信息，我们将竭尽全力包您满意。"

@interface HPFeedbackController () <UITextViewDelegate,HPSelectTableDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) MBProgressHUD *hud;

@property (nonatomic, assign) NSInteger timerCount;

/**
 选中的选项
 */
@property (nonatomic, copy) NSString *selectedText;
@property (nonatomic, strong) UITextView *textView;

/**
 意见反馈类型
 */
@property (nonatomic, copy) NSString *typs;
@end

@implementation HPFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _typs = @"0";
    _timerCount = 3;
    
    [self setupUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_WHITE_FCFDFF];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"意见反馈"];
    
    UIView *typeTitleView = [self setupTitleViewWithTitle:@"反馈类型"];
    [self.view addSubview:typeTitleView];
    [typeTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20.f * g_rateWidth);
        make.top.equalTo(navigationView.mas_bottom).with.offset(20.f * g_rateWidth);
    }];
    
    HPSelectTableLayout *layout = [[HPSelectTableLayout alloc] init];
    [layout setColNum:3];
    [layout setXSpace:18.f * g_rateWidth];
    [layout setYSpace:15.f * g_rateWidth];
    [layout setItemSize:CGSizeMake(100.f * g_rateWidth, 34.f * g_rateWidth)];
    [layout setNormalFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [layout setSelectedFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [layout setNormalBgColor:COLOR_GRAY_EEEEEE];
    [layout setSelectedBgColor:COLOR_RED_FF3C5E];
    [layout setNormalTextColor:COLOR_BLACK_666666];
    [layout setSelectTextColor:UIColor.whiteColor];
    [layout setItemCornerRadius:5.f];
    [layout setItemBorderWidth:0.f];
    
    NSArray *options = @[@"产品建议", @"我要吐槽", @"虚假信息举报", @"登录注册问题", @"异常退出问题", @"其他问题"];
    HPSelectTable *selectTable = [[HPSelectTable alloc] initWithOptions:options layout:layout];
    [selectTable setBtnAtIndex:0 selected:YES];
    selectTable.delegate = self;
    [self.view addSubview:selectTable];
    [selectTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeTitleView);
        make.top.equalTo(typeTitleView.mas_bottom).with.offset(14.f * g_rateWidth);
    }];
    
    UIView *contentTitleView = [self setupTitleViewWithTitle:@"反馈内容"];
    [self.view addSubview:contentTitleView];
    [contentTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeTitleView);
        make.top.equalTo(selectTable.mas_bottom).with.offset(28.f * g_rateWidth);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [contentView.layer setCornerRadius:5.f];
    [contentView setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeTitleView);
        make.top.equalTo(contentTitleView.mas_bottom).with.offset(14.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 150.f * g_rateWidth));
    }];
    [self setupContentView:contentView];
    
    UIButton *commitBtn = [[UIButton alloc] init];
    [commitBtn.layer setCornerRadius:24.f];
    [commitBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [commitBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(onClickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-27.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 47.f));
    }];
}

- (UIView *)setupTitleViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_RED_FF3C5E];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(2.f, 17.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).with.offset(7.f);
        make.centerY.equalTo(line);
    }];
    
    return view;
}

- (void)setupContentView:(UIView *)view {
    UITextView *textView = [[UITextView alloc] init];
    [textView setBackgroundColor:UIColor.clearColor];
    [textView setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [textView setTextColor:COLOR_GRAY_BBBBBB];
    [textView setText:TEXT_VIEW_PLACEHOLDER];
    [textView setDelegate:self];
    [view addSubview:textView];
    self.textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f));
    }];
}

- (void)onTimerTriggered {
    _timerCount --;
    
    [_hud.label setText:[NSString stringWithFormat:@"感谢您的宝贵意见! (%ld)", _timerCount]];
    
    if (_timerCount < 0) {
        [_hud hideAnimated:YES];
        [_timer invalidate];
        _timer = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:TEXT_VIEW_PLACEHOLDER]) {
        [textView setTextColor:COLOR_BLACK_333333];
        [textView setText:@""];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        [textView setText:TEXT_VIEW_PLACEHOLDER];
        [textView setTextColor:COLOR_GRAY_BBBBBB];
    }
}

#pragma mark - OnClick

- (void)onClickCommitBtn:(UIButton *)btn {
    NSLog(@"onClickCommitBtn");
    
    if (_typs.length == 0) {
        [HPProgressHUD alertMessage:@"请选择反馈类型"];
    }else if (_textView.text.length == 0) {
        [HPProgressHUD alertMessage:@"请填写反馈内容"];
    }else if(_typs.length != 0 && _textView.text.length != 0){
        [self feedbackOwnerComments];
    }
}
#pragma mark - 意见反馈
- (void)feedbackOwnerComments
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud = hud;
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"感谢您的宝贵意见! (3)";
    [hud.label setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [hud.label setTextColor:UIColor.whiteColor];
    hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
    [hud.bezelView.layer setCornerRadius:10.f];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimerTriggered) userInfo:nil repeats:YES];
    _timer = timer;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"context"] = _textView.text;
    dic[@"types"] = _typs;

    [HPHTTPSever HPGETServerWithMethod:@"/v1/back/freeBack" paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE==200) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            MSG;
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
#pragma mark - HPSelectTableDelegate
- (void)selectTable:(HPSelectTable *)selectTable didSelectText:(NSString *)text atIndex:(NSInteger)index
{
    _selectedText = text;
    _typs = [NSString stringWithFormat:@"%ld",index];
}
@end
