//
//  HPShareDetailController.m
//  HPShareApp
//
//  Created by HP on 2018/11/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareDetailController.h"
#import "HPBannerView.h"
#import "HPCalendarView.h"
#import "HPPageControlFactory.h"
#import "HPTimeString.h"
#import "HPCommonData.h"
#import "HPShareDetailModel.h"
#import "HPTagView.h"
#import "HPCustomerServiceModalView.h"
#import "HPTextDialogView.h"
#import "HPShareReleaseParam.h"
#import "HPTimeRentView.h"
#import "Macro.h"
#import "HPShareMapAnnotation.h"
#import "HPImageUtil.h"
#import "HPShareMapAnnotationView.h"
#import "HPCustomCalloutView.h"

#define kCalloutViewMargin          -8


typedef NS_ENUM(NSInteger, HPShareDetailGoto) {
    HPShareDetailGotoShare = 180,
};

@interface HPShareDetailController () <HPBannerViewDelegate,MAMapViewDelegate>


/**
 呼出框
 */
@property (nonatomic, strong) HPCustomCalloutView *calloutView;
@property (nonatomic, copy) NSString *getTime;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, weak) HPBannerView *bannerView;

@property (nonatomic, weak) HPPageControl *pageControl;
@property (nonatomic, strong) UIView *titleRegion;
@property (nonatomic, strong) UIView *infoRegion;
@property (nonatomic, weak) UILabel *titleLabel;

/**
 分享按钮
 */
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) NSMutableArray *tagItems;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *tradeLabel;
/**
 share信息下line
 */
@property (nonatomic, strong) UIView *shareInfoLine;


/**
 基本信息view
 */
@property (nonatomic, strong) UIView *baseinfoRegion;

/**
 基本信息下line
 */
@property (nonatomic, strong) UIView *baseInfoLine;

/**
 shareMode信息下line
 */
@property (nonatomic, strong) UIView *rentModelLine;


/**
 共享模式view
 */
@property (nonatomic, strong) UIView *shareModeView;
/**
 基本信息标题
 */
@property (nonatomic, strong) UILabel *baseTitleLabel;

@property (nonatomic, strong) UILabel *releaseTimeLabel;

@property (nonatomic, strong) UILabel *industryLabel;

/**
 合作意向
 */
@property (nonatomic, strong) UILabel *intentionLabel;


/**
 共享出租模式
 */
@property (nonatomic, strong) HPTimeRentView *rentModeView;


/**
 共享模式标题
 */
@property (nonatomic, strong) UILabel *modeTitlelabel;


/**
 店铺位置
 */
@property (nonatomic, strong) UIView *storeLocationView;

/**
 店铺标题
 */
@property (nonatomic, strong) UILabel *storeTitleLabel;


/**
 店铺地图
 */
@property (nonatomic, strong) UIView *mapSuperView;

/**
 共享时段
 */
@property (nonatomic, weak) UILabel *shareTimeLabel;

@property (nonatomic, weak) UILabel *areaLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UILabel *priceUnitLabel;

@property (nonatomic, weak) UILabel *remarkLabel;

@property (nonatomic, weak) UIImageView *portrait;

@property (nonatomic, weak) UILabel *userNameLabel;

@property (nonatomic, weak) HPCalendarView *calendarView;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) HPShareDetailModel *model;
/**
 共享租金
 */
@property (nonatomic, strong) UILabel *priceDescLabel;
/**
 共享面积
 */
@property (nonatomic, strong) UILabel *areaDescLabel;

@property (nonatomic, weak) HPCustomerServiceModalView *customerServiceModalView;

@property (nonatomic, weak) UIButton *keepBtn;
@property (nonatomic, strong) MAMapView *mapView;

/**
 地图中心点--店铺在地图中的位置
 */
@property (nonatomic, strong) MAPointAnnotation *centerPoint;

@property (strong, nonatomic) AMapLocationManager * locationManager;//定位用


@end

@implementation HPShareDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isPopGestureRecognize = NO;
    
    _tagItems = [[NSMutableArray alloc] init];
    
    [self setupUI];
    
    HPShareDetailModel *model = self.param[@"model"];
    NSString *spaceId = model.spaceId;
    if (spaceId) {
        [self getShareDetailInfoById:spaceId];
        [self addHistory:spaceId];
    }
    
    //初始化所有子控件
//    [self initShareSubviews];
    //详情所有子视图 masonry布局
    [self setShareDetailSubviewsFrame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.param[@"update"]) {
        [self updateData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_bannerView stopAutoScroll];
}

#pragma mark - 初始化地图
- (void)initMapView{
    //初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapSuperView.bounds];
    [self.mapView setZoomLevel:17 animated:YES];
    [self.mapSuperView addSubview:self.mapView];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView.delegate = self;
    
    //自定义style
//    [self.mapView setCustomMapStyleID:GaoDeStyleID];
    //默认不生效，开启自定义风格地图
    self.mapView.customMapStyleEnabled = YES;
    
    // 开启定位
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    CLLocationCoordinate2D center;
    center.latitude = [_model.latitude doubleValue];
    center.longitude = [_model.longitude doubleValue];

    //路径规划
//    self.mapSearch = [[AMapSearchAPI alloc] init];
//    self.mapSearch.delegate = self;
    
    //    iOS 去除高德地图下方的 logo 图标
    [self.mapView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            UIImageView * logoM = obj;
            
            logoM.layer.contents = (__bridge id)[UIImage imageNamed:@""].CGImage;
            
        }
        
    }];
    //iOS 去除高德地图下方的 地图比例尺
    self.mapView.showsScale = NO;
    HPShareMapAnnotation *storeAnnotion = [[HPShareMapAnnotation alloc] initWithModel:_model];
    //添加屏幕中心点
    [self.mapView addAnnotation:storeAnnotion];
    [self.mapView setCenterCoordinate:storeAnnotion.coordinate];
//    self.centerPoint.title = _model.title;
//    self.centerPoint.subtitle = _model.address;
}

- (MAPointAnnotation *)centerPoint
{
    if (!_centerPoint)
    {
        _centerPoint = [[MAPointAnnotation alloc] init];
        _centerPoint.coordinate = self.mapView.userLocation.location.coordinate;
//        CLLocationCoordinate2D coordinate;
//        coordinate.longitude = [_model.longitude doubleValue];
//        coordinate.latitude = [_model.latitude doubleValue];
//
//        _centerPoint.coordinate = coordinate;
        
        _centerPoint.lockedToScreen = YES;
        _centerPoint.lockedScreenPoint = self.mapView.center;
    }
    return _centerPoint;
}

#pragma mark - 初始化所有子控件 ------------
- (UIView *)shareInfoLine
{
    if (!_shareInfoLine) {
        _shareInfoLine = [UIView new];
        _shareInfoLine.backgroundColor = COLOR_GRAY_F8F8F8;
    }
    return _shareInfoLine;
}

- (UIView *)baseInfoLine
{
    if (!_baseInfoLine) {
        _baseInfoLine = [UIView new];
        _baseInfoLine.backgroundColor = COLOR_GRAY_F8F8F8;
    }
    return _baseInfoLine;
}

- (UIView *)rentModelLine
{
    if (!_rentModelLine) {
        _rentModelLine = [UIView new];
        _rentModelLine.backgroundColor = COLOR_GRAY_F8F8F8;
    }
    return _rentModelLine;
}

- (UIView *)baseinfoRegion
{
    if (!_baseinfoRegion) {
        _baseinfoRegion = [UIView new];
    }
    return _baseinfoRegion;
}

- (UILabel *)baseTitleLabel
{
    if (!_baseTitleLabel) {
        _baseTitleLabel = [UILabel new];
        _baseTitleLabel.text = @"基本信息";
        _baseTitleLabel.textColor = COLOR_BLACK_333333;
        _baseTitleLabel.textAlignment = NSTextAlignmentLeft;
        _baseTitleLabel.font = kFont_Medium(16.f);
    }
    return _baseTitleLabel;
}

- (HPTimeRentView *)rentModeView
{
    if (!_rentModeView) {
        _rentModeView = [HPTimeRentView new];
    }
    return _rentModeView;
}

- (UIView *)shareModeView
{
    if (!_shareModeView) {
        _shareModeView = [UIView new];
        
    }
    return _shareModeView;
}

- (UILabel *)modeTitlelabel
{
    if (!_modeTitlelabel) {
        _modeTitlelabel = [UILabel new];
        _modeTitlelabel.text = @"共享模式";
        _modeTitlelabel.textColor = COLOR_BLACK_333333;
        _modeTitlelabel.textAlignment = NSTextAlignmentLeft;
        _modeTitlelabel.font = kFont_Medium(16.f);
    }
    return _modeTitlelabel;
}

- (UIView *)storeLocationView
{
    if (!_storeLocationView) {
        _storeLocationView = [UIView new];
    }
    return _storeLocationView;
}

- (UILabel *)storeTitleLabel
{
    if (!_storeTitleLabel) {
        _storeTitleLabel = [UILabel new];
        _storeTitleLabel.text = @"店铺位置";
        _storeTitleLabel.textColor = COLOR_BLACK_333333;
        _storeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _storeTitleLabel.font = kFont_Medium(16.f);
    }
    return _storeTitleLabel;
}

- (UIView *)mapSuperView
{
    if (!_mapSuperView) {
        _mapSuperView = [UIView new];
    }
    return _mapSuperView;
}

- (HPCustomCalloutView *)calloutView
{
    if (!_calloutView) {
        _calloutView = [HPCustomCalloutView new];
        _calloutView.backgroundColor = COLOR_GRAY_FFFFFF;
        [_calloutView.layer setShadowColor:COLOR_GRAY_A6A6A6.CGColor];
        [_calloutView.layer setShadowOffset:CGSizeMake(0.f, 2.f)];
        [_calloutView.layer setShadowRadius:4.f];
        [_calloutView.layer setShadowOpacity:1.f];
        [_calloutView.layer setCornerRadius:2.f];
    }
    return _calloutView;
}

#pragma mark - 所有子视图 masonry布局
- (void)setShareDetailSubviewsFrame
{
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.and.width.equalTo(self.scrollView);
        make.height.mas_equalTo(210.f * g_rateWidth);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.width.mas_equalTo(44.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(self.bannerView);
    }];
    
    [self.titleRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.scrollView);
        make.top.equalTo(self.bannerView.mas_bottom);
        make.height.mas_equalTo(getWidth(636.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleRegion).with.offset(getWidth(21.f));
        make.top.equalTo(self.titleRegion).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(16.f), getWidth(18.f)));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(getWidth(30.f));;
    }];
    
    [self.infoRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleRegion.mas_bottom).offset(getWidth(27.f));
        make.left.right.mas_equalTo(self.titleRegion);
        make.height.mas_equalTo(getWidth(76.f));
    }];
    
    [self.shareInfoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(335.f), getWidth(1.f)));
        make.centerX.mas_equalTo(self.titleRegion);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(120.f));
    }];
    
    [self.baseinfoRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(141.f));
        make.left.right.mas_equalTo(self.titleRegion);
        make.top.mas_equalTo(self.shareInfoLine.mas_bottom);
    }];
    
    [self.baseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(21.f));
        make.top.mas_equalTo(self.shareInfoLine.mas_bottom).offset(getWidth(15.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(self.baseTitleLabel.font.pointSize);
    }];
    
    [self.baseInfoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(335.f), getWidth(1.f)));
        make.centerX.mas_equalTo(self.titleRegion);
        make.top.mas_equalTo(self.shareInfoLine.mas_bottom).offset(getWidth(141.f));
    }];
    
    //共享模式 父视图
    [self.shareModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleRegion);
        make.top.mas_equalTo(self.baseInfoLine.mas_bottom);
        make.height.mas_equalTo(getWidth(120.f));
    }];
    
    [self.modeTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(21.f));
        make.top.mas_equalTo(self.baseInfoLine.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.modeTitlelabel.font.pointSize);
    }];
    
    //共享模式 子视图
    [self.rentModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.shareModeView);
        make.top.mas_equalTo(self.modeTitlelabel.mas_bottom).offset(getWidth(19.f));;
    }];
    
    [self.rentModelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(335.f), getWidth(1.f)));
        make.centerX.mas_equalTo(self.titleRegion);
        make.top.mas_equalTo(self.baseInfoLine.mas_bottom).offset(getWidth(120.f));
    }];
    
    [self.storeLocationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleRegion);
        make.height.mas_equalTo(getWidth(215.f));
    }];
    
    [self.storeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(21.f));
        make.top.mas_equalTo(self.rentModelLine.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.storeTitleLabel.font.pointSize);
    }];
    
    [self.mapSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.top.mas_equalTo(self.storeTitleLabel.mas_bottom).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-20.f));
        make.bottom.mas_equalTo(getWidth(-20.f));
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.mapSuperView);
    }];
}

#pragma mark - SetupUI

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_WHITE_FAF9FE];
    UIView *navView = [self setupNavigationBarWithTitle:@"店铺共享"];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setBackgroundColor:COLOR_WHITE_FAF9FE];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(navView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //轮播图
    HPBannerView *bannerView = [[HPBannerView alloc] init];
    [bannerView setBannerViewDelegate:self];
    [bannerView setImages:@[[UIImage imageNamed:@"shared_shop_details_background"]]];
    [bannerView setImageContentMode:UIViewContentModeScaleAspectFill];
    [bannerView setShowImagePagerEnabled:YES];
    [scrollView addSubview:bannerView];
    _bannerView = bannerView;
    
    UIButton *backBtn = [[UIButton alloc] init];
    [scrollView addSubview:backBtn];
    self.backBtn = backBtn;
    
    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleCircle];
    [pageControl setNumberOfPages:0];
    [scrollView addSubview:pageControl];
    _pageControl = pageControl;
    
    //标题view
    UIView *titleRegion = [[UIView alloc] init];
    [titleRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:titleRegion];
    _titleRegion = titleRegion;
    [self setupTitleRegion:titleRegion];
    
    UIView *remarkRegion = [[UIView alloc] init];
    [remarkRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:remarkRegion];
    [remarkRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(self.titleRegion.mas_bottom).with.offset(15.f * g_rateWidth);
        make.bottom.equalTo(scrollView).with.offset(-getWidth(80.f));
    }];
    [self setupRemarkRegion:remarkRegion];

    UIView *contactRegion = [[UIView alloc] init];
    [contactRegion setBackgroundColor:UIColor.whiteColor];
    [contactRegion.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [contactRegion.layer setShadowOffset:CGSizeMake(0.f, -2.f)];
    [contactRegion.layer setShadowOpacity:0.19f];
    [self.view addSubview:contactRegion];
    [contactRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(60.f * g_rateWidth);
        make.bottom.equalTo(self.view);
    }];
    [self setupContactRegion:contactRegion];
    if (self.param[@"index"]) {
        [contactRegion setHidden:YES];
    }
    else {
        [contactRegion setHidden:NO];
    }

    UIView *editRegion = [[UIView alloc] init];
    [editRegion setBackgroundColor:UIColor.whiteColor];
    [editRegion.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [editRegion.layer setShadowOffset:CGSizeMake(0.f, -2.f)];
    [editRegion.layer setShadowOpacity:0.19f];
    [self.view addSubview:editRegion];
    [editRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(60.f * g_rateWidth);
        make.bottom.equalTo(self.view);
    }];
    [self setupEditRegion:editRegion];

    if (self.param[@"index"]) {
        [editRegion setHidden:NO];
    }
    else {
        [editRegion setHidden:YES];
    }
}

- (void)setTag:(NSArray *)tags {
    for (int i = 0; i < _tagItems.count; i++) {
        HPTagView *tagItem = _tagItems[i];
        if (i < tags.count) {
            if ([tags[i] isEqualToString:@""]) {
                continue;
            }
            [tagItem setHidden:NO];
            [tagItem setText:tags[i]];
        }
    }
}

#pragma mark  - 标题和tag 信息
- (void)setupTitleRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kFont_Medium(22.f)];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    for (int i = 0; i < 3; i ++) {
        HPTagView *tagView = [[HPTagView alloc] init];
        [view addSubview:tagView];
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(titleLabel);
                make.top.equalTo(titleLabel.mas_bottom).with.offset(10.f * g_rateWidth);
            }
            else {
                UIView *lastTagItem = self.tagItems[i - 1];
                make.left.equalTo(lastTagItem.mas_right).with.offset(5.f);
                make.centerY.equalTo(lastTagItem);
            }
        }];
        [tagView setHidden:YES];
        
        [_tagItems addObject:tagView];
    }
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn setBackgroundImage:ImageNamed(@"detail_share") forState:UIControlStateNormal];
    shareBtn.tag = HPShareDetailGotoShare;
    [shareBtn addTarget:self action:@selector(clickShareInfoGoto:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shareBtn];
    _shareBtn = shareBtn;
    
    //共享子控件
    [self setupShareInfoView:view];
    
    [view addSubview:self.shareInfoLine];
    [view addSubview:self.baseinfoRegion];
    //基本信息标题
    [self.baseinfoRegion addSubview:self.baseTitleLabel];
    //基本信息子控件
    [self setupBaseInfoRegion:view];
    
    [view addSubview:self.shareInfoLine];
    [view addSubview:self.baseInfoLine];

    //出租模式
    [view addSubview:self.shareModeView];
    [self.shareModeView addSubview:self.modeTitlelabel];
    [self.shareModeView addSubview:self.rentModeView];
    for (HPTimeRentButton *btn in self.rentModeView.subviews) {
        btn.userInteractionEnabled = NO;
    }
    [view addSubview:self.rentModelLine];
    
    [view addSubview:self.storeLocationView];
    [view addSubview:self.storeTitleLabel];
    [view addSubview:self.mapSuperView];
    [self.mapSuperView addSubview:self.mapView];
}

#pragma mark - 共享信息UI
- (void)setupShareInfoView:(UIView *)view
{
    NSArray *shareInfoArr = @[@"共享租金\n-元/天",@"共享面积\n不限",@"共享时段\n--"];
    for (int i = 0; i < shareInfoArr.count; i++) {
        UILabel *infoLabel = [UILabel new];
        infoLabel.textAlignment = NSTextAlignmentLeft;
        infoLabel.text = shareInfoArr[i];
        infoLabel.numberOfLines = 0;
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        NSString *info = shareInfoArr[i];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:info];
        //设置行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:12];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,info.length)];
        
        //富文本
        [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(0, 4)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
        [attr addAttribute:NSFontAttributeName value:kFont_Medium(17.f) range:NSMakeRange(4, info.length - 4)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(4, info.length - 4)];
        infoLabel.attributedText = attr;
        if (i == 0) {
            self.priceLabel = infoLabel;
        }else if (i == 1){
            self.areaLabel = infoLabel;
        }else if (i == 2){
            self.shareTimeLabel = infoLabel;
        }
        [view addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(51.f));
            make.left.mas_equalTo(getWidth(20.f) + i * (kScreenWidth/3));
            make.height.mas_equalTo(getWidth(60.f));
        }];
    }
}

#pragma mark - shareInfo view
- (void)setupBaseInfoRegion:(UIView *)view
{
    NSArray *shareArr = @[@"发布时间  2018.12.22",@"经营行业  餐饮·中餐厅",@"合作意向  茶饮甜品,餐饮小吃",];
    for (int i = 0; i < shareArr.count; i++) {
        UILabel *sharelabel = [UILabel new];
        sharelabel.text = shareArr[i];
        sharelabel.textAlignment = NSTextAlignmentLeft;
        sharelabel.numberOfLines = 0;
        sharelabel.lineBreakMode = NSLineBreakByWordWrapping;
        NSString *info = shareArr[i];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:info];
        
        //富文本
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:NSMakeRange(4, info.length - 4)];
        sharelabel.attributedText = attr;
        if (i == 0) {
            _releaseTimeLabel = sharelabel;
        }else if (i == 1){
            _industryLabel = sharelabel;
        }else if (i == 2){
            _intentionLabel = sharelabel;
        }
        [view addSubview:sharelabel];
        [sharelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.baseTitleLabel.mas_bottom).offset(getWidth(15.f) + i * (getWidth(15.f) + sharelabel.font.pointSize));
            make.left.mas_equalTo(getWidth(20.f));
            make.height.mas_equalTo(sharelabel.font.pointSize);
        }];
    }
}

#pragma mark - 备注信息view
- (void)setupRemarkRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"备注信息"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(26.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    [remarkLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [remarkLabel setTextColor:COLOR_BLACK_666666];
    [remarkLabel setNumberOfLines:0];
    [view addSubview:remarkLabel];
    _remarkLabel = remarkLabel;
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(19.f * g_rateWidth);
        make.width.mas_equalTo(324.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-20.f * g_rateWidth);
    }];
}

#pragma mark - 底部联系人 view
- (void)setupContactRegion:(UIView *)view {
    UIImageView *portrait = [[UIImageView alloc] init];
    [portrait.layer setMasksToBounds:YES];
    [portrait.layer setCornerRadius:20.f * g_rateWidth];
    portrait.userInteractionEnabled = YES;
    portrait.image = ImageNamed(@"shared_shop_details_head_portrait");
    [view addSubview:portrait];
    _portrait = portrait;
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(29.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(40.f * g_rateWidth, 40.f * g_rateWidth));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MyCardVC:)];
    [portrait addGestureRecognizer:tap];
    
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:18.f]];
    [phoneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"shared_shop_details_calendar_telephone"] forState:UIControlStateNormal];
    [phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, -6.f)];
    [phoneBtn setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_RED_FF531E] forState:UIControlStateNormal];
    [phoneBtn setTitle:@"电话" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
    phoneBtn.layer.cornerRadius = 2.f;
    phoneBtn.layer.masksToBounds = YES;
    [view addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view).offset(getWidth(-14.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(100.f), getWidth(40.f)));
        make.centerY.mas_equalTo(view);
    }];
    
    UIButton *keepBtn = [[UIButton alloc] init];
    [keepBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:18.f]];
    [keepBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [keepBtn setTitleColor:COLOR_RED_912D01 forState:UIControlStateSelected];
    [keepBtn setImage:ImageNamed(@"shared_shop_details_calendar_collection") forState:UIControlStateNormal];
    [keepBtn setImage:ImageNamed(@"shared_shop_details_calendar_collection_selected") forState:UIControlStateSelected];
    [keepBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, -6.f)];
    [keepBtn setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_YELLOW_FFBA15] forState:UIControlStateNormal];
    [keepBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [keepBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [keepBtn setTitle:@"已收藏" forState:UIControlStateSelected|UIControlStateHighlighted];
    keepBtn.layer.cornerRadius = 2.f;
    keepBtn.layer.masksToBounds = YES;
    [view addSubview:keepBtn];
    _keepBtn = keepBtn;
    [keepBtn addTarget:self action:@selector(addOrCancelCollection:) forControlEvents:UIControlEventTouchUpInside];
    [keepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.right.equalTo(phoneBtn.mas_left).offset(getWidth(-12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(100.f), getWidth(40.f)));
    }];
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    [userNameLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [userNameLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    [_userNameLabel setText:@"高小薇"];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portrait.mas_right).with.offset(14.f * g_rateWidth);
        make.right.equalTo(keepBtn.mas_left);
        make.centerY.equalTo(view);
    }];
}

- (void)setupEditRegion:(UIView *)view {
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn.titleLabel setFont:kFont_Medium(18.f)];
    [deleteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:COLOR_ORANGE_F59C40];
    [deleteBtn addTarget:self action:@selector(onClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.width.equalTo(view).multipliedBy(0.5f);
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.titleLabel setFont:kFont_Medium(18.f)];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setBackgroundColor:COLOR_RED_FE2A3B];
    [editBtn addTarget:self action:@selector(onClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(deleteBtn.mas_right);
        make.top.and.bottom.and.right.equalTo(view);
    }];
}

#pragma mark - 点击头像跳转到我的卡片

- (void)MyCardVC:(UITapGestureRecognizer *)tap
{
    HPShareDetailModel *model = self.param[@"model"];
    [self pushVCByClassName:@"HPMyCardController" withParam:@{@"userId":model.userId}];
}

#pragma mark - 拨打电话
- (void)makePhoneCall:(UIButton *)button{
    HPShareDetailModel *model = self.param[@"model"];

        if (_customerServiceModalView == nil) {
            HPCustomerServiceModalView *customerServiceModalView = [[HPCustomerServiceModalView alloc] initWithParent:self.parentViewController.view];
            customerServiceModalView.phone = model.contactMobile;
            [customerServiceModalView setPhoneString:model.contactMobile];
            _customerServiceModalView = customerServiceModalView;
        }
        
        [_customerServiceModalView show:YES];
        [self.parentViewController.view bringSubviewToFront:_customerServiceModalView];
}

#pragma mark - onClickBackBtn

- (void)onClickBackBtn {
    if (self.param[@"update"]) {
        [self popWithParam:self.param];
    }
    else {
        [self pop];
    }
}

- (void)onClickDeleteBtn:(UIButton *)btn {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        _textDialogView = textDialogView;
    }
    
    [_textDialogView setText:@"确定删除本条发布信息？"];
    HPShareDetailModel *model = self.param[@"model"];
    kWeakSelf(weakSelf);
    [_textDialogView setConfirmCallback:^{
        [weakSelf deleteInfoBySpaceId:model.spaceId];
    }];
    [_textDialogView show:YES];
}

- (void)onClickEditBtn:(UIButton *)btn {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        _textDialogView = textDialogView;
    }
    
    [_textDialogView setText:@"是否编辑该条发布信息？"];
    HPShareDetailModel *model = self.param[@"model"];
    kWeakSelf(weakSelf);
    [_textDialogView setConfirmCallback:^{
        [weakSelf editInfoBySpaceId:model.spaceId type:model.type];
    }];
    [_textDialogView show:YES];
}

#pragma mark - HPbannerViewDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - NetWork
//获取详情数据
- (void)getShareDetailInfoById:(NSString *)spaceId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"spaceId"] = spaceId;
    
    [HPProgressHUD alertWithLoadingText:@"数据加载中"];
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/detail" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD hideHud];
            HPShareDetailModel *model = [HPShareDetailModel mj_objectWithKeyValues:DATA];
            NSDictionary *userCardCase = DATA[@"userCardCase"];
            if (![userCardCase isMemberOfClass:NSNull.class]) {
                model.avatarUrl = userCardCase[@"avatarUrl"];
            }
            [self loadData:model];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

//添加浏览历史
- (void)addHistory:(NSString *)spaceId {
    if (!spaceId) {
        return;
    }
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/browseHistory/add" isNeedToken:YES paraments:@{@"spaceId":spaceId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            HPLog(@"添加浏览历史成功");
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)addOrCancelCollection:(UIButton *)btn {
    if (btn.isSelected) {
        [self cancelCollection:btn];
    }
    else
        [self addCollection:btn];
}

//添加收藏
- (void)addCollection:(UIButton *)btn {
    HPShareDetailModel *model = self.param[@"model"];
    if (!model) {
        return;
    }
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/collection/add" isNeedToken:YES paraments:@{@"spaceId":model.spaceId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"收藏成功"];
            [btn setSelected:YES];
        }else
        {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

//取消收藏
- (void)cancelCollection:(UIButton *)btn {
    HPShareDetailModel *model = self.param[@"model"];
    if (!model) {
        return;
    }
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/collection/cancel" isNeedToken:YES paraments:@{@"spaceId":model.spaceId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"取消收藏"];
            [btn setSelected:NO];
        }else
        {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

//删除信息
- (void)deleteInfoBySpaceId:(NSString *)spaceId {
    NSString *url = [NSString stringWithFormat:@"/v1/space/delete/%@", spaceId];
    [HPHTTPSever HPGETServerWithMethod:url isNeedToken:YES paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSNumber *index = self.param[@"index"];
                [self popWithParam:@{@"delete":index}];
            });
        }
        else
            [HPProgressHUD alertMessage:MSG];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)editInfoBySpaceId:(NSString *)spaceId type:(NSInteger)type {
    if (type == 1) {
        [self pushVCByClassName:@"HPOwnerCardDefineController" withParam:@{@"spaceId":spaceId, @"index":self.param[@"index"]}];
    }
    else if (type == 2) {
        [self pushVCByClassName:@"HPStartUpCardDefineController" withParam:@{@"spaceId":spaceId, @"index":self.param[@"index"]}];
    }
}

#pragma mark - LoadData

- (void)loadData:(HPShareDetailModel *)model {
    [_titleLabel setText:model.title];
    //初始化地图
    _model = model;
    [self initMapView];

    if (model.tag) {
        NSArray *tags = [model.tag componentsSeparatedByString:@","];
        [self setTag:tags];
    }
    NSString *timedate = [model.createTime componentsSeparatedByString:@" "].firstObject;
    NSString *getTime = [timedate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.getTime = getTime;
    [_releaseTimeLabel setText:[NSString stringWithFormat:@"发布时间  %@",getTime]];
    _releaseTimeLabel.textAlignment = NSTextAlignmentLeft;
    _releaseTimeLabel.numberOfLines = 0;
    _releaseTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *releaseattr = [[NSMutableAttributedString alloc] initWithString:_releaseTimeLabel.text];
    
    //富文本
    [releaseattr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
    [releaseattr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:NSMakeRange(4, _releaseTimeLabel.text.length - 4)];
    _releaseTimeLabel.attributedText = releaseattr;
    
    if (model.type == 1) {//业主
        [_addressLabel setText:[NSString stringWithFormat:@"店铺地址:%@",model.address]];
        [_areaDescLabel setText:[NSString stringWithFormat:@"共享面积  %@",model.area]];
    }
    else if (model.type == 2) { //创客
        NSString *areaName = [HPCommonData getAreaNameById:model.areaId];
        NSString *districeName = [HPCommonData getDistrictNameByAreaId:model.areaId districtId:model.districtId];
        [_addressLabel setText:[NSString stringWithFormat:@"期望区域:%@-%@", areaName, districeName]];
        [_priceDescLabel setText:@"期望租金"];
        [_areaDescLabel setText:@"期望面积"];

    }
    
    NSString *industry = [HPCommonData getIndustryNameById:model.industryId];
    NSString *subIndustry = [HPCommonData getIndustryNameById:model.subIndustryId];
    [_industryLabel setText:[NSString stringWithFormat:@"经营行业  %@·%@", industry, subIndustry]];
    
    _industryLabel.textAlignment = NSTextAlignmentLeft;
    _industryLabel.numberOfLines = 0;
    _industryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *industryLabelattr = [[NSMutableAttributedString alloc] initWithString:_industryLabel.text];
    
    //富文本
    [industryLabelattr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
    [industryLabelattr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:NSMakeRange(4, _industryLabel.text.length - 4)];
    _industryLabel.attributedText = industryLabelattr;
    
    if (model.intention && ![model.intention isEqualToString:@""]) {
        NSString *intention = [HPCommonData getIndustryNameById:model.industryId];
        NSString *subIntention = [HPCommonData getIndustryNameById:model.subIndustryId];
        [_intentionLabel setText:[NSString stringWithFormat:@"合作意向  %@·%@", intention, subIntention]];
    }else{
        [_intentionLabel setText:[NSString stringWithFormat:@"合作意向  面议"]];
    }
    
    _intentionLabel.textAlignment = NSTextAlignmentLeft;
    _intentionLabel.numberOfLines = 0;
    _intentionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *intentionLabelattr = [[NSMutableAttributedString alloc] initWithString:_intentionLabel.text];
    
    //富文本
    [intentionLabelattr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
    [intentionLabelattr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:NSMakeRange(4, _intentionLabel.text.length - 4)];
    _intentionLabel.attributedText = intentionLabelattr;
    
    if (model.shareTime && ![model.shareTime isEqualToString:@""]) {
        [_shareTimeLabel setText:[NSString stringWithFormat:@"共享时段\n%@",model.shareTime]];
    }
    else {
        [_shareTimeLabel setText:[NSString stringWithFormat:@"共享时段\n不限"]];
    }
    
    _shareTimeLabel.textAlignment = NSTextAlignmentLeft;
    _shareTimeLabel.numberOfLines = 0;
    _shareTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *shareTimeattr = [[NSMutableAttributedString alloc] initWithString:_shareTimeLabel.text];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:12];
    [shareTimeattr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,_shareTimeLabel.text.length)];
    
    //富文本
    [shareTimeattr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
    [shareTimeattr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(4, _shareTimeLabel.text.length - 4)];
    _shareTimeLabel.attributedText = shareTimeattr;
    
    if (model.area && [model.area isEqualToString:@"0"]) {
        if ([model.areaRange intValue] == 1) {
            [_areaLabel setText:[NSString stringWithFormat:@"共享面积\n %@",@"不限"]];
        }else if ([model.areaRange intValue] == 2){
            [_areaLabel setText:[NSString stringWithFormat:@"共享面积\n%@",@"小于5㎡"]];
        }else if ([model.areaRange intValue] == 3){
            [_areaLabel setText:[NSString stringWithFormat:@"共享面积\n%@",@"5-10㎡"]];
        }else if ([model.areaRange intValue] == 4){
            [_areaLabel setText:[NSString stringWithFormat:@"共享面积\n%@",@"10-20㎡"]];
        }else if ([model.areaRange intValue] == 5){
            [_areaLabel setText:[NSString stringWithFormat:@"共享面积\n%@",@"20㎡以上"]];
        }else {
            [_areaLabel setText:[NSString stringWithFormat:@"共享面积\n面议"]];
        }
    }
    else
        [_areaLabel setText:[NSString stringWithFormat:@"共享面积\n不限"]];

    _areaLabel.textAlignment = NSTextAlignmentLeft;
    _areaLabel.numberOfLines = 0;
    _areaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString *areaattr = [[NSMutableAttributedString alloc] initWithString:_areaLabel.text];
    //设置行间距
    NSMutableParagraphStyle *areaparagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [areaparagraphStyle setLineSpacing:12];
    [areaattr addAttribute:NSParagraphStyleAttributeName value:areaparagraphStyle range:NSMakeRange(0,_areaLabel.text.length)];

    //富文本
    [areaattr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(0, 4)];
    [areaattr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
    [areaattr addAttribute:NSFontAttributeName value:kFont_Medium(17.f) range:NSMakeRange(4, _areaLabel.text.length - 4)];
    [areaattr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(4, _areaLabel.text.length - 4)];
    _areaLabel.attributedText = areaattr;

    if (model.rent && ![model.rent isEqualToString:@"1"]) {
        if (model.rentType == 1) {
            [_priceLabel setText:[NSString stringWithFormat:@"共享租金\n%@ %@",model.rent,@"元/小时"]];
        }else if (model.rentType == 2){
            [_priceLabel setText:[NSString stringWithFormat:@"共享租金\n%@ %@",model.rent,@"元/天"]];
        }else if (model.rentType == 3){
            [_priceLabel setText:[NSString stringWithFormat:@"共享租金\n%@ %@",model.rent,@"元/月"]];
        }else if (model.rentType == 4){
            [_priceLabel setText:[NSString stringWithFormat:@"共享租金\n%@ %@",model.rent,@"元/年"]];
        }else {
            [_priceLabel setText:[NSString stringWithFormat:@"共享租金\n面议"]];
        }
        
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.numberOfLines = 0;
        _priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
        //设置行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:12];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,_priceLabel.text.length)];
        
        //富文本
        [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(0, 4)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
        [attr addAttribute:NSFontAttributeName value:kFont_Medium(17.f) range:NSMakeRange(4, _priceLabel.text.length - 4)];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(4, _priceLabel.text.length - 4)];
        _priceLabel.attributedText = attr;

    }
    
    if (model.rentMode && ![model.rentMode isEqualToString:@""]) {
        for (int i = 0; i < self.rentModeView.subviews.count;i++) {
            HPTimeRentButton *NObtn = self.rentModeView.subviews[i];
            NObtn.userInteractionEnabled = NO;
            HPTimeRentButton *btn = self.rentModeView.subviews[[model.rentMode intValue] - 1];
            btn.selected = YES;
        }
    
    if (!model.remark || [model.remark isEqualToString:@""]) {
        [_remarkLabel setText:@"用户很懒，什么也没有填写～"];
    }
    else {
        [_remarkLabel setText:model.remark];
    }
    
    if (model.avatarUrl) {
        [_portrait sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"shared_shop_details_head_portrait"]];
    }
    
    [_userNameLabel setText:model.contact];
    
    if (model.collected == 1) {
        [_keepBtn setSelected:YES];
    }
    else
        [_keepBtn setSelected:NO];
    
    if (model.shareDays) {
        NSArray *shareDays = [model.shareDays componentsSeparatedByString:@","];
        [_calendarView setSelectedDateStrs:shareDays];
    }
    
    if (model.pictures && model.pictures.count > 0) {
        if (model.pictures.count > 1) {
            [_pageControl setNumberOfPages:model.pictures.count];
            [_pageControl setCurrentPage:0];
        }
        else {
            [_pageControl setHidden:YES];
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (HPPictureModel *picModel in model.pictures) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.url] placeholderImage:ImageNamed(@"shared_shop_details_background")];
            [array addObject:imageView];
        }
        
        [_bannerView setImageViews:array];
        if (model.pictures.count > 1) {
            [_bannerView startAutoScrollWithInterval:2.0];
        }
    }
    }
}

- (void)updateData {
    if (!self.param[@"update"]) {
        return;
    }
    
    HPShareReleaseParam *param = self.param[@"update"];
    
    [_titleLabel setText:param.title];
    
    if (param.tag) {
        NSArray *tags = [param.tag componentsSeparatedByString:@","];
        [self setTag:tags];
    }
    
    if ([param.type isEqualToString:@"1"]) {//业主
        [_addressLabel setText:[NSString stringWithFormat:@"店铺地址:%@",param.address]];
        [_priceDescLabel setText:@"共享租金"];
        [_areaDescLabel setText:@"共享面积"];
        
    }
    else if ([param.type isEqualToString:@"2"]) { //创客
        NSString *areaName = [HPCommonData getAreaNameById:param.areaId];
        NSString *districeName = [HPCommonData getDistrictNameByAreaId:param.areaId districtId:param.districtId];
        [_addressLabel setText:[NSString stringWithFormat:@"期望区域:%@-%@", areaName, districeName]];
        [_priceDescLabel setText:@"期望租金"];
        [_areaDescLabel setText:@"期望面积"];
        
    }
    
    NSString *industry = [HPCommonData getIndustryNameById:param.industryId];
    NSString *subIndustry = [HPCommonData getIndustryNameById:param.subIndustryId];
    
    [_tradeLabel setText:[NSString stringWithFormat:@"%@·%@", industry, subIndustry]];
    
    if (param.shareTime && ![param.shareTime isEqualToString:@""]) {
        [_shareTimeLabel setText:param.shareTime];
    }
    else {
        [_shareTimeLabel setText:@"面议"];
    }
    
    _shareTimeLabel.textAlignment = NSTextAlignmentLeft;
    _shareTimeLabel.numberOfLines = 0;
    _shareTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_shareTimeLabel.text];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:12];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,_shareTimeLabel.text.length)];
    
    //富文本
    [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(0, 4)];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(0, 4)];
    [attr addAttribute:NSFontAttributeName value:kFont_Medium(17.f) range:NSMakeRange(4, _shareTimeLabel.text.length - 4)];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(4, _shareTimeLabel.text.length - 4)];
    _shareTimeLabel.attributedText = attr;
    
    if (param.area && ![param.area isEqualToString:@"0"]) {
        [_areaLabel setText:[NSString stringWithFormat:@"%@ ㎡", param.area]];
    }
    else
        [_areaLabel setText:@"面议"];
    
    if (param.rent && ![param.rent isEqualToString:@"0"]) {
        [_priceLabel setText:param.rent];
        [_priceUnitLabel setText:[param.rentType isEqualToString:@"1"] ? @"元/小时":@"元/天"];
    }
    else {
        [_priceLabel setText:@"面议"];
        [_priceUnitLabel setHidden:YES];
    }
    
    if (!param.remark || [param.remark isEqualToString:@""]) {
        [_remarkLabel setText:@"用户很懒，什么也没有填写～"];
    }
    else {
        [_remarkLabel setText:param.remark];
    }
    
    [_userNameLabel setText:param.contact];
    
    if (param.shareDays) {
        NSArray *shareDays = [param.shareDays componentsSeparatedByString:@","];
        [_calendarView setSelectedDateStrs:shareDays];
    }
    
    if (param.pictureIdArr && param.pictureIdArr.count > 0) {
        if (param.pictureIdArr.count > 1) {
            [_pageControl setNumberOfPages:param.pictureIdArr.count];
            [_pageControl setCurrentPage:0];
        }
        else {
            [_pageControl setHidden:YES];
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *pictureUrl in param.pictureUrlArr) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:ImageNamed(@"shared_shop_details_background")];
            [array addObject:imageView];
        }

        [_bannerView setImageViews:array];
        if (param.pictureUrlArr.count > 1) {
            [_bannerView startAutoScrollWithInterval:2.0];
        }
        else {
            [_bannerView stopAutoScroll];
        }
    }
}

#pragma mark - clickShareInfoGoto 点击事件
- (void)clickShareInfoGoto:(UIButton *)button
{
    
}

#pragma mark - 实际地图点
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:HPShareMapAnnotation.class]) {
        //此时annotation就是我们calloutview的annotation
        HPShareMapAnnotation *ann = (HPShareMapAnnotation *)annotation;
        HPShareMapAnnotationView *annotationView = [[HPShareMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Share_Annotation"];
        //否则创建新的calloutView
        if (!annotationView) {
            annotationView = [[HPShareMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"] ;
            
            XCUCustomContentView *cell = [[[NSBundle mainBundle] loadNibNamed:@"XCUCustomContentView" owner:self options:nil] objectAtIndex:0];
            
            [annotationView.contentView addSubview:cell];
            annotationView.infoView = cell;
        }
        annotationView.centerOffset = CGPointMake(0, -80);
        //开始设置添加marker时的赋值
        annotationView.infoView.deviceLable.text = [ann.locationInfo objectForKey:@"device"];
        annotationView.infoView.adressLable.text = [ann.locationInfo objectForKey:@"adress"];
        annotationView.infoView.timeLable.text =[ann.locationInfo objectForKey:@"time"];
        [annotationView setImage:ImageNamed(@"gps_location")];
//        annotationView.canShowCallout = YES;
        return annotationView;
    }

    return nil;
}

#pragma mark - 点击店铺地图坐标大头针时 即点击地图marker时所触发（并显示callout）
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
//    [view setSelected:YES];
    // 被点击的MKAnnotationView的标题和副标题
    NSString *titleStr = view.annotation.title;
}


#pragma mark - 这个方法在点击地图任意位置，相当于隐藏callout
-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
//    [view setSelected:NO];
    [self pushVCByClassName:@"HPGeodeMapViewController" withParam:@{@"loaction":_model}];
}
@end
