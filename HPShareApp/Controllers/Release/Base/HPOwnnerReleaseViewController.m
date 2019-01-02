//
//  HPOwnnerReleaseViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOwnnerReleaseViewController.h"
#import "HPUploadButton.h"
#import "HPImageUtil.h"

#import "HPAlertSheet.h"
#import "TZImagePickerController.h"
#import "HPAddPhotoView.h"
#import "HPUploadImageHandle.h"
#import "HPTextDialogView.h"

typedef NS_ENUM(NSInteger, HPReleaseImageBtnIndex) {
    HPReleaseImageBtnIndexFace = 150,
    HPReleaseImageBtnIndexStoreInside,
    HPReleaseImageBtnIndexFreeSpace,
    HPReleaseImageBtnIndexFreeeSpaceMore,
    HPReleaseImageBtnIndexAdd
};

typedef NS_ENUM(NSInteger, HPDeleteImageBtnIndex) {
    HPDeleteImageBtnIndexFace = 160,
    HPDeleteImageBtnIndexStoreInside,
    HPDeleteImageBtnIndexFreeSpace,
    HPDeleteImageBtnIndexFreeeSpaceMore,
    HPDeleteImageBtnIndexAdd
};
@interface HPOwnnerReleaseViewController ()
@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) UIView *navTilteView;

/**
 上传view
 */
@property (nonatomic, strong) UIView *uploadView;

/**
 上传图片图示label
 */
@property (nonatomic, strong) UILabel *uploadLabel;
/**
 上传图片分割线
 */
@property (nonatomic, strong) UIView *uploadLine;


/**
 上传的图片计数器
 */
@property (nonatomic, strong) UILabel *uploadNumLabel;

/**
 图片数组视图
 */
@property (nonatomic, strong) UIView *photoView;

@property (nonatomic, strong) UIButton *starBtn;

/**
 选中的图片来源按钮索引
 */
@property (nonatomic, assign) HPReleaseImageBtnIndex selectedPhotoBtnIndex;


/**
 拍照图片按钮
 */
@property (nonatomic, strong) HPUploadButton *btn;

/**
 备注提示label
 */
@property (nonatomic, strong) UILabel *leavesLabel;
/**
 样例view
 */
@property (nonatomic, strong) UIView *exampleView;

/**
 样例标题label
 */
@property (nonatomic, strong) UILabel *exampleLabel;


/**
 样例图片父视图
 */
@property (nonatomic, strong) UIView *exampleBGView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIButton *tipOneStarBtn;
@property (nonatomic, strong) UIButton *tipTwoStarBtn;

@property (nonatomic, strong) UILabel *tipOneLabel;
@property (nonatomic, strong) UILabel *tipTwoLabel;


@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *releaseBtn;

@property (nonatomic, strong) NSArray *uploadTextArray;


/**
 存放获取到的图片d字典数组
 */
@property (nonatomic, strong) NSMutableArray *photoArray;
@end

@implementation HPOwnnerReleaseViewController
- (void)onClickBackBtn {
    HPLog(@"确定放弃此次完善信息操作？");
    if ([self.delegate respondsToSelector:@selector(backvcIn:andPhotosArray:)]) {
        [self.delegate backvcIn:self andPhotosArray:self.photoArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _photoArray = [NSMutableArray array];
    UIView *navTilteView = [self setupNavigationBarWithTitle:@"发布"];
    self.view.backgroundColor = COLOR_GRAY_F6F6F6;
    self.uploadTextArray = @[@""];//@[@"封面",@"店铺内部",@"闲置空间",@"闲置空间",@""];
    [self.photoArray addObjectsFromArray:self.uploadTextArray];
    _navTilteView = navTilteView;
    [self setUpPhotosSubviews];
    [self setUpReleaseSubVeiws];
    
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

- (void)setUpPhotosSubviews
{
    [self.view addSubview:self.uploadView];
    [self.uploadView addSubview:self.uploadLabel];
    [self.uploadView addSubview:self.uploadNumLabel];
    [self.uploadView addSubview:self.uploadLine];
    [self.uploadView addSubview:self.photoView];
    [self setUpUploadButton];
    [self.uploadView addSubview:self.starBtn];
    [self.uploadView addSubview:self.leavesLabel];
    
    [self.view addSubview:self.exampleView];
    [self.exampleView addSubview:self.exampleLabel];
    [self.exampleView addSubview:self.exampleBGView];
    [self.exampleBGView addSubview:self.leftBtn];
    [self.leftBtn addSubview:self.leftLabel];
    [self.exampleBGView addSubview:self.rightBtn];
    [self.rightBtn addSubview:self.rightLabel];
    [self.exampleBGView addSubview:self.tipOneStarBtn];
    [self.exampleBGView addSubview:self.tipOneLabel];

    [self.exampleBGView addSubview:self.tipTwoStarBtn];
    [self.exampleBGView addSubview:self.tipTwoLabel];

    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.releaseBtn];
}

- (void)setUpUploadButton
{
    for (int i = 0; i < self.photoArray.count; i++) {
        CGFloat row = i/4;
        CGFloat col = i%4;
        CGFloat btnY = getWidth(15.f) + getWidth(75.f) *row;
        HPUploadButton *btn = [HPUploadButton new];
        [btn setImage:ImageNamed(@"shop_transfer_upload") forState:UIControlStateNormal];
        [btn setTitle:self.uploadTextArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        btn.backgroundColor = COLOR_GRAY_F2F2F2;
        btn.layer.cornerRadius = 2.f;
        btn.layer.masksToBounds = YES;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = kFont_Medium(11.f);
        btn.tag = 150 + i;
        
        [btn addTarget:self action:@selector(cameraBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:btn];
        self.btn = btn;
        if (i == 0) {
            btn.faceLabel.hidden = NO;
        }
        
        CGFloat space = (kScreenWidth - getWidth(75.f) * 4 - getWidth(45.f))/3;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((getWidth(75.f) + space)*col + getWidth(20.f));
            make.top.mas_equalTo(self.uploadLine.mas_bottom).offset(btnY);
            make.width.mas_equalTo(getWidth(75.f));
            make.height.mas_equalTo(getWidth(65.f));
        }];
        
        UIButton *deleteBtn = [UIButton new];
        deleteBtn.layer.cornerRadius = getWidth(7.5f);
        deleteBtn.layer.masksToBounds = YES;
        [deleteBtn setBackgroundImage:ImageNamed(@"shop_transfer_cancel") forState:UIControlStateNormal];
        deleteBtn.tag = 160 + i;
        [deleteBtn addTarget:self action:@selector(clickToDeletephoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((getWidth(75.f) + space)*col + getWidth(67.5f) + getWidth(20.f));
            make.top.mas_equalTo(self.photoView).offset(getWidth(15.f) + getWidth(-7.5f) + (space + getWidth(65.f)) * row);
            make.width.mas_equalTo(getWidth(15.f));
            make.height.mas_equalTo(getWidth(15.f));
        }];
    }
}


/**
 @param image 图片参数 可为 本地图片 可为 拍照图片
 */
- (UIButton *)creatButtonWithImage:(UIImage *)image With:(int)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(replaceObject:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
static int selectBtn_tag = -1;
- (void)replaceObject:(UIButton *)button
{
    selectBtn_tag = (int)button.tag;
    [self makePhotosSheetClick:button];
}
- (void)cameraBtn_clicked:(UIButton *)button
{
    [self makePhotosSheetClick:button];
}


/**
 删除图片
 */
- (void)clickToDeletephoto:(UIButton *)button
{
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setText:@"是否删除图片？"];
        [textDialogView setModalTop:279.f * g_rateHeight];
        [textDialogView setCanecelBtnTitle:@"取消"];
        [textDialogView setConfirmBtnTitle:@"删除"];
        _textDialogView = textDialogView;
    }
    //    kWeakSelf(weakSlef);
    [_textDialogView setConfirmCallback:^{
        // 此处加入点击确认后的操作
        if (button.tag == HPDeleteImageBtnIndexFace) {
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFace];
        }else if(button.tag == HPDeleteImageBtnIndexStoreInside){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexStoreInside];
        }else if(button.tag == HPDeleteImageBtnIndexFreeSpace){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeSpace];
        }else if(button.tag == HPDeleteImageBtnIndexFreeeSpaceMore){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeeSpaceMore];
        }
        
    }];
    
    [_textDialogView show:YES];
    
}

- (UIView *)uploadView{
    if (!_uploadView) {
        _uploadView = [UIView new];
        _uploadView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _uploadView;
}

- (UILabel *)uploadLabel
{
    if (!_uploadLabel) {
        _uploadLabel = [UILabel new];
        _uploadLabel.text = @"照片上传 上传照片更容易获得租客关注";
        _uploadLabel.textAlignment = NSTextAlignmentLeft;
        
        NSString *str = @"照片上传";
        NSRange range = [_uploadLabel.text rangeOfString:str];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_uploadLabel.text];
        [attr addAttribute:NSFontAttributeName value:kFont_Medium(15.f) range:range];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:range];
        [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(range.length, _uploadLabel.text.length - str.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(range.length, _uploadLabel.text.length - str.length)];
        _uploadLabel.attributedText = attr;
    }
    return _uploadLabel;
}

- (UIView *)uploadLine
{
    if (!_uploadLine) {
        _uploadLine = [UIView new];
        _uploadLine.backgroundColor = COLOR_GRAY_DADADA;
        
    }
    return _uploadLine;
}

- (UIView *)photoView
{
    if (!_photoView) {
        _photoView = [UIView new];
        
    }
    return _photoView;
}
- (UILabel *)uploadNumLabel
{
    if (!_uploadNumLabel) {
        _uploadNumLabel = [UILabel new];
        _uploadNumLabel.textAlignment = NSTextAlignmentRight;
        _uploadNumLabel.textColor = COLOR_GRAY_999999;
        _uploadNumLabel.font = kFont_Medium(12.f);
        _uploadNumLabel.text = @"0/8";
    }
    return _uploadNumLabel;
}

- (UIButton *)starBtn{
    if(!_starBtn){
        _starBtn = [UIButton new];
        [_starBtn setTitle:@"*" forState:UIControlStateNormal];
        [_starBtn setTitleColor:COLOR_RED_FF0000 forState:UIControlStateNormal];
        
    }
    return _starBtn;
}

- (UILabel *)leavesLabel
{
    if (!_leavesLabel) {
        _leavesLabel = [UILabel new];
        _leavesLabel.text = @"注:至少上传一张照片，封面建议采用店铺正面图";
        _leavesLabel.textColor = COLOR_GRAY_999999;
        _leavesLabel.textAlignment = NSTextAlignmentLeft;
        _leavesLabel.font = kFont_Medium(11.f);
    }
    return _leavesLabel;
}

- (UIView *)exampleView
{
    if (!_exampleView) {
        _exampleView = [UIView new];
        _exampleView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _exampleView;
}

- (UILabel *)exampleLabel
{
    if (!_exampleLabel) {
        _exampleLabel = [UILabel new];
        _exampleLabel.text = @"拍摄示例";
        _exampleLabel.textColor = COLOR_BLACK_333333;
        _exampleLabel.textAlignment = NSTextAlignmentLeft;
        _exampleLabel.font = kFont_Medium(15.f);
    }
    return _exampleLabel;
}

- (UIView *)exampleBGView
{
    if (!_exampleBGView) {
        _exampleBGView = [UIView new];
        _exampleBGView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _exampleBGView;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        _leftBtn.userInteractionEnabled = NO;
        [_leftBtn setBackgroundImage:ImageNamed(@"example_store") forState:UIControlStateNormal];
        
    }
    return _leftBtn;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.text = @"店铺照片";
        _leftLabel.textColor = COLOR_GRAY_FFFFFF;
        _leftLabel.font = kFont_Medium(11.f);
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.backgroundColor = COLOR_BLACK_000000;
        _leftLabel.alpha = 0.5;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = COLOR_GRAY_FFFFFF;
        _rightLabel.text = @"共享空间照片";
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.font = kFont_Medium(11.f);
        _rightLabel.backgroundColor = COLOR_BLACK_000000;
        _rightLabel.alpha = 0.5;
    }
    return _rightLabel;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        _rightBtn.userInteractionEnabled = NO;
        [_rightBtn setBackgroundImage:ImageNamed(@"example_space") forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (UIButton *)tipOneStarBtn
{
    if (!_tipOneStarBtn) {
        _tipOneStarBtn = [UIButton new];
        [_tipOneStarBtn setTitle:@"*" forState:UIControlStateNormal];
        [_tipOneStarBtn setTitleColor:COLOR_RED_FF0000 forState:UIControlStateNormal];
    }
    return _tipOneStarBtn;
}

- (UILabel *)tipOneLabel
{
    if (!_tipOneLabel) {
        _tipOneLabel = [UILabel new];
        _tipOneLabel.text = @"保持照片视野开阔，画面清晰，比例一致；";
        _tipOneLabel.textColor = COLOR_GRAY_999999;
        _tipOneLabel.textAlignment = NSTextAlignmentLeft;
        _tipOneLabel.font = kFont_Medium(11.f);
    }
    return _tipOneLabel;
}

- (UILabel *)tipTwoLabel
{
    if (!_tipTwoLabel) {
        _tipTwoLabel = [UILabel new];
        _tipTwoLabel.text = @"拍摄到完整店铺或出租空间可以获得更多租客的关注。";
        _tipTwoLabel.textColor = COLOR_GRAY_999999;
        _tipTwoLabel.textAlignment = NSTextAlignmentLeft;
        _tipTwoLabel.font = kFont_Medium(11.f);
    }
    return _tipTwoLabel;
}
- (UIButton *)tipTwoStarBtn
{
    if (!_tipTwoStarBtn) {
        _tipTwoStarBtn = [UIButton new];
        [_tipTwoStarBtn setTitle:@"*" forState:UIControlStateNormal];
        [_tipTwoStarBtn setTitleColor:COLOR_RED_FF0000 forState:UIControlStateNormal];
    }
    return _tipTwoStarBtn;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _bottomView;
}

- (UIButton *)releaseBtn
{
    if (!_releaseBtn) {
        _releaseBtn = [UIButton new];
        [_releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_releaseBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _releaseBtn.titleLabel.font = kFont_Medium(16.f);
        _releaseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _releaseBtn.layer.cornerRadius = 7.f;
        _releaseBtn.layer.masksToBounds = YES;
        _releaseBtn.backgroundColor = COLOR_RED_EA0000;
        [_releaseBtn addTarget:self action:@selector(onClickReleaseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseBtn;
}

#pragma mark - 发布按钮点击事件
- (void)onClickReleaseBtn:(UIButton *)button
{
    
}
- (void)setUpReleaseSubVeiws
{
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navTilteView.mas_bottom);
        if (self.photoArray.count > 4) {
            make.height.mas_equalTo(getWidth(256.f));
        }else{
            make.height.mas_equalTo(getWidth(181.f));
        }
    }];
    
    [self.uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.uploadLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/5*4);
    }];
    
    [self.uploadNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.uploadView).offset(getWidth(-26.f));
        make.bottom.mas_equalTo(self.uploadLine.mas_bottom).offset(getWidth(-11.f));
        make.width.mas_equalTo(getWidth(25.f));
        make.height.mas_equalTo(self.uploadNumLabel.font.pointSize);
    }];
    
    [self.uploadLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.uploadView);
        make.top.mas_equalTo(self.uploadLabel.mas_bottom).offset(getWidth(11.f));
        make.height.mas_equalTo(0.5f);
    }];
    
    CGFloat space = (kScreenWidth - getWidth(75.f) * 4 - getWidth(45.f))/3;

    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.uploadView);
        make.top.mas_equalTo(self.uploadLine.mas_bottom);
        if (self.photoArray.count > 4) {
            make.height.mas_equalTo(getWidth(75.f) * 2 + space);
        }else{
            make.height.mas_equalTo(getWidth(75.f) + space);
        }
    }];
    
    [_starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(9), getWidth(8)));
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(getWidth(10.f));
    }];
    
    [self.leavesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uploadView).offset(getWidth(33.f));
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(getWidth(14.f));
        make.width.mas_equalTo(getWidth(kScreenWidth - 66.f));
        make.height.mas_equalTo(self.leavesLabel.font.pointSize);
    }];
    
    [self.exampleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadView.mas_bottom).offset(getWidth(24.f));
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(215.f));
    }];
    
    [self.exampleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(21.f));
        make.top.mas_equalTo(getWidth(15.f));
        make.height.mas_equalTo(self.exampleLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/5*4);
    }];
    
    [self.exampleBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.exampleView);
        make.top.mas_equalTo(self.exampleLabel.mas_bottom).offset(getWidth(10.f));;
    }];

    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(155.f), getWidth(115.f)));
        make.left.mas_equalTo(self.exampleBGView).offset(getWidth(20.f));
        make.top.mas_equalTo(self.exampleBGView);
    }];

    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.leftBtn);
        make.height.mas_equalTo(self.leftLabel.font.pointSize + getWidth(10.f));
    }];

    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(155.f), getWidth(115.f)));
        make.right.mas_equalTo(self.exampleBGView).offset(getWidth(-20.f));
        make.top.mas_equalTo(self.exampleBGView);
    }];

    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.rightBtn);
        make.height.mas_equalTo(self.leftLabel.font.pointSize + getWidth(10.f));
    }];

    [self.tipOneStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(19.f));
        make.top.mas_equalTo(self.leftBtn.mas_bottom).offset(getWidth(17.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(9.f), getWidth(8.f)));
    }];

    [self.tipTwoStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(19.f));
        make.top.mas_equalTo(self.leftBtn.mas_bottom).offset(getWidth(37.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(9.f), getWidth(8.f)));
    }];

    [self.tipOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(34.f));
        make.top.mas_equalTo(self.leftBtn.mas_bottom).offset(getWidth(16.f));
        make.right.mas_equalTo(getWidth(-34.f));
        make.height.mas_equalTo(self.tipOneLabel.font.pointSize);
    }];

    [self.tipTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(34.f));
        make.top.mas_equalTo(self.tipOneLabel.mas_bottom).offset(getWidth(10.f));
        make.right.mas_equalTo(getWidth(-34.f));
        make.height.mas_equalTo(self.tipTwoLabel.font.pointSize);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(getWidth(85.f) + g_bottomSafeAreaHeight);
    }];
    
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(335.f), getWidth(45.f)));
        make.top.mas_equalTo(getWidth(22.f));
        make.centerX.mas_equalTo(self.bottomView);
    }];
}

#pragma mark - 获取相机或相册图片按钮点击事件
- (void)makePhotosSheetClick:(UIButton *)button
{
    self.selectedPhotoBtnIndex = button.tag;

    [self.alertSheet show:YES];
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
            imagePicker.maxImagesCount = 8;
            self.imagePicker = imagePicker;
        }
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
//    [self setPhotosAboveSheet:self.selectedPhotoBtnIndex andphoto:photo];
    if(selectBtn_tag >= 0 && (selectBtn_tag != (_photoArray.count - 1))){
        [_photoArray replaceObjectAtIndex:selectBtn_tag withObject:photo];
        selectBtn_tag = -1;
    }else{
        if (_photoArray.count == 1) { // 添加图片
            
            [_photoArray insertObject:photo atIndex:0];
            
        } else {
            
            [_photoArray insertObject:photo atIndex:0];
        }
    }
    [_photoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (int i = 0; i < _photoArray.count; i ++) {
        int row = i % 4;
        UIButton *btn = [self creatButtonWithImage:_photoArray[i] With:row];
        [btn setBackgroundImage:_photoArray[i] forState:UIControlStateNormal];
        [_photoView addSubview:btn];
        
        if (i == _photoArray.count-1) {
            [btn addTarget:self action:@selector(cameraBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    HPLog(@"333:%@",_photoArray);

    [self dismissViewControllerAnimated:self.photoPicker completion:nil];
}

#pragma mark -获取来的图片进行btn赋值设置
- (void)setPhotosAboveSheet:(HPReleaseImageBtnIndex)btnIndex andphoto:(UIImage *)photo
{
    NSString *photoKey = [NSString stringWithFormat:@"%ld",btnIndex];
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    photoDic[photoKey] = photo;
    if (![self.photoArray containsObject:photoDic]) {
        [self.photoArray addObject:photoDic];
    }else{
        [self.photoArray removeObject:photoDic];
    }
    self.uploadNumLabel.text = [NSString stringWithFormat:@"%ld/8",self.photoArray.count];;
    UIButton *photoBtn = [self.view viewWithTag:btnIndex];
    [photoBtn setImage:ImageNamed(@"") forState:UIControlStateNormal];
    [photoBtn setTitle:@"" forState:UIControlStateNormal];
    switch (self.selectedPhotoBtnIndex) {
        case HPReleaseImageBtnIndexFace:
            [photoBtn setBackgroundImage:photo forState:UIControlStateNormal];
            break;
        case HPReleaseImageBtnIndexStoreInside:
            [photoBtn setBackgroundImage:photo forState:UIControlStateNormal];
            
            break;
        case HPReleaseImageBtnIndexFreeSpace:
            [photoBtn setBackgroundImage:photo forState:UIControlStateNormal];
            
            break;
        case HPReleaseImageBtnIndexFreeeSpaceMore:
            [photoBtn setBackgroundImage:photo forState:UIControlStateNormal];
            
            break;
        default:
           
            break;
    }
}
#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    picker.allowCrop = YES;
    UIImage *photo = photos[0];
    [self setPhotosAboveSheet:self.selectedPhotoBtnIndex andphoto:photo];
}

@end
