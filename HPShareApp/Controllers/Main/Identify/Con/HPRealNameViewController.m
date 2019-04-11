//
//  HPIdentifyViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRealNameViewController.h"

#import "HPGradientUtil.h"

@interface HPRealNameViewController ()

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UILabel *scanLabel;

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, strong) UIView *lineName;

@property (nonatomic, strong) UILabel *IDLabel;

@property (nonatomic, strong) UITextField *IDField;

@property (nonatomic, strong) UIView *lineID;
@end

@implementation HPRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    self.navTitleView = [self setupNavigationBarWithTitle:@"实名认证"];
    
    [self setUpSubviews];
    
    [self setUpSubviewsMasonry];

}

- (void)setUpSubviews
{
    [self.view addSubview:self.titleLabel];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR(235, 33, 1, 1) endColor:COLOR(235, 33, 1, 0)];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.view addSubview:self.colorBtn];
    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [self.view addSubview:self.subTitleLabel];
    
    [self.view addSubview:self.scanBtn];

    [self.view addSubview:self.scanLabel];

    [self.view addSubview:self.nameLabel];

    [self.view addSubview:self.nameField];

    [self.view addSubview:self.lineName];

    [self.view addSubview:self.IDLabel];

    [self.view addSubview:self.IDField];

    [self.view addSubview:self.lineID];

}

- (void)setUpSubviewsMasonry
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(g_statusBarHeight + 44.f + getWidth(30.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(getWidth(12.f));
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.top.equalTo(self.colorBtn.mas_bottom).offset(getWidth(13.f));
        make.height.mas_equalTo(self.subTitleLabel.font.pointSize);

    }];
    
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.width.height.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    [self.scanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.scanBtn.mas_left).offset(getWidth(-7.f));
        make.width.mas_equalTo(getWidth(200.f));
        make.height.mas_equalTo(self.scanLabel.font.pointSize);
        make.centerY.mas_equalTo(self.scanBtn);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.width.mas_equalTo(getWidth(200.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.top.mas_equalTo(self.scanLabel.mas_bottom).offset(getWidth(24.f));;
    }];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(getWidth(37.f));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.lineName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.nameField.mas_bottom);
    }];
    
    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.IDLabel.font.pointSize);
        make.top.mas_equalTo(self.lineName.mas_bottom).offset(getWidth(22.f));
    }];
    
    [self.IDField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(getWidth(37.f));
        make.top.mas_equalTo(self.IDLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.lineID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.IDField.mas_bottom);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:kFont_Bold(18.f)];
        [_titleLabel setTextColor:COLOR_BLACK_333333];
        [_titleLabel setText:@"身份证实名认证"];
        
    }
    return _titleLabel;
}

- (UIButton *)colorBtn
{
    if (!_colorBtn) {
        _colorBtn = [[UIButton alloc] init];
        [_colorBtn.layer setCornerRadius:2.f];
        [_colorBtn.layer setMasksToBounds:YES];
    }
    return _colorBtn;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        [_subTitleLabel setFont:kFont_Medium(12.f)];
        [_subTitleLabel setTextColor:COLOR_GRAY_999999];
        [_subTitleLabel setText:@"完成身份认证后交易更高效、更便捷"];
    }
    return _subTitleLabel;
}

- (UILabel *)scanLabel
{
    if (!_scanLabel) {
        _scanLabel = [UILabel new];
        _scanLabel.text = @"证件扫描";
        _scanLabel.textColor = COLOR_BLACK_333333;
        _scanLabel.font = kFont_Medium(14.f);
        _scanLabel.textAlignment = NSTextAlignmentRight;
    }
    return _scanLabel;
}

- (UIButton *)scanBtn
{
    if (!_scanBtn) {
        _scanBtn = [UIButton new];
        [_scanBtn setBackgroundImage:ImageNamed(@"saomiao") forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(onClickScanBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"姓名";
        _nameLabel.textColor = COLOR_BLACK_333333;
        _nameLabel.font = kFont_Bold(16.f);
    }
    return _nameLabel;
}

- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc] init];
        _nameField.textAlignment = NSTextAlignmentLeft;
        _nameField.textColor = COLOR_BLACK_333333;
        _nameField.font = kFont_Medium(13.f);
        _nameField.placeholder = @"请填写真实姓名";
        _nameField.tintColor = COLOR_RED_EA0000;
        // "通过KVC修改占位文字的颜色"
        
        [_nameField setValue:COLOR_GRAY_999999 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _nameField;
}

- (UIView *)lineName{
    if (!_lineName) {
        _lineName = [UIView new];
        _lineName.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _lineName;
}

- (UILabel *)IDLabel
{
    if (!_IDLabel) {
        _IDLabel = [UILabel new];
        _IDLabel.text = @"身份证（加密处理）";
        _IDLabel.textColor = COLOR_BLACK_333333;
        _IDLabel.font = kFont_Bold(16.f);
    }
    return _IDLabel;
}

- (UITextField *)IDField
{
    if (!_IDField) {
        _IDField = [[UITextField alloc] init];
        _IDField.textAlignment = NSTextAlignmentLeft;
        _IDField.textColor = COLOR_BLACK_333333;
        _IDField.font = kFont_Medium(13.f);
        _IDField.placeholder = @"请填写并核对证件号码";
        _IDField.tintColor = COLOR_RED_EA0000;
        // "通过KVC修改占位文字的颜色"
        
        [_IDField setValue:COLOR_GRAY_999999 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _IDField;
}

- (UIView *)lineID{
    if (!_lineID) {
        _lineID = [UIView new];
        _lineID.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _lineID;
}

- (void)onClickScanBtn:(UIButton *)button
{
    
}
@end
