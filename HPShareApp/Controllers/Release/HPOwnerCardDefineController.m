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
#import "HPStoreItemButton.h"
#import "HPAreaButton.h"
#import "HPReviseReleaseInfoViewController.h"
#import "CDZPicker.h"
#import "HPDataHandlePickerView.h"
#import "HPBotomPickerModalView.h"

#define PANEL_SPACE 10.f
#define TEXT_VIEW_PLACEHOLDER @"请输入您的需求，例：入驻本店需事先准备相关产品质检材料，入店时需确认，三无产品请绕道..."

typedef NS_ENUM(NSInteger, HPSelectItemIndex) {
    HPSelectItemIndexCity = 100,
    HPSelectItemIndexArea,
    HPSelectItemIndexAddress,
    HPSelectItemIndexIndustry,
    HPSelectItemIndexShareTitle
};

@interface HPOwnerCardDefineController ()<HPShareSelectedItemViewDelegate,HPShareSpaceInfoDelegate> {
    BOOL _canRelease;
}
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, weak) UIButton *addressBtn;

@property (nonatomic, weak) UITextField *titleField;//发布标题

@property (nonatomic, weak) UITextField *areaField;//期望面积

@property (nonatomic, weak) UITextField *addressField;//详细地址

@property (nonatomic, weak) HPSelectTable *unitSelectTable;//价格单位

@property (nonatomic, weak) UITextField *intentSpaceField;//意向行业/产品

@property (nonatomic, weak) UITextField *contactField;//联系人

@property (nonatomic, weak) UITextField *phoneNumField;//手机号码

@property (nonatomic, weak) UITextView *remarkTextView;//备注信息

@property (nonatomic, strong) HPShareSelectedItemView *itemView;

@property (nonatomic, strong) HPAreaButton *cityBtn;
@property (nonatomic, strong) HPAreaButton *areaBtn;

/**
 行业
 */
@property (nonatomic, strong) UIButton *industryBtn;

/**
 生成标题field
 */
@property (nonatomic, strong) UITextField *convertTitleField;

/**
 标题
 */
@property (nonatomic, strong) UILabel *shareTitle;

@property (nonatomic, strong) CDZPicker *pickerView;

@property (nonatomic, weak) HPBotomPickerModalView *areaPickerView;
@property (nonatomic, strong) HPBotomPickerModalView *industryPickerView;
/**
 下一级界面逆传过来的数据
 */
@property (nonatomic, copy) NSString *shareSpace;
@property (nonatomic, copy) NSString *shareTime;
@property (nonatomic, copy) NSString *industry;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *rentType;
@property (nonatomic, copy) NSString *rentAmount;

@property (strong, nonatomic) NSMutableArray *cityArray,*disArray,*streetArray;
@property (strong, nonatomic) NSMutableDictionary *streetDic;

@end

@implementation HPOwnerCardDefineController
#pragma mark - HPShareSpaceInfoDelegate
- (void)backvcIn:(HPReviseReleaseInfoViewController *)vc andShareInfo:(NSString *)shareSpace andShareTime:(NSString *)shareTime andIndustry:(NSString *)industry andShareType:(NSString *)type andShareRent:(NSString *)rent andShareRentAmount:(NSString *)amount
{
    self.shareSpace = shareSpace;
    self.shareTime = shareTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isPopGestureRecognize = NO;
    _canRelease = YES;
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _cityArray = [NSMutableArray array];
    _disArray = [NSMutableArray array];
    _streetArray = [NSMutableArray array];
    _streetDic = [NSMutableDictionary dictionary];
    HPAddressModel *addressModel = self.param[@"address"];
    if (addressModel) {
        [_addressBtn setTitle:addressModel.POIName forState:UIControlStateSelected];
        [_addressBtn setSelected:YES];
    }
}

#pragma mark - setupUI

- (void)setupUI {
    [self setupNavigationBarWithTitle:@"填写店铺基础信息"];
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

}
#pragma mark - 信息完整度
- (UIView *)setUpInfoLabel
{
    UIView *view = [UIView new];
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
    [view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    return view;
}

#pragma mark - row view
- (void)setupPanelAtIndex:(NSInteger)index ofView:(UIView *)view {
    HPRowPanel *panel = [[HPRowPanel alloc] init];
    [view addSubview:panel];
        if (index == 0) {
            [panel addRowView:[self setUpInfoLabel] withHeight:25.f * g_rateWidth];

            [panel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.scrollView);
                make.top.equalTo(view);
                make.height.mas_equalTo(getWidth(25.f));
                make.width.mas_equalTo(self.view);
            }];
            
    }
    else if (index == 1) {
        //店铺简称
        [panel addRowView:[self setupStoreNameRowView]];
        [panel addRowView:[self setupStoreTagRowView] withHeight:46.f * g_rateWidth];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(92.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        
    }
    else if (index == 2) {
        [panel addRowView:[self setupAreaRowView]];
        [panel addRowView:[self setupPriceRowView]];
        [panel addRowView:[self setupShareTimeRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(138.f * g_rateWidth);
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
        
    }else if (index == 4){
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
#pragma mark - 店铺标签
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
    
    HPStoreItemButton *addBtn = [[HPStoreItemButton alloc] init];
    [addBtn setTitle:@"品牌连锁、百年老店、街角旺铺" forState:UIControlStateNormal];
    [addBtn setImage:ImageNamed(@"customizing_business_cards_add_to") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(onClickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(getWidth(122.f));
        make.right.equalTo(view).offset(getWidth(-21.f));
        make.height.mas_equalTo(getWidth(20.f));
        make.centerY.mas_equalTo(view);
    }];
    
    return view;
}
#pragma mark - 所在区域
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
    HPAreaButton *cityBtn = [HPAreaButton new];
    [cityBtn setTitle:@"深圳市" forState:UIControlStateNormal];
    [cityBtn setImage:ImageNamed(@"transfer_down") forState:UIControlStateNormal];
    [cityBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
//    [cityBtn addTarget:self action:@selector(callPickerViewWithDataSource:) forControlEvents:UIControlEventTouchUpInside];
    cityBtn.tag = HPSelectItemIndexCity;
    [view addSubview:cityBtn];
    _cityBtn = cityBtn;
    [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(getWidth(122.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(64.f), getWidth(20.f)));
        make.centerY.mas_equalTo(view);
    }];
    
    HPAreaButton *areaBtn = [HPAreaButton new];
    [areaBtn setTitle:@"请选择区域" forState:UIControlStateNormal];
    [areaBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [areaBtn setImage:ImageNamed(@"transfer_down") forState:UIControlStateNormal];
    [areaBtn addTarget:self action:@selector(callPickerViewWithDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:areaBtn];
    areaBtn.tag = HPSelectItemIndexArea;

    _areaBtn = areaBtn;
    [areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cityBtn.mas_right).offset(getWidth(36.f));
        make.right.mas_equalTo(view).offset(getWidth(-20.f));
        make.height.mas_equalTo(getWidth(20.f));
        make.centerY.mas_equalTo(view);
    }];
    
    return view;
}
#pragma mark -详细地址
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

    UITextField *textField = [self setupTextFieldWithPlaceholder:@"请填写店铺详细地址" ofView:view rightTo:view];
    [textField setKeyboardType:UIKeyboardTypeDecimalPad];
//    textField.text = @"fsadhgjg";
    textField.textColor = COLOR_BLACK_333333;
    _addressField = textField;
    
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
    [valueBtn.titleLabel setFont:kFont_Regular(14.f)];
    [valueBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [valueBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [valueBtn setTitle:@"请选择" forState:UIControlStateNormal];
    valueBtn.tag = HPSelectItemIndexIndustry;
    [valueBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [valueBtn addTarget:self action:@selector(callPickerViewWithDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:valueBtn];
    _industryBtn = valueBtn;
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
    _contactField.textColor = COLOR_BLACK_333333;
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
    HPLoginModel *account = [HPUserTool account];
    UITextField *textField = [self setupTextFieldWithPlaceholder:account.userInfo.mobile?:@"" ofView:view rightTo:view];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    textField.text = account.userInfo.mobile?:@"";
    textField.textColor = COLOR_BLACK_333333;
    textField.userInteractionEnabled = NO;//不允许交互，固定为注册登录人的手机号
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
    [birthBtn addTarget:self action:@selector(convertShareTitle:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:birthBtn];
    [birthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view).offset(getWidth(-20.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(40.f), getWidth(25.f)));
        make.centerY.mas_equalTo(view);
    }];
    UILabel *shareTitle = [self setupTitleLabelWithText:@"标题" ofView:view];
    _shareTitle = shareTitle;
    UITextField *textField = [self setupTextFieldWithPlaceholder:@"完善信息，生成标题更满意" ofView:view rightTo:birthBtn];
    textField.textColor = COLOR_BLACK_333333;
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    _convertTitleField = textField;
    
    return view;
}

#pragma mark - 生成按钮事件
- (void)convertShareTitle:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [button setTitle:@"清空" forState:UIControlStateNormal];
        //获取生存的字符串
        [self getConvertString];
        _shareTitle.hidden = YES;
//        HPLog(@"dfggg:%@",_shareTitle);
        [_convertTitleField mas_updateConstraints:^(MASConstraintMaker *make) {
            [make.left uninstall];
            make.left.mas_equalTo(self.scrollView).offset(getWidth(21.f));
        }];
    }else{
        [button setTitle:@"生成" forState:UIControlStateNormal];
        _shareTitle.hidden = NO;
        _convertTitleField.text = @"";
        [_convertTitleField mas_updateConstraints:^(MASConstraintMaker *make) {
            [make.left uninstall];
            make.left.mas_equalTo(self.scrollView).offset(getWidth(122.f));
        }];
    }
    
}

- (void)getConvertString
{
    NSString *areaString;
    if ([self.areaBtn.currentTitle isEqualToString:@"请选择区域"]) {
        areaString = nil;
    }else{
        areaString = self.areaBtn.currentTitle;
    }
    NSString *titleString = [NSString stringWithFormat:@"%@%@店有%@空间可供出租",self.titleField.text,areaString?:@"",self.shareSpace?:@""];
    self.convertTitleField.text = titleString;
    
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
    
//    if (_cityBtn.currentTitle.length != 0 && _areaBtn.currentTitle.length != 0 && ![_areaBtn.currentTitle isEqualToString:@"请选择区域"] && _addressField.text.length != 0 && _industryBtn.titleLabel.text.length != 0 && _phoneNumField.text.length != 0 && _convertTitleField.text.length != 0) {
    HPReviseReleaseInfoViewController *shareInfoVC = [HPReviseReleaseInfoViewController new];
    shareInfoVC.delegate = self;
    [self.navigationController pushViewController:shareInfoVC animated:YES];
//        [self pushVCByClassName:@"HPReviseReleaseInfoViewController"];
//    }else{//弹框提示
//        HPShareSelectedItemView *itemView = [[HPShareSelectedItemView alloc] init];
//        [itemView show:YES];
//        itemView.delegate = self;
//        _itemView = itemView;
//        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self.view);
//        }];
//    }

}
#pragma mark - 弹框提示移除按钮
- (void)clickBtnHiddenShareSelectView
{
    [_itemView setHidden:YES];
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

#pragma mark - 点击叫出pickerview
- (void)callPickerViewWithDataSource:(UIButton *)button
{
        [self setUpPickerView:button.tag];
}

- (void)setUpPickerView:(HPSelectItemIndex)selectItemIndex
{
    CDZPicker *pickerView = [CDZPicker new];
    _pickerView = pickerView;
    kWeakSelf(weakSelf);
    if (selectItemIndex == HPSelectItemIndexCity) {
        /*pickerView.tipTitle = @"选择城市";
        CDZPickerBuilder *builder = [CDZPickerBuilder new];
        builder.showMask = YES;
        builder.cancelTextColor = COLOR_GRAY_BBBBBB;
        builder.confirmTextColor = COLOR_RED_EA0000;

        [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:@[@"objective-c",@"java",@"python",@"php"] confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
            [weakSelf.cityBtn setTitle:[strings componentsJoinedByString:@","] forState:UIControlStateNormal];
            CGFloat stringsW = BoundWithSize([strings componentsJoinedByString:@","], kScreenWidth, 14).size.width + 20;
            [weakSelf.cityBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(stringsW);
            }];

        }cancel:^{
            //your code
        }];*/
    }else if (selectItemIndex == HPSelectItemIndexArea){
        if (!_areaPickerView) {
            HPLinkageData *data = [[HPLinkageData alloc] initWithModels:[HPCommonData getAreaData]];
            [data setChildNameKey:@"name"];
            [data setParentNameKey:@"name"];
            HPBotomPickerModalView *areaPickerView = [[HPBotomPickerModalView alloc] initWithData:data];
            [areaPickerView setConfirmCallBack:^(NSInteger parentIndex, NSInteger childIndex, NSObject *model) {
                HPDistrictModel *districtModel = (HPDistrictModel *)model;
                NSString *areaName = [HPCommonData getAreaNameById:districtModel.areaId];
                NSLog(@"Pick district: %@-%@", areaName, districtModel.name);
                NSString *areaTitle = [NSString stringWithFormat:@"%@-%@", areaName, districtModel.name];
                CGFloat areaW = BoundWithSize(areaTitle, kScreenWidth, 13.f).size.width + 15;
               [self.areaBtn setTitle:areaTitle forState:UIControlStateNormal];
                [self.areaBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(areaW);
                }];
            }];
            _areaPickerView = areaPickerView;
        }
        
        [_areaPickerView show:YES];
    }else if (selectItemIndex == HPSelectItemIndexIndustry){
        if (!_industryPickerView) {
            HPLinkageData *data = [[HPLinkageData alloc] initWithModels:[HPCommonData getIndustryData]];
            [data setChildNameKey:@"industryName"];
            [data setParentNameKey:@"industryName"];
            HPBotomPickerModalView *industryPickerView = [[HPBotomPickerModalView alloc] initWithData:data];
            [industryPickerView setConfirmCallBack:^(NSInteger parentIndex, NSInteger childIndex, NSObject *model) {
                HPIndustryModel *industryModel = (HPIndustryModel *)model;
                NSString *industryName = [HPCommonData getIndustryNameById:industryModel.industryId];
                NSLog(@"Pick industryTitle: %@-%@", industryName, industryModel.industryName);
                NSString *industryTitle = [NSString stringWithFormat:@"%@-%@", industryName, industryModel.industryName];
                CGFloat industryW = BoundWithSize(industryTitle, kScreenWidth, 13.f).size.width + 15;
                [self.industryBtn setTitle:industryTitle forState:UIControlStateNormal];
                [self.industryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(industryW);
                }];
            }];
            _industryPickerView = industryPickerView;
        }
        
        [_industryPickerView show:YES];
    }
    /*
    [pickerView show:YES];
    kWeakSelf(wekSelf);
    [pickerView setFinishClickCallback:^(NSString *model) {
        HPLog(@"selectedModel:%@",model);
        if (selectItemIndex == HPSelectItemIndexCity) {
            [wekSelf.cityBtn setTitle:model forState:UIControlStateNormal];;
        }else if (selectItemIndex == HPSelectItemIndexArea){
            [wekSelf.areaBtn setTitle:model forState:UIControlStateNormal];;
        }else if (selectItemIndex == HPSelectItemIndexIndustry){
            [wekSelf.industryBtn setTitle:model forState:UIControlStateNormal];;
        }
        CGFloat modelW = BoundWithSize(model, kScreenWidth, 15.f).size.width+ 20;
        [self.cityBtn setTitle:model forState:UIControlStateNormal];
        [self.cityBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(modelW);
        }];
    }];
    [pickerView setCancelClickCallback:^(NSString *model) {
        if (selectItemIndex == HPSelectItemIndexCity) {
            [wekSelf.cityBtn setTitle:@"请选择" forState:UIControlStateNormal];;
        }else if (selectItemIndex == HPSelectItemIndexArea){
            [wekSelf.areaBtn setTitle:@"请选择" forState:UIControlStateNormal];;
        }else if (selectItemIndex == HPSelectItemIndexIndustry){
            [wekSelf.industryBtn setTitle:@"请选择" forState:UIControlStateNormal];;
        }
        
    }];
    
    [pickerView setViewTapClickCallback:^{
        
    }];*/
}
@end
