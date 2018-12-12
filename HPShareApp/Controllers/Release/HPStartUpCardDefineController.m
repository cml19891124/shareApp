//
//  HPStartUpCardDefineController.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPStartUpCardDefineController.h"
#import "HPUploadImageHandle.h"
#import "HPPictureModel.h"

#define PANEL_SPACE 10.f
#define TEXT_VIEW_PLACEHOLDER @"请输入您的需求，例：无需寄存货物，随到随卖，只需提供座椅，诚信经营，求长期合作。"

@interface HPStartUpCardDefineController () {
    BOOL _canRelease;
}

@property (nonatomic, weak) UITextField *titleField;//发布标题

@property (nonatomic, weak) UITextField *areaField;//期望面积

@property (nonatomic, weak) UITextField *priceField;//期望价格

@property (nonatomic, weak) HPSelectTable *unitSelectTable;//价格单位

@property (nonatomic, weak) UITextField *intentSpaceField;//意向空间

@property (nonatomic, weak) UITextField *contactField;//联系人

@property (nonatomic, weak) UITextField *phoneNumField;//手机号码

@property (nonatomic, weak) UITextView *remarkTextView;//备注信息

@end

@implementation HPStartUpCardDefineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBarWithTitle:@"需求发布"];
    self.isPopGestureRecognize = NO;
    _canRelease = YES;
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAreaList];
    [self getTradeList];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - setupUI

- (void)setupUI {
    for (int i = 0; i < 5; i++) {
        [self setupPanelAtIndex:i ofView:self.scrollView];
    }
    
    UIButton *releaseBtn = [[UIButton alloc] init];
    [releaseBtn.layer setCornerRadius:7.f];
    [releaseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [releaseBtn setBackgroundColor:COLOR_RED_FC4865];
    [releaseBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [releaseBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(onClickReleaseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:releaseBtn];
    [releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).with.offset(-20.f * g_rateWidth);
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView.subviews[4].mas_bottom).with.offset(40.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 45.f * g_rateWidth));
    }];
    
    
    __weak typeof(self) weakSelf = self;
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

- (void)setupPanelAtIndex:(NSInteger)index ofView:(UIView *)view {
    HPRowPanel *panel = [[HPRowPanel alloc] init];
    [view addSubview:panel];
    
    if (index == 0) {
        [panel addRowView:[self setupPhotoRowView] withHeight:187.f * g_rateWidth];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(view);
            make.height.mas_equalTo(187.f * g_rateWidth);
            make.top.equalTo(view);
        }];
    }
    else if (index == 1) {
        [panel addRowView:[self setupStartupTitleRowView]];
        [panel addRowView:[self setupTradeRowView]];
        [panel addRowView:[self setupProductTagRowView] withHeight:93.f * g_rateWidth];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(184.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
    else if (index == 2) {
        [panel addRowView:[self setupAreaRowView]];
        [panel addRowView:[self setupPriceRowView]];
        [panel addRowView:[self setupDistrictRowView]];
        [panel addRowView:[self setupShareTimeRowView]];
        [panel addRowView:[self setupShareDateRowView]];
        [panel addRowView:[self setupIntentSpaceRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(275.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
    else if (index == 3) {
        [panel addRowView:[self setupContactRowView]];
        [panel addRowView:[self setupPhoneNumRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(90.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
    else if (index == 4) {
        [panel addRowView:[self setupRemarkRowView]withHeight:175.f * g_rateWidth];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(175.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
}

- (UIView *)setupPhotoRowView {
    UIView *view = [[UIView alloc] init];
    
    HPAlignCenterButton *uploadBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"shop_transfer_upload"]];
    [uploadBtn setTextFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [uploadBtn setTextColor:COLOR_RED_FF3C5E];
    [uploadBtn setText:@"上传图片"];
    [uploadBtn addTarget:self action:@selector(onClickUploadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).with.offset(43.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(55.f, 72.f));
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_CCCCCC];
    [descLabel setText:@"上传品牌或产品图，提高合作机会。"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(uploadBtn.mas_bottom).with.offset(12.f * g_rateWidth);
        make.height.mas_equalTo(12.f);
    }];
    
    HPAddPhotoView *addPhotoView = [[HPAddPhotoView alloc] init];
    [addPhotoView setMaxNum:4];
    kWeakSelf(weakSelf);
    [addPhotoView setAddBtnCallBack:^{
        [weakSelf.alertSheet show:YES];
    }];
    [view addSubview:addPhotoView];
    self.addPhotoView = addPhotoView;
    [addPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [addPhotoView setHidden:YES];
    
    return view;
}

- (UIView *)setupStartupTitleRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"发布标题" ofView:view];
    _titleField = [self setupTextFieldWithPlaceholder:@"例：优品小店深圳急求共享铺位" ofView:view rightTo:view];
    
    return view;
}

- (UIView *)setupTradeRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"经营行业" ofView:view];
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    UIButton *valueBtn = [[UIButton alloc] init];
    [valueBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [valueBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [valueBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [valueBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [valueBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [valueBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [valueBtn addTarget:self action:@selector(onClickTradeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:valueBtn];
    [valueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.right.equalTo(downIcon.mas_left).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

- (UIView *)setupProductTagRowView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"产品/品牌标签"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [addBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [addBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [addBtn setTitle:@"添加产品或品牌标签(最多3个）" forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"customizing_business_cards_add_to"] forState:UIControlStateNormal];
    [addBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 15.f * g_rateWidth, 0.f, -15.f * g_rateWidth)];
    [addBtn addTarget:self action:@selector(onClickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(18.f * g_rateWidth);
    }];
    
    return view;
}

- (UIView *)setupAreaRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"期望面积" ofView:view];
    
    UILabel *unitLabel = [self setupUnitLabelWithText:@"（㎡）" ofView:view];
    
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"不填默认不限" ofView:view rightTo:unitLabel];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    _areaField = textField;
    
    return view;
}

- (UIView *)setupPriceRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"期望价格" ofView:view];
    
    NSArray *options = @[@"（元/小时）", @"（元/天）"];
    HPSelectTableLayout *layout = [[HPSelectTableLayout alloc] init];
    [layout setColNum:2];
    [layout setXSpace:-10.f * g_rateWidth];
    [layout setItemSize:CGSizeMake(68.f, 13.f)];
    [layout setNormalTextColor:COLOR_GRAY_CCCCCC];
    [layout setSelectTextColor:COLOR_BLACK_666666];
    [layout setNormalBgColor:UIColor.clearColor];
    [layout setSelectedBgColor:UIColor.clearColor];
    [layout setItemBorderWidth:0.f];
    HPSelectTable *unitSelectTable = [[HPSelectTable alloc] initWithOptions:options layout:layout];
    [unitSelectTable setBtnAtIndex:0 selected:YES];
    [view addSubview:unitSelectTable];
    _unitSelectTable = unitSelectTable;
    [unitSelectTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-10.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"不填默认面议" ofView:view rightTo:unitSelectTable];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    _priceField = textField;
    
    return view;
}

- (UIView *)setupDistrictRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"期望区域" ofView:view];
    
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    UIButton *valueBtn = [[UIButton alloc] init];
    [valueBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [valueBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [valueBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [valueBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [valueBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [valueBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [valueBtn addTarget:self action:@selector(onClickDistrictBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:valueBtn];
    [valueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.right.equalTo(downIcon.mas_left).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

- (UIView *)setupShareTimeRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"共享时段" ofView:view];
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    UIButton *valueBtn = [[UIButton alloc] init];
    [valueBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [valueBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [valueBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [valueBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [valueBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [valueBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [valueBtn addTarget:self action:@selector(onClickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:valueBtn];
    [valueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.right.equalTo(downIcon.mas_left).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

- (UIView *)setupShareDateRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"共享日期" ofView:view];
    
    UIButton *calendarBtn = [[UIButton alloc] init];
    [calendarBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [calendarBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [calendarBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [calendarBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [calendarBtn setImage:[UIImage imageNamed:@"customizing_business_calendar"] forState:UIControlStateNormal];
    [calendarBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [calendarBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -15.f, 0.f, 15.f)];
    [calendarBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, getWidth(233.f)-15.f, 0.f, -(getWidth(233.f)-15.f))];
    [calendarBtn addTarget:self action:@selector(onClickCalendarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:calendarBtn];
    [calendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
    }];
    
    return view;
}

- (UIView *)setupIntentSpaceRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"意向空间" ofView:view];
    _intentSpaceField = [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    
    return view;
}

- (UIView *)setupContactRowView {
    UIView *view = [[UIView alloc] init];
    [self setupTitleLabelWithText:@"联系人" ofView:view];
    _contactField = [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    return view;
}

- (UIView *)setupPhoneNumRowView {
    UIView *view = [[UIView alloc] init];
    [self setupTitleLabelWithText:@"手机号码" ofView:view];
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    _phoneNumField = textField;
    return view;
}

- (UIView *)setupRemarkRowView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"备注信息"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.height.mas_equalTo(15.f);
    }];
    
    UITextView *textView = [[UITextView alloc] init];
    [textView.layer setCornerRadius:5.f];
    [textView setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    [textView setTextColor:COLOR_GRAY_CCCCCC];
    [textView setBackgroundColor:COLOR_GRAY_F6F6F6];
    [textView setText:TEXT_VIEW_PLACEHOLDER];
    [textView setContentInset:UIEdgeInsetsMake(2.f, 5.f, 2.f, 5.f)];
    [textView setDelegate:self];
    [view addSubview:textView];
    _remarkTextView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(16.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 108.f * g_rateWidth));
    }];
    return view;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:TEXT_VIEW_PLACEHOLDER]) {
        [textView setTextColor:COLOR_BLACK_333333];
        [textView setText:@""];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        [textView setText:TEXT_VIEW_PLACEHOLDER];
        [textView setTextColor:COLOR_GRAY_CCCCCC];
    }
}

#pragma mark - onClick

- (void)onClickReleaseBtn {
    if (!_canRelease) {
        return;
    }
    _canRelease = NO;
    
    NSString *title = _titleField.text;
    NSString *area = _areaField.text;
    NSString *areaId = self.selectedDistrictModel.areaId;
    NSString *districtId = self.selectedDistrictModel.districtId;
    NSString *industryId = self.selectedIndustryModel.pid;
    NSString *subIndustryId = self.selectedIndustryModel.industryId;
    NSString *rent = _priceField.text;
    NSString *rentType = self.unitSelectTable.selectedIndex == 0 ? @"1" : @"2";
    NSString *shareTime = [self.timePicker getTimeStr];
    NSString *shareDays = @"";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (NSDate *date in self.calendarDialogView.selectedDates) {
        NSString *dateStr = [dateFormatter stringFromDate:date];
        shareDays = [shareDays stringByAppendingString:dateStr];
        if (date != self.calendarDialogView.selectedDates.lastObject) {
            shareDays = [shareDays stringByAppendingString:@","];
        }
    }
    
    NSString *contact = _contactField.text;
    NSString *contactMobile = _phoneNumField.text;
    NSString *intention = _intentSpaceField.text;
    NSString *remark = _remarkTextView.text;
    
    NSString *tag = @"";
    for (NSString *tagItem in self.tagDialogView.checkItems) {
        tag = [tag stringByAppendingString:tagItem];
        if (tagItem != self.tagDialogView.checkItems.lastObject) {
            tag = [tag stringByAppendingString:@","];
        }
    }
    
    NSString *type = @"2";
    HPLoginModel *loginModel = [HPUserTool account];
    if (!loginModel.token) {
        [HPProgressHUD alertMessage:@"用户未登录"];
        return;
    }
    
    NSString *userId = ((NSDictionary *)loginModel.userInfo)[@"userId"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:title forKey:@"title"];
    [param setObject:area forKey:@"area"];
    [param setObject:areaId forKey:@"areaId"];
    [param setObject:districtId forKey:@"districtId"];
    [param setObject:industryId forKeyedSubscript:@"industryId"];
    [param setObject:subIndustryId forKeyedSubscript:@"subIndustryId"];
    [param setObject:rent forKeyedSubscript:@"rent"];
    [param setObject:rentType forKey:@"rentType"];
    [param setObject:shareTime forKey:@"shareTime"];
    [param setObject:shareDays forKey:@"shareDays"];
    [param setObject:contact forKey:@"contact"];
    [param setObject:contactMobile forKey:@"contactMobile"];
    [param setObject:intention forKey:@"intention"];
    [param setObject:remark forKey:@"remark"];
    [param setObject:tag forKey:@"tag"];
    [param setObject:type forKey:@"type"];
    [param setObject:userId forKey:@"userId"];
    [param setObject:@"0" forKey:@"isApproved"];
    
    NSMutableArray *pictureIdArr = [[NSMutableArray alloc] init];
    NSArray *photos = self.addPhotoView.photos;
    
    [HPUploadImageHandle upLoadImages:photos withUrl:kBaseUrl@"/v1/file/uploadPictures" parameterName:@"files" success:^(id responseObject) {
        if (CODE == 200) {
            NSArray<HPPictureModel *> *pictureModels = [HPPictureModel mj_objectArrayWithKeyValuesArray:DATA];
            for (HPPictureModel *pictureModel in pictureModels) {
                [pictureIdArr addObject:pictureModel.pictureId];
            }
            
            [param setObject:pictureIdArr forKey:@"pictureIdArr"];
            
            [self releaseInfo:param];
        }
        else {
            self->_canRelease = YES;
            [HPProgressHUD alertMessage:MSG];
        }
    } fail:^(NSError *error) {
        self->_canRelease = YES;
        ErrorNet
    }];
}

#pragma mark - NetWork

- (void)releaseInfo:(NSDictionary *)param {
    [HPHTTPSever HPPostServerWithMethod:@"/v1/space/post" paraments:param needToken:YES complete:^(id  _Nonnull responseObject) {
        self->_canRelease = YES;
        
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"发布成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        self->_canRelease = YES;
        NSLog(@"+++++++发布失败++++++");
        NSLog(@"error: %@", error);
    }];
}

@end
