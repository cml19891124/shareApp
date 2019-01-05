//
//  HPConfigCenterController.m
//  HPShareApp
//
//  Created by HP on 2018/11/28.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPConfigCenterController.h"
#import "HPRightImageButton.h"
#import "HPAlertSheet.h"
#import "TZImagePickerController.h"
#import "HPAddPhotoView.h"
#import "HPTimeString.h"
#import "HPUploadImageHandle.h"
#import "UIButton+WebCache.h"
#import "HPClearCacheTool.h"
#import "HPCustomerServiceModalView.h"
#import "LEEAlert.h"


typedef NS_ENUM(NSInteger, HPConfigGoto) {
    HPConfigGotoPortrait = 0,
    HPConfigGotoFullName,
    HPConfigGotoCompany,
    HPConfigGotoContact,
    HPConfigGotoUserName,
    HPConfigGotoMail,
    HPConfigGotoPhoneNum,
    HPConfigGotoPassword,
    HPConfigGotoVersion,
    HPConfigGotoCache,
    HPConfigGotoAddBtn
};

@interface HPConfigCenterController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIView *accountInfoPanel;
@property (nonatomic, weak) UIImageView *portraitView;
@property (nonatomic, strong) UIView *professDetailPanel;
@property (nonatomic, strong) UIView *versionPanel;
@property (nonatomic, weak) HPCustomerServiceModalView *customerServiceModalView;

@property (nonatomic, weak) HPRightImageButton *fullNameGotoBtn;

@property (nonatomic, weak) HPRightImageButton *companyGotoBtn;

@property (nonatomic, weak) HPRightImageButton *contactGotoBtn;

@property (nonatomic, weak) HPRightImageButton *userNameGotoBtn;

@property (nonatomic, weak) HPRightImageButton *mailGotoBtn;

@property (nonatomic, weak) HPRightImageButton *phoneNumGotoBtn;

@property (nonatomic, weak) HPRightImageButton *passwordGotoBtn;

@property (nonatomic, weak) HPRightImageButton *versionGotoBtn;

@property (nonatomic, weak) HPRightImageButton *cacheGotoBtn;

@property (nonatomic, strong) MASConstraint *versionTop;
/**
 专属顾问的添加按钮
 */
@property (nonatomic, strong) HPRightImageButton *addBtn;


/**
 顾问头像
 */
@property (nonatomic, strong) UIImageView *userIcon;

/**
 顾问名称
 */
@property (nonatomic, strong) UILabel *fessionnameLabel;

/**
 顾问职责
 */
@property (nonatomic, strong) UILabel *fessionInfoLabel;


/**
 业务员id field
 */
@property (nonatomic, strong) UITextField *fessionField;

@property (nonatomic, strong) UIImagePickerController *photoPicker;

@property (nonatomic, weak) TZImagePickerController *imagePicker;
@property (nonatomic, weak) HPAlertSheet *alertSheet;

/**
 获取到的图片
 */
@property (nonatomic, strong) UIImage *photo;
@end

@implementation HPConfigCenterController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HPLoginModel *model = [HPUserTool account];
    NSString *fianlMobile = model.userInfo.mobile.length > 0?[model.userInfo.mobile stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"]:@"未填写";
    CGFloat cashSize = [HPClearCacheTool readCacheSize];
    NSString *cacheStr = [NSString stringWithFormat:@"%.2fMB",cashSize];
    [self setPortrait:[UIImage imageNamed:@"my_business_card_default_head_image"]];
    [self setText:model.userInfo.username.length > 0?model.userInfo.username:@"未填写" ofBtnWithType:HPConfigGotoUserName];
    [self setText:fianlMobile > 0?fianlMobile:@"未填写" ofBtnWithType:HPConfigGotoPhoneNum];
    [self setText:model.userInfo.password?@"修改":@"未设置" ofBtnWithType:HPConfigGotoPassword];
    [self setText:@"V1.1.0" ofBtnWithType:HPConfigGotoVersion];
    [self setText:cacheStr.length>0 ?cacheStr:@"16.8MB" ofBtnWithType:HPConfigGotoCache];
    //查询绑定的业务员
    [self queryOnlineProducters];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    kWeakSelf(weakSelf);
    HPAlertSheet *alertSheet = [[HPAlertSheet alloc] init];
    HPAlertAction *photoAction = [[HPAlertAction alloc] initWithTitle:@"拍照" completion:^{
        [weakSelf onClickAlbumOrPhotoSheetWithTag:0];
    }];
    [alertSheet addAction:photoAction];
    HPAlertAction *albumAction = [[HPAlertAction alloc] initWithTitle:@"从手机相册选择" completion:^{
        [weakSelf onClickAlbumOrPhotoSheetWithTag:1];
    }];
    [alertSheet addAction:albumAction];
    self.alertSheet = alertSheet;
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
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"设置中心"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
    
    UILabel *accountInfoLabel = [[UILabel alloc] init];
    [accountInfoLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [accountInfoLabel setTextColor:COLOR_BLACK_333333];
    [accountInfoLabel setText:@"账户信息"];
    [scrollView addSubview:accountInfoLabel];
    [accountInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(19.f * g_rateWidth);
        make.left.equalTo(scrollView).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(accountInfoLabel.font.pointSize);
    }];
    
    //账号管理
    UIView *accountInfoPanel = [[UIView alloc] init];
    [self setupShadowOfPanel:accountInfoPanel];
    [scrollView addSubview:accountInfoPanel];
    self.accountInfoPanel = accountInfoPanel;
    [accountInfoPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountInfoLabel.mas_bottom ).with.offset(14.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.width.mas_equalTo(345.f * g_rateWidth);
    }];
    [self setupAccountInfoPanel:accountInfoPanel];
    
    //专属顾问
    UIView *professionalPanel = [[UIView alloc] init];
    [self setupShadowOfPanel:professionalPanel];
    [scrollView addSubview:professionalPanel];
    [professionalPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountInfoPanel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.left.equalTo(self.accountInfoPanel);
        make.width.mas_equalTo(345.f * g_rateWidth);
        make.height.mas_equalTo(63.f * g_rateWidth);
    }];
    [self setupProfessionalPanel:professionalPanel];
    
    //专属顾问详情
    UIView *professDetailPanel = [[UIView alloc] init];
    professDetailPanel.backgroundColor = UIColor.redColor;
    [self setupShadowOfPanel:professDetailPanel];
    [scrollView addSubview:professDetailPanel];
    _professDetailPanel = professDetailPanel;
    [professDetailPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(professionalPanel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.left.equalTo(self.accountInfoPanel);
        make.width.mas_equalTo(345.f * g_rateWidth);
        make.height.mas_equalTo(70.f * g_rateWidth);
    }];
    [self setupProfessDetailPanel:professDetailPanel];
    
    //版本控制
    UIView *versionPanel = [[UIView alloc] init];
    [self setupShadowOfPanel:versionPanel];
    [scrollView addSubview:versionPanel];
    _versionPanel = versionPanel;
    [versionPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        MASConstraint *versionTop = make.top.equalTo(professionalPanel.mas_bottom).with.offset(15.f * g_rateWidth);
        self.versionTop = versionTop;
        make.centerX.equalTo(scrollView);
        make.width.mas_equalTo(345.f * g_rateWidth);
    }];
    [self setupVersionPanel:versionPanel];
    
    //切换账号-退出登录
    UIButton *switchBtn = [[UIButton alloc] init];
    [switchBtn.layer setCornerRadius:24.f * g_rateWidth];
    [switchBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [switchBtn setTitleColor:COLOR_PINK_FFEFF2 forState:UIControlStateNormal];
    [switchBtn setTitle:@"切换账号" forState:UIControlStateNormal];
    [switchBtn setBackgroundColor:COLOR_RED_FF3C5E];
    [switchBtn addTarget:self action:@selector(swithAccountOfOthers:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionPanel.mas_bottom).with.offset(25.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 47.f * g_rateWidth));
        make.bottom.equalTo(scrollView).with.offset(-26.f * g_rateWidth);
    }];
}

#pragma mark - 专属顾问view
- (void)setupProfessionalPanel:(UIView *)panel
{
    UIView *professionalRow = [self addRowOfParentView:panel withHeight:70.f * g_rateWidth margin:0.f isEnd:NO];
    UILabel *professionalLabel = [self setupTitleLabelWithTitle:@"申请专属顾问"];
    [professionalRow addSubview:professionalLabel];
    _professDetailPanel = professionalRow;
    [professionalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(professionalRow).offset(getWidth(19.f));
        make.centerY.equalTo(professionalRow);
        make.height.mas_equalTo(professionalLabel.font.pointSize);
    }];
    
    HPRightImageButton *addBtn = [self setupGotoBtnWithTitle:@"去添加"];
    [addBtn setTag:HPConfigGotoAddBtn];
    [professionalRow addSubview:addBtn];
    _addBtn = addBtn;
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(professionalRow).offset(getWidth(-17.f));
        make.centerY.equalTo(professionalLabel);
    }];
}

#pragma mark - 专属顾问详情view
- (void)setupProfessDetailPanel:(UIView *)view
{
    UIView *professDetailRow = [self addRowOfParentView:view withHeight:70.f * g_rateWidth margin:0.f isEnd:NO];
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = ImageNamed(@"my_business_card_default_head_image");
    [professDetailRow addSubview:userIcon];
    self.userIcon = userIcon;
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(19.f));
        make.height.mas_equalTo(getWidth(46.f));
        make.width.mas_equalTo(getWidth(46.f));
        make.centerY.mas_equalTo(professDetailRow);
    }];
    
    UILabel *fessionnameLabel = [UILabel new];
    fessionnameLabel.font = kFont_Medium(15.f);
    fessionnameLabel.textColor = COLOR_BLACK_444444;
    fessionnameLabel.textAlignment = NSTextAlignmentLeft;
    fessionnameLabel.text = @"周银";
    [professDetailRow addSubview:fessionnameLabel];
    self.fessionnameLabel = fessionnameLabel;
    [fessionnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).offset(getWidth(20.f));
        make.top.mas_equalTo(getWidth(17.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(fessionnameLabel.font.pointSize);
    }];
    
    UILabel *fessionInfoLabel = [UILabel new];
    fessionInfoLabel.font = kFont_Medium(12.f);
    fessionInfoLabel.textColor = COLOR_GRAY_999999;
    fessionInfoLabel.textAlignment = NSTextAlignmentLeft;
    fessionInfoLabel.text = @"专属顾问为您提供免费咨询服务";
    [professDetailRow addSubview:fessionInfoLabel];
    self.fessionInfoLabel = fessionInfoLabel;
    [fessionInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).offset(getWidth(20.f));
        make.top.mas_equalTo(fessionnameLabel.mas_bottom).offset(getWidth(11.f));
        make.right.mas_equalTo(professDetailRow).offset(getWidth(-65.f));
        make.height.mas_equalTo(fessionnameLabel.font.pointSize);
    }];
    
    UIButton *callBtn = [UIButton new];
    [callBtn setBackgroundImage:ImageNamed(@"call") forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callProfessional:) forControlEvents:UIControlEventTouchUpInside];
    [professDetailRow addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(44.f), getWidth(44.f)));
        make.right.mas_equalTo(getWidth(-18.f));
        make.top.mas_equalTo(getWidth(13.f));
    }];
}

#pragma mark - 拨打业务员电话
- (void)callProfessional:(UIButton *)button
{
    if (_customerServiceModalView == nil) {
        HPCustomerServiceModalView *customerServiceModalView = [[HPCustomerServiceModalView alloc] initWithParent:self.parentViewController.view];
        customerServiceModalView.phone = @"0755-86713128";
        [customerServiceModalView setPhoneString:@"0755-86713128"];
        _customerServiceModalView = customerServiceModalView;
    }
    
    [_customerServiceModalView show:YES];
    [self.parentViewController.view bringSubviewToFront:_customerServiceModalView]; 
}

#pragma mark - 切换账号
- (void)swithAccountOfOthers:(UIButton *)button
{
    [self switchAccount];
}

- (void)switchAccount
{
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/logOut" isNeedToken:YES paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPUserTool deleteAccount];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
- (void)setupPersonInfoPanel:(UIView *)view {
    
    UIView *portraitRow = [self addRowOfParentView:view withHeight:63.f * g_rateWidth margin:0.f isEnd:NO];
    
    UILabel *portraitLabel = [self setupTitleLabelWithTitle:@"头像"];
    [portraitRow addSubview:portraitLabel];
    [portraitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitRow).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(portraitRow);
        make.height.mas_equalTo(portraitLabel.font.pointSize);
    }];
    
    UIControl *portraitCtrl = [[UIControl alloc] init];
    [portraitCtrl setTag:HPConfigGotoPortrait];
    [portraitCtrl addTarget:self action:@selector(onClickGotoCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [portraitRow addSubview:portraitCtrl];
    [portraitCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(portraitRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(portraitLabel);
    }];
    
    UIImageView *portraitView = [[UIImageView alloc] init];
    [portraitView.layer setCornerRadius:23.f];
    [portraitView.layer setMasksToBounds:YES];
    [portraitCtrl addSubview:portraitView];
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(portraitCtrl);
        make.size.mas_equalTo(CGSizeMake(46.f, 46.f));
    }];
    
    UIImageView *gotoView = [[UIImageView alloc] init];
    [gotoView setImage:[UIImage imageNamed:@"shouye_gengduo"]];
    [portraitCtrl addSubview:gotoView];
    [gotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(portraitCtrl);
        make.left.equalTo(portraitView.mas_right).with.offset(10.f);
        make.centerY.equalTo(portraitView);
        make.size.mas_equalTo(CGSizeMake(6.f, 11.f));
    }];
    
    UIView *fullNameRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    
    UILabel *fullNameLabel = [self setupTitleLabelWithTitle:@"姓名"];
    [fullNameRow addSubview:fullNameLabel];
    [fullNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitLabel);
        make.centerY.equalTo(fullNameRow);
        make.height.mas_equalTo(fullNameLabel.font.pointSize);
    }];
    
    HPRightImageButton *fullNameGotoBtn = [self setupGotoBtnWithTitle:@"未填写"];
    [fullNameGotoBtn setTag:HPConfigGotoFullName];
    [fullNameRow addSubview:fullNameGotoBtn];
    _fullNameGotoBtn = fullNameGotoBtn;
    [fullNameGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(portraitCtrl);
        make.centerY.equalTo(fullNameLabel);
    }];
    
    UIView *companyRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    
    UILabel *companyLabel = [self setupTitleLabelWithTitle: @"公司名称"];
    [companyRow addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitLabel);
        make.centerY.equalTo(companyRow);
        make.height.mas_equalTo(companyLabel.font.pointSize);
    }];
    
    HPRightImageButton *companyGotoBtn = [self setupGotoBtnWithTitle:@"未填写"];
    [companyGotoBtn setTag:HPConfigGotoCompany];
    [companyRow addSubview:companyGotoBtn];
    _companyGotoBtn = companyGotoBtn;
    [companyGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(portraitCtrl);
        make.centerY.equalTo(companyLabel);
    }];
    
    UIView *contactRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:2.f * g_rateWidth isEnd:YES];
    
    UILabel *contactLabel = [self setupTitleLabelWithTitle:@"联系方式"];
    [contactRow addSubview:contactLabel];
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitLabel);
        make.centerY.equalTo(contactRow);
        make.height.mas_equalTo(contactLabel.font.pointSize);
    }];
    
    HPRightImageButton *contactGotoBtn = [self setupGotoBtnWithTitle:@"未填写"];
    [contactGotoBtn setTag:HPConfigGotoContact];
    [contactRow addSubview:contactGotoBtn];
    _contactGotoBtn = contactGotoBtn;
    [contactGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(portraitCtrl);
        make.centerY.equalTo(contactLabel);
    }];
}

- (void)setupAccountInfoPanel:(UIView *)view {
    HPLoginModel *model = [HPUserTool account];
    UIView *portraitRow = [self addRowOfParentView:view withHeight:63.f * g_rateWidth margin:0.f isEnd:NO];
    
    UILabel *portraitLabel = [self setupTitleLabelWithTitle:@"头像"];
    [portraitRow addSubview:portraitLabel];
    [portraitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitRow).with.offset(17.f * g_rateWidth);
        make.centerY.equalTo(portraitRow);
        make.height.mas_equalTo(portraitLabel.font.pointSize);
    }];
    
    UIButton *portraitView = [[UIButton alloc] init];
    [portraitView.layer setCornerRadius:23.f];
    [portraitView.layer setMasksToBounds:YES];
    [portraitView.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [portraitView addTarget:self action:@selector(onClickGotoCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [portraitRow addSubview:portraitView];
    
    if (model.userInfo.avatarUrl && model.userInfo.avatarUrl.length > 0 ) {
        [portraitView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.avatarUrl] forState:(UIControlState)UIControlStateNormal placeholderImage:ImageNamed(@"personal_center_not_login_head")];
    }
    else {
        [portraitView setImage:ImageNamed(@"personal_center_not_login_head") forState:UIControlStateNormal];
    }
    
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(portraitRow).with.offset(-17.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(46.f, 46.f));
        make.centerY.mas_equalTo(portraitRow);
    }];
    
    UIView *mailRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    
    UILabel *mailLabel = [self setupTitleLabelWithTitle:@"用户名(昵称)"];
    [mailRow addSubview:mailLabel];
    [mailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitLabel);
        make.centerY.equalTo(mailRow);
    }];
    
    HPRightImageButton *mailGotoBtn = [self setupGotoBtnWithTitle:model.userInfo.username.length > 0?model.userInfo.username: @"未填写"];
    [mailGotoBtn setTag:HPConfigGotoMail];
    [mailRow addSubview:mailGotoBtn];
    _mailGotoBtn = mailGotoBtn;
    [mailGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mailRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(mailRow);
    }];
    
    UIView *phoneNumRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    
    UILabel *phoneNumLabel = [self setupTitleLabelWithTitle:@"绑定手机"];
    [phoneNumRow addSubview:phoneNumLabel];
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitRow).with.offset(17.f * g_rateWidth);
        make.centerY.equalTo(phoneNumRow);
    }];
    
    HPRightImageButton *phoneNumGotoBtn = [self setupGotoBtnWithTitle:model.userInfo.mobile.length >0 ?model.userInfo.mobile:@"未绑定"];
    [phoneNumGotoBtn setTag:HPConfigGotoPhoneNum];
    [phoneNumRow addSubview:phoneNumGotoBtn];
    _phoneNumGotoBtn = phoneNumGotoBtn;
    [phoneNumGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneNumRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(phoneNumRow);
    }];
    
    UIView *passwordRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:10.f * g_rateWidth isEnd:YES];
    
    UILabel *passwordLabel = [self setupTitleLabelWithTitle:@"登录密码"];
    [passwordRow addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordRow).with.offset(17.f * g_rateWidth);
        make.centerY.equalTo(passwordRow);
    }];
    
    HPRightImageButton *passwordGotoBtn = [self setupGotoBtnWithTitle:@"未设置"];
    [passwordGotoBtn setTag:HPConfigGotoPassword];
    [passwordRow addSubview:passwordGotoBtn];
    _passwordGotoBtn = passwordGotoBtn;
    [passwordGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passwordRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(passwordRow);
    }];
}

- (void)setupVersionPanel:(UIView *)view {
    UIView *versionRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:10.f * g_rateWidth isEnd:NO];
    
    UILabel *versionLabel = [self setupTitleLabelWithTitle:@"版本信息"];
    [versionRow addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(versionRow).with.offset(17.f * g_rateWidth);
        make.centerY.equalTo(versionRow);
    }];
    
    HPRightImageButton *versionGotoBtn = [self setupGotoBtnWithTitle:kAppVersion?[NSString stringWithFormat:@"V%@",kAppVersion]:@"V1.0.0"];
    [versionGotoBtn setTag:HPConfigGotoVersion];
    [versionRow addSubview:versionGotoBtn];
    _versionGotoBtn = versionGotoBtn;
    [versionGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(versionRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(versionRow);
    }];
    
    UIView *cacheRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:10.f * g_rateWidth isEnd:YES];
    
    UILabel *cacheLabel = [self setupTitleLabelWithTitle:@"清理缓存"];
    [cacheRow addSubview:cacheLabel];
    [cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(versionLabel);
        make.centerY.equalTo(cacheRow);
    }];
    
    HPRightImageButton *cacheGotoBtn = [self setupGotoBtnWithTitle:@"0MB"];
    [cacheGotoBtn setTag:HPConfigGotoCache];
    [cacheRow addSubview:cacheGotoBtn];
    _cacheGotoBtn = cacheGotoBtn;
    [cacheGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(versionGotoBtn);
        make.centerY.equalTo(cacheRow);
    }];
}

#pragma mark - setupCommonUI

- (void)setupShadowOfPanel:(UIView *)view {
    [view.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [view.layer setShadowRadius:6.f];
    [view.layer setShadowOpacity:0.3f];
    [view.layer setCornerRadius:6.f];
    [view setBackgroundColor:UIColor.whiteColor];
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

- (void)onClickAlbumOrPhotoSheetWithTag:(NSInteger)tag {
    if (tag == 0) {
        if (self.photoPicker == nil) {
            UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
            [photoPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [photoPicker setDelegate:self];
            photoPicker.allowsEditing = YES;
            self.photoPicker = photoPicker;
        }
        
        [self presentViewController:self.photoPicker animated:YES completion:nil];
    }
    else if (tag == 1) {
        if (self.imagePicker == nil) {
            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
            [imagePicker setNaviBgColor:COLOR_RED_FF3C5E];
            [imagePicker setNaviTitleColor:UIColor.whiteColor];
            [imagePicker setIconThemeColor:COLOR_RED_FF3C5E];
            [imagePicker setOKButtonTitleColorNormal:COLOR_RED_FF3C5E];
            [imagePicker setOKButtonTitleColorDisabled:COLOR_GRAY_999999];
            [imagePicker.view setNeedsDisplay];
            imagePicker.maxImagesCount = 1;
            self.imagePicker = imagePicker;
        }
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}
#pragma mark - OnClick

- (void)onClickGotoCtrl:(UIControl *)ctrl {
    switch (ctrl.tag) {
        case HPConfigGotoPortrait:
            NSLog(@"HPConfigGotoPortrait");
            [self.alertSheet show:YES];
            break;
            
        case HPConfigGotoFullName:
            NSLog(@"HPConfigGotoFullName");

            break;
            
        case HPConfigGotoCompany:
            NSLog(@"HPConfigGotoCompany");
            break;
            
        case HPConfigGotoContact:
            NSLog(@"HPConfigGotoContact");
            break;
            
        case HPConfigGotoUserName:
//            [self pushVCByClassName:@"HPConfigUserNameController"];
            break;
            
        case HPConfigGotoMail:
//            NSLog(@"HPConfigGotoMail");
            [self pushVCByClassName:@"HPConfigUserNameController" withParam:@{@"title":@"设置您的用户名"}];

            break;
            
        case HPConfigGotoPhoneNum:
            [self pushVCByClassName:@"HPUnbindPhoneController"];
            break;
        
        case HPConfigGotoPassword:
            NSLog(@"HPConfigGotoPassword");
            [self pushVCByClassName:@"HPForgetPasswordController" withParam:@{@"isForget":@"1"}];
            break;
            
        case HPConfigGotoAddBtn:
            NSLog(@"HPConfigGotoAddBtn");
            [self getProfessionalDetailView:ctrl];
            break;
            
        case HPConfigGotoVersion:
            NSLog(@"HPConfigGotoVersion");
            break;
            
        case HPConfigGotoCache:
            NSLog(@"HPConfigGotoCache");
            [self setUpAlertViewForWarning];
            break;
            
        default:
            break;
    }
}

#pragma mark - 专属顾问 有无 切换按钮
- (void)getProfessionalDetailView:(UIControl *)ctrl
{
    // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
    
    __block UITextField *fessionField = nil;
    
    [LEEAlert alert].config.LeeAddTextField(^(UITextField *textField) {
        
        // 这里可以进行自定义的设置
        
        textField.placeholder = @"请输入专属顾问号";
        
        textField.textColor = [UIColor darkGrayColor];
        
        fessionField = textField; //赋值
        self.fessionField = fessionField;
        self.fessionField.delegate = self;
    }).LeeCancelAction(@"取消", ^{
        
    })
    .LeeAction(@"确认", ^{
        [self getUserToAddUserProducter];
    })
    .LeeShow(); // 设置完成后 别忘记调用Show来显示
}

#pragma mark - 更改详情顾问 约束
- (void)layoutProfessionFrame
{
    [self.versionPanel mas_updateConstraints:^(MASConstraintMaker *make) {
        [self.versionTop uninstall];
        make.top.mas_equalTo(self.professDetailPanel.mas_bottom).offset(getWidth(15.f));
    }];
}

#pragma mark - 确定清除缓存数据
- (void)setUpAlertViewForWarning
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确定要清理缓存吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    //添加确定
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
        NSLog(@"确定");
        HPClearCacheTool *tool = [HPClearCacheTool new];
        [tool clearFile];
        CGFloat cashSize = [HPClearCacheTool readCacheSize];
        NSString *cacheStr = [NSString stringWithFormat:@"%.2fMB",cashSize];
        [self setText:cacheStr.length>0 ?cacheStr:@"16.8MB" ofBtnWithType:HPConfigGotoCache];
        [self dismissViewControllerAnimated:YES completion:NULL];

    }];
    //设置`确定`按钮的颜色
    [sureBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
    //将action添加到控制器
    [alertVc addAction:cancelBtn];
    [alertVc addAction :sureBtn];
    //展示
    [self presentViewController:alertVc animated:YES completion:nil];
    
}
#pragma mark - SetInfo

- (void)setPortrait:(UIImage *)image {
    [_portraitView setImage:image];
}

- (void)setText:(NSString *)text ofBtnWithType:(HPConfigGoto)type {
    HPRightImageButton *btn = nil;
    
    switch (type) {
        case HPConfigGotoFullName:
            btn = _fullNameGotoBtn;
            break;
            
        case HPConfigGotoCompany:
            btn = _companyGotoBtn;
            break;
            
        case HPConfigGotoContact:
            btn = _contactGotoBtn;
            break;
            
        case HPConfigGotoUserName:
            btn = _userNameGotoBtn;
            break;
            
        case HPConfigGotoMail:
            btn = _mailGotoBtn;
            break;
            
        case HPConfigGotoPhoneNum:
            btn = _phoneNumGotoBtn;
            break;
            
        case HPConfigGotoPassword:
            btn = _passwordGotoBtn;
            break;
            
        case HPConfigGotoVersion:
            btn = _versionGotoBtn;
            break;
            
        case HPConfigGotoCache:
            btn = _cacheGotoBtn;
            break;
            
        default:
            break;
    }
    
    if (btn) {
        [btn setSelectedText:text];
        [btn setSelected:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    _photo = photo;
    [self dismissViewControllerAnimated:self.photoPicker completion:nil];
    [self uploadLocalImageGetAvatarUrl];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    picker.allowCrop = YES;
    UIImage *photo = photos[0];
    _photo = photo;
    [self uploadLocalImageGetAvatarUrl];
}

#pragma  mark - 上传一张图片
- (void)uploadLocalImageGetAvatarUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/file/uploadPicture",kBaseUrl];//放上传图片的网址
    NSString *historyTime = [HPTimeString getNowTimeTimestamp];
    [HPUploadImageHandle sendPOSTWithUrl:url withLocalImage:_photo isNeedToken:YES parameters:@{@"file":historyTime} success:^(id data) {
        NSString *url = [data[@"data"]firstObject][@"url"]?:@"";
        if (url) {
            [self onClickChangeUpdateUser:url];
        }
    } fail:^(NSError *error) {
        ErrorNet
    }];
    
}

#pragma mark - 完成修改密码操作
- (void)onClickChangeUpdateUser:(NSString *)avatarUrl
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"avatarUrl"] = avatarUrl;
    HPLoginModel *account = [HPUserTool account];
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/updateUser" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            HPLoginModel *model = [HPLoginModel mj_objectWithKeyValues:responseObject[@"data"]];
            HPUserInfo *userInfo = [[HPUserInfo alloc] init];
            userInfo.avatarUrl = responseObject[@"data"][@"avatarUrl"]?:@"";
            userInfo.password = account.userInfo.password?:@"";
            userInfo.username = account.userInfo.username?:@"";
            userInfo.userId = account.userInfo.userId?:@"";
            userInfo.mobile = account.userInfo.mobile?:@"";
            account.userInfo = userInfo;
            [HPUserTool saveAccount:account];
            [HPProgressHUD alertMessage:@"头像修改成功"];
            [self.portraitView sd_setImageWithURL:[NSURL URLWithString:model.cardInfo.avatarUrl] placeholderImage:ImageNamed(@"my_business_card_default_head_image")];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - 查询绑定的业务员-----------业务员相关网络请求
- (void)queryOnlineProducters
{
    HPLoginModel *account = [HPUserTool account];
    [HPHTTPSever HPGETServerWithMethod:@"/v1/salesman/query" isNeedToken:YES paraments:@{@"userId":account.userInfo.userId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - 进行用户绑定业务员 判断操作
- (void)getUserToAddUserProducter
{
    if (_fessionField.text.length <= 4) {
        [HPProgressHUD alertMessage:@"请输入四位业务员编码"];
    }else{
        [self addUserProducter];
    }
}

#pragma mark - 用户绑定业务员
- (void)addUserProducter
{
    HPLoginModel *account = [HPUserTool account];
    [HPHTTPSever HPPostServerWithMethod:@"/v1/salesman/addUser" paraments:@{@"staffCode":_fessionField.text,@"userId":account.userInfo.userId} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.addBtn setText:@"去更改"];

            [self layoutProfessionFrame];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Progress:nil Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - uitextfielddelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _fessionField) {
        if (textField.text.length < 4) {
            [HPProgressHUD alertMessage:@"请输入四位顾问编码"];
        }else{
            textField.text = [textField.text substringToIndex:textField.text.length -1];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _fessionField) {
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:textField.text.length -1];
            [HPProgressHUD alertMessage:@"顾问编码不得超过四位"];
        }
    }
    return YES;
}
@end
