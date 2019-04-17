//
//  HPManagerBoardViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPManagerBoardViewController.h"

#import "HPGradientUtil.h"

#import "HPAlignCenterButton.h"

#import "TZImagePickerController.h"

#import "HPUploadImageHandle.h"

#import "HPAlertSheet.h"


@interface HPManagerBoardViewController ()<UINavigationBarDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, weak) TZImagePickerController *imagePicker;

/**
 营业执照图片路径
 */
@property (nonatomic, copy) NSString *photoUrl;

@property (nonatomic, copy) NSString *pictureId;

@property (nonatomic, weak) HPAlertSheet *alertSheet;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *compriseLabel;

@property (nonatomic, strong) UITextField *compriseField;

@property (nonatomic, strong) UIView *lineComprise;

@property (nonatomic, strong) UILabel *boardLabel;

@property (nonatomic, strong) UITextField *boardField;

@property (nonatomic, strong) UIView *lineBoard;

@property (nonatomic, strong) UILabel *boardPhoto;

@property (nonatomic, strong) UILabel *boardTipLabel;

@property (nonatomic, strong) UILabel *boardExperylabel;

@property (nonatomic, strong) UILabel *boardCheckLabel;

@property (nonatomic, strong) UIView *upView;

@property (nonatomic, strong) UIImageView *portView;

@property (nonatomic, strong) HPAlignCenterButton *uploadBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (strong, nonatomic) UIImage *photo;

@property (nonatomic, strong) UIImagePickerController *photoPicker;

@end

@implementation HPManagerBoardViewController


- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        
        self.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }

    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self setUpBoardSubviews];
    
    [self setUpBoardSubviewsMasonry];
    
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

#pragma mark - 添加营业执照信息认证 auditStatus: 0审核未通过，1通过，2审核中
- (void)getPassportAddIdentifyApi
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"name"] = self.compriseField.text;
    dic[@"number"] = self.boardField.text;
    dic[@"pictureId"] = self.pictureId;
    dic[@"pictureUrl"] = self.photoUrl;

    [HPHTTPSever HPPostServerWithMethod:@"/v1/business/addBusinessLicense" paraments:dic needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"操作成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setUpBoardSubviews
{
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.backBtn];

    [self.scrollView addSubview:self.titleLabel];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR(253, 3, 3, 1) endColor:COLOR(253, 3, 3, 0)];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.scrollView addSubview:self.colorBtn];
    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [self.scrollView addSubview:self.subTitleLabel];
    
    [self.scrollView addSubview:self.compriseLabel];
    
    [self.scrollView addSubview:self.compriseField];
    
    [self.scrollView addSubview:self.lineComprise];
    
    [self.scrollView addSubview:self.boardLabel];
    
    [self.scrollView addSubview:self.boardField];
    
    [kNotificationCenter addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:self.boardField];
    
    [self.scrollView addSubview:self.lineBoard];
    
    [self.scrollView addSubview:self.boardPhoto];

    [self.scrollView addSubview:self.boardTipLabel];

    [self.scrollView addSubview:self.boardExperylabel];

    [self.scrollView addSubview:self.boardCheckLabel];

    [self.scrollView addSubview:self.upView];

    [self.upView addSubview:self.portView];

    [self.upView addSubview:self.uploadBtn];

    [self.view addSubview:self.confirmBtn];

}

#pragma mark - NSNotification

- (void)didTextFieldChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self.boardField) {
        // text field 的内容
        NSString *contentText = textField.text;
        
        // 获取高亮内容的范围
        UITextRange *selectedRange = [textField markedTextRange];
        // 这行代码 可以认为是 获取高亮内容的长度
        NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        // 没有高亮内容时,对已输入的文字进行操作
        if (markedTextLength == 0) {
            // 如果 text field 的内容长度大于我们限制的内容长度
            if (contentText.length > 18) {
                // 截取从前面开始maxLength长度的字符串
                //            textField.text = [contentText substringToIndex:maxLength];
                // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
                NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 18)];
                textField.text = [contentText substringWithRange:rangeRange];
                [HPProgressHUD alertMessage:@"营业执照号码不得超过18位"];
            }
        }
        
    }
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

- (void)setUpBoardSubviewsMasonry
{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(UIEdgeInsetsZero);
        make.bottom.mas_equalTo(getWidth(-64.f));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
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
    
    [self.compriseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.width.mas_equalTo(getWidth(200.f));
        make.height.mas_equalTo(self.compriseLabel.font.pointSize);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(getWidth(33.f));;
    }];
    
    [self.compriseField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(getWidth(37.f));
        make.top.mas_equalTo(self.compriseLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.lineComprise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.compriseField.mas_bottom);
    }];
    
    [self.boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.boardLabel.font.pointSize);
        make.top.mas_equalTo(self.lineComprise.mas_bottom).offset(getWidth(22.f));
    }];
    
    [self.boardField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(getWidth(37.f));
        make.top.mas_equalTo(self.boardLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.lineBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.boardField.mas_bottom);
    }];
    
    [self.boardPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.boardPhoto.font.pointSize);
        make.top.mas_equalTo(self.lineBoard.mas_bottom).offset(getWidth(35.f));
    }];
    
    [self.boardTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.boardTipLabel.font.pointSize);
        make.top.mas_equalTo(self.boardPhoto.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.boardExperylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.boardExperylabel.font.pointSize);
        make.top.mas_equalTo(self.boardTipLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.boardCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.boardCheckLabel.font.pointSize);
        make.top.mas_equalTo(self.boardExperylabel.mas_bottom).offset(getWidth(7.f));
    }];
    
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(100.f), getWidth(140.f)));
        make.top.mas_equalTo(self.boardCheckLabel.mas_bottom).offset(getWidth(24.f));
    }];
    
    [self.portView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.upView);
        make.size.mas_equalTo(CGSizeMake(getWidth(50.f), getWidth(40.f)));
        make.top.mas_equalTo(getWidth(50.f));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(getWidth(330.f), getWidth(44.f)));
        make.top.mas_equalTo(self.view.mas_bottom).offset(getWidth(-54.f));
    }];
}

- (UIImageView *)portView
{
    if(!_portView){
        _portView = [UIImageView new];
        _portView.image = ImageNamed(@"");
    }
    return _portView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:ImageNamed(@"fanhui") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];

        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsVerticalScrollIndicator:NO];
    }
    return _scrollView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:kFont_Bold(18.f)];
        [_titleLabel setTextColor:COLOR_BLACK_333333];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel setText:@"营业执照认证"];
        
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
        [_subTitleLabel setTextColor:COLOR_BLACK_333333];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        [_subTitleLabel setText:@"完成身份认证后交易更高效、更便捷"];
    }
    return _subTitleLabel;
}

- (UILabel *)compriseLabel
{
    if (!_compriseLabel) {
        _compriseLabel = [UILabel new];
        _compriseLabel.text = @"企业名称";
        _compriseLabel.textColor = COLOR_BLACK_333333;
        _compriseLabel.font = kFont_Bold(16.f);
    }
    return _compriseLabel;
}

- (UITextField *)compriseField
{
    if (!_compriseField) {
        _compriseField = [[UITextField alloc] init];
        _compriseField.textAlignment = NSTextAlignmentLeft;
        _compriseField.textColor = COLOR_BLACK_333333;
        _compriseField.font = kFont_Medium(13.f);
        _compriseField.placeholder = @"请填写企业名称";
        _compriseField.tintColor = COLOR_RED_EA0000;
        // "通过KVC修改占位文字的颜色"
        
        [_compriseField setValue:COLOR_GRAY_999999 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _compriseField;
}

- (UIView *)lineComprise{
    if (!_lineComprise) {
        _lineComprise = [UIView new];
        _lineComprise.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _lineComprise;
}

- (UILabel *)boardLabel
{
    if (!_boardLabel) {
        _boardLabel = [UILabel new];
        _boardLabel.text = @"营业执照号码（加密处理）";
        _boardLabel.textColor = COLOR_BLACK_333333;
        _boardLabel.font = kFont_Bold(16.f);
    }
    return _boardLabel;
}

- (UITextField *)boardField
{
    if (!_boardField) {
        _boardField = [[UITextField alloc] init];
        _boardField.textAlignment = NSTextAlignmentLeft;
        _boardField.textColor = COLOR_BLACK_333333;
        _boardField.font = kFont_Medium(13.f);
        _boardField.placeholder = @"请填写并核对证件号码";
        _boardField.tintColor = COLOR_RED_EA0000;
        // "通过KVC修改占位文字的颜色"
        
        [_boardField setValue:COLOR_GRAY_999999 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _boardField;
}

- (UIView *)lineBoard{
    if (!_lineBoard) {
        _lineBoard = [UIView new];
        _lineBoard.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _lineBoard;
}

- (UILabel *)boardPhoto
{
    if (!_boardPhoto) {
        _boardPhoto = [UILabel new];
        _boardPhoto.text = @"营业执照照片";
        _boardPhoto.textColor = COLOR_BLACK_333333;
        _boardPhoto.font = kFont_Bold(16.f);
    }
    return _boardPhoto;
}

- (UILabel *)boardTipLabel
{
    if (!_boardTipLabel) {
        _boardTipLabel = [UILabel new];
        _boardTipLabel.text = @"审核要求";
        _boardTipLabel.textColor = COLOR_GRAY_999999;
        _boardTipLabel.font = kFont_Bold(13.f);
    }
    return _boardTipLabel;
}

- (UILabel *)boardExperylabel
{
    if (!_boardExperylabel) {
        _boardExperylabel = [UILabel new];
        _boardExperylabel.text = @"1.证件处于有效期内";
        _boardExperylabel.textColor = COLOR_GRAY_999999;
        _boardExperylabel.font = kFont_Medium(13.f);
    }
    return _boardExperylabel;
}

- (UILabel *)boardCheckLabel
{
    if (!_boardCheckLabel) {
        _boardCheckLabel = [UILabel new];
        _boardCheckLabel.text = @"2.填写证件号码与上传执照代码保持一致";
        _boardCheckLabel.textColor = COLOR_GRAY_999999;
        _boardCheckLabel.font = kFont_Medium(13.f);
    }
    return _boardCheckLabel;
}

- (UIView *)upView
{
    if (!_upView) {
        _upView = [UIView new];
        _upView.backgroundColor = COLOR_GRAY_EEEEEE;
        _upView.layer.cornerRadius = 2.f;
        _upView.layer.masksToBounds = YES;
    }
    return _upView;
}

- (HPAlignCenterButton *)uploadBtn
{
    if (!_uploadBtn) {
        _uploadBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(@"upload")];
        _uploadBtn.text = @"点此上传";
        _uploadBtn.textFont = kFont_Medium(12.f);
        _uploadBtn.textColor = COLOR_GRAY_999999;
        [_uploadBtn addTarget:self action:@selector(onClickUploadBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = COLOR_RED_EA0000;
        _confirmBtn.layer.cornerRadius = 6.f;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_confirmBtn addTarget:self action:@selector(conClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (void)conClickConfirmBtn:(UIButton *)button
{
    if(self.boardField.text.length == 0){
        [HPProgressHUD alertMessage:@"请输入营业执照号码"];
        return;
    }
    if(self.compriseField.text.length == 0){
        [HPProgressHUD alertMessage:@"请输入企业名称"];
        return;
    }
    
    if (self.photoUrl.length == 0 || !self.photoUrl) {
        [HPProgressHUD alertMessage:@"请选择营业执照图片"];
        return;
    }
    [self getPassportAddIdentifyApi];
}

- (void)onClickUploadBtn:(UIButton *)button
{
    [self.alertSheet show:YES];

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    _photo = photo;
    self.portView.image = photo;
    [self dismissViewControllerAnimated:self.photoPicker completion:nil];
    [self uploadLocalImageGetAvatarUrl];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    picker.allowCrop = YES;
    UIImage *photo = photos[0];
    _photo = photo;
    self.portView.image = photo;
    [self uploadLocalImageGetAvatarUrl];
}

#pragma  mark - 上传一张图片
- (void)uploadLocalImageGetAvatarUrl
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/file/uploadPicture",kBaseUrl];//放上传图片的网址
    NSString *historyTime = [HPTimeString getNowTimeTimestamp];
    [HPUploadImageHandle sendPOSTWithUrl:url withLocalImage:_photo isNeedToken:YES parameters:@{@"file":historyTime} success:^(id data) {
        NSString *url = [data[@"data"]firstObject][@"url"]?:@"";
        NSString *pictureId = [data[@"data"]firstObject][@"pictureId"]?:@"";
        self.pictureId = pictureId;
        if (url) {
            self.photoUrl = url;
        }
    } fail:^(NSError *error) {
        ErrorNet
    }];
    
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

#pragma mark - 识别身份证

@end
