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

#define PANEL_SPACE 10.f

NS_ASSUME_NONNULL_BEGIN

@interface HPBaseReleaseController : HPBaseTextInputController <TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) HPAlertSheet *alertSheet;

@property (nonatomic, weak) HPTextDialogView *dialogView;

@property (nonatomic, weak) HPLinkageSheetView *tradeSheetView;

@property (nonatomic, weak) HPTagDialogView *tagDialogView;

@property (nonatomic, weak) HPTimePicker *timePicker;

@property (nonatomic, weak) HPCalendarDialogView *calendarDialogView;

@property (nonatomic, strong) UIImagePickerController *photoPicker;

@property (nonatomic, weak) TZImagePickerController *imagePicker;

@property (nonatomic, weak) HPAddPhotoView *addPhotoView;

- (UILabel *)setupTitleLabelWithText:(NSString *)text ofView:(UIView *)view;

- (UILabel *)setupOptTitleLabelWithText:(NSString *)text ofView:(UIView *)view;

- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)text ofView:(UIView *)view rightTo:(UIView *)rightView;

- (UILabel *)setupUnitLabelWithText:(NSString *)text ofView:(UIView *)view;

- (UIImageView *)setupDownIconOfView:(UIView *)view;

- (void)onClickUploadBtn:(UIButton *)btn;

- (void)onClickBackBtn;

- (void)onClickReleaseBtn;

- (void)onClickDistrictBtn:(UIButton *)btn;

- (void)onClickTradeBtn:(UIButton *)btn;

- (void)onClickTagBtn:(UIButton *)btn;

- (void)onClickTimeBtn:(UIButton *)btn;

- (void)onClickCalendarBtn:(UIButton *)btn;

- (void)onClickAlbumOrPhotoSheetWithTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
