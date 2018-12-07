//
//  HPOwnerCardDefineController.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOwnerCardDefineController.h"
#import "HPAlertSheet.h"
#import "HPTextDialogView.h"
#import "HPLinkageSheetView.h"
#import "HPRowPanel.h"
#import "HPAlignCenterButton.h"
#import "HPImageUtil.h"
#import "HPSelectTable.h"
#import "HPTagDialogView.h"
#import "HPCalendarModalView.h"

#define PANEL_SPACE 10.f
#define TEXT_VIEW_PLACEHOLDER @"请输入您的需求，例：入驻本店需事先准备相关产品质检材料，入店时需确认，三无产品请绕道..."

@interface HPOwnerCardDefineController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) HPAlertSheet *alertSheet;

@property (nonatomic, weak) HPTextDialogView *dialogView;

@property (nonatomic, weak) HPLinkageSheetView *districtSheetView;

@property (nonatomic, weak) HPLinkageSheetView *tradeSheetView;

@property (nonatomic, weak) UIButton *isLongTermBtn;

@property (nonatomic, weak) UITextView *remarkTextView;

@property (nonatomic, weak) HPTagDialogView *tagDialogView;

@property (nonatomic, weak) HPCalendarModalView *calendarModalView;

@end

@implementation HPOwnerCardDefineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBarWithTitle:@"定制名片"];
    self.isPopGestureRecognize = NO;
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    for (int i = 0; i < 5; i++) {
        [self setupPanelAtIndex:i ofView:scrollView];
    }
    
    UIButton *previewBtn = [[UIButton alloc] init];
    [previewBtn.layer setCornerRadius:7.f];
    [previewBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [previewBtn setBackgroundColor:UIColor.whiteColor];
    [previewBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [previewBtn setTitle:@"预览名片" forState:UIControlStateNormal];
    [previewBtn addTarget:self action:@selector(onClickReleaseBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:previewBtn];
    [previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(scrollView.subviews[4].mas_bottom).with.offset(40.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 45.f * g_rateWidth));
    }];
    
    UIButton *createBtn = [[UIButton alloc] init];
    [createBtn.layer setCornerRadius:7.f];
    [createBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [createBtn setBackgroundColor:COLOR_RED_FC4865];
    [createBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [createBtn setTitle:@"生成名片" forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(onClickReleaseBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:createBtn];
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.bottom.equalTo(scrollView).with.offset(-20.f * g_rateWidth);
        make.top.equalTo(previewBtn.mas_bottom).with.offset(10.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 45.f * g_rateWidth));
    }];
    
    HPAlertSheet *alertSheet = [[HPAlertSheet alloc] init];
    HPAlertAction *photoAction = [[HPAlertAction alloc] initWithTitle:@"拍照" completion:nil];
    [alertSheet addAction:photoAction];
    HPAlertAction *albumAction = [[HPAlertAction alloc] initWithTitle:@"从手机相册选择" completion:nil];
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
        [panel addRowView:[self setupSpaceTitleRowView]];
        [panel addRowView:[self setupSpaceAddressRowView] withHeight:78.f * g_rateWidth];
        [panel addRowView:[self setupTradeRowView]];
        [panel addRowView:[self setupcCertificationRowView]];
        [panel addRowView:[self setupSpaceTagRowView] withHeight:93.f * g_rateWidth];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(310.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
    else if (index == 2) {
        [panel addRowView:[self setupAreaRowView]];
        [panel addRowView:[self setupPriceRowView]];
        [panel addRowView:[self setupShareTimeRowView]];
        [panel addRowView:[self setupShareDateRowView]];
        [panel addRowView:[self setupIntentTradeRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(230.f * g_rateWidth);
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
    
    return view;
}

- (UIView *)setupSpaceTitleRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"空间标题" ofView:view];
    [self setupTextFieldWithPlaceholder:@"例：优品小店黄金铺位共享" ofView:view rightTo:view];
    
    return view;
}

- (UIView *)setupSpaceAddressRowView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"详细地址"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.height.mas_equalTo(15.f);
    }];
    
    UILabel *cityLabel = [[UILabel alloc] init];
    [cityLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    [cityLabel setTextColor:COLOR_BLACK_444444];
    [cityLabel setText:@"深圳市"];
    [view addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.centerY.equalTo(titleLabel);
        make.width.mas_equalTo(50.f * g_rateWidth);
    }];
    
    UIView *separator = [[UIView alloc] init];
    [separator setBackgroundColor:COLOR_GRAY_D2D3D4];
    [view addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityLabel.mas_right).with.offset(25.f * g_rateWidth);
        make.centerY.equalTo(cityLabel);
        make.size.mas_equalTo(CGSizeMake(12.f, 1.f));
    }];
    
    UIImageView *downIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transfer_down"]];
    [view addSubview:downIcon];
    [downIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(cityLabel);
        make.size.mas_equalTo(CGSizeMake(13.f, 8.f));
    }];
    
    UIButton *regionBtn = [[UIButton alloc] init];
    [regionBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [regionBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    [regionBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [regionBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [regionBtn setTitle:@"请选择区域" forState:UIControlStateNormal];
    [regionBtn addTarget:self action:@selector(onClickDistrictBtn:) forControlEvents:UIControlEventTouchUpInside];
    [regionBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [view addSubview:regionBtn];
    [regionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separator.mas_right).with.offset(26.f * g_rateWidth);
        make.centerY.equalTo(cityLabel);
        make.right.equalTo(downIcon.mas_left).with.offset(-10.f * g_rateWidth);
    }];
    
    UITextField *detailTextField = [[UITextField alloc] init];
    [detailTextField setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:15.f]];
    [detailTextField setTextColor:COLOR_BLACK_333333];
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"请填写详细地址"];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:COLOR_GRAY_CCCCCC
                        range:NSMakeRange(0, 7)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]
                        range:NSMakeRange(0, 7)];
    [detailTextField setAttributedPlaceholder:placeholder];
    
    [view addSubview:detailTextField];
    [detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityLabel);
        make.bottom.equalTo(view).with.offset(-8.f * g_rateWidth);
        make.right.equalTo(downIcon);
    }];
    
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

- (UIView *)setupcCertificationRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"资格认证" ofView:view];
    
    UIButton *certificationBtn = [[UIButton alloc] init];
    [certificationBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [certificationBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [certificationBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [certificationBtn setTitle:@"认证" forState:UIControlStateNormal];
    [certificationBtn setImage:[UIImage imageNamed:@"select_the_arrow"] forState:UIControlStateNormal];
    [certificationBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 27.f, 0.f, -27.f)];
    [certificationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -30.f, 0.f, 30.f)];
    [view addSubview:certificationBtn];
    [certificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

- (UIView *)setupSpaceTagRowView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"空间标签"];
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
    
    [self setupTitleLabelWithText:@"共享面积" ofView:view];
    
    UILabel *unitLabel = [self setupUnitLabelWithText:@"（㎡）" ofView:view];
    
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"不填默认不限" ofView:view rightTo:unitLabel];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    
    return view;
}

- (UIView *)setupPriceRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"共享租金" ofView:view];
    
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
    [unitSelectTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-10.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"不填默认面议" ofView:view rightTo:unitSelectTable];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    
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
    [valueBtn addTarget:self action:@selector(onClickDistrictBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self setupTitleLabelWithText:@"共享排期" ofView:view];
    
    CGRect rect = CGRectMake(0.f, 0.f, 55.f, 20.f);
    UIImage *normalImage = [HPImageUtil getImageByColor:COLOR_GRAY_CCCCCC inRect:rect];
    UIImage *selectImage = [HPImageUtil getImageByColor:COLOR_RED_FF3C5E inRect:rect];
    
    UIButton *isBtn = [[UIButton alloc] init];
    [isBtn.layer setCornerRadius:4.f];
    [isBtn.layer setMasksToBounds:YES];
    [isBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [isBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [isBtn setTitle:@"面议" forState:UIControlStateNormal];
    [isBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [isBtn setBackgroundImage:selectImage forState:UIControlStateSelected];
    [isBtn addTarget:self action:@selector(onClickIsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:isBtn];
    self.isLongTermBtn = isBtn;
    [isBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-20.f);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(55.f, 20.f));
    }];
    
    UIButton *calendarBtn = [[UIButton alloc] init];
    [calendarBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [calendarBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [calendarBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [calendarBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [calendarBtn setImage:[UIImage imageNamed:@"customizing_business_calendar"] forState:UIControlStateNormal];
    [calendarBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [calendarBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -15.f, 0.f, 15.f)];
    [calendarBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 152.f, 0.f, -152.f)];
    [view addSubview:calendarBtn];
    [calendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.right.equalTo(isBtn.mas_left).with.offset(-22.f * g_rateWidth);
    }];
    
    return view;
}

- (UIView *)setupIntentTradeRowView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"意向行业/产品"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    
    return view;
}

- (UIView *)setupContactRowView {
    UIView *view = [[UIView alloc] init];
    [self setupTitleLabelWithText:@"联系人" ofView:view];
    [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    return view;
}

- (UIView *)setupPhoneNumRowView {
    UIView *view = [[UIView alloc] init];
    [self setupTitleLabelWithText:@"手机号码" ofView:view];
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
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
    self.remarkTextView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(16.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 108.f * g_rateWidth));
    }];
    return view;
}

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

#pragma mark - NSNotification

- (void)didTextFieldChange:(NSNotification *)notification {
    
}

#pragma mark - onClick

- (void)onClickIsBtn:(UIButton *)btn {
    [btn setSelected:!btn.isSelected];
}

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
    if (self.districtSheetView == nil) {
        NSDictionary *data = @{@"parent":@[@"罗湖区", @"福田区", @"南山区", @"盐田区", @"宝安区", @"龙岗区", @"坪山区", @"光明区", @"龙华区", @"大鹏新区"],
                               @"children":@{
                                       @"罗湖区":@[@"不限", @"布心", @"蔡屋围", @"草埔", @"翠竹", @"东湖", @"东门", @"独树村", @"国贸", @"红岗花园", @"洪湖", @"黄贝岭", @"火车站", @"莲塘", @"留医部", @"罗湖区委", @"泥岗", @"清水河", @"人民南", @"水贝", @"水库", @"笋岗", @"田贝", @"文锦渡", @"银湖", @"其他"],
                                       @"福田区":@[@"不限", @"八卦岭", @"保税区", @"笔架山", @"彩田村", @"车公庙", @"赤尾", @"福华新村", @"福民新村", @"福田区委", @"其他", @"岗厦", @"购物公园", @"皇岗", @"华强北", @"华强南", @"景田", @"莲花北村", @"莲花一村", @"莲花二村", @"莲花三村", @"荔枝公园", @"上步", @"上梅林", @"上沙", @"沙尾", @"沙嘴", @"石厦", @"下梅林", @"香蜜湖", @"下沙", @"新洲", @"益田村", @"园岭", @"中心区", @"竹子林", @"其他"],
                                       @"南山区":@[@"不限", @"白石洲", @"大冲", @"桂庙路口", @"海上世界", @"海王大厦", @"后海", @"华侨城", @"科技园", @"南山区政府", @"南山医院", @"南头", @"南新路口", @"南油", @"前海", @"蛇口", @"深大北门", @"深圳湾", @"桃源村", @"西丽", @"中心区", @"其他"],
                                       @"盐田区":@[@"不限", @"沙头角", @"盐田", @"大梅沙", @"小梅沙", @"其他"],
                                       @"宝安区":@[@"不限", @"福永", @"宝安中心区", @"沙井", @"石岩", @"松岗", @"桃源居", @"新中心区", @"西乡", @"翻身路", @"新安", @"其他"],
                                       @"龙岗区":@[@"不限", @"横岗", @"龙岗", @"坂田", @"龙岗中心城", @"平湖", @"坪地", @"大运新城", @"万科城", @"百鸽笼", @"布吉关", @"布吉街", @"长龙", @"大芬村", @"丹竹头", @"康桥", @"丽湖", @"木棉湾", @"南岭", @"下水径", @"信义", @"又一村", @"中海怡翠", @"其他"],
                                       @"坪山区":@[@"不限", @"坪山", @"坑梓", @"其他"],
                                       @"光明区":@[@"其他"],
                                       @"龙华区":@[@"不限", @"大浪", @"观澜", @"金地梅陇镇", @"锦绣江南", @"莱蒙水榭春天", @"龙华", @"龙华中心区", @"美丽365花园", @"梅林关口", @"民治", @"深圳北站", @"世纪春城", @"其他"],
                                       @"大鹏新区":@[@"不限", @"大鹏", @"南澳", @"葵涌", @"其他"]
                                       }};
        HPLinkageData *linkageData = [[HPLinkageData alloc] initWithParents:data[@"parent"] Children:data[@"children"]];
        HPLinkageSheetView *districtSheetView = [[HPLinkageSheetView alloc] initWithData:linkageData singleTitles:@[@"不限"] allSingleCheck:NO];
        [districtSheetView setSelectDescription:@"选择区域（最多可选3个）"];
        [districtSheetView setMaxCheckNum:3];
        [districtSheetView selectCellAtParentIndex:0 childIndex:0];
        
        [districtSheetView setConfirmCallback:^(NSString *selectedParent, NSArray *checkItems) {
            NSString *checkItemStr = [NSString stringWithFormat:@"%@ : ", selectedParent];
            for (NSString *checkItem in checkItems) {
                checkItemStr = [checkItemStr stringByAppendingString:checkItem];
                
                if (checkItem != checkItems.lastObject) {
                    checkItemStr = [checkItemStr stringByAppendingString:@", "];
                }
            }
            
            [btn setTitle:checkItemStr forState:UIControlStateSelected];
            [btn setSelected:YES];
        }];
        
        self.districtSheetView = districtSheetView;
    }
    
    [self.districtSheetView show:YES];
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
    if (_tagDialogView == nil) {
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
        
        _tagDialogView = tagDialogView;
    }
    
    [_tagDialogView show:YES];
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

@end
