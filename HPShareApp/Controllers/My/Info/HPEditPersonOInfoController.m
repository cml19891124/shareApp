//
//  HPChangePasswordController.m
//  HPShareApp
//
//  Created by HP on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "HPRightImageButton.h"
#import "HPEditPersonOInfoController.h"
#import "HPAlertSheet.h"
#import "TZImagePickerController.h"
#import "HPAddPhotoView.h"
#import "HPTimeString.h"
#import "HPUploadImageHandle.h"
#import "UIButton+WebCache.h"

typedef NS_ENUM(NSInteger, HPEditInfoGoto) {
    HPEditGotoPortrait = 10,
    HPEditGotoFullName,
    HPEditGotoCompany,
    HPEditGotoContact,
    HPEditGotoSign
};
@interface HPEditPersonOInfoController ()<UITextFieldDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIView *accountInfoPanel;
@property (nonatomic, weak) HPRightImageButton *nameBtn;
@property (nonatomic, weak) HPRightImageButton *companyBtn;
@property (nonatomic, weak) HPRightImageButton *contactBtn;

@property (nonatomic, strong) UIImagePickerController *photoPicker;

@property (nonatomic, weak) TZImagePickerController *imagePicker;
@property (nonatomic, weak) HPAlertSheet *alertSheet;
@property (nonatomic, strong) UIButton *portraitView;
/**
 获取到的图片
 */
@property (nonatomic, strong) UIImage *photo;
@end

@implementation HPEditPersonOInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];


    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"编辑名片"];
    [self setUpUI];
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
    [signInfoLabel setText:@"签名信息(完善签名，让用户更懂你)"];
    NSMutableAttributedString *signstr = [[NSMutableAttributedString alloc] initWithString:signInfoLabel.text];
    [signstr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:NSMakeRange(0, 4)];
    [signstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_BOLD size:16.f] range:NSMakeRange(0, 4)];
    [signstr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(4,signstr.length - 4)];
    [signstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_BOLD size:12.f] range:NSMakeRange(4,signstr.length - 4)];
    signInfoLabel.attributedText = signstr;
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
    UILabel *nameLabel = [self setupTitleLabelWithTitle:@"我的签名"];
    [nameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView).with.offset(18.f * g_rateWidth);
        make.centerY.equalTo(nameView);
        make.height.mas_equalTo(nameLabel.font.pointSize);
        make.right.equalTo(nameView).with.offset(-18.f * g_rateWidth);
        
    }];
    
    HPRightImageButton *nameBtn = [self setupGotoBtnWithTitle:@"修改"];
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
        [self.alertSheet show:YES];
    }else if (button.tag == HPEditGotoFullName) {
        HPLog(@"HPEditGotoFullName");
        [self pushVCByClassName:@"HPConfigUserNameController" withParam:@{@"title":@"编辑您的姓名"}];
    }else if (button.tag == HPEditGotoCompany) {
        HPLog(@"HPEditGotoCompany");
        [self pushVCByClassName:@"HPConfigUserNameController" withParam:@{@"title":@"编辑您的公司名"}];
    }else if (button.tag == HPEditGotoContact) {
        HPLog(@"HPEditGotoContact");
        [self pushVCByClassName:@"HPConfigUserNameController" withParam:@{@"title":@"编辑您的联系方式"}];

    }else if (button.tag == HPEditGotoSign) {
        HPLog(@"HPEditGotoSign");
        [self pushVCByClassName:@"HPSignInfoController" withParam:@{@"title":@"我的签名"}];

    }
    
}
- (void)setupShadowOfPanel:(UIView *)view {
    HPLoginModel *model = [HPUserTool account];

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
    [portraitView sd_setImageWithURL:[NSURL URLWithString:model.cardInfo.avatarUrl.length > 0 ?model.cardInfo.avatarUrl:@""] forState:UIControlStateNormal];
    [headerView addSubview:portraitView];
    self.portraitView = portraitView;
    [portraitView addTarget:self action:@selector(onClickGotoCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(46.f, 46.f));
        make.right.mas_equalTo(getWidth(-34.f));
    }];
    UIButton *rowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowBtn setBackgroundImage:ImageNamed(@"shouye_gengduo") forState:UIControlStateNormal];
    [headerView addSubview:rowBtn];
    [rowBtn addTarget:self action:@selector(onClickGotoCtrl:) forControlEvents:UIControlEventTouchUpInside];
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
    
    HPRightImageButton *nameBtn = [self setupGotoBtnWithTitle:model.cardInfo.realName.length > 0?model.cardInfo.realName:@"未填写"];
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

    HPRightImageButton *companyBtn = [self setupGotoBtnWithTitle:model.cardInfo.company.length > 0?model.cardInfo.company:@"未填写"];
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

    HPRightImageButton *contactBtn = [self setupGotoBtnWithTitle:model.userInfo.mobile.length > 0?model.userInfo.mobile:@"未填写"];
    [contactView addSubview:contactBtn];
    [contactBtn setTag:HPEditGotoContact];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-18.f));
        make.centerY.mas_equalTo(contactView);
    }];
}

- (void)onClickAlbumOrPhotoSheetWithTag:(NSInteger)tag {
    if (tag == 0) {
        if (self.photoPicker == nil) {
            UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
            [photoPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [photoPicker setDelegate:self];
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
            self.imagePicker = imagePicker;
        }
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}
- (UILabel *)setupTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [label setTextColor:COLOR_GRAY_888888];
    [label setText:title];
    return label;
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
    HPLoginModel *account = [HPUserTool account];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"avatarUrl"] = avatarUrl;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/updateUser" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSDictionary *result= responseObject[@"data"];
            [self.portraitView sd_setImageWithURL:[NSURL URLWithString:result[@"avatarUrl"]?:@""] forState:UIControlStateNormal];
            account.cardInfo.avatarUrl = result[@"avatarUrl"]?:@"";
            account.cardInfo.signature = account.cardInfo.signature?:@"";
            account.cardInfo.title = account.cardInfo.title?:@"";
            account.cardInfo.userId = account.cardInfo.userId?:@"";
            [HPUserTool saveAccount:account];
            [HPProgressHUD alertMessage:@"头像修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
@end
