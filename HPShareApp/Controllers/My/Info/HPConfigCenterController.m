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
#import "HPQueryproductersModel.h"
#import "HPTextDialogView.h"
#import <JMessage/JMessage.h>
#import "HPSingleton.h"

#import "HPUpdateVersionView.h"

#import "HPUpdateVersionTool.h"

#import "HPGradientUtil.h"

typedef NS_ENUM(NSInteger, HPConfigGoto) {
    HPConfigGotoPortrait = 0,
    HPConfigGotoFullName,
    HPConfigGotoCompany,
    HPConfigGotoContact,
    HPConfigGotoUserName,
    HPConfigGotoMail,
    HPConfigGotoPhoneNum,
    HPConfigGotoThirdAccount,
    HPConfigGotoDeleteAccount,
    HPConfigGotoPassword,
    HPConfigGotoVersion,
    HPConfigGotoCache,
    HPConfigGotoAddBtn
};

@interface HPConfigCenterController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) HPTextDialogView *textDialogView;
@property (nonatomic, strong) UIView *accountInfoPanel;
@property (nonatomic, weak) UIImageView *portraitView;
@property (nonatomic, strong) UIView *professDetailPanel;
@property (nonatomic, strong) UIView *versionPanel;
@property (nonatomic, strong) HPQueryproductersModel *model;
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

//专属顾问详情view
@property (strong, nonatomic) UIView *detailPanel;
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

@property (nonatomic, weak) HPAlertSheet *outLoginSheet;

/**
 获取到的图片
 */
@property (nonatomic, strong) UIImage *photo;

@property (nonatomic, weak) HPUpdateVersionView *updateView;

@property (strong, nonatomic) UIView *professDetailRow;

@property (strong, nonatomic) UIButton *callBtn;
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
    [self setText:kAppVersion?[NSString stringWithFormat:@"V%@",kAppVersion]:@"V1.0.0" ofBtnWithType:HPConfigGotoVersion];
    [self setText:cacheStr.length>0 ?cacheStr:@"16.8MB" ofBtnWithType:HPConfigGotoCache];
    //查询绑定的业务员
    [self queryOnlineProducters];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    kWEAKSELF
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
    
    HPAlertSheet *outLoginSheet = [[HPAlertSheet alloc] init];
     HPAlertAction *outLoginAction = [[HPAlertAction alloc] initWithTitle:@"退出登录" completion:^{
        [weakSelf onClickOutLoginSheetWithTag:3];
    }];
    [outLoginSheet addAction:outLoginAction];
    self.outLoginSheet = outLoginSheet;
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];

    UIButton *backBtn = [UIButton new];
    [backBtn setImage:ImageNamed(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];

    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
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
    [accountInfoLabel setText:@"账号信息管理"];
    [scrollView addSubview:accountInfoLabel];
    [accountInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(19.f * g_rateWidth);
        make.left.equalTo(scrollView).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(accountInfoLabel.font.pointSize);
    }];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR(235, 3, 3, 1) endColor:COLOR(235, 3, 3, 0)];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIButton *colorBtn = [[UIButton alloc] init];
    [colorBtn.layer setCornerRadius:2.f];
    [colorBtn.layer setMasksToBounds:YES];
    [colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [scrollView addSubview:colorBtn];
    [colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).with.offset(getWidth(20.f));
        make.top.equalTo(accountInfoLabel.mas_bottom).offset(getWidth(12.f));
        make.size.mas_equalTo(btnSize);
    }];
    
    //账号管理
    UIView *accountInfoPanel = [[UIView alloc] init];
//    [self setupShadowOfPanel:accountInfoPanel];
    accountInfoPanel.layer.borderColor = COLOR_GRAY_EEEEEE.CGColor;
    accountInfoPanel.layer.borderWidth = 1;
    [scrollView addSubview:accountInfoPanel];
    self.accountInfoPanel = accountInfoPanel;
    [accountInfoPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(colorBtn.mas_bottom ).with.offset(getWidth(30.f));
        make.centerX.equalTo(scrollView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self setupAccountInfoPanel:accountInfoPanel];
    
    //专属顾问
    UIView *professionalPanel = [[UIView alloc] init];
//    [self setupShadowOfPanel:professionalPanel];
    [scrollView addSubview:professionalPanel];
    [professionalPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountInfoPanel.mas_bottom).with.offset(1);
        make.left.equalTo(self.accountInfoPanel);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(180.f * g_rateWidth);
    }];
    
    [self setupThirdAccountProfessionalPanel:professionalPanel];
    
    //专属顾问详情view
    UIView *detailPanel = [[UIView alloc] init];
    [scrollView addSubview:detailPanel];
    self.detailPanel = detailPanel;

    [detailPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(professionalPanel.mas_bottom).with.offset(1);
        make.left.equalTo(self.accountInfoPanel);
        make.width.mas_equalTo(345.f * g_rateWidth);
        make.height.mas_equalTo(64.f * g_rateWidth);
    }];
    [self setUpGuWenView:detailPanel];
    
    [self.detailPanel addSubview:self.professDetailRow];
    
    [self.professDetailRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //版本控制
    UIView *versionPanel = [[UIView alloc] init];
//    [self setupShadowOfPanel:versionPanel];
    versionPanel.layer.borderWidth = 1;
    versionPanel.layer.borderColor = COLOR_GRAY_EEEEEE.CGColor;
    [scrollView addSubview:versionPanel];
    _versionPanel = versionPanel;
    [versionPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        MASConstraint *versionTop = make.top.equalTo(self.detailPanel.mas_bottom).with.offset(1);
        self.versionTop = versionTop;
        make.centerX.equalTo(scrollView);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self setupVersionPanel:versionPanel];
    
    //切换账号-退出登录
    UIButton *switchBtn = [[UIButton alloc] init];
    [switchBtn.layer setCornerRadius:24.f * g_rateWidth];
    [switchBtn.titleLabel setFont:kFont_Medium(16.f)];
    [switchBtn setTitleColor:COLOR_ORANGE_EB0404 forState:UIControlStateNormal];
    [switchBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    switchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [switchBtn addTarget:self action:@selector(swithAccountOfOthers:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionPanel.mas_bottom).with.offset(35.f * g_rateWidth);
        make.left.mas_equalTo(getWidth(18.f));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2,getWidth(50.f)));
        make.bottom.equalTo(scrollView).with.offset(-30.f * g_rateWidth);
    }];
}

//专属顾问详情view
- (void)setUpGuWenView:(UIView *)rowView
{
    //专属顾问详情
    UIView *professDetailRow = [self addRowOfParentView:rowView withHeight:64.f * g_rateWidth margin:0.f isEnd:NO];
    professDetailRow.backgroundColor = COLOR_GRAY_F9F9F9;
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = ImageNamed(@"my_business_card_default_head_image");
    [professDetailRow addSubview:userIcon];
    self.userIcon = userIcon;
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(6.f));
        make.width.height.mas_equalTo(getWidth(38.f));
        make.centerY.mas_equalTo(professDetailRow);
    }];
    
    UILabel *fessionnameLabel = [UILabel new];
    fessionnameLabel.font = kFont_Medium(16.f);
    fessionnameLabel.textColor = COLOR_BLACK_444444;
    fessionnameLabel.textAlignment = NSTextAlignmentLeft;
    fessionnameLabel.text = @"--";
    [professDetailRow addSubview:fessionnameLabel];
    self.fessionnameLabel = fessionnameLabel;
    [fessionnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).offset(getWidth(12.f));
        make.top.mas_equalTo(getWidth(16.f));
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
        make.left.mas_equalTo(userIcon.mas_right).offset(getWidth(12.f));
        make.bottom.mas_equalTo(userIcon.mas_bottom);
        make.right.mas_equalTo(professDetailRow).offset(getWidth(-65.f));
        make.height.mas_equalTo(fessionnameLabel.font.pointSize);
    }];
    
    UIButton *callBtn = [UIButton new];
    [callBtn setBackgroundImage:ImageNamed(@"call") forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callProfessional:) forControlEvents:UIControlEventTouchUpInside];
    [professDetailRow addSubview:callBtn];
    self.callBtn= callBtn;
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(30.f), getWidth(30.f)));
        make.right.mas_equalTo(getWidth(-18.f));
        make.centerY.mas_equalTo(professDetailRow);
    }];
    self.professDetailRow = professDetailRow;

}

#pragma mark - 第三方账号+专属顾问标题view
- (void)setupThirdAccountProfessionalPanel:(UIView *)panel
{
    HPLoginModel *account = [HPUserTool account];
    UIView *phoneNumRow = [self addRowOfParentView:panel withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    
    UILabel *phoneNumLabel = [self setupTitleLabelWithTitle:@"绑定手机"];
    [phoneNumRow addSubview:phoneNumLabel];
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumRow).with.offset(17.f * g_rateWidth);
        make.centerY.equalTo(phoneNumRow);
    }];
    
    HPRightImageButton *phoneNumGotoBtn = [self setupGotoBtnWithTitle:account.userInfo.mobile.length >0 ?account.userInfo.mobile:@"未绑定"];
    [phoneNumGotoBtn setTag:HPConfigGotoPhoneNum];
    [phoneNumRow addSubview:phoneNumGotoBtn];
    _phoneNumGotoBtn = phoneNumGotoBtn;
    [phoneNumGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneNumRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(phoneNumRow);
    }];
    
    //三方账号绑定
    UIView *thirdAccountRow = [self addRowOfParentView:panel withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    UILabel *accountLabel = [self setupTitleLabelWithTitle:@"第三方账号绑定"];
    [thirdAccountRow addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdAccountRow).with.offset(17.f * g_rateWidth);
        make.centerY.equalTo(thirdAccountRow);
    }];
    
    HPRightImageButton *thirdGotoBtn = [self setupGotoBtnWithTitle:account.userInfo.mobile.length >0 ?account.userInfo.mobile:@"未绑定"];
    [thirdGotoBtn setTag:HPConfigGotoThirdAccount];
    [thirdAccountRow addSubview:thirdGotoBtn];
    [thirdGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(thirdAccountRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(thirdAccountRow);
    }];
    
    //账号注销
    UIView *deleteAccountRow = [self addRowOfParentView:panel withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    UILabel *deleteAccountLabel = [self setupTitleLabelWithTitle:@"账号注销"];
    [deleteAccountRow addSubview:deleteAccountLabel];
    [deleteAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deleteAccountRow).with.offset(17.f * g_rateWidth);
        make.centerY.equalTo(deleteAccountRow);
    }];
    
    HPRightImageButton *deleteGotoBtn = [self setupGotoBtnWithTitle:@"申请注销"];
    [deleteGotoBtn setTag:HPConfigGotoDeleteAccount];
    [deleteAccountRow addSubview:deleteGotoBtn];
    [deleteGotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleteAccountRow).with.offset(-17.f * g_rateWidth);
        make.centerY.equalTo(deleteAccountRow);
    }];
    
    UIView *professionalRow = [self addRowOfParentView:panel withHeight:45.f * g_rateWidth margin:0.f isEnd:NO];
    UILabel *professionalLabel = [self setupTitleLabelWithTitle:@"合派专属顾问"];
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

#pragma mark - 拨打业务员电话
- (void)callProfessional:(UIButton *)button
{
    if (_customerServiceModalView == nil) {
        HPCustomerServiceModalView *customerServiceModalView = [[HPCustomerServiceModalView alloc] initWithParent:self.parentViewController.view];
        customerServiceModalView.phone = self.model.mobile?self.model.mobile: @"0755-86566389";
        [customerServiceModalView setPhoneString:self.model.mobile?self.model.mobile: @"0755-86566389"];
        _customerServiceModalView = customerServiceModalView;
    }
    
    [_customerServiceModalView show:YES];
    [self.parentViewController.view bringSubviewToFront:_customerServiceModalView]; 
}

#pragma mark - 切换账号
- (void)swithAccountOfOthers:(UIButton *)button
{
    
    [self.outLoginSheet setCancelTextColor:COLOR_BLACK_333333];
    [self.outLoginSheet setCancelTextFont:kFont_Medium(16.f)];
    
    [self.outLoginSheet show:YES];

}

- (void)onClickOutLoginSheetWithTag:(NSInteger)tag
{
    if (tag == 3) {
        [self switchAccount];

    }
}

- (void)switchAccount
{
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/logOut" isNeedToken:YES paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPUserTool deleteAccount];
            [JMSGUser logout:^(id resultObject, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        HPLog(@"Action logout success");
                        [HPSingleton sharedSingleton].identifyTag = 0;
                    }
                });
            }];
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
    
    /*
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
    }];*/
    
    UIView *passwordRow = [self addRowOfParentView:view withHeight:45.f * g_rateWidth margin:10.f * g_rateWidth isEnd:YES];
    
    UILabel *passwordLabel = [self setupTitleLabelWithTitle:@"修改密码"];
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
            HPLog(@"HPConfigGotoPortrait");
            
            [self.alertSheet show:YES];
            break;
            
        case HPConfigGotoFullName:
            HPLog(@"HPConfigGotoFullName");

            break;
            
        case HPConfigGotoCompany:
            HPLog(@"HPConfigGotoCompany");
            break;
            
        case HPConfigGotoContact:
            HPLog(@"HPConfigGotoContact");
            break;
            
        case HPConfigGotoUserName:
//            [self pushVCByClassName:@"HPConfigUserNameController"];
            break;
            
        case HPConfigGotoMail:
//            HPLog(@"HPConfigGotoMail");
            [self pushVCByClassName:@"HPConfigUserNameController" withParam:@{@"title":@"设置您的用户名"}];

            break;
            
        case HPConfigGotoPhoneNum:
            [self pushVCByClassName:@"HPUnbindPhoneController"];
            break;
        
        case HPConfigGotoThirdAccount://三方账号绑定
            HPLog(@"sanfang ");
            [self pushVCByClassName:@"HPAccountBindViewController"];
            break;
            
        case HPConfigGotoDeleteAccount://绑定注销
            HPLog(@"注销 ");
            [self pushVCByClassName:@"HPCancelViewController"];
            break;
        case HPConfigGotoPassword:
            HPLog(@"HPConfigGotoPassword");
            [self pushVCByClassName:@"HPForgetPasswordController" withParam:@{@"isForget":@"1"}];
            break;
            
        case HPConfigGotoAddBtn:
            HPLog(@"HPConfigGotoAddBtn");
            if ([self.addBtn.text isEqualToString:@"更改"]) {
                [HPProgressHUD alertMessage:@"暂时不支持更改"];
            }else{
                [self getProfessionalDetailView:ctrl];
            }
            break;
            
        case HPConfigGotoVersion:
            HPLog(@"HPConfigGotoVersion");
            [self updateAppVersionInfo];
            break;
            
        case HPConfigGotoCache:
            HPLog(@"HPConfigGotoCache");
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
    [self.detailPanel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    self.fessionnameLabel.hidden = YES;
    self.userIcon.hidden = YES;
    self.fessionInfoLabel.hidden = YES;
    self.callBtn.hidden = YES;

}

#pragma mark - 确定清除缓存数据
- (void)setUpAlertViewForWarning
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确定要清理缓存吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        HPLog(@"取消");
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    //添加确定
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
        HPLog(@"确定");
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
    [HPProgressHUD alertWithLoadingText:@"加载中..."];
    HPLoginModel *account = [HPUserTool account];
    [HPHTTPSever HPGETServerWithMethod:@"/v1/salesman/query" isNeedToken:YES paraments:@{@"userId":account.userInfo.userId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {

            self.model = [HPQueryproductersModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (self.model) {
                [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:ImageNamed(@"my_business_card_default_head_image")];
                self.fessionnameLabel.text = self.model.salesmanName;
                [self layoutProfessionFrame];
                [HPProgressHUD alertWithFinishText:@"加载完成"];
                [self.addBtn setText:@"更改"];
            }else{
//                [HPProgressHUD alertMessage:@"请添加业务员"];
                [self.addBtn setText:@"去添加"];

            }
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
    if (_fessionField.text.length < 4) {
        [HPProgressHUD alertMessage:@"请输入四位业务员编码"];
    }else{
        [self addUserProducter];
    }
}

#pragma mark - 用户绑定业务员
- (void)addUserProducter
{
    HPLoginModel *account = [HPUserTool account];
    
    NSDictionary *param = @{@"staffCode":_fessionField.text,@"userId":@([account.userInfo.userId intValue])};
    
    [HPHTTPSever HPPostServerWithMethod:@"/v1/salesman/addUser" paraments:param needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.addBtn setText:@"更改"];
            [HPProgressHUD alertMessage:@"绑定成功"];
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
            [HPProgressHUD alertMessage:@"请输入四位业务员编码"];
        }else{
            textField.text = [textField.text substringToIndex:textField.text.length];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _fessionField) {
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:textField.text.length -1];
            [HPProgressHUD alertMessage:@"业务员编码不得超过四位"];
        }
    }
    return YES;
}

#pragma mark - 检测版本更新信息
- (void)updateAppVersionInfo
{
    BOOL isUpdate = [HPUpdateVersionTool updateAppVersionTool];
    if (isUpdate) {
        [self showAlert];
    }else{
        [HPProgressHUD alertMessage:@"已是最新版本"];
    }
}

/**
 *  检查新版本更新弹框
 */
-(void)showAlert
{
    if (_updateView == nil) {
        kWEAKSELF
        HPUpdateVersionView *updateView = [[HPUpdateVersionView alloc] initWithParent:self.view];
        
        [updateView setUpdateBlock:^{
            // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", kAppleId]];
            [[UIApplication sharedApplication] openURL:url];
            
        }];
        
        [updateView setCloseBlcok:^{
            [weakSelf.updateView removeFromSuperview];
        }];
        _updateView = updateView;
    }
    
    [_updateView show:YES];
    
}

@end
