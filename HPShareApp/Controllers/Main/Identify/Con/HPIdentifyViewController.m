//
//  HPIdentifyViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdentifyViewController.h"

#import "HPRightImageButton.h"

#import "HPGradientUtil.h"

@interface HPIdentifyViewController ()

@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *nameSubLabel;

@property (nonatomic, strong) UIView *bgview;

@end

@implementation HPIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubviews];
    
    [self setUpSubviewsMasonry];

}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpSubviews
{
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self.view addSubview:self.headView];
    
    [self.headView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.headView addSubview:self.titleLabel];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR_GRAY_FFFFFF endColor:COLOR_ORANGE_EB0303];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.headView addSubview:self.colorBtn];
    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [self.headView addSubview:self.subTitleLabel];
    
    [self.view addSubview:self.bgview];

    [self setUpIdentifyView:self.bgview];
}

- (void)setUpSubviewsMasonry
{
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(167.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView);
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(getWidth(15.f));
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.colorBtn.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.subTitleLabel.font.pointSize);
        
    }];
    
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(162.f));
        make.top.mas_equalTo(self.headView.mas_bottom);
    }];
}

- (UIView *)bgview
{
    if (!_bgview) {
        _bgview = [UIView new];
        [_bgview setBackgroundColor:COLOR_GRAY_FFFFFF];
    }
    return _bgview;
}

- (UIImageView *)headView
{
    if (!_headView) {
        _headView = [UIImageView new];
        _headView.userInteractionEnabled = YES;
        _headView.image = ImageNamed(@"BG");
    }
    return _headView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:kFont_Bold(24.f)];
        [_titleLabel setTextColor:COLOR_GRAY_FFFFFF];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setText:@"资格认证"];
        
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
        [_subTitleLabel setTextColor:COLOR_GRAY_FFFFFF];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_subTitleLabel setText:@"证照信息认证，交易保障全面升级"];
    }
    return _subTitleLabel;
}


- (void)setUpIdentifyView:(UIView *)bgview
{
    UIView *nameRow = [self addRowOfParentView:bgview withHeight:getWidth(81.f) margin:0.f isEnd:NO];
    
    _nameLabel = [self setupTitleLabelWithTitle:@"实名认证"];
    [nameRow addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameRow).with.offset(18.f * g_rateWidth);
        make.top.mas_equalTo(getWidth(20.f));
    }];
    
    _nameSubLabel = [self setupTitleLabelWithTitle:@"认证信息将严格保密"];
    [nameRow addSubview:self.nameSubLabel];
    [self.nameSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameRow).with.offset(18.f * g_rateWidth);
        make.bottom.mas_equalTo(nameRow.mas_bottom).offset(getWidth(-10.f));
    }];
    
    HPRightImageButton *realNameBtn = [self setupGotoBtnWithTitle:@"去认证"];
    [realNameBtn setTag:4700];
    [nameRow addSubview:realNameBtn];
    
    [realNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameRow).with.offset(-15.f * g_rateWidth);
        make.centerY.equalTo(nameRow);
    }];
    
    UIView *lineNameV = [UIView new];
    lineNameV.backgroundColor = COLOR_GRAY_EEEEEE;
    [nameRow addSubview:lineNameV];
    [lineNameV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(nameRow);
        make.height.mas_equalTo(1);
    }];
    //营业执照
    UIView *passportRow = [self addRowOfParentView:bgview withHeight:getWidth(80.f) margin:0.f isEnd:NO];
    
    UILabel *boardLabel = [self setupTitleLabelWithTitle:@"营业执照认证"];
    [passportRow addSubview:boardLabel];
    [boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passportRow).with.offset(18.f * g_rateWidth);
        make.top.mas_equalTo(getWidth(10.f));
    }];
    
    UILabel *boardSubLabel = [self setupTitleLabelWithTitle:@"上传营业执照交易更有保障"];
    [passportRow addSubview:boardSubLabel];
    [boardSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passportRow).with.offset(18.f * g_rateWidth);
        make.bottom.mas_equalTo(passportRow.mas_bottom).offset(getWidth(-10.f));
    }];
    
    HPRightImageButton *boardBtn = [self setupGotoBtnWithTitle:@"去认证"];
    [boardBtn setTag:4701];
    [passportRow addSubview:boardBtn];
    
    [boardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passportRow).with.offset(-15.f * g_rateWidth);
        make.centerY.equalTo(passportRow);
    }];
    
    UIView *lineBoardV = [UIView new];
    lineBoardV.backgroundColor = COLOR_GRAY_EEEEEE;
    [nameRow addSubview:lineBoardV];
    [lineBoardV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(passportRow);
        make.height.mas_equalTo(1);
    }];
}

- (UIView *)addRowOfParentView:(UIView *)view withHeight:(CGFloat)height margin:(CGFloat)margin isEnd:(BOOL)isEnd {
    UIView *row = [[UIView alloc] init];
    [view addSubview:row];
    [row mas_makeConstraints:^(MASConstraintMaker *make) {
        if (view.subviews.count == 1) {
            make.top.equalTo(view).with.offset(margin);
        }
        else {
            UIView *lastRow = view.subviews[view.subviews.count - 2];
            make.top.equalTo(lastRow.mas_bottom);
        }
        
        if (isEnd) {
            make.bottom.equalTo(view).with.offset(-margin);
        }
        
        make.left.and.width.equalTo(view);
        make.height.mas_equalTo(height);
    }];
    
    return row;
}

- (UILabel *)setupTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [label setTextColor:COLOR_GRAY_888888];
    [label setText:title];
    return label;
}

- (HPRightImageButton *)setupGotoBtnWithTitle:(NSString *)title {
    HPRightImageButton *btn = [[HPRightImageButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"shouye_gengduo"]];
    [btn setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [btn setText:title];
    [btn setSpace:10.f];
    [btn setColor:COLOR_GRAY_999999];
    [btn setSelectedColor:COLOR_BLACK_333333];
    [btn addTarget:self action:@selector(onClickGotoCtrl:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)onClickGotoCtrl:(HPRightImageButton *)button
{
    if (button.tag == 4700) {
        [self pushVCByClassName:@"HPRealNameViewController"];
    }else if (button.tag == 4701){
        [self pushVCByClassName:@"HPManagerBoardViewController"];

    }
}
@end
