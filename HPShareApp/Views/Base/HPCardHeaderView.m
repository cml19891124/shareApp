#import "HPCardHeaderView.h"
#import "Masonry.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "UIButton+WebCache.h"

@implementation HPCardHeaderView

- (instancetype)initWithFrame:(CGRect)frame withUserId:(NSString *)userId
{
    if (self = [super initWithFrame:frame]) {
        _userId = userId;
        [self getCardInfoDetailByUserId:userId];
        [self setUpSubviews];
    }
    return self;
}
#pragma mark - 获取卡片详情
- (void)getCardInfoDetailByUserId:(NSString *)userId
{
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *userdic = (NSDictionary *)account.userInfo;
    NSMutableDictionary *detaildic = [NSMutableDictionary dictionary];
    detaildic[@"followedId"] = userId;
    detaildic[@"userId"] = userdic[@"userId"];
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/cardDetails" isNeedToken:YES paraments:detaildic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.cardDetailsModel = [HPCardDetailsModel mj_objectWithKeyValues:responseObject[@"data"][@"cardInfo"]];
            [self.phoneNumLabel setText:self.cardDetailsModel.telephone.length >0 ?self.cardDetailsModel.telephone:@"未填写"];
            [self.companyLabel setText:self.cardDetailsModel.company.length >0 ?self.cardDetailsModel.company:@"未填写"];
            [self.descLabel setText:self.cardDetailsModel.signature.length >0 ?self.cardDetailsModel.signature:@"未填写"];
            [self.signatureLabel setText:self.cardDetailsModel.title.length > 0?self.cardDetailsModel.title:@"未填写"];
            [self.portraitView sd_setImageWithURL:[NSURL URLWithString:self.cardDetailsModel.avatarUrl.length >0?self.cardDetailsModel.avatarUrl:userdic[@"avatarUrl"]] forState:UIControlStateNormal];
            if ([self.userId intValue] == [userdic[@"userId"] intValue]) {
                [self.editBtn setTitle:@"编辑名片" forState:UIControlStateNormal];
                [self.editBtn setTag:HPMyCardTypeEdit];
                [self.editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                if([self.cardDetailsModel.fans isEqualToString:@"0"]){
                    [self.editBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.editBtn setTag:HPMyCardTypeFocus];
                    self.method = @"/v1/fans/add";
                    [self.editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
                }else {
                    [self.editBtn setTitle:@"已关注" forState:UIControlStateNormal];
                    [self.editBtn setTag:HPMyCardTypeCancelFocus];
                    self.method = @"/v1/fans/cancel";
                    [self.editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet;
    }];
    
}
- (void)setUpSubviews
{
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"my_business_card_background_map"]];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.top.equalTo(self).with.offset(-g_statusBarHeight);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back"]];
    [self addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(25.f * g_rateWidth);
        make.top.equalTo(self).with.offset(g_statusBarHeight);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.mas_equalTo(self).offset(g_statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"我的名片"];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(backIcon);
    }];
    
    UIView *cardPanel = [[UIView alloc] init];
    [cardPanel.layer setCornerRadius:5.f];
    [cardPanel.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [cardPanel.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [cardPanel.layer setShadowOpacity:0.07f];
    [cardPanel.layer setShadowRadius:16.f];
    [cardPanel setBackgroundColor:UIColor.whiteColor];
    [self addSubview:cardPanel];
    _cardPanel = cardPanel;
    [cardPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backIcon.mas_bottom).with.offset(33.f * g_rateWidth);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 215.f * g_rateWidth));
    }];
    [self setupCardPanel:cardPanel];
    
    UIView *infoRegion = [[UIView alloc] init];
    [infoRegion.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [infoRegion.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [infoRegion.layer setShadowOpacity:0.07f];
    [infoRegion.layer setShadowRadius:16.f];
    [infoRegion setBackgroundColor:UIColor.whiteColor];
    [self addSubview:infoRegion];
    _infoRegion = infoRegion;
    [infoRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.top.equalTo(cardPanel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(225.f * g_rateWidth);
    }];
    [self setupInfoRegion:infoRegion];
}

- (void)setupCardPanel:(UIView *)view {
    
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *userdic = (NSDictionary *)account.cardInfo;
    NSString *avatarUrl = userdic[@"avatarUrl"];
    UIButton *portraitView = [[UIButton alloc] init];
    [portraitView.layer setCornerRadius:getWidth(63.f) * 0.5];
    [portraitView.layer setMasksToBounds:YES];
    if (avatarUrl.length == 0) {
        [portraitView setBackgroundImage:ImageNamed(@"personal_center_not_login_head") forState:UIControlStateNormal];
    }else{
        [portraitView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal];
    }
    [view addSubview:portraitView];
    _portraitView = portraitView;
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(17.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(getWidth(63.f), getWidth(63.f)));
    }];
    
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    [phoneNumLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [phoneNumLabel setTextColor:COLOR_BLACK_333333];
    phoneNumLabel.text = userdic[@"telephone"];
    [view addSubview:phoneNumLabel];
    _phoneNumLabel = phoneNumLabel;
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitView.mas_right).with.offset(13.f * g_rateWidth);
        make.top.equalTo(portraitView).with.offset(12.f * g_rateWidth);
        make.height.mas_equalTo(phoneNumLabel.font.pointSize);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [companyLabel setTextColor:COLOR_BLACK_666666];
    [view addSubview:companyLabel];
    _companyLabel = companyLabel;
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumLabel);
        make.bottom.equalTo(portraitView.mas_bottom).with.offset(-11.f * g_rateWidth);
        make.height.mas_equalTo(phoneNumLabel.font.pointSize);
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.layer setCornerRadius:9.f];
    [editBtn.layer setMasksToBounds:YES];
    [editBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:10.f]];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    if ([self.userId intValue] == [userdic[@"userId"] intValue]) {
        [editBtn setTitle:@"编辑名片" forState:UIControlStateNormal];
        [editBtn setTag:HPMyCardTypeEdit];
        [editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];
    }
    [editBtn setBackgroundColor:COLOR_RED_FF3455];
    [view addSubview:editBtn];
    self.editBtn = editBtn;
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(8.f);
        make.centerY.equalTo(phoneNumLabel);
        make.size.mas_equalTo(CGSizeMake(55.f, 19.f));
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portraitView.mas_bottom).with.offset(18.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(301.f * g_rateWidth, 1.f));
    }];
    
    UIImageView *signatureIcon = [[UIImageView alloc] init];
    [signatureIcon setImage:[UIImage imageNamed:@"my_business_card_leaf"]];
    [view addSubview:signatureIcon];
    [signatureIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.top.equalTo(line.mas_bottom).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(getWidth(13.f), getWidth(13.f)));
    }];
    
    UILabel *signatureLabel = [[UILabel alloc] init];
    [signatureLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [signatureLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:signatureLabel];
    _signatureLabel = signatureLabel;
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureIcon.mas_right).with.offset(8.f);
        make.centerY.equalTo(signatureIcon);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setNumberOfLines:0];
    [view addSubview:descLabel];
    _descLabel = descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureLabel);
        make.top.equalTo(signatureIcon.mas_bottom).with.offset(15.f * g_rateWidth);
        make.width.mas_equalTo(271.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(- 10.f * g_rateWidth);
    }];
}

- (void)setupInfoRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"认证信息"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UIControl *creditCtrl = [[UIControl alloc] init];
    [creditCtrl.layer setBorderWidth:1.f];
    [creditCtrl.layer setBorderColor:COLOR_GRAY_EEEEEE.CGColor];
    [creditCtrl setBackgroundColor:UIColor.whiteColor];
    [view addSubview:creditCtrl];
    [creditCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 65.f * g_rateWidth));
    }];
    [self setupCreditCtrl:creditCtrl];
    
    UIControl *verifiedCtrl = [[UIControl alloc] init];
    [verifiedCtrl.layer setBorderWidth:1.f];
    [verifiedCtrl.layer setBorderColor:COLOR_GRAY_EEEEEE.CGColor];
    [verifiedCtrl setBackgroundColor:UIColor.whiteColor];
    [view addSubview:verifiedCtrl];
    _verifiedCtrl = verifiedCtrl;
    [verifiedCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(creditCtrl.mas_bottom).with.offset(15.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 65.f * g_rateWidth));
    }];
    [self setupVerifiedCtrl:verifiedCtrl];
}

- (void)setupCreditCtrl:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:[UIImage imageNamed:@"my_business_card_sesame_credit"]];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"芝麻信用"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.left.equalTo(iconView.mas_right).with.offset(12.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setText:@"芝麻信用还未授权"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:@"select_the_arrow"]];
    [view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-23.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *gotoLabel = [[UILabel alloc] init];
    [gotoLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [gotoLabel setTextColor:COLOR_RED_FF3455];
    [gotoLabel setText:@"去授权"];
    [view addSubview:gotoLabel];
    [gotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left).with.offset(-6.f);
        make.centerY.equalTo(arrow);
    }];
}

- (void)setupVerifiedCtrl:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:[UIImage imageNamed:@"my_business_card_real_name_authentication"]];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"实名认证"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.left.equalTo(iconView.mas_right).with.offset(12.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setText:@"未实名认证"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:@"select_the_arrow"]];
    [view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-23.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *gotoLabel = [[UILabel alloc] init];
    [gotoLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [gotoLabel setTextColor:COLOR_RED_FF3455];
    [gotoLabel setText:@"去认证"];
    [view addSubview:gotoLabel];
    [gotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left).with.offset(-6.f);
        make.centerY.equalTo(arrow);
    }];
}

- (void)onClickBackBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickBackButtonBackToMyContoller)]) {
        [self.delegate clickBackButtonBackToMyContoller];
    }
}

- (void)focusSBToFansList:(UIButton *)button
{
    [self getCardInfoDetailByUserId:_userId];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(clickButtonInCardHeaderView:focusSBToFansList:andCardType:)]) {
            [self.delegate clickButtonInCardHeaderView:self focusSBToFansList:self.model andCardType:button.tag];
        }
    });
}
@end
