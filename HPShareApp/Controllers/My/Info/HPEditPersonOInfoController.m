//
//  HPChangePasswordController.m
//  HPShareApp
//
//  Created by HP on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "HPRightImageButton.h"

#import "HPEditPersonOInfoController.h"
typedef NS_ENUM(NSInteger, HPEditInfoGoto) {
    HPEditGotoPortrait = 10,
    HPEditGotoFullName,
    HPEditGotoCompany,
    HPEditGotoContact,
    HPEditGotoSign
};
@interface HPEditPersonOInfoController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *accountInfoPanel;
@property (nonatomic, weak) HPRightImageButton *nameBtn;
@property (nonatomic, weak) HPRightImageButton *companyBtn;
@property (nonatomic, weak) HPRightImageButton *contactBtn;

@end

@implementation HPEditPersonOInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"编辑名片"];
    [self setUpUI];
    
}

- (void)setUpUI{
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight + 44);
    }];
    
    UILabel *accountInfoLabel = [[UILabel alloc] init];
    [accountInfoLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [accountInfoLabel setTextColor:COLOR_BLACK_333333];
    [accountInfoLabel setText:@"名片信息"];
    [scrollView addSubview:accountInfoLabel];
    [accountInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(19.f * g_rateWidth);
        make.left.equalTo(scrollView).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(accountInfoLabel.font.pointSize);
    }];
    
    UIView *accountInfoPanel = [[UIView alloc] init];
    [scrollView addSubview:accountInfoPanel];
    self.accountInfoPanel = accountInfoPanel;
    [accountInfoPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountInfoLabel.mas_bottom ).with.offset(14.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.width.mas_equalTo(345.f * g_rateWidth);
        make.height.mas_equalTo(200.f * g_rateWidth);
    }];
    [self setupShadowOfPanel:accountInfoPanel];
    
    UILabel *signInfoLabel = [[UILabel alloc] init];
    [signInfoLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [signInfoLabel setTextColor:COLOR_BLACK_333333];
    [signInfoLabel setText:@"签名信息"];
    [scrollView addSubview:signInfoLabel];
    [signInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountInfoPanel.mas_bottom).with.offset(19.f * g_rateWidth);
        make.left.equalTo(scrollView).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(signInfoLabel.font.pointSize);
    }];
    
    UIView *signView = [[UIView alloc] init];
    [scrollView addSubview:signView];
    [signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signInfoLabel.mas_bottom ).with.offset(14.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.width.mas_equalTo(345.f * g_rateWidth);
        make.height.mas_equalTo(45.f * g_rateWidth);
    }];
//    self.signView = signView;
    [self setUpSignInfoView:signView];
    
}


- (void)setUpSignInfoView:(UIView *)view
{
    view.backgroundColor = UIColor.whiteColor;
    [view.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [view.layer setShadowRadius:15.f];
    [view.layer setShadowOpacity:0.3f];
    [view.layer setCornerRadius:15.f];
    
    UIView *nameView = [[UIView alloc] init];
    [view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.height.mas_equalTo(getWidth(45.f));
        make.top.mas_equalTo(view).offset(getWidth(0.f));

    }];
    UILabel *nameLabel = [self setupTitleLabelWithTitle:@"签名"];
    [nameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(nameView);
        make.height.mas_equalTo(nameLabel.font.pointSize);
        make.right.equalTo(nameView).with.offset(-18.f * g_rateWidth);
        
    }];
    
    HPRightImageButton *nameBtn = [self setupGotoBtnWithTitle:@"未填写"];
    [nameView addSubview:nameBtn];
    [nameBtn setTag:HPEditGotoSign];
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-18.f));
        make.centerY.mas_equalTo(nameView);
    }];
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

- (void)onClickGotoCtrl:(UIButton *)button
{
    if (button.tag == HPEditGotoPortrait) {
        HPLog(@"HPEditGotoPortrait");
    }else if (button.tag == HPEditGotoFullName) {
        HPLog(@"HPEditGotoFullName");
    }else if (button.tag == HPEditGotoCompany) {
        HPLog(@"HPEditGotoCompany");
    }else if (button.tag == HPEditGotoContact) {
        HPLog(@"HPEditGotoContact");
    }else if (button.tag == HPEditGotoSign) {
        HPLog(@"HPEditGotoSign");
    }
    
}
- (void)setupShadowOfPanel:(UIView *)view {
    view.backgroundColor = UIColor.whiteColor;
    [view.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [view.layer setShadowRadius:15.f];
    [view.layer setShadowOpacity:0.3f];
    [view.layer setCornerRadius:15.f];

    UIView *headerView = [[UIView alloc] init];
    [view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(66.f));
        make.left.right.top.mas_equalTo(view);
    }];
    
    UILabel *portraitLabel = [self setupTitleLabelWithTitle:@"头像"];
    [headerView addSubview:portraitLabel];
    [portraitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(headerView);
        make.height.mas_equalTo(portraitLabel.font.pointSize);
    }];
    
    UIButton *portraitView = [[UIButton alloc] init];
    [portraitView.layer setCornerRadius:23.f];
    [portraitView.layer setMasksToBounds:YES];
    [portraitView setImage:ImageNamed(@"my_business_card_default_head_image") forState:UIControlStateNormal];
    [headerView addSubview:portraitView];
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(46.f, 46.f));
        make.right.mas_equalTo(getWidth(-34.f));
    }];
    UIButton *rowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowBtn setBackgroundImage:ImageNamed(@"shouye_gengduo") forState:UIControlStateNormal];
    [headerView addSubview:rowBtn];
    [rowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerView.mas_right).offset(getWidth(-18.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(6), getWidth(10)));
        make.centerY.mas_equalTo(headerView);
    }];
    HPRightImageButton *clickBtn = [self setupGotoBtnWithTitle:@""];
    [headerView addSubview:clickBtn];
    [clickBtn setTag:HPEditGotoPortrait];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(portraitView.mas_left);
        make.right.mas_equalTo(rowBtn.mas_right);
        make.centerY.mas_equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(62, 46));
    }];
    
    UIView *nameView = [[UIView alloc] init];
    [view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.height.mas_equalTo(getWidth(42.f));
        make.top.mas_equalTo(headerView.mas_bottom);
    }];
    UILabel *nameLabel = [self setupTitleLabelWithTitle:@"姓名"];
    [nameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(nameView);
        make.height.mas_equalTo(nameLabel.font.pointSize);
        make.right.equalTo(nameView).with.offset(-18.f * g_rateWidth);

    }];
    
    HPRightImageButton *nameBtn = [self setupGotoBtnWithTitle:@"未填写"];
    [nameView addSubview:nameBtn];
    [nameBtn setTag:HPEditGotoFullName];
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-18.f));
        make.centerY.mas_equalTo(nameView);
    }];
    
    UIView *companyView = [[UIView alloc] init];
    [view addSubview:companyView];
    [companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.height.mas_equalTo(getWidth(42.f));
        make.top.mas_equalTo(nameView.mas_bottom);
    }];
    UILabel *companyLabel = [self setupTitleLabelWithTitle:@"公司名称"];
    [companyView addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyView).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(companyView);
        make.height.mas_equalTo(companyLabel.font.pointSize);
        make.right.equalTo(companyView).with.offset(-18.f * g_rateWidth);

    }];

    HPRightImageButton *companyBtn = [self setupGotoBtnWithTitle:@"未填写"];
    [companyView addSubview:companyBtn];
    [companyBtn setTag:HPEditGotoCompany];
    [companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-18.f));
        make.centerY.mas_equalTo(companyView);
    }];

    UIView *contactView = [[UIView alloc] init];
    [view addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.height.mas_equalTo(getWidth(42.f));
        make.top.mas_equalTo(companyView.mas_bottom);
    }];
    UILabel *contactLabel = [self setupTitleLabelWithTitle:@"联系方式"];
    [contactView addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactView).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(contactView);
        make.height.mas_equalTo(contactLabel.font.pointSize);
        make.right.equalTo(contactView).with.offset(-18.f * g_rateWidth);
    }];

    HPRightImageButton *contactBtn = [self setupGotoBtnWithTitle:@"未填写"];
    [contactView addSubview:contactBtn];
    [contactBtn setTag:HPEditGotoContact];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-18.f));
        make.centerY.mas_equalTo(contactView);
    }];
}

- (void)fillContactPhoneClick:(UIButton *)button
{
    
}
- (void)fillNameClick:(UIButton *)button
{
    
}

- (void)fillCompanyNameClick:(UIButton *)button
{
    
}

#pragma mark - 获取头像
- (void)getPersonalHearImage:(UITapGestureRecognizer *)tap
{
    
}
- (UILabel *)setupTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [label setTextColor:COLOR_GRAY_888888];
    [label setText:title];
    return label;
}


@end
