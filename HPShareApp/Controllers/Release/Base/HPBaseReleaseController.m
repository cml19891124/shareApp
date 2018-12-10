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

- (void)onClickReleaseBtn {
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
}

- (void)onClickTradeBtn:(UIButton *)btn {
    if (self.tradeSheetView == nil) {
        NSDictionary *data = @{@"parent":@[@"餐饮美食", @"购物消费", @"休闲娱乐", @"其他"],
                               @"children":@{
                                       @"餐饮美食":@[@"不限", @"粤菜", @"湘菜", @"川菜", @"东北菜", @"西北菜", @"江浙菜", @"台湾菜", @"烧烤", @"火锅", @"海鲜", @"粥粉面", @"自助餐", @"快餐简餐", @"茶餐厅", @"咖啡厅", @"面包甜点", @"奶茶饮品", @"韩式", @"日料", @"西餐厅", @"东南亚菜"],
                                       @"购物消费":@[@"不限", @"购物消费1", @"购物消费2", @"购物消费3", @"购物消费4"],
                                       @"休闲娱乐":@[@"不限", @"休闲娱乐1", @"休闲娱乐2", @"休闲娱乐3", @"休闲娱乐4"],
                                       @"其他":@[@"不限", @"其他1", @"其他2", @"其他3", @"其他4"]}};
        HPLinkageData *linkageData = [[HPLinkageData alloc] initWithParents:data[@"parent"] Children:data[@"children"]];
        HPLinkageSheetView *tradeSheetView = [[HPLinkageSheetView alloc] initWithData:linkageData singleTitles:@[@"不限"] allSingleCheck:NO];
        [tradeSheetView setSelectDescription:@"选择行业"];
        [tradeSheetView setMaxCheckNum:3];
        [tradeSheetView selectCellAtParentIndex:0 childIndex:0];
        
        [tradeSheetView setConfirmCallback:^(NSString *selectedParent, NSArray *checkItems) {
            NSString *checkItemStr = [NSString stringWithFormat:@"%@ : ", selectedParent];;
            for (NSString *checkItem in checkItems) {
                checkItemStr = [checkItemStr stringByAppendingString:checkItem];
                
                if (checkItem != checkItems.lastObject) {
                    checkItemStr = [checkItemStr stringByAppendingString:@", "];
                }
            }
            
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
    NSLog(@"UIImagePickerController");
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
    NSLog(@"didFinishPickingPhotos: %ld", photos.count);
    
    if (_addPhotoView) {
        [_addPhotoView setHidden:NO];
        
        for (UIImage *photo in photos) {
            [_addPhotoView addPhoto:photo];
            [self.imagePicker setMaxImagesCount:self.imagePicker.maxImagesCount - 1];
        }
    }
}

@end
