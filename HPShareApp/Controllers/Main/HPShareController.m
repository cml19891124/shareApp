//
//  HPShareController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareController.h"
#import "HPShareRecommendCard.h"
#import "HPImageUtil.h"
#import "HPBannerView.h"
#import "HPAlignCenterButton.h"
#import "HPSharePersonCard.h"
#import "HPPageControlFactory.h"
#import "iCarousel.h"
#import "HPMyCardController.h"
#import "HPShareDetailController.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "HPNearbyShareView.h"
#import "HPAreaModel.h"
#import "HPLinkageSheetView.h"
@interface HPShareController () <HPBannerViewDelegate,iCarouselDelegate,iCarouselDataSource,HPSharePersonCardDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,CLLocationManagerDelegate,AMapSearchDelegate>
@property (nonatomic, strong) UIView *localMapView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) HPLinkageSheetView *districtSheetView;

@property (nonatomic, weak) HPPageControl *pageControl;

@property (nonatomic, weak) HPBannerView *bannerView;

@property (nonatomic, weak) HPShareRecommendCard *shareCard_1;

@property (nonatomic, weak) HPShareRecommendCard *shareCard_2;

@property (nonatomic, weak) HPPageView *sharePersonPageView;

@property (nonatomic, strong) NSArray *sharePersonData;
@property(nonatomic,strong) iCarousel *carousel;

@property (nonatomic, strong) MAMapView *mapView;
@property (strong, nonatomic) AMapLocationManager * locationManager;//定位用

@property (strong, nonatomic) NSMutableArray *cityArray,*disArray,*streetArray;
@property (strong, nonatomic) NSMutableDictionary *streetDic;
@end

@implementation HPShareController

#pragma mark - 初始化地图
- (void)initMapView{
    
    //初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.localMapView.bounds];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"style.data" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self.mapView setCustomMapStyleWithWebData:data];
    [self.mapView setCustomMapStyleEnabled:YES];
    [self.mapView setZoomLevel:17 animated:YES];
//    [self.view addSubview:self.mapView];
    self.mapView.layer.cornerRadius = 5 * g_rateWidth;
    self.mapView.layer.masksToBounds = YES;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView.delegate = self;
    MAUserLocationRepresentation *UserLocationRep = [[MAUserLocationRepresentation alloc] init];
    
    UserLocationRep.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    [self.mapView updateUserLocationRepresentation:UserLocationRep];
    
    
    // 开启定位
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.headingFilter = 10;
    self.mapView.distanceFilter = 5;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
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
    //导航
    //初始化AMapNaviDriveManager
//    if (self.driveManager == nil)
//    {
//        self.driveManager = [[AMapNaviDriveManager alloc] init];
//        [self.driveManager setDelegate:self];
//    }
    
    //添加屏幕中心点
    //[self.mapView addAnnotation:self.centerPoint];
//    [self.view bringSubviewToFront:self.rentNotiView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _cityArray = [NSMutableArray array];
    _disArray = [NSMutableArray array];
    _streetArray = [NSMutableArray array];
    _streetDic = [NSMutableDictionary dictionary];
    [self getAreaListInShenzhen];
}
#pragma mark - 获取深圳区域列表
- (void)getAreaListInShenzhen
{
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/area/list" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSLog(@"**************");
            weakSelf.cityArray = [HPAreaModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)onClickCityBtn:(UIButton *)btn {
    if (self.districtSheetView == nil) {

        HPLinkageData *linkageData = [[HPLinkageData alloc] initWithModels:_cityArray];
                HPLinkageSheetView *tradeSheetView = [[HPLinkageSheetView alloc] initWithData:linkageData singleTitles:@[@"不限"] allSingleCheck:NO];
                [tradeSheetView setSelectDescription:@"选择城市"];
                [tradeSheetView setMaxCheckNum:3];
                [tradeSheetView selectCellAtParentIndex:0 childIndex:0];
                
                [tradeSheetView setConfirmCallback:^(NSString *selectedParent, NSArray *checkItems, NSObject *selectedChildModel) {
                    NSString *checkItemStr = [NSString stringWithFormat:@"%@ : ", selectedParent];;
                    for (NSString *checkItem in checkItems) {
                        checkItemStr = [checkItemStr stringByAppendingString:checkItem];
                        
                        if (checkItem != checkItems.lastObject) {
                            checkItemStr = [checkItemStr stringByAppendingString:@", "];
                        }
                    }
                    
                    [btn setTitle:checkItemStr forState:UIControlStateSelected];
                    [btn setSelected:YES];
                    CGFloat checkItemW = BoundWithSize(checkItemStr, kScreenWidth, 13).size.width + 30;

                    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(checkItemW);
                    }];
                    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.f, -20.f + checkItemW, 0.f, -30.f)];

                }];
                
                self.districtSheetView = tradeSheetView;

    }
    
    [self.districtSheetView show:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [_shareCard_1 setTitle:@"金嘉味黄金铺位共享"];
    [_shareCard_1 setTrade:@"餐饮"];
    [_shareCard_1 setRentTime:@"面议"];
    [_shareCard_1 setArea:@"30"];
    [_shareCard_1 setPrice:@"30"];
    [_shareCard_1 setTagType:HPShareRecommendCardTypeOwner];
    
    [_shareCard_2 setTitle:@"全聚德北京烤鸭店急求90家共享铺位"];
    [_shareCard_2 setTrade:@"服饰"];
    [_shareCard_2 setRentTime:@"短租"];
    [_shareCard_2 setArea:@"18"];
    [_shareCard_2 setPrice:@"80"];
    [_shareCard_2 setTagType:HPShareRecommendCardTypeStartup];
    
    NSArray *sharePersonData = @[@{@"followed_id":@"1",@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"followed_id":@"12",@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"followed_id":@"10",@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"followed_id":@"2",@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"followed_id":@"3",@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"}];
    [self reloadShareRecommendRegionWithDate:sharePersonData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_bannerView startAutoScrollWithInterval:2.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_bannerView stopAutoScroll];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_GRAY_F6F6F6];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.top.and.left.and.width.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-g_tabBarHeight);
    }];
    
    HPBannerView *bannerView = [[HPBannerView alloc] init];
    [bannerView setImages:@[[UIImage imageNamed:@"shouye_banner"], [UIImage imageNamed:@"shouye_banner"], [UIImage imageNamed:@"shouye_banner"]]];
    [bannerView setBannerViewDelegate:self];
    [scrollView addSubview:bannerView];
    _bannerView = bannerView;
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(-g_statusBarHeight);
        make.left.and.width.equalTo(scrollView);
        make.height.mas_equalTo(225.f * g_rateWidth);
    }];
    
    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
    [pageControl setNumberOfPages:3];
    [pageControl setCurrentPage:0];
    [scrollView addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.bottom.equalTo(bannerView).with.offset(-42.f * g_rateWidth);
    }];
    
    UIView *searchView = [[UIView alloc] init];
    [searchView.layer setCornerRadius:4.f];
    [searchView.layer setMasksToBounds:YES];
    [searchView setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.35f]];
    [scrollView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(scrollView).with.offset(5.f * g_rateHeight);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 35.f * g_rateWidth));
    }];
    [self setupSearchView:searchView];
    
    UIView *menuPanel = [[UIView alloc] init];
    [menuPanel.layer setCornerRadius:4.f];
    [menuPanel.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [menuPanel.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [menuPanel.layer setShadowRadius:6.f];
    [menuPanel.layer setShadowOpacity:0.2f];
    [menuPanel setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:menuPanel];
    [menuPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bannerView).with.offset(67.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 105.f * g_rateWidth));
    }];
    [self setupMenuPanel:menuPanel];
    
    UIView *todayShareRegion = [[UIView alloc] init];
    [scrollView addSubview:todayShareRegion];
    [todayShareRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuPanel.mas_bottom);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupTodayShareRegion:todayShareRegion];
    
    UIView *nearbyShareRegion = [[UIView alloc] init];
    [scrollView addSubview:nearbyShareRegion];
    [nearbyShareRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(todayShareRegion.mas_bottom);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupNearbyShareRegion:nearbyShareRegion];
    
    UIView *shareRecommendRegion = [[UIView alloc] init];
    [scrollView addSubview:shareRecommendRegion];
    [shareRecommendRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nearbyShareRegion.mas_bottom);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupShareRecommendRegion:shareRecommendRegion];
    
    UIView *shareProcessRegion = [[UIView alloc] init];
    [scrollView addSubview:shareProcessRegion];
    [shareProcessRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareRecommendRegion.mas_bottom);
        make.left.and.width.equalTo(scrollView);
        make.bottom.equalTo(scrollView).with.offset(-25.f * g_rateWidth);
    }];
    [self setupShareProcessRegion:shareProcessRegion];
}

- (void)setupSearchView:(UIView *)view {
    UIButton *locationBtn = [[UIButton alloc] init];
    [locationBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [locationBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [locationBtn setTitle:@"深圳" forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"shouye_xiala"] forState:UIControlStateNormal];
    [locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -12.f, 0.f, 12.f)];
    [locationBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 30.f, 0.f, -30.f)];
    [locationBtn addTarget:self action:@selector(onClickCityBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.width.mas_equalTo(63.f * g_rateWidth);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.6f]];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationBtn.mas_right);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(1.f, 16.f * g_rateWidth));
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"shouye_sousuo"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"输入关键字进行搜索" forState:UIControlStateNormal];
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 10.f, 0.f, -10.f)];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 16.f, 0.f, -16.f)];
    [view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right);
        make.top.and.bottom.and.right.equalTo(view);
    }];
}

- (void)setupMenuPanel:(UIView *)view {
    UIView *centerView = [[UIView alloc] init];
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).with.offset(17.f * g_rateWidth);
    }];
    
    HPAlignCenterButton *shopBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"icon_renli"]];
    [shopBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [shopBtn setTextColor:COLOR_BLACK_333333];
    [shopBtn setText:@"人力共享"];
    [shopBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:shopBtn];
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
    }];
    
    HPAlignCenterButton *spaceBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"icon_goods"]];
    [spaceBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [spaceBtn setTextColor:COLOR_BLACK_333333];
    [spaceBtn setText:@"货品共享"];
    [spaceBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:spaceBtn];
    [spaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopBtn.mas_right).with.offset(26.f * g_rateWidth);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
    }];
    
    HPAlignCenterButton *goodBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"icon_stores"]];
    [goodBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [goodBtn setTextColor:COLOR_BLACK_333333];
    [goodBtn setText:@"店铺共享"];
    [goodBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:goodBtn];
    [goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spaceBtn.mas_right).with.offset(26.f * g_rateWidth);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
    }];
    
    HPAlignCenterButton *mapBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"icon_map"]];
    [mapBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [mapBtn setTextColor:COLOR_BLACK_333333];
    [mapBtn setText:@"共享地图"];
    [mapBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:mapBtn];
    [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodBtn.mas_right).with.offset(26.f * g_rateWidth);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
        make.right.equalTo(centerView);
    }];
}

- (void)setupTodayShareRegion:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"今日共享" ofRegion:view];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [moreBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"shouye_gengduo"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 52.f, 0.f, -52.f)];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -6.f, 0.f, 6.f)];
    [moreBtn addTarget:self action:@selector(onClickMoreView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
    }];
    
    HPShareRecommendCard *shareCard_1 = [[HPShareRecommendCard alloc] init];
    [shareCard_1.layer setCornerRadius:7.f];
    [shareCard_1.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [shareCard_1.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [shareCard_1.layer setShadowRadius:6.f];
    [shareCard_1.layer setShadowOpacity:0.2f];
    [view addSubview:shareCard_1];
    _shareCard_1 = shareCard_1;
    [shareCard_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 115.f * g_rateWidth));
    }];
    
    HPShareRecommendCard *shareCard_2 = [[HPShareRecommendCard alloc] init];
    [shareCard_2.layer setCornerRadius:7.f];
    [shareCard_2.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [shareCard_2.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [shareCard_2.layer setShadowRadius:6.f];
    [shareCard_2.layer setShadowOpacity:0.2f];
    [view addSubview:shareCard_2];
    _shareCard_2 = shareCard_2;
    [shareCard_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareCard_1.mas_bottom).with.offset(15.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 115.f * g_rateWidth));
        make.bottom.equalTo(view).with.offset(-5.f * g_rateWidth);
    }];
}

- (void)setupNearbyShareRegion:(UIView *)view {
    //初始化地图
    [self initMapView];
    UILabel *titleLabel = [self setupTitle:@"附近共享" ofRegion:view];
    
    UIView *mapView = [[UIView alloc] init];
    [mapView.layer setCornerRadius:5.f];
    [mapView setBackgroundColor:COLOR_GRAY_999999];
    [view addSubview:mapView];
    self.localMapView = mapView;
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 121.f * g_rateWidth));
        make.bottom.equalTo(view).with.offset(-5.f * g_rateWidth);
    }];
    [mapView addSubview:self.mapView];
    
    UIView *coverView = [UIView new];
    coverView.backgroundColor = UIColor.blackColor;
    coverView.alpha = 0.4;
    [coverView.layer setCornerRadius:5.f];
    coverView.layer.masksToBounds = YES;
    [mapView insertSubview:coverView aboveSubview:self.mapView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    HPNearbyShareView *nearbyView = [HPNearbyShareView new];
    nearbyView.layer.cornerRadius = 4;
    nearbyView.layer.masksToBounds = YES;
    [mapView addSubview:nearbyView];
    [mapView bringSubviewToFront:nearbyView];
    [nearbyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(315.f * g_rateWidth);
        make.height.mas_equalTo(91.f * g_rateWidth);
        make.center.mas_equalTo(mapView);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareDetailVC:)];
    [nearbyView addGestureRecognizer:tap];
}
#pragma mark - 共享详情
- (void)shareDetailVC:(UITapGestureRecognizer *)tap
{
    [self pushVCByClassName:@"HPShareDetailController"];
}
- (void)setupShareRecommendRegion:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"共享人推荐" ofRegion:view];
    /*
    HPPageView *pageView = [[HPPageView alloc] init];
    [pageView setPageMarginLeft:15.f * g_rateWidth];
    [pageView setPageSpace:15.f * g_rateWidth];
    [pageView setPageWidth:291.f * g_rateWidth];
    [pageView setDelegate:self];
    [view addSubview:pageView];
    _sharePersonPageView = pageView;
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.height.mas_equalTo(187.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-5.f * g_rateWidth);
    }];*/
    iCarousel * carousel = [[iCarousel alloc] init];
    carousel.dataSource = self;
    carousel.bounces = NO;
    carousel.pagingEnabled = YES;
    carousel.delegate = self;
    carousel.type  = iCarouselTypeLinear;
    [view addSubview:carousel];
    self.carousel = carousel;
    
    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(15);
        make.width.mas_equalTo(g_rateWidth * 291.f);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.height.mas_equalTo(187.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-5.f * g_rateWidth);
    }];
}

- (void)reloadShareRecommendRegionWithDate:(NSArray *)data {
    _sharePersonData = data;
//    [_sharePersonPageView refreshPageItem];
    [_carousel reloadData];

}

- (void)setupShareProcessRegion:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"共享流程" ofRegion:view];
    
    UIView *processView = [[UIView alloc] init];
    [processView setBackgroundColor:UIColor.whiteColor];
    [processView.layer setCornerRadius:4.f];
    [processView.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [processView.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [processView.layer setShadowRadius:6.f];
    [processView.layer setShadowOpacity:0.2f];
    [view addSubview:processView];
    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 124.f * g_rateWidth));
        make.bottom.equalTo(view);
    }];
    
    UIImageView *processIcon = [[UIImageView alloc] init];
    [processIcon setImage:[UIImage imageNamed:@"share_process"]];
    [processView addSubview:processIcon];
    [processIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(processView).with.offset(31.f * g_rateWidth);
        make.top.equalTo(processView).with.offset(20.f * g_rateWidth);
    }];
    
    UILabel *processLabel = [[UILabel alloc] init];
    [processLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [processLabel setTextColor:COLOR_BLACK_333333];
    [processLabel setText:@"共享的正确打开方式"];
    [processView addSubview:processLabel];
    [processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(processIcon.mas_right).with.offset(10.f);
        make.centerY.equalTo(processIcon);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [processView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processIcon.mas_bottom).with.offset(17.f * g_rateWidth);
        make.centerX.equalTo(processView);
        make.size.mas_equalTo(CGSizeMake(285.f * g_rateWidth, 1.f));
    }];
    
    UIView *centerView = [[UIView alloc] init];
    [processView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(processView);
        make.centerX.equalTo(processView);
    }];
    
    UIView *releaseProcess = [self setupProcessItemWithIndex:@"1" icon:[UIImage imageNamed:@"share_release"] title:@"发布信息"];
    [centerView addSubview:releaseProcess];
    [releaseProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.centerY.equalTo(centerView);
    }];
    
    UIView *contactProcess = [self setupProcessItemWithIndex:@"2" icon:[UIImage imageNamed:@"share_contact"] title:@"线上沟通"];
    [centerView addSubview:contactProcess];
    [contactProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(releaseProcess.mas_right).with.offset(31.f * g_rateWidth);
        make.centerY.equalTo(centerView);
    }];
    
    UIView *surveyProcess = [self setupProcessItemWithIndex:@"3" icon:[UIImage imageNamed:@"share_survey"] title:@"线下实勘"];
    [centerView addSubview:surveyProcess];
    [surveyProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactProcess.mas_right).with.offset(31.f * g_rateWidth);
        make.centerY.equalTo(centerView);
    }];
    
    UIView *successProcess = [self setupProcessItemWithIndex:@"4" icon:[UIImage imageNamed:@"share_success"] title:@"成功共享"];
    [centerView addSubview:successProcess];
    [successProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surveyProcess.mas_right).with.offset(31.f * g_rateWidth);
        make.centerY.equalTo(centerView);
        make.right.equalTo(centerView);
    }];
}

#pragma mark - setupCommonUI

- (UILabel *)setupTitle:(NSString *)title ofRegion:(UIView *)view {
    UIView *line = [[UIView alloc] init];
    [line.layer setCornerRadius:1.f];
    [line setBackgroundColor:COLOR_RED_FF4562];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(15.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(3.f, 20.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:21.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line);
        make.left.equalTo(line.mas_right).with.offset(10.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    return titleLabel;
}

- (UIView *)setupProcessItemWithIndex:(NSString *)index icon:(UIImage *)icon title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:icon];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    UILabel *indexLabel = [[UILabel alloc] init];
    [indexLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [indexLabel setTextColor:COLOR_BLACK_666666];
    [indexLabel setText:index];
    [view addSubview:indexLabel];
    [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(iconView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [titleLabel setTextColor:COLOR_BLACK_666666];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).with.offset(10.f);
        make.left.and.right.equalTo(view);
        make.height.mas_equalTo(titleLabel.font.pointSize);
        make.bottom.equalTo(view);
    }];
    
    return view;
}
/*
#pragma mark - HPageViewDelegate

- (UIView *)pageView:(HPPageView *)pageView viewAtPageIndex:(NSInteger)index {
    NSDictionary *dict = _sharePersonData[index];
    
    HPSharePersonCard *sharePersonCard = [[HPSharePersonCard alloc] init];
    [sharePersonCard setPortrait:dict[@"portrait"]];
    [sharePersonCard setUserName:dict[@"userName"]];
    [sharePersonCard setCompany:dict[@"company"]];
    [sharePersonCard setSignature:dict[@"signature"]];
    [sharePersonCard setDescription:dict[@"desc"]];
    
    return sharePersonCard;
}

- (NSInteger)pageNumberOfPageView:(HPPageView *)pageView {
    return _sharePersonData.count;
}
*/

#pragma mark - HPBannerDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - onClick

- (void)onClickMoreView:(UIView *)view {
    
    [self pushVCByClassName:@"HPShareListController"];
}

- (void)onClickShareBtn:(HPAlignCenterButton *)btn {
    if ([btn.text isEqualToString:@"人力共享"]) {
        [self pushVCByClassName:@"HPShareSpaceListController" withParam:@{@"shareType":@"0"}];
    }
    else if ([btn.text isEqualToString:@"店铺共享"]) {
        [self pushVCByClassName:@"HPShareShopListController" withParam:@{@"shareType":@"1"}];
    }
    else if ([btn.text isEqualToString:@"货品共享"]) {
        [self pushVCByClassName:@"HPShareGoodViewController" withParam:@{@"shareType":@"2"}];
    }
    else if ([btn.text isEqualToString:@"共享地图"]) {
        [self pushVCByClassName:@"HPShareMapController" withParam:@{@"shareType":@"3"}];
    }
}
#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _sharePersonData.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,291.f * g_rateWidth, 187.f * g_rateWidth)];
        NSDictionary *dict = _sharePersonData[index];
        
        HPSharePersonCard *sharePersonCard = [[HPSharePersonCard alloc] init];
        [sharePersonCard setPortrait:dict[@"portrait"]];
        [sharePersonCard setUserName:dict[@"userName"]];
        [sharePersonCard setCompany:dict[@"company"]];
        [sharePersonCard setSignature:dict[@"signature"]];
        [sharePersonCard setDescription:dict[@"desc"]];

        sharePersonCard.delegate = self;
        [view addSubview:sharePersonCard];
        [sharePersonCard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(view);
            make.width.mas_equalTo(291.f * g_rateWidth);
            make.height.mas_equalTo(187.f * g_rateWidth);
        }];
    }
    return view;
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.03;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    [self pushVCByClassName:@"HPMyCardController"];
}

#pragma mark - HPSharePersonCardDelegate
- (void)clickFollowBtnToFocusSB
{
    HPLog(@"focusSB");
}
@end
