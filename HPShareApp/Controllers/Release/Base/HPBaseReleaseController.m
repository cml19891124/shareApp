//
//  HPBaseReleaseController.m
//  HPShareApp
//
//  Created by Jay on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseReleaseController.h"

@interface HPBaseReleaseController () <UIGestureRecognizerDelegate>

@end

@implementation HPBaseReleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:COLOR_GRAY_F6F6F6];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_navigationBarHeight);
        make.left.and.width.and.bottom.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScrollViewTap)];
    [tapGesture setDelegate:self];
    [scrollView addGestureRecognizer:tapGesture];
    
    self.areaModels = [HPCommonData getAreaData];
    self.industryModels = [HPCommonData getIndustryData];
    
    _isUpdate = NO;
    _shareReleaseParam = [HPShareReleaseParam new];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - setupCommonUI

- (UILabel *)setupTitleLabelWithText:(NSString *)text ofView:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:text];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    return titleLabel;
}

- (UILabel *)setupOptTitleLabelWithText:(NSString *)text ofView:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [titleLabel setTextColor:COLOR_BLACK_666666];
    [titleLabel setText:text];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    return titleLabel;
}

- (UITextField *)setupTextFieldWithPlaceholder:(NSString *)text ofView:(UIView *)view rightTo:(UIView *)rightView {
    UITextField *textField = [[UITextField alloc] init];
    [textField setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [textField setTextColor:COLOR_BLACK_333333];
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:text];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:COLOR_GRAY_CCCCCC
                        range:NSMakeRange(0, text.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:FONT_MEDIUM size:15.f]
                        range:NSMakeRange(0, text.length)];
    [textField setAttributedPlaceholder:placeholder];
    
    [view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        if (rightView == view) {
            make.right.equalTo(rightView).with.offset(-20.f * g_rateWidth);
        }
        else {
            make.right.equalTo(rightView.mas_left).with.offset(-20.f * g_rateWidth);
        }
        make.centerY.equalTo(view);
    }];
    
    return textField;
}

- (UILabel *)setupUnitLabelWithText:(NSString *)text ofView:(UIView *)view {
    UILabel *unitLabel = [[UILabel alloc] init];
    [unitLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [unitLabel setTextColor:COLOR_BLACK_666666];
    [unitLabel setTextAlignment:NSTextAlignmentRight];
    [unitLabel setText:text];
    [view addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
        make.width.mas_equalTo(45.f);
        make.centerY.equalTo(view);
    }];
    
    return unitLabel;
}

- (UIImageView *)setupDownIconOfView:(UIView *)view {
    UIImageView *downIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_the_arrow_gray"]];
    [view addSubview:downIcon];
    [downIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(8.f, 13.f));
    }];
    return downIcon;
}

#pragma mark - onClick

- (void)onClickUploadBtn:(UIButton *)btn {
    [self.alertSheet show:YES];
}

- (void)onClickBackBtn {
    if (self.dialogView == nil) {
        HPTextDialogView *dialogView = [[HPTextDialogView alloc] init];
        [dialogView setText:@"确定放弃本次发布？"];
        __weak typeof(self) weakSelf = self;
        [dialogView setConfirmCallback:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        self.dialogView = dialogView;
    }
    
    [self.dialogView show:YES];
}

- (void)onClickDistrictBtn:(UIButton *)btn {
    if (self.districtSheetView == nil) {
        HPLinkageData *linkageData = [[HPLinkageData alloc] initWithModels:_areaModels];
        HPLinkageSheetView *districtSheetView = [[HPLinkageSheetView alloc] initWithData:linkageData singleTitles:@[] allSingleCheck:YES];
        [districtSheetView setSelectDescription:@"选择区域"];
        [districtSheetView selectCellAtParentIndex:0 childIndex:0];
        
        [districtSheetView setConfirmCallback:^(NSString *selectedParent, NSArray *checkItems, NSObject *selectedChildModel) {
            NSString *checkItemStr = [NSString stringWithFormat:@"%@ : ", selectedParent];;
            for (NSString *checkItem in checkItems) {
                checkItemStr = [checkItemStr stringByAppendingString:checkItem];
                
                if (checkItem != checkItems.lastObject) {
                    checkItemStr = [checkItemStr stringByAppendingString:@", "];
                }
            }
            
            self.selectedDistrictModel = (HPDistrictModel *)selectedChildModel;
            [btn setTitle:checkItemStr forState:UIControlStateSelected];
            [btn setSelected:YES];
        }];
        
        _districtSheetView = districtSheetView;
    }
    
    [_districtSheetView show:YES];
}

- (void)onClickTradeBtn:(UIButton *)btn {
    if (self.tradeSheetView == nil) {
        HPLinkageData *linkageData = [[HPLinkageData alloc] initWithModels:_industryModels];
        [linkageData setParentNameKey:@"industryName"];
        [linkageData setChildNameKey:@"industryName"];
        HPLinkageSheetView *tradeSheetView = [[HPLinkageSheetView alloc] initWithData:linkageData singleTitles:@[] allSingleCheck:YES];
        [tradeSheetView setSelectDescription:@"选择行业"];
        [tradeSheetView selectCellAtParentIndex:0 childIndex:0];
        
        [tradeSheetView setConfirmCallback:^(NSString *selectedParent, NSArray *checkItems, NSObject *selectedChildModel) {
            NSString *checkItemStr = [NSString stringWithFormat:@"%@ : ", selectedParent];;
            for (NSString *checkItem in checkItems) {
                checkItemStr = [checkItemStr stringByAppendingString:checkItem];
                
                if (checkItem != checkItems.lastObject) {
                    checkItemStr = [checkItemStr stringByAppendingString:@", "];
                }
            }
            
            self.selectedIndustryModel = (HPIndustryModel *)selectedChildModel;
            [btn setTitle:checkItemStr forState:UIControlStateSelected];
            [btn setSelected:YES];
        }];
        
        self.tradeSheetView = tradeSheetView;
    }
    
    [self.tradeSheetView show:YES];
}

- (void)onClickTagBtn:(UIButton *)btn {
    if (self.tagDialogView == nil) {
        NSArray *items = @[@"品牌连锁", @"百年老店", @"街角旺铺", @"交通便利", @"客流量大", @"配套齐全"];
        HPTagDialogView *tagDialogView = [[HPTagDialogView alloc] initWithItems:items];
        [tagDialogView setModalTop:150.f * g_rateHeight];
        [tagDialogView setModalSize:CGSizeMake(300.f * g_rateWidth, 343.f * g_rateWidth)];
        [tagDialogView setMaxCheckNum:3];
        __weak typeof(tagDialogView) weakTagDialogView = tagDialogView;
        [tagDialogView setConfirmCallback:^{
            NSArray *checkItems = weakTagDialogView.checkItems;
            NSString *title = @"";
            
            for (int i = 0; i < checkItems.count; i ++) {
                title = [title stringByAppendingString:checkItems[i]];
                
                if (i != checkItems.count - 1) {
                    title = [title stringByAppendingString:@"，"];
                }
            }
            
            [btn setTitle:title forState:UIControlStateSelected];
            [btn setSelected:YES];
        }];
        
        self.tagDialogView = tagDialogView;
    }
    
    [self.tagDialogView show:YES];
}

- (void)onClickTimeBtn:(UIButton *)btn {
    if (self.timePicker == nil) {
        HPTimePicker *timePicker = [[HPTimePicker alloc] init];
        __weak HPTimePicker *weakTimePicker = timePicker;
        [timePicker setConfirmCallback:^{
            [btn setTitle:[weakTimePicker getTimeStr] forState:UIControlStateSelected];
            [btn setSelected:YES];
        }];
        self.timePicker = timePicker;
    }
    
    [self.timePicker show:YES];
}

- (void)onClickCalendarBtn:(UIButton *)btn {
    if (self.calendarDialogView == nil) {
        HPCalendarDialogView *calendarDialogView = [[HPCalendarDialogView alloc] init];
        __weak HPCalendarDialogView *weakCalendarDialogView = calendarDialogView;
        [calendarDialogView setConfirmCallback:^{
            NSArray *selectedDates = weakCalendarDialogView.selectedDates;
            if (selectedDates.count == 0) {
                [btn setSelected:NO];
            }
            else {
                [btn setTitle:[NSString stringWithFormat:@"%lu天", (unsigned long)selectedDates.count] forState:UIControlStateSelected];
                [btn setSelected:YES];
            }
        }];
        self.calendarDialogView = calendarDialogView;
    }
    
    [self.calendarDialogView show:YES];
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

# pragma mark - UIGestureRecognizerDelegate

- (void)onScrollViewTap {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:HPAlignCenterButton.class]) {
        return NO;
    }

    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    if (_addPhotoView) {
        [_addPhotoView setHidden:NO];
        UIImage *photo = info[UIImagePickerControllerOriginalImage];
        [_addPhotoView addPhoto:photo];
        [self.imagePicker setMaxImagesCount:self.imagePicker.maxImagesCount - 1];
    }
    
    [self dismissViewControllerAnimated:self.photoPicker completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (_addPhotoView) {
        [_addPhotoView setHidden:NO];
        
        for (UIImage *photo in photos) {
            [_addPhotoView addPhoto:photo];
            [self.imagePicker setMaxImagesCount:self.imagePicker.maxImagesCount - 1];
        }
    }
}

#pragma mark - NetWork

- (void)getAreaList {
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/area/list" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            weakSelf.areaModels = [HPAreaModel mj_objectArrayWithKeyValuesArray:DATA];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)getTradeList {
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/industry/listWithChildren" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            weakSelf.industryModels = [HPIndustryModel mj_objectArrayWithKeyValuesArray:DATA];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
