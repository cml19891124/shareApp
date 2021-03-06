//
//  HPBaseReleaseController.h
//  HPShareApp
//
//  Created by Jay on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTextInputController.h"
#import "HPAlertSheet.h"
#import "HPTextDialogView.h"
#import "HPLinkageSheetView.h"
#import "HPRowPanel.h"
#import "HPAlignCenterButton.h"
#import "HPImageUtil.h"
#import "HPSelectTable.h"
#import "HPTagDialogView.h"
#import "HPCalendarDialogView.h"
#import "TZImagePickerController.h"
#import "HPAddPhotoView.h"
#import "HPTimePicker.h"
#import "HPCommonData.h"
#import "HPShareReleaseParam.h"
#import "HPShareDetailModel.h"

#define PANEL_SPACE 10.f

NS_ASSUME_NONNULL_BEGIN

@interface HPBaseReleaseController : HPBaseTextInputController <TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) HPAlertSheet *alertSheet;

@property (nonatomic, weak) HPTextDialogView *dialogView;

@property (nonatomic, weak) HPLinkageSheetView *districtSheetView;

@property (nonatomic, weak) HPLinkageSheetView *tradeSheetView;

@property (nonatomic, weak) HPTagDialogView *tagDialogView;

/**
 意向行业的弹框
 */
@property (nonatomic, weak) HPTagDialogView *tagIntentionView;

@property (nonatomic, weak) HPTimePicker *timePicker;

@property (nonatomic, weak) HPCalendarDialogView *calendarDialogView;

@property (nonatomic, strong) UIImagePickerController *photoPicker;

@property (nonatomic, weak) TZImagePickerController *imagePicker;

@property (nonatomic, weak) HPAddPhotoView *addPhotoView;

@property (nonatomic, strong) NSArray *areaModels;

@property (nonatomic, strong) NSArray *industryModels;

@property (nonatomic, strong) HPDistrictModel *selectedDistrictModel;

@property (nonatomic, strong) HPIndustryModel *selectedIndustryModel;

@property (nonatomic, strong) HPShareReleaseParam *shareReleaseParam;

@property (nonatomic, strong) NSMutableArray *intentionArray;
//新增 信息完整度 字典
@property (nonatomic, strong) NSMutableDictionary *infoDict;

//添加公共UI组件

- (UILabel *)setupTitleLabelWithText:(NSString *)text ofView:(UIView *)view;

- (UILabel *)setupOptTitleLabelWithText:(NSString *)text ofView:(UIView *)view;

- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)text ofView:(UIView *)view rightTo:(UIView *)rightView;

- (UILabel *)setupUnitLabelWithText:(NSString *)text ofView:(UIView *)view;

- (UIImageView *)setupDownIconOfView:(UIView *)view;

//点击按钮触发弹窗方法

- (void)onClickUploadBtn:(UIButton *)btn;

- (void)onClickBackBtn;

- (void)onClickDistrictBtn:(UIButton *)btn;

- (void)onClickTradeBtn:(UIButton *)btn;

- (void)onClickTagBtn:(UIButton *)btn;

- (void)onClickGetIndustryTagBtn:(UIButton *)btn;

- (void)onClickTimeBtn:(UIButton *)btn;

- (void)onClickCalendarBtn:(UIButton *)btn;

- (void)onClickAlbumOrPhotoSheetWithTag:(NSInteger)tag;

//初始化弹窗控件

- (void)initDistrictSheetViewWithBtn:(UIButton *)btn;

- (void)initTradeSheetViewWithBtn:(UIButton *)btn;

- (void)initTagDialogViewWithBtn:(UIButton *)btn;
#pragma mark - 意向行业
- (void)initTagDialogViewWithIntentionIndustryBtn:(UIButton *)btn;

- (void)initTimePickerWithBtn:(UIButton *)btn;

- (void)initCalendarViewWithBtn:(UIButton *)btn;

//网络请求

- (void)getAreaList;

- (void)getTradeList;

//子类重写，编辑拼租管理填充数据

- (void)loadData:(HPShareDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
