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
#import "TZPhotoPickerController.h"
#import "HPAddressModel.h"
#import "HPUploadImageHandle.h"
#import "HPPictureModel.h"
#import "HPShareSelectedItemView.h"
#define PANEL_SPACE 10.f
#define TEXT_VIEW_PLACEHOLDER @"请输入您的需求，例：入驻本店需事先准备相关产品质检材料，入店时需确认，三无产品请绕道..."

@interface HPOwnerCardDefineController ()<HPShareSelectedItemViewDelegate> {
    BOOL _canRelease;
}
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, weak) UIButton *addressBtn;

@property (nonatomic, weak) UITextField *titleField;//发布标题

@property (nonatomic, weak) UITextField *areaField;//期望面积

@property (nonatomic, weak) UITextField *priceField;//期望价格

@property (nonatomic, weak) HPSelectTable *unitSelectTable;//价格单位

@property (nonatomic, weak) UITextField *intentSpaceField;//意向行业/产品

@property (nonatomic, weak) UITextField *contactField;//联系人

@property (nonatomic, weak) UITextField *phoneNumField;//手机号码

@property (nonatomic, weak) UITextView *remarkTextView;//备注信息

@property (nonatomic, strong) HPShareSelectedItemView *itemView;
@end

@implementation HPOwnerCardDefineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    HPAddressModel *addressModel = self.param[@"address"];
    if (addressModel) {
        [_addressBtn setTitle:addressModel.POIName forState:UIControlStateSelected];
        [_addressBtn setSelected:YES];
    }
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
    UIView *navTitleView = [self setupNavigationBarWithTitle:@"填写店铺基础信息"];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(navTitleView.mas_bottom);
    }];
    UILabel *infoLabel = [UILabel new];
    infoLabel.backgroundColor = COLOR_BLUE_D5F2FF;
    infoLabel.text = [NSString stringWithFormat:@"信息完善度越高搜索排名越靠前，当前信息完善度为%@",@"30%"];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:infoLabel.text];
    NSString *str = @"信息完善度越高搜索排名越靠前，当前信息完善度为";
    NSRange range = [infoLabel.text rangeOfString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_666666 range:range];
    [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(range.length, infoLabel.text.length - str.length)];
    [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(range.length, infoLabel.text.length - str.length)];
    infoLabel.attributedText = attr;
    [self.scrollView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(navTitleView.mas_bottom);
        make.height.mas_equalTo(getWidth(25.f));
    }];
    
    for (int i = 0; i < 5; i++) {
        [self setupPanelAtIndex:i ofView:self.scrollView];
    }
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = COLOR_GRAY_FFFFFF;
    [self.view insertSubview:bottomView aboveSubview:self.scrollView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, getWidth(83.f) + g_bottomSafeAreaHeight));
    }];
    
    UIButton *releaseBtn = [[UIButton alloc] init];
    [releaseBtn.layer setCornerRadius:7.f];
    [releaseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [releaseBtn setBackgroundColor:COLOR_RED_EA0000];
    [releaseBtn.titleLabel setFont:kFont_Bold(16.f)];
    [releaseBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(onClickReleaseBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:releaseBtn];
    [releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(45.f));
        make.left.top.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-21.f));
    }];
    
//    kWeakSelf(weakSelf);
//    HPAlertSheet *alertSheet = [[HPAlertSheet alloc] init];
//    HPAlertAction *photoAction = [[HPAlertAction alloc] initWithTitle:@"拍照" completion:^{
//        [weakSelf onClickAlbumOrPhotoSheetWithTag:0];
//    }];
//    [alertSheet addAction:photoAction];
//    HPAlertAction *albumAction = [[HPAlertAction alloc] initWithTitle:@"从手机相册选择" completion:^{
//        [weakSelf onClickAlbumOrPhotoSheetWithTag:1];
//    }];
//    [alertSheet addAction:albumAction];
//    self.alertSheet = alertSheet;
}

- (void)setupPanelAtIndex:(NSInteger)index ofView:(UIView *)view {
    HPRowPanel *panel = [[HPRowPanel alloc] init];
    [view addSubview:panel];
    
//    if (index == 0) {
//        [panel addRowView:[self setupPhotoRowView] withHeight:187.f * g_rateWidth];
//        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.width.equalTo(view);
//            make.height.mas_equalTo(187.f * g_rateWidth);
//            make.top.equalTo(view);
//        }];
//    }
//    else
        if (index == 0) {
            //店铺简称
        
        [panel addRowView: [self setupStoreNameRowView]];
//        [panel addRowView:[self setupSpaceAddressRowView]];
//        [panel addRowView:[self setupTradeRowView]];
        [panel addRowView:[self setupStoreTagRowView] withHeight:46.f * g_rateWidth];
//        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(92.f * g_rateWidth);
            make.top.equalTo(self.infoLabel.mas_bottom).offset(getWidth(15.f));
        }];
    }
    else if (index == 1) {
        [panel addRowView:[self setupAreaRowView]];
        [panel addRowView:[self setupPriceRowView]];
        [panel addRowView:[self setupShareTimeRowView]];
//        [panel addRowView:[self setupShareDateRowView]];
//        [panel addRowView:[self setupIntentTradeRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(138.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
    else if (index == 2) {
        [panel addRowView:[self setupContactRowView]];
        [panel addRowView:[self setupPhoneNumRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(90.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
    else if (index == 3) {
        [panel addRowView:[self setupRemarkRowView]withHeight:45.f * g_rateWidth];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(45.f * g_rateWidth);
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
    [descLabel setText:@"上传共享空间照片，让匹配更高效。"];
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

- (UIView *)setupStoreNameRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"店铺简称" ofView:view];
    _titleField = [self setupTextFieldWithPlaceholder:@"请填写店铺简称" ofView:view rightTo:view];
    
    return view;
}

- (UIView *)setupSpaceAddressRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"店铺地址" ofView:view];
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    UIButton *valueBtn = [[UIButton alloc] init];
    [valueBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [valueBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [valueBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [valueBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [valueBtn setTitle:@"请输入店铺或空间地址" forState:UIControlStateNormal];
    [valueBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [valueBtn addTarget:self action:@selector(onClickAddressbtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:valueBtn];
    _addressBtn = valueBtn;
    [valueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.right.equalTo(downIcon.mas_left).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(view);
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

- (UIView *)setupStoreTagRowView {
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"店铺标签"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn.titleLabel setFont:kFont_Regular(13.f)];
    [addBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [addBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateSelected];
    [addBtn setTitle:@"品牌连锁、百年老店、街角旺铺" forState:UIControlStateNormal];
    [addBtn setImage:ImageNamed(@"customizing_business_cards_add_to") forState:UIControlStateNormal];
    [addBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f,getWidth(-346.f), 0.f, -50.f * g_rateWidth)];
    [addBtn addTarget:self action:@selector(onClickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(getWidth(-21.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(20.f), getWidth(20.f)));
        make.centerY.mas_equalTo(view);
    }];
    
    return view;
}

- (UIView *)setupAreaRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    [self setupTitleLabelWithText:@"所在区域" ofView:view];
    UIButton *cityBtn = [UIButton new];
    [cityBtn setTitle:@"深圳市" forState:UIControlStateNormal];
    [cityBtn setImage:ImageNamed(@"transfer_down") forState:UIControlStateNormal];
    [cityBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(-20.f), getWidth(51.f), getWidth(-19.f), 0)];
    [cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(-49.f), 0, getWidth(10.f))];
    cityBtn.titleLabel.font = kFont_Regular(14.f);
    [cityBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [view addSubview:cityBtn];
    [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(getWidth(114.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(100.f), getWidth(14.f)));
        make.centerY.mas_equalTo(view);
    }];
    
    UIButton *areaBtn = [UIButton new];
    [areaBtn setTitle:@"请选择区域" forState:UIControlStateNormal];
    [areaBtn setImage:ImageNamed(@"transfer_down") forState:UIControlStateNormal];
    [areaBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(-20.f), getWidth(128.f), getWidth(-19.f), 0)];
    [areaBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(-49.f), 0, getWidth(10.f))];
    areaBtn.titleLabel.font = kFont_Regular(14.f);
    [areaBtn setTitleColor:COLOR_GRAY_CCCCCC forState:UIControlStateNormal];
    [view addSubview:areaBtn];
    [areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(getWidth(209.f));
        make.right.mas_equalTo(view).offset(getWidth(-20.f));
        make.height.mas_equalTo(getWidth(14.f));
        make.centerY.mas_equalTo(view);
    }];
//    UILabel *unitLabel = [self setupUnitLabelWithText:@"（㎡）" ofView:view];
    
//    UITextField *textField = [self setupTextFieldWithPlaceholder:@"不填默认不限" ofView:view rightTo:unitLabel];
//    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
//    _areaField = textField;
    
    return view;
}

- (UIView *)setupPriceRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    [self setupTitleLabelWithText:@"详细地址" ofView:view];
    
//    NSArray *options = @[@"（元/小时）", @"（元/天）"];
//    HPSelectTableLayout *layout = [[HPSelectTableLayout alloc] init];
//    [layout setColNum:2];
//    [layout setXSpace:-10.f * g_rateWidth];
//    [layout setItemSize:CGSizeMake(68.f, 13.f)];
//    [layout setNormalTextColor:COLOR_GRAY_CCCCCC];
//    [layout setSelectTextColor:COLOR_BLACK_666666];
//    [layout setNormalBgColor:UIColor.clearColor];
//    [layout setSelectedBgColor:UIColor.clearColor];
//    [layout setItemBorderWidth:0.f];
//    HPSelectTable *unitSelectTable = [[HPSelectTable alloc] initWithOptions:@[] layout:layout];
//    [unitSelectTable setBtnAtIndex:0 selected:YES];
//    [view addSubview:unitSelectTable];
//    _unitSelectTable = unitSelectTable;
//    [unitSelectTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(view).with.offset(-10.f * g_rateWidth);
//        make.centerY.equalTo(view);
//    }];

    UITextField *textField = [self setupTextFieldWithPlaceholder:@"请填写店铺详细地址" ofView:view rightTo:view];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    _priceField = textField;
    
    return view;
}

- (UIView *)setupShareTimeRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    [self setupTitleLabelWithText:@"经营行业" ofView:view];
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
    
    [self setupTitleLabelWithText:@"共享排期" ofView:view];
    
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
    
    _intentSpaceField = [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    
    return view;
}

- (UIView *)setupContactRowView {
    UIView *view = [[UIView alloc] init];
    [self setupTitleLabelWithText:@"联系人" ofView:view];
    _contactField = [self setupTextFieldWithPlaceholder:@"完善称呼交流更方便" ofView:view rightTo:view];
    return view;
}

- (UIView *)setupPhoneNumRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    [self setupTitleLabelWithText:@"联系方式" ofView:view];
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"请填写" ofView:view rightTo:view];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    _phoneNumField = textField;
    return view;
}

- (UIView *)setupRemarkRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    UIButton *birthBtn = [UIButton new];
    [birthBtn setTitle:@"生成" forState:UIControlStateNormal];
    birthBtn.layer.cornerRadius = 4.f;
    birthBtn.layer.masksToBounds = YES;
    birthBtn.backgroundColor = COLOR_RED_EA0000;
    birthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [birthBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
    birthBtn.titleLabel.font = kFont_Medium(12.f);
    [view addSubview:birthBtn];
    [birthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view).offset(getWidth(-20.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(40.f), getWidth(25.f)));
        make.centerY.mas_equalTo(view);
    }];
    [self setupTitleLabelWithText:@"标题" ofView:view];
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"完善信息，生成标题更满意" ofView:view rightTo:birthBtn];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    _phoneNumField = textField;
    
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15.f]];
//    [titleLabel setTextColor:COLOR_BLACK_333333];
//    [titleLabel setText:@"备注信息"];
//    [view addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
//        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
//        make.height.mas_equalTo(15.f);
//    }];
//
//    UITextView *textView = [[UITextView alloc] init];
//    [textView.layer setCornerRadius:5.f];
//    [textView setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
//    [textView setTextColor:COLOR_GRAY_CCCCCC];
//    [textView setBackgroundColor:COLOR_GRAY_F6F6F6];
//    [textView setText:TEXT_VIEW_PLACEHOLDER];
//    [textView setContentInset:UIEdgeInsetsMake(2.f, 5.f, 2.f, 5.f)];
//    [textView setDelegate:self];
//    [view addSubview:textView];
//    _remarkTextView = textView;
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(titleLabel.mas_bottom).with.offset(16.f * g_rateWidth);
//        make.centerX.equalTo(view);
//        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 108.f * g_rateWidth));
//    }];
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

#pragma mark - Function

- (NSString *)getAreaIdByName:(NSString *)name {
    for (HPAreaModel *areaModel in self.areaModels) {
        if ([areaModel.name isEqualToString:name]) {
            return areaModel.areaId;
        }
    }
    
    return nil;
}

#pragma mark - OnClick

- (void)onClickAddressbtn:(UIButton *)btn {
    [self pushVCByClassName:@"HPShareAddressController"];
}

- (void)onClickReleaseBtn {
    /*
    if (!_canRelease) {
        return;
    }
    _canRelease = NO;
    
    HPAddressModel *addressModel = self.param[@"address"];
    NSString *latitude;
    NSString *longitude;
    NSString *address;
    if (addressModel) {
        latitude = [NSString stringWithFormat:@"%lf", addressModel.lat];
        longitude = [NSString stringWithFormat:@"%lf", addressModel.lon];
        address = addressModel.POIName;
    }
    
    NSString *title = _titleField.text;
    NSString *area = _areaField.text;
    NSString *areaId = [self getAreaIdByName:addressModel.district];
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
    
    NSString *type = @"1";
    HPLoginModel *loginModel = [HPUserTool account];
    if (!loginModel.token) {
        [HPProgressHUD alertMessage:@"用户未登录"];
        return;
    }
    
    NSString *userId = loginModel.userInfo.userId;
    
    self.shareReleaseParam.title = title;
    self.shareReleaseParam.area = area;
    self.shareReleaseParam.areaId = areaId;
    self.shareReleaseParam.latitude = latitude;
    self.shareReleaseParam.longitude = longitude;
    self.shareReleaseParam.address = address;
    self.shareReleaseParam.industryId = industryId;
    self.shareReleaseParam.subIndustryId = subIndustryId;
    self.shareReleaseParam.rent = rent;
    self.shareReleaseParam.rentType = rentType;
    self.shareReleaseParam.shareTime = shareTime;
    self.shareReleaseParam.shareDays = shareDays;
    self.shareReleaseParam.contact = contact;
    self.shareReleaseParam.contactMobile = contactMobile;
    self.shareReleaseParam.intention = intention;
    self.shareReleaseParam.remark = remark;
    self.shareReleaseParam.tag = tag;
    self.shareReleaseParam.type = type;
    self.shareReleaseParam.userId = userId;
    self.shareReleaseParam.isApproved = @"0";
    
    NSArray *photos = self.addPhotoView.photos;
    
    [HPUploadImageHandle upLoadImages:photos withUrl:kBaseUrl@"/v1/file/uploadPictures" parameterName:@"files" success:^(id responseObject) {
        if (CODE == 200) {
            NSArray<HPPictureModel *> *pictureModels = [HPPictureModel mj_objectArrayWithKeyValuesArray:DATA];
            for (HPPictureModel *pictureModel in pictureModels) {
                [self.shareReleaseParam.pictureIdArr addObject:pictureModel.pictureId];
            }
            
            NSDictionary *param = self.shareReleaseParam.mj_keyValues;
            [self releaseInfo:param];
        }
        else {
            self->_canRelease = YES;
            [HPProgressHUD alertMessage:MSG];
        }
    } progress:^(double progress) {
        NSLog(@"progress: %lf", progress);
        [HPProgressHUD alertWithProgress:progress text:@"上传图片中"];
    } fail:^(NSError *error) {
        self->_canRelease = YES;
        ErrorNet
    }];*/
    HPShareSelectedItemView *itemView = [[HPShareSelectedItemView alloc] init];
    itemView.delegate = self;
    [self.view addSubview:itemView];
    _itemView = itemView;
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
#pragma mark - 弹框提示移除按钮
- (void)clickBtnInShareSelectViewToRemoveView
{
    [_itemView removeFromSuperview];
}
#pragma mark - NetWork

- (void)releaseInfo:(NSDictionary *)param {
    [HPHTTPSever HPPostServerWithMethod:@"/v1/space/post" paraments:param needToken:YES complete:^(id  _Nonnull responseObject) {
        self->_canRelease = YES;
        
        if (CODE == 200) {
            [HPProgressHUD alertWithFinishText:@"发布成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
    } Progress:^(double progress) {
        [HPProgressHUD alertWithProgress:progress text:@"发布信息中"];
    } Failure:^(NSError * _Nonnull error) {
        self->_canRelease = YES;
        ErrorNet
    }];
}

@end
