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

@end

@implementation HPStoreLeavesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *navTilteView = [self setupNavigationBarWithTitle:@"完善店铺共享信息"];
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

- (void)setUpLeavesSubViews
{
    [self.view addSubview:self.leavesView];
    [self.leavesView addSubview:self.leavesPlaceView];
//    [self.leavesView addSubview:self.placehButton];

}

- (void)setUpLeavesSubviewsFrame
{
    
    [self.leavesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(self.leavesLabel.mas_bottom).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-23.f));
        make.height.mas_equalTo(getWidth(165.f));
    }];
    
    [self.leavesPlaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
//    [self.placehButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(self.leavesView.placehLab);
//        make.center.mas_equalTo(self.leavesView.placehLab);
//    }];
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
        [_placehButton setTitle:@"" forState:UIControlStateNormal];
        [_placehButton addTarget:self action:@selector(cleanLeavesView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placehButton;
}

- (void)cleanLeavesView:(UIButton *)button
{
    self.leavesPlaceView.text = @"";
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length) {
        _leavesPlaceView.textLength = 0;
        _leavesPlaceView.interception = YES;
        _leavesPlaceView.promptLab.text = @"清空";
        [_leavesPlaceView.promptLab sizeToFit];
    }
}
@end
