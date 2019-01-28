//
//  HPMyController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMyController.h"
#import "HPAlignCenterButton.h"
#import "HPProgressHUD.h"
#import "HPMyCardController.h"
#import "HPCustomerServiceModalView.h"
#import "HPUploadImageHandle.h"
#import "HPTimeString.h"
#import "HPUploadImageHandle.h"
#import "HPPersonCenterModel.h"
#import "UIButton+WebCache.h"

@interface HPMyController ()

@property (nonatomic, weak) UIButton *portraitBtn;

@property (nonatomic, weak) UIButton *loginBtn;

@property (nonatomic, weak) UIButton *descLabel;

@property (nonatomic, weak) UIButton *certificateBtn;

@property (nonatomic, weak) UIView *certificationView;

@property (nonatomic, weak) UILabel *keepNumLabel;

@property (nonatomic, weak) UILabel *followNumLabel;

@property (nonatomic, weak) UILabel *historyNumLabel;

@property (nonatomic, weak) HPCustomerServiceModalView *customerServiceModalView;
@property (nonatomic, strong) NSMutableArray *userInfoArray;

@property (nonatomic, strong) HPPersonCenterModel *infoModel;

/**
 共享管理条数
 */
@property (nonatomic, strong) UILabel *spacenum;
@end

@implementation HPMyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfosListData];
}
- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}
- (void)setUserInfo
{
    HPLoginModel *model = [HPUserTool account];

    if (model.token) {
        [_portraitBtn sd_setImageWithURL:[NSURL URLWithString:model.userInfo.avatarUrl] forState:UIControlStateNormal placeholderImage:ImageNamed(@"personal_center_not_login_head")];
        [_loginBtn setTitle:model.userInfo.username.length > 0? model.userInfo.username:@"未填写" forState:UIControlStateDisabled];
        [_loginBtn setEnabled:NO];
        [_keepNumLabel setText:[NSString stringWithFormat:@"%ld",_infoModel.collectionNum]?:@"--"];
        [_followNumLabel setText:[NSString stringWithFormat:@"%ld",_infoModel.followingNum]?:@"--"];
        [_historyNumLabel setText:[NSString stringWithFormat:@"%ld",_infoModel.browseNum]?:@"--"];
        
        if (_infoModel.spaceNum) {
            NSString *spaceNumStr = [NSString stringWithFormat:@"%ld条",_infoModel.spaceNum];
            [_spacenum setText:spaceNumStr];
        }

        [_descLabel setHidden:YES];
        
        if (g_isCertified) {
            [_certificationView setHidden:NO];
        }
        else {
            [_certificateBtn setHidden:NO];
        }
    }
    else {
        [_certificationView setHidden:YES];
        [_certificateBtn setHidden:YES];
        [_descLabel setHidden:NO];
        [_loginBtn setEnabled:YES];
        [_portraitBtn setImage:[UIImage imageNamed:@"personal_center_not_login_head"] forState:UIControlStateNormal];
        [_keepNumLabel setText:@"--"];
        [_followNumLabel setText:@"--"];
        [_historyNumLabel setText:@"--"];
    }
    
    if (model.userInfo.avatarUrl.length <= 0 && model.token) {
        [self uploadLocalImageGetAvatarUrl];
    }
}
#pragma  mark - 上传一张图片
- (void)uploadLocalImageGetAvatarUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/file/uploadPicture",kBaseUrl];//放上传图片的网址
    HPLoginModel *account = [HPUserTool account];
    NSString *historyTime = [HPTimeString getNowTimeTimestamp];
    UIImage *image = [UIImage imageNamed:@"personal_center_not_login_head"];
    [HPUploadImageHandle sendPOSTWithUrl:url withLocalImage:image isNeedToken:YES parameters:@{@"file":historyTime} success:^(id data) {
        
         HPUserInfo *userInfo = [[HPUserInfo alloc] init];
         userInfo.avatarUrl = [data[@"data"]firstObject][@"url"]?:@"";
         userInfo.password = account.userInfo.password?:@"";
         userInfo.username = account.userInfo.username?:@"";
         userInfo.userId = account.userInfo.userId?:@"";
         userInfo.mobile = account.userInfo.mobile?:@"";
         account.userInfo = userInfo;
         [HPUserTool saveAccount:account];
    } fail:^(NSError *error) {
        ErrorNet
    }];
    
}

#pragma mark - 获取个心中心统计数据
- (void)getUserInfosListData
{
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/center" isNeedToken:YES paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            weakSelf.infoModel = [HPPersonCenterModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (weakSelf.infoModel) {
                [self setUserInfo];
            }
        }else{
            [self setUserInfo];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setupUI {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"my_bg"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(-1);
        make.top.mas_equalTo(-1);
        make.right.equalTo(self.view).offset(1);
        if (iPhone5) {
            make.height.mas_equalTo(getHeight(300.f));
        }else{
            make.height.mas_equalTo(getHeight(250.f));
        }
    }];
    
    UIImageView *configIcon = [[UIImageView alloc] init];
    [configIcon setImage:[UIImage imageNamed:@"personal_center_set_up"]];
    [self.view addSubview:configIcon];
    [configIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 15.f * g_rateHeight);
        make.right.equalTo(self.view).with.offset(-20.f * g_rateWidth);
    }];
    
    UIButton *configBtn = [[UIButton alloc] init];
    [configBtn addTarget:self action:@selector(onClickConfigBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:configBtn];
    [configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50.f * g_rateWidth, 50.f * g_rateWidth));
    }];
    
    UIButton *portraitBtn = [[UIButton alloc] init];
    [portraitBtn.layer setCornerRadius:36.f * g_rateWidth];
    portraitBtn.layer.masksToBounds = YES;
    [portraitBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [portraitBtn setImage:[UIImage imageNamed:@"personal_center_not_login_head"] forState:UIControlStateNormal];
    [portraitBtn addTarget:self action:@selector(onClickConfigBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:portraitBtn];
    _portraitBtn = portraitBtn;
    [portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 45.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(72.f * g_rateWidth, 72.f * g_rateWidth));
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(onClickConfigBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    _loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portraitBtn.mas_bottom).with.offset(5.f);
        make.centerX.equalTo(portraitBtn);
    }];
    
    UIButton *descLabel = [[UIButton alloc] init];
    [descLabel.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel.titleLabel setTextColor:COLOR_PINK_FFC5C4];
    [descLabel setTitle:@"登录即可免费发布共享信息" forState:UIControlStateNormal];
    [descLabel addTarget:self action:@selector(onClickConfigBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:descLabel];
    _descLabel = descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(5.f);
        make.centerX.equalTo(loginBtn);
        make.height.mas_equalTo(descLabel.titleLabel.font.pointSize);
    }];
    
    UIButton *certificateBtn = [[UIButton alloc] init];
    [certificateBtn.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [certificateBtn setTitleColor:COLOR_PINK_FFC5C4 forState:UIControlStateNormal];
    [certificateBtn setTitle:@"完成实名认证，提高共享成功率" forState:UIControlStateNormal];
    [certificateBtn setImage:[UIImage imageNamed:@"personal_center_towards_the_right"] forState:UIControlStateNormal];
    [certificateBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 176.f, 0.f, -176.f)];
    [certificateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -5.f, 0.f, 5.f)];
    [certificateBtn addTarget:self action:@selector(onClickCertificateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:certificateBtn];
    _certificateBtn = certificateBtn;
    [certificateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(descLabel);
    }];
    [certificateBtn setHidden:YES];
    
    UIView *certificationView = [self setupCertificationView];
    [self.view addSubview:certificationView];
    _certificationView = certificationView;
    [certificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(descLabel);
    }];
    [certificationView setHidden:YES];
    
    UIView *collectionPanel = [[UIView alloc] init];
    [collectionPanel.layer setCornerRadius:10.f];
    [collectionPanel.layer setShadowColor:COLOR_GRAY_E5E5E5.CGColor];
    [collectionPanel.layer setShadowOffset:CGSizeMake(0.f, 2.f)];
    [collectionPanel.layer setShadowRadius:15.f];
    [collectionPanel.layer setShadowOpacity:0.45f];
    [collectionPanel setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:collectionPanel];
    [collectionPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 90.f * g_rateWidth));
    }];
    [self setupCollectioinPanel:collectionPanel];
    
    UIView *functionPanel = [[UIView alloc] init];
    [functionPanel.layer setCornerRadius:10.f];
    [functionPanel.layer setShadowColor:COLOR_GRAY_E5E5E5.CGColor];
    [functionPanel.layer setShadowOffset:CGSizeMake(0.f, 2.f)];
    [functionPanel.layer setShadowRadius:15.f];
    [functionPanel.layer setShadowOpacity:0.45f];
    [functionPanel setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:functionPanel];
    [functionPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionPanel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 260.f * g_rateWidth));
    }];
    [self setupFunctionPanel:functionPanel];
}

- (UIView *)setupCertificationView {
    UIView *view = [[UIView alloc] init];
    
    UIView *verifiedView = [[UIView alloc] init];
    [verifiedView.layer setCornerRadius:9.f];
    [verifiedView setBackgroundColor:[COLOR_BLACK_333333 colorWithAlphaComponent:0.25f]];
    [view addSubview:verifiedView];
    [verifiedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(95.f, 17.f));
    }];
    
    UIImageView *verifiedIcon = [[UIImageView alloc] init];
    [verifiedIcon setImage:[UIImage imageNamed:@"personal_center_real_name_authentication"]];
    [verifiedView addSubview:verifiedIcon];
    [verifiedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(verifiedView);
    }];
    
    UILabel *verifiedLabel = [[UILabel alloc] init];
    [verifiedLabel setFont:[UIFont fontWithName:FONT_REGULAR size:9.f]];
    [verifiedLabel setTextColor:UIColor.whiteColor];
    [verifiedLabel setText:@"已通过实名认证"];
    [verifiedView addSubview:verifiedLabel];
    [verifiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verifiedIcon.mas_right).with.offset(3.f);
        make.centerY.equalTo(verifiedView);
    }];
    
    UIView *zhimaView = [[UIView alloc] init];
    [zhimaView.layer setCornerRadius:9.f];
    [zhimaView setBackgroundColor:[COLOR_BLACK_333333 colorWithAlphaComponent:0.25f]];
    [view addSubview:zhimaView];
    [zhimaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.equalTo(view);
        make.left.equalTo(verifiedView.mas_right).with.offset(12.f);
        make.size.mas_equalTo(CGSizeMake(95.f, 17.f));
    }];
    
    UIImageView *zhimaIcon = [[UIImageView alloc] init];
    [zhimaIcon setImage:[UIImage imageNamed:@"personal_center_sesame_credit"]];
    [zhimaView addSubview:zhimaIcon];
    [zhimaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(zhimaView);
    }];
    
    UILabel *zhimaLabel = [[UILabel alloc] init];
    [zhimaLabel setFont:[UIFont fontWithName:FONT_REGULAR size:9.f]];
    [zhimaLabel setTextColor:UIColor.whiteColor];
    [zhimaLabel setText:@"芝麻信用已授权"];
    [zhimaView addSubview:zhimaLabel];
    [zhimaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhimaIcon.mas_right).with.offset(3.f);
        make.centerY.equalTo(zhimaView);
    }];
    
    return view;
}

- (void)setupCollectioinPanel:(UIView *)view {
    UIView *leftLine = [[UIView alloc] init];
    [leftLine setBackgroundColor:COLOR_GRAY_E5E5E5];
    [view addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(111.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(1.f, 21.f * g_rateWidth));
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    [rightLine setBackgroundColor:COLOR_GRAY_E5E5E5];
    [view addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-111.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(1.f, 21.f * g_rateWidth));
    }];
    
    UIControl *leftView = [[UIControl alloc] init];
    [leftView addTarget:self action:@selector(onClickCollectionCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [leftView setTag:0];
    [view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.and.equalTo(view);
        make.right.equalTo(leftLine.mas_left);
    }];
    
    UIControl *rightView = [[UIControl alloc] init];
    [rightView addTarget:self action:@selector(onClickCollectionCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [rightView setTag:2];
    [view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.and.equalTo(view);
        make.left.equalTo(rightLine.mas_right);
    }];
    
    UIControl *centerView = [[UIControl alloc] init];
    [centerView addTarget:self action:@selector(onClickCollectionCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [centerView setTag:1];
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(leftLine.mas_right);
        make.right.equalTo(rightLine.mas_left);
    }];
    
    UILabel *keepNumLabel = [[UILabel alloc] init];
    [keepNumLabel setFont:[UIFont fontWithName:FONT_BOLD size:20.f]];
    [keepNumLabel setTextColor:COLOR_BLACK_333333];
    keepNumLabel.text = @"--";
    [leftView addSubview:keepNumLabel];
    _keepNumLabel = keepNumLabel;
    [keepNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftView);
        make.centerX.equalTo(leftView);
        make.height.mas_equalTo(keepNumLabel.font.pointSize);
    }];
    
    UILabel *keepLabel = [[UILabel alloc] init];
    [keepLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [keepLabel setTextColor:COLOR_BLACK_666666];
    [keepLabel setText:@"收藏"];
    [leftView addSubview:keepLabel];
    [keepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keepNumLabel.mas_bottom).with.offset(8.f);
        make.centerX.equalTo(keepNumLabel);
        make.height.mas_equalTo(keepLabel.font.pointSize);
        make.bottom.equalTo(leftView);
    }];
    
    UILabel *followNumLabel = [[UILabel alloc] init];
    [followNumLabel setFont:[UIFont fontWithName:FONT_BOLD size:20.f]];
    [followNumLabel setTextColor:COLOR_BLACK_333333];
    followNumLabel.text = @"--";
    [centerView addSubview:followNumLabel];
    _followNumLabel = followNumLabel;
    [followNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView);
        make.centerX.equalTo(centerView);
        make.height.mas_equalTo(followNumLabel.font.pointSize);
    }];

    UILabel *followLabel = [[UILabel alloc] init];
    [followLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [followLabel setTextColor:COLOR_BLACK_666666];
    [followLabel setText:@"关注"];
    [centerView addSubview:followLabel];
    [followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(followNumLabel.mas_bottom).with.offset(8.f);
        make.centerX.equalTo(followNumLabel);
        make.height.mas_equalTo(followLabel.font.pointSize);
        make.bottom.equalTo(centerView);
    }];

    UILabel *historyNumLabel = [[UILabel alloc] init];
    [historyNumLabel setFont:[UIFont fontWithName:FONT_BOLD size:20.f]];
    [historyNumLabel setTextColor:COLOR_BLACK_333333];
    historyNumLabel.text = @"--";
    [rightView addSubview:historyNumLabel];
    _historyNumLabel = historyNumLabel;
    [historyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView);
        make.centerX.equalTo(rightView);
        make.height.mas_equalTo(historyNumLabel.font.pointSize);
    }];

    UILabel *historyLabel = [[UILabel alloc] init];
    [historyLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [historyLabel setTextColor:COLOR_BLACK_666666];
    [historyLabel setText:@"浏览历史"];
    [rightView addSubview:historyLabel];
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyNumLabel.mas_bottom).with.offset(8.f);
        make.centerX.equalTo(rightView);
        make.height.mas_equalTo(historyLabel.font.pointSize);
        make.bottom.equalTo(rightView);
    }];
}

- (void)setupFunctionPanel:(UIView *)view {
    UIView *centerView = [[UIView alloc] init];
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    CGFloat xSpace = 61.f * g_rateWidth;
    CGFloat ySpace = 36.f * g_rateWidth;
    UIView *shareManagementItem = [self setupFunctionItemWithIcon:[UIImage imageNamed:@"personal_center_sharing_management"] title:@"共享管理" desc:@"0条"];
    [centerView addSubview:shareManagementItem];
    [shareManagementItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(centerView);
    }];
    _spacenum = shareManagementItem.subviews[1];
    
    UIView *myCardItem = [self setupFunctionItemWithIcon:[UIImage imageNamed:@"personal_center_business_card"] title:@"我的名片" desc:@"交流更高效"];
    [centerView addSubview:myCardItem];
    [myCardItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView);
        make.left.equalTo(shareManagementItem.mas_right).with.offset(xSpace);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inviteSBDistrbuteGifts:)];
    UIView *invitationPriceItem = [self setupFunctionItemWithIcon:[UIImage imageNamed:@"personal_center_courtesy"] title:@"礼包卡券" desc:@"限时免费"];
    [centerView addSubview:invitationPriceItem];
    [invitationPriceItem addGestureRecognizer:tap];
    [invitationPriceItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView);
        make.left.equalTo(myCardItem.mas_right).with.offset(xSpace);
        make.right.equalTo(centerView);
    }];
    
    UIView *feedbackItem = [self setupFunctionItemWithIcon:[UIImage imageNamed:@"personal_center_information"] title:@"意见反馈" desc:@"感谢有你"];
    [centerView addSubview:feedbackItem];
    [feedbackItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(shareManagementItem.mas_bottom).with.offset(ySpace);
        make.bottom.equalTo(centerView);
    }];
    
    UIView *customerServiceItem = [self setupFunctionItemWithIcon:[UIImage imageNamed:@"personal_center_customer_service"] title:@"在线客服" desc:@"贴心做服务"];
    [centerView addSubview:customerServiceItem];
    [customerServiceItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myCardItem);
        make.top.equalTo(feedbackItem);
        make.bottom.equalTo(centerView);
    }];
    
    UIView *aboutUsItem = [self setupFunctionItemWithIcon:[UIImage imageNamed:@"personal_center_about_us"] title:@"关于我们" desc:@"用心做产品"];
    [centerView addSubview:aboutUsItem];
    [aboutUsItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(invitationPriceItem);
        make.top.equalTo(feedbackItem);
        make.bottom.equalTo(centerView);
    }];
}
#pragma mark - 邀请有礼
- (void)inviteSBDistrbuteGifts:(UITapGestureRecognizer *)tap
{
    [self pushVCByClassName:@"HPInviteSBGiftsController"];
}
- (UIView *)setupFunctionItemWithIcon:(UIImage *)icon title:(NSString *)title desc:(NSString *)desc {
    UIView *view = [[UIView alloc] init];
    
    HPAlignCenterButton *btn = [[HPAlignCenterButton alloc] initWithImage:icon];
    [btn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [btn setTextColor:COLOR_BLACK_333333];
    [btn setText:title];
    [btn addTarget:self action:@selector(onClickFunctionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        if ([title containsString:@"我的名片"]) {
            make.top.mas_equalTo(view).offset(getWidth(4.f));
            make.size.mas_equalTo(CGSizeMake(55.f, 50.f));

        }else{
            make.top.mas_equalTo(view);
            make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
        }
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:11.f]];
    [descLabel setTextColor:COLOR_GRAY_BBBBBB];
    [descLabel setText:desc];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
//        if ([title containsString:@"我的名片"]) {
//            make.top.equalTo(btn.mas_bottom).with.offset(2.f * g_rateWidth);
//        }else{
            make.top.equalTo(btn.mas_bottom).with.offset(6.f * g_rateWidth);
//        }
        make.height.mas_equalTo(descLabel.font.pointSize);
        make.bottom.equalTo(view);
    }];
    
    return view;
}

#pragma mark - OnClick

- (void)onClickConfigBtn:(UIButton *)btn {
    HPLoginModel *model = [HPUserTool account];
    if (!model.token) {
//        [HPProgressHUD alertMessage:@"用户未登录"];
        [self pushVCByClassName:@"HPLoginController"];

        return;
    }else{
    
    [self pushVCByClassName:@"HPConfigCenterController"];
    }
}

- (void)onClickLoginBtn:(UIButton *)btn {
    [self pushVCByClassName:@"HPLoginController"];
}

- (void)onClickCertificateBtn:(UIButton *)btn {
    NSLog(@"onClickCertificateBtn");
}

- (void)onClickCollectionCtrl:(UIControl *)ctrl {
    HPLoginModel *model = [HPUserTool account];
    if (!model.token) {
        [HPProgressHUD alertMessage:@"用户未登录"];
        return;
    }
    
    if (ctrl.tag == 0) { //收藏
        [self pushVCByClassName:@"HPKeepController"];
    }
    else if (ctrl.tag == 1) { //关注
        [self pushVCByClassName:@"HPFollowController"];
    }
    else if (ctrl.tag == 2) { //浏览历史
        [self pushVCByClassName:@"HPHistoryController"];
    }
}

- (void)onClickFunctionBtn:(HPAlignCenterButton *)btn {
    HPLoginModel *account = [HPUserTool account];
    if (!account.token) {
        [HPProgressHUD alertMessage:@"用户未登录"];
        return;
    }
    
    if ([btn.text isEqualToString:@"我的名片"]) {
        [self pushVCByClassName:@"HPMyCardController" withParam:@{@"userId":account.userInfo.userId}];
    }
    else if ([btn.text isEqualToString:@"共享管理"]) {
        [self pushVCByClassName:@"HPShareManageController"];
    }
    else if ([btn.text isEqualToString:@"意见反馈"]) {
        [self pushVCByClassName:@"HPFeedbackController"];
    }
    else if ([btn.text isEqualToString:@"在线客服"]) {
        if (_customerServiceModalView == nil) {
            HPCustomerServiceModalView *customerServiceModalView = [[HPCustomerServiceModalView alloc] initWithParent:self.parentViewController.view];
            customerServiceModalView.phone = @"0755-86713128";
            [customerServiceModalView setPhoneString:@"0755-86713128"];
            _customerServiceModalView = customerServiceModalView;
        }
        
        [_customerServiceModalView show:YES];
        [self.parentViewController.view bringSubviewToFront:_customerServiceModalView]; 
    }else if ([btn.text isEqualToString:@"关于我们"]){
        [self pushVCByClassName:@"HPAboutUsViewController"];
    }
}

@end
