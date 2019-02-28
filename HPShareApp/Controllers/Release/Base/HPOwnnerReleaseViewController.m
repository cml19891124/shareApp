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
#import "HPAddressModel.h"
#import "HPAlertSheet.h"
#import "TZImagePickerController.h"
#import "HPAddPhotoView.h"
#import "HPUploadImageHandle.h"
#import "HPTextDialogView.h"
#import "HPInfoModel.h"

typedef NS_ENUM(NSInteger, HPReleaseImageBtnIndex) {
    HPReleaseImageBtnIndexFace = 150,
    HPReleaseImageBtnIndexStoreInside,
    HPReleaseImageBtnIndexFreeSpace,
    HPReleaseImageBtnIndexFreeeSpaceMore,
    HPReleaseImageBtnIndexFreeSpaceZeroInRowOne,
    HPReleaseImageBtnIndexFreeSpaceOneInRowOne,
    HPReleaseImageBtnIndexFreeSpaceTwoInRowOne,
    HPReleaseImageBtnIndexFreeSpaceThreeInRowOne
};

typedef NS_ENUM(NSInteger, HPDeleteImageBtnIndex) {
    HPDeleteImageBtnIndexFace = 160,
    HPDeleteImageBtnIndexStoreInside,
    HPDeleteImageBtnIndexFreeSpace,
    HPDeleteImageBtnIndexFreeeSpaceMore,
    HPDeleteImageBtnIndexFreeSpaceZeroInRowOne,
    HPDeleteImageBtnIndexFreeSpaceOneInRowOne,
    HPDeleteImageBtnIndexFreeSpaceTwoInRowOne,
    HPDeleteImageBtnIndexFreeSpaceThreeInRowOne
};
@interface HPOwnnerReleaseViewController ()

/**
 是否是第一次点击选择图片，否就需要交换元素，是就需要把后续来的图片插入倒数第二的位置
 */
@property (nonatomic, assign) BOOL isFirst;


/**
 是封面
 */
@property (nonatomic, assign) BOOL isFace;
@property (nonatomic, weak) HPTextDialogView *setFaceDialogView;
@property (nonatomic, weak) HPTextDialogView *deleteImageDialogView;

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

#pragma mark - 创建照片按钮
- (void)setUpUploadButton
{
    [_photoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.photoArray.count; i++) {
        CGFloat row = i/4;
        CGFloat col = i%4;
        CGFloat btnY = getWidth(15.f) + getWidth(75.f) *row;
        HPUploadButton *btn = [HPUploadButton new];
        [btn setImage:ImageNamed(@"shop_transfer_upload") forState:UIControlStateNormal];
        
        if ([self.photoArray[i] isKindOfClass:UIImage.class]) {
            [btn setImage:ImageNamed(@"") forState:UIControlStateNormal];
            [btn setBackgroundImage:self.photoArray[i] forState:UIControlStateNormal];
        }else if ([self.photoArray[i] isKindOfClass:NSString.class]){

            [btn setImage:ImageNamed(self.photoArray[i]) forState:UIControlStateNormal];
        }
        if (i == self.photoArray.count-1 && self.photoArray.count == 1) {
            [btn setImage:ImageNamed(@"shop_transfer_upload") forState:UIControlStateNormal];
        }
        [btn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        btn.backgroundColor = COLOR_GRAY_F2F2F2;
        btn.layer.cornerRadius = 2.f;
        btn.layer.masksToBounds = YES;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = kFont_Medium(11.f);
        btn.tag = 150 + i;
        //点击后设置当前图片为店铺封面
        [btn addTarget:self action:@selector(setCurrentImageAsFaceImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoView addSubview:btn];
        self.btn = btn;
        if (i == 0 && self.photoArray.count != 1) {
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

        if (i == self.photoArray.count - 1)
        {
            if ([self.photoArray containsObject:@"shop_transfer_upload"]) {
                deleteBtn.hidden = YES;
            }
            [btn addTarget:self action:@selector(clickedCameraBtnToAddImages:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((getWidth(75.f) + space)*col + getWidth(67.5f) + getWidth(20.f));
            make.top.mas_equalTo(self.photoView).offset(getWidth(15.f) + getWidth(-7.5f) + (space + getWidth(65.f)) * row);
            make.width.mas_equalTo(getWidth(15.f));
            make.height.mas_equalTo(getWidth(15.f));
        }];
    }
}


#pragma mark - 点击图片按钮-只有非店铺封面的按钮才可以点击设置为店铺封面
- (void)setCurrentImageAsFaceImage:(UIButton *)button
{
    if (self.photoArray.count > 1 && button.tag != HPReleaseImageBtnIndexFace && button.tag != 150 + self.photoArray.count - 1) {
        if (_setFaceDialogView == nil) {
            HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
            [textDialogView setText:@"是否设置为店铺封面？"];
            [textDialogView setModalTop:279.f * g_rateHeight];
            [textDialogView setCanecelBtnTitle:@"取消"];
            [textDialogView setConfirmBtnTitle:@"确认"];
            _setFaceDialogView = textDialogView;
        }
        [_setFaceDialogView setConfirmCallback:^{
            [self.photoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //获取封面图片
            UIImage *faceImage = self.photoArray[0];
            //用点击的按钮图片替换当前第一个元素的封面图片
            [self.photoArray replaceObjectAtIndex:0 withObject:self.photoArray[button.tag - 150]];
            //移除当前位置的图片
            [self.photoArray removeObjectAtIndex:button.tag - 150];
            //
            [self.photoArray insertObject:faceImage atIndex:button.tag - 150];
            [self setUpUploadButton];
            
            [self.view layoutIfNeeded];
            [self.photoView layoutIfNeeded];
        }];
        [_setFaceDialogView show:YES];
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

#pragma mark - 添加图片按钮的点击事件
- (void)clickedCameraBtnToAddImages:(UIButton *)button
{
    [self makePhotosSheetClick:button];
}


/**
 删除图片
 */
- (void)clickToDeletephoto:(UIButton *)button
{
    if (_deleteImageDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setText:@"是否删除图片？"];
        [textDialogView setModalTop:279.f * g_rateHeight];
        [textDialogView setCanecelBtnTitle:@"取消"];
        [textDialogView setConfirmBtnTitle:@"删除"];
        _deleteImageDialogView = textDialogView;
    }
    kWeakSelf(weakSelf);
    __strong typeof(&*weakSelf) strongSelf = weakSelf;
    [_deleteImageDialogView setConfirmCallback:^{
        // 此处加入点击确认后的操作
        if (button.tag == HPDeleteImageBtnIndexFace) {
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFace - 160];
        }else if(button.tag == HPDeleteImageBtnIndexStoreInside){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexStoreInside - 160];
        }else if(button.tag == HPDeleteImageBtnIndexFreeSpace){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeSpace - 160];
        }else if(button.tag == HPDeleteImageBtnIndexFreeeSpaceMore){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeeSpaceMore - 160];
        }else if(button.tag == HPDeleteImageBtnIndexFreeSpaceZeroInRowOne){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeSpaceZeroInRowOne - 160];
        }else if(button.tag == HPDeleteImageBtnIndexFreeSpaceOneInRowOne){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeSpaceOneInRowOne - 160];
        }else if(button.tag == HPDeleteImageBtnIndexFreeSpaceTwoInRowOne){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeSpaceTwoInRowOne - 160];
        }else if(button.tag == HPDeleteImageBtnIndexFreeSpaceThreeInRowOne){
            [self.photoArray removeObjectAtIndex:HPDeleteImageBtnIndexFreeSpaceThreeInRowOne - 160];
        }
        
        //添加按钮的添加
        if (self.photoArray.count >= 9) {//数量达到
            [self.photoArray removeLastObject];
        }else{
            if (![self.photoArray containsObject:@"shop_transfer_upload"]) {
                [self.photoArray insertObject:@"shop_transfer_upload" atIndex:self.photoArray.count];
            }
        }
        
        
        if (![strongSelf.photoArray containsObject:@"shop_transfer_upload"]) {
            strongSelf.uploadNumLabel.text = [NSString stringWithFormat:@"%ld/8",self.photoArray.count];
        }else
        {
            strongSelf.uploadNumLabel.text = [NSString stringWithFormat:@"%ld/8",self.photoArray.count - 1];
        }
        
        [strongSelf setUpUploadButton];

        CGFloat space = (kScreenWidth - getWidth(75.f) * 4 - getWidth(45.f))/3;
        
        [strongSelf.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.uploadView);
            make.top.mas_equalTo(self.uploadLine.mas_bottom);
            if (self.photoArray.count > 4) {
                make.height.mas_equalTo(getWidth(75.f) * 2 + space);
            }else{
                make.height.mas_equalTo(getWidth(75.f) + space);
            }
        }];
        
        [self.view layoutIfNeeded];
        [self.photoView layoutIfNeeded];
        [strongSelf.photoView layoutIfNeeded];
        [strongSelf.view layoutIfNeeded];
    }];
    
    [_deleteImageDialogView show:YES];
    
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
        _rightLabel.text = @"拼租空间照片";
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
    
    HPLoginModel *loginModel = [HPUserTool account];
    if (!loginModel.token) {
        [HPProgressHUD alertMessage:@"用户未登录"];
        return;
    }
    
    NSString *userId = loginModel.userInfo.userId;
    //获取定位信息
    HPAddressModel *addressModel = [HPAddressModel mj_objectWithKeyValues:[kUserDefaults objectForKey:@"address"]];
    NSString *latitude;
    NSString *longitude;
    NSString *address;
    if (addressModel) {
        latitude = [NSString stringWithFormat:@"%lf", addressModel.lat];
        longitude = [NSString stringWithFormat:@"%lf", addressModel.lon];
        address = addressModel.POIName;
    }
    self.shareReleaseParam.latitude = latitude;
    self.shareReleaseParam.longitude = longitude;
    HPInfoModel *model = [HPInfoModel mj_objectWithKeyValues:self.infoDict];
    self.shareReleaseParam.title = model.converTitle;
    self.shareReleaseParam.shortName = model.storeName;

    NSString *areaRange = @"";
    if ([model.space containsString:@"不限"]) {
        areaRange = @"1";
    }else if ([model.space containsString:@"5㎡"]) {
        areaRange = @"2";
    }else if ([model.space containsString:@"10㎡"]) {
        areaRange = @"3";
    }else if ([model.space containsString:@"20㎡"]) {
        areaRange = @"4";
    }else if ([model.space containsString:@"以上"]) {
        areaRange = @"5";
    }
    self.shareReleaseParam.area = @"0";
    self.shareReleaseParam.areaRange = areaRange;
    NSArray *areaArr = [model.area componentsSeparatedByString:@"-"];
    self.shareReleaseParam.areaId = [self getAreaIdByName:areaArr.firstObject];
    self.shareReleaseParam.districtId = [self getAreaIdByName:areaArr.firstObject andDistrictName:areaArr.lastObject];
    NSArray *industryNameArray = [model.industry componentsSeparatedByString:@"-"];
    self.shareReleaseParam.industryId = [HPCommonData getIndustryIdByIndustryName:industryNameArray.firstObject];
    self.shareReleaseParam.subIndustryId = [HPCommonData getIndustryIdByIndustryName:industryNameArray.lastObject];
    
    NSString *rentAmount = @"";
    if ([model.rentType containsString:@"元/小时"]) {
        NSRange range = [model.rentType rangeOfString:@"元/小时"];
        rentAmount = [model.rentType substringToIndex:range.location - 1];
    }else if ([model.rentType containsString:@"元/天"]){
        NSRange range = [model.rentType rangeOfString:@"元/天"];
        rentAmount = [model.rentType substringToIndex:range.location - 1];
    }else if ([model.rentType containsString:@"元/月"]){
        NSRange range = [model.rentType rangeOfString:@"元/月"];
        rentAmount = [model.rentType substringToIndex:range.location - 1];
    }else if ([model.rentType containsString:@"元/年"]){
        NSRange range = [model.rentType rangeOfString:@"元/年"];
        rentAmount = [model.rentType substringToIndex:range.location - 1];
    }
    self.shareReleaseParam.rent = rentAmount;
    
    NSString *rentType = @"";
    if ([model.rentType containsString:@"小时"]) {
        rentType = @"1";
    }else if ([model.rentType containsString:@"天"]){
        rentType = @"2";
    }else if ([model.rentType containsString:@"月"]){
        rentType = @"3";
    }else if ([model.rentType containsString:@"年"]){
        rentType = @"4";
    }
    self.shareReleaseParam.rentType = rentType;
    self.shareReleaseParam.shareTime = model.time;
    self.shareReleaseParam.contact = model.contact;
    self.shareReleaseParam.contactMobile = model.phone;
    self.shareReleaseParam.intention = model.intention;
    self.shareReleaseParam.remark = model.leaves;
    self.shareReleaseParam.userId = userId;
    self.shareReleaseParam.isApproved = @"0";
    self.shareReleaseParam.completeDegree = [self.ratio substringToIndex:self.ratio.length - 1];
    self.shareReleaseParam.address = model.address;
    self.shareReleaseParam.salesmanUserId = loginModel.salesman.userId?:@"";
    self.shareReleaseParam.type = @"1";
    self.shareReleaseParam.tag = model.storeTag;
    NSString *rentMode = @"";
    if ([model.rentType containsString:@"小时"]) {
        rentMode = @"1";
    }else if ([model.rentType containsString:@"天"]){
        rentMode = @"2";
    }else if ([model.rentType containsString:@"月"]){
        rentMode = @"3";
    }else if ([model.rentType containsString:@"年"]){
        rentMode = @"4";
    }
    self.shareReleaseParam.rentMode = rentMode;
    
    if (self.photoArray.count <= 1) {
        [HPProgressHUD alertMessage:@"至少上传一张照片"];
        return;
    }
    else if (!self.shareReleaseParam.title.length) {
        [HPProgressHUD alertMessage:@"请填写标题"];
        return;
    }
    else if (!self.shareReleaseParam.address.length) {
        [HPProgressHUD alertMessage:@"请填写地址"];
        return;
    }
    else if (!self.shareReleaseParam.industryId.length) {
        [HPProgressHUD alertMessage:@"请选择行业"];
        return;
    }
    else if (!self.shareReleaseParam.subIndustryId.length) {
        [HPProgressHUD alertMessage:@"请选择行业"];
        return;
    }
    else if (self.shareReleaseParam.contactMobile.length != 11) {
        [HPProgressHUD alertMessage:@"请填写联系方式"];
        return;
    }
    NSMutableArray *uploadArray = [NSMutableArray array];
    for (id imagestr in self.photoArray) {
        if ([imagestr isKindOfClass:UIImage.class]) {
            [uploadArray addObject:imagestr];
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseUrl,@"/v1/file/uploadPictures"];
    [HPUploadImageHandle upLoadImages:uploadArray withUrl:url parameterName:@"files" success:^(id responseObject) {
        if (CODE == 200) {
            NSArray<HPPictureModel *> *pictureModels = [HPPictureModel mj_objectArrayWithKeyValuesArray:DATA];
            for (HPPictureModel *pictureModel in pictureModels) {
                [self.shareReleaseParam.pictureIdArr addObject:pictureModel.pictureId];
                [self.shareReleaseParam.pictureUrlArr addObject:pictureModel.url];
            }
            
            if (self.param[@"spaceId"]) {
                [self.shareReleaseParam setSpaceId:self.param[@"spaceId"]];
                NSDictionary *param = self.shareReleaseParam.mj_keyValues;
                [self updateInfo:param];
            }
            else {
                NSDictionary *param = self.shareReleaseParam.mj_keyValues;
                [self releaseInfo:param];
            }
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
    } progress:^(double progress) {
        NSLog(@"progress: %lf", progress);
        [HPProgressHUD alertWithProgress:progress text:@"上传图片中"];
    } fail:^(NSError *error) {
        ErrorNet
    }];
}

#pragma mark - 上传修改信息
- (void)updateInfo:(NSDictionary *)param {
    [HPHTTPSever HPPostServerWithMethod:@"/v1/space/update" paraments:param needToken:YES complete:^(id  _Nonnull responseObject) {
        
        if (CODE == 200) {
            [HPProgressHUD alertWithFinishText:@"修改成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSNumber *index = self.param[@"index"];
                [self popWithParam:@{@"update":self.shareReleaseParam, @"index":index}];
            });
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
    } Progress:^(double progress) {
        [HPProgressHUD alertWithProgress:progress text:@"上传信息中"];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - 上传发布信息
- (void)releaseInfo:(NSDictionary *)param {
    [HPHTTPSever HPPostServerWithMethod:@"/v1/space/post" paraments:param needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertWithFinishText:@"发布成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
    } Progress:^(double progress) {
        [HPProgressHUD alertWithProgress:progress text:@"上传信息中"];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}


#pragma mark - 获取area_Id

- (NSString *)getAreaIdByName:(NSString *)name {
    for (HPAreaModel *areaModel in self.areaModels) {
        if ([areaModel.name isEqualToString:name]) {
            return areaModel.areaId;
        }
    }
    
    return nil;
}

#pragma mark - 获取districtId

- (NSString *)getAreaIdByName:(NSString *)name andDistrictName:(NSString *)districtName{
    for (HPAreaModel *areaModel in self.areaModels) {
        if ([areaModel.name isEqualToString:name]) {
            for (HPDistrictModel *districtModel in areaModel.children) {
                if ([districtModel.name isEqualToString:districtName]) {
                    return districtModel.districtId;

                }
            }
        }
    }
    
    return nil;
}

#pragma mark - masonry 布局
- (void)setUpReleaseSubVeiws
{
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navTilteView.mas_bottom);
        make.bottom.mas_equalTo(self.leavesLabel.mas_bottom).offset(getWidth(20.f));
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
    if (self.photoArray.count == 9) {
        [HPProgressHUD alertMessage:@"最多上传8张图片"];
    }else{
        [self.alertSheet show:YES];
    }
}

#pragma mark - 进入相册或拍照
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
    
    [self.view layoutIfNeeded];
    [self.photoView layoutIfNeeded];
    
    [_photoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self setUpUploadButton];
    
    
    if (self.photoArray.count >= 9) {//数量达到
        [self.photoArray removeLastObject];
    }
    self.uploadNumLabel.text = [NSString stringWithFormat:@"%ld/8",self.photoArray.count];
    [self setUpUploadButton];
    CGFloat space = (kScreenWidth - getWidth(75.f) * 4 - getWidth(45.f))/3;
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.uploadView);
        make.top.mas_equalTo(self.uploadLine.mas_bottom);
        if (self.photoArray.count > 4) {
            make.height.mas_equalTo(getWidth(75.f) * 2 + space);
        }else{
            make.height.mas_equalTo(getWidth(75.f) + space);
        }
    }];
    
    [self.view layoutIfNeeded];
    [self.photoView layoutIfNeeded];

    [self dismissViewControllerAnimated:self.photoPicker completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    if (!_isFirst) {//默认否 交换元素
        picker.allowCrop = YES;
        _isFirst = YES;
        [_photoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.photoArray addObjectsFromArray:photos];
        //移除第一个
        [self.photoArray removeObjectAtIndex:0];
        //将默认图片 插入最后一位
        [self.photoArray insertObject:@"shop_transfer_upload" atIndex:self.photoArray.count];
        
    }else{//获取到的图片依次插入倒数第二
        for (int i = 0; i < photos.count; i++) {
            [self.photoArray insertObject:photos[i] atIndex:self.photoArray.count - 1];
        }
    }
    if (self.photoArray.count >= 9) {//数量达到
        [self.photoArray removeLastObject];
    }else{
        
    }
    if (![self.photoArray containsObject:@"shop_transfer_upload"]) {
        self.uploadNumLabel.text = [NSString stringWithFormat:@"%ld/8",self.photoArray.count];
    }else
    {
        self.uploadNumLabel.text = [NSString stringWithFormat:@"%ld/8",self.photoArray.count - 1];
    }
    
    [self setUpUploadButton];
    CGFloat space = (kScreenWidth - getWidth(75.f) * 4 - getWidth(45.f))/3;
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.uploadView);
        make.top.mas_equalTo(self.uploadLine.mas_bottom);
        if (self.photoArray.count > 4) {
            make.height.mas_equalTo(getWidth(75.f) * 2 + space);
        }else{
            make.height.mas_equalTo(getWidth(75.f) + space);
        }
    }];
    
    [self.view layoutIfNeeded];
    [self.photoView layoutIfNeeded];
}

@end
