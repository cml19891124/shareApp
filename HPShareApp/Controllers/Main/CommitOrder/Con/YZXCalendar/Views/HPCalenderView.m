//
//  HPCalenderView.m
//  HPShareApp
//
//  Created by HP on 2019/3/29.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCalenderView.h"

#import "HPGlobalVariable.h"

@implementation HPCalenderView

- (void)setupModalView:(UIView *)view
{
    self.view = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(g_statusBarHeight + 44 + getWidth(53.f));
    }];
    
    [self.view addSubview:self.selectView];
    
    [self.selectView addSubview:self.singleSelectBtn];

//    [self.selectView addSubview:self.marginView];
//
//    [self.selectView addSubview:self.duringBtn];
    
    [self.selectView addSubview:self.closeBtn];

    [self.view addSubview:self.selectDaysVC.view];
    
    
    [self setUpSubviewsMasonry];
}

- (void)setUpSubviewsMasonry
{
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(46.f));
    }];
    
    CGFloat btnW = BoundWithSize(self.singleSelectBtn.currentTitle, kScreenWidth, 16.f).size.width;
    [self.singleSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(self.singleSelectBtn.titleLabel.font.pointSize);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.width.height.mas_equalTo(getWidth(15.f));
    }];
    
    [_selectDaysVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.selectView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (UIView *)selectView
{
    if (!_selectView) {
        _selectView = [UIView new];
        _selectView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _selectView;
}

- (UIView *)marginView
{
    if (!_marginView) {
        _marginView = [UIView new];
        _marginView.backgroundColor = COLOR_GRAY_CCCCCC;
    }
    return _marginView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setBackgroundImage:ImageNamed(@"close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(onClickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)singleSelectBtn
{
    if (!_singleSelectBtn) {
        _singleSelectBtn = [UIButton new];
        _singleSelectBtn.tag = YZXTimeToChooseInDay;
        [_singleSelectBtn setTitle:@"选择日期" forState:UIControlStateNormal];
        [_singleSelectBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        _singleSelectBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _singleSelectBtn.titleLabel.font = kFont_Medium(16.f);
        _singleSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _singleSelectBtn;
}

- (UIButton *)duringBtn
{
    if (!_duringBtn) {
        _duringBtn = [UIButton new];
        _duringBtn.tag = YZXTimeToChooseInCustom;
        [_duringBtn setTitle:@"段选" forState:UIControlStateNormal];
        [_duringBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        _duringBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _duringBtn.titleLabel.font = kFont_Medium(16.f);
        _duringBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _duringBtn;
}

- (YZXSelectDateViewController *)selectDaysVC
{
    if (!_selectDaysVC.view) {
        _selectDaysVC = [[YZXSelectDateViewController alloc] init];
        _selectDaysVC.delegate =self;
        [_selectDaysVC.navigationController setNavigationBarHidden:YES animated:YES];
        kWEAKSELF
        _selectDaysVC.confirmTheDateBlock = ^(NSString *startDate, NSString *endDate, YZXTimeToChooseType selectedType) {
            weakSelf.selectedType = selectedType;
            weakSelf.startDate = startDate;
            weakSelf.endDate = endDate;
            
        };
    }
    return _selectDaysVC;
}

- (void)onTapModalOutSide
{
    [self show:NO];
}

- (void)onClickCloseBtn:(UIButton *)button
{
    [self show:NO];
}

#pragma mark - SelectedDayDelegate

- (void)selectedDay:(NSString *)day
{
    [self show:NO];
    if (self.singleBlock) {
        self.singleBlock(day);
    }
}

- (void)confirmSelectedDays
{
    [self show:NO];
    if (self.calenderBlock) {
        self.calenderBlock(self.startDate, self.endDate, self.selectedType);
    }
}
@end
