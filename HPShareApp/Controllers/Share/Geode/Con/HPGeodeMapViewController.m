//
//  HPGeodeMapViewController.m
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPGeodeMapViewController.h"
#import "Macro.h"
#import "HPShareDetailModel.h"
#import "HPShareMapAnnotation.h"
#import "HPShareMapAnnotationView.h"
#import "MANaviRoute.h"

#import "HPRouteTypeMenu.h"

static const NSInteger RoutePlanningPaddingEdge                    = 20;


@interface HPGeodeMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>


@property (nonatomic, strong) HPShareDetailModel *model;
@property (nonatomic, strong) MAMapView *mapView;
/**
 地图中心点--店铺在地图中的位置
 */
@property (nonatomic, strong) MAPointAnnotation *centerPoint;

@property (strong, nonatomic) AMapLocationManager * locationManager;//定位用

/**
 地图上路线数组
 */
@property(nonatomic,strong) NSMutableArray * routeArray;
//路径规划
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@property (nonatomic, strong) AMapRoute *route;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic, assign) CLLocationCoordinate2D startPoint;//路径规划开始点坐标
@property (nonatomic, assign) CLLocationCoordinate2D destinationPoint;//路径规划结束点坐标

@property (nonatomic, strong) NSMutableArray *searchPOIs;

@property (nonatomic, strong) UIView *dataView;

@property (nonatomic, strong) MASConstraint *dataViewTopConstraint;

@property (nonatomic, strong) AMapSearchAPI *searchAPI;


/**
 行驶路线类型
 */
@property (nonatomic, assign) NSInteger routeType;

#pragma mark -----------------------行驶方式菜单栏：步行/骑行/公交/驾车

/**
 行驶类型菜单栏
 */
@property (nonatomic, strong) UIView *menu;

/**
 行驶路线图片数组
 */
@property (nonatomic, strong) NSArray *routeImageArray;
@property (nonatomic, strong) NSArray *routeTitleArray;


/**
 点击事件block
 */
@property (nonatomic, copy) RouteTypeBtnBlock routeBtnBlock;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) HPRouteButton *btn;
@end

@implementation HPGeodeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.routeArray = [NSMutableArray array];
    self.routeType = HPRouteTypeWalking;//默认步行
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    self.routeImageArray = @[@"man",@"ride",@"bus",@"car"];
    self.routeTitleArray = @[@"步行",@"骑行",@"公交",@"驾车"];

    [self setUpMenuSubviews];
    
    //初始化地图
    [self initMapView];
}

- (void)setUpMenuSubviews{
    
    [self.view addSubview:self.menu];
//    self.menu.hidden = YES;
    [self setupShadowOfMenu:self.menu];
    
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(70.f));
        make.top.mas_equalTo(self.view.mas_top).offset(getWidth(-70.f));
    }];
    
    CGFloat btnW = (kScreenWidth - getWidth(13.f) * 5)/4;
    for (int i = 0; i < self.routeImageArray.count; i ++) {
        HPRouteButton *btn = [HPRouteButton new];
        btn.layer.cornerRadius = btnW/4;
        btn.layer.masksToBounds = YES;
        [btn setImage:ImageNamed(self.routeImageArray[i]) forState:UIControlStateNormal];
        [btn setTitle:self.routeTitleArray[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HPImageUtil createImageWithColor:UIColor.clearColor] forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickRouteBtnChangeColor:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200 + i;
        [self.menu addSubview:btn];
        self.btn = btn;
        if (i == 0) {
            self.selectBtn = btn;
            btn.selected = YES;
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((getWidth(13.f) + btnW) * i + getWidth(13.f));
            make.size.mas_equalTo(CGSizeMake(btnW, getWidth(70.f)));
            make.top.mas_equalTo(self.menu);
        }];
    }
}

- (void)setupShadowOfMenu:(UIView *)view {
    [view.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
//    [view.layer setShadowRadius:6.f];
    [view.layer setShadowOpacity:0.3f];
//    [view.layer setCornerRadius:6.f];
    [view setBackgroundColor:UIColor.whiteColor];
}

- (void)clickRouteBtnChangeColor:(UIButton *)button
{
    self.selectBtn.selected = NO;
    button.selected = YES;
    self.selectBtn = button;
    self.routeType = button.tag;
    [self routePlanWithDestination:self.destinationPoint];

}

- (UIView *)menu
{
    if (!_menu) {
        _menu = [UIView new];
    }
    return _menu;
}

#pragma mark - 初始化地图
- (void)initMapView{
    UIView *navView = [self setupNavigationBarWithTitle:@"店铺位置"];
    //初始化地图
    self.mapView = [[MAMapView alloc] init];
    [self.mapView setZoomLevel:17 animated:YES];
    
    [self.view addSubview:self.mapView];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(navView.mas_bottom).offset(getWidth(70.f));
    }];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView.delegate = self;

    MAUserLocationRepresentation *UserLocationRep = [[MAUserLocationRepresentation alloc] init];
    
    UserLocationRep.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    [self.mapView updateUserLocationRepresentation:UserLocationRep];
    //默认不生效，开启自定义风格地图
    self.mapView.customMapStyleEnabled = YES;
    
    // 开启定位
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    //路径规划
    self.mapSearch = [[AMapSearchAPI alloc] init];
    self.mapSearch.delegate = self;
    
    //    iOS 去除高德地图下方的 logo 图标
    [self.mapView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            UIImageView * logoM = obj;
            
            logoM.layer.contents = (__bridge id)[UIImage imageNamed:@""].CGImage;
            
        }
        
    }];
    //iOS 去除高德地图下方的 地图比例尺
    self.mapView.showsScale = NO;
    
    _model = self.param[@"loaction"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.longitude doubleValue], [_model.latitude doubleValue]);
    self.destinationPoint = coordinate;
    HPShareMapAnnotation *storeAnnotion = [[HPShareMapAnnotation alloc] initWithModel:_model];
    //添加店铺位置点
    [self.mapView addAnnotation:storeAnnotion];
    
    //添加屏幕中心点
    [self.mapView setCenterCoordinate:storeAnnotion.coordinate];
    self.mapView.selectedAnnotations = @[storeAnnotion];

}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    //===============用户位置点
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *pointReuseIdentifier = @"UserLocation";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        [annotationView setImage:ImageNamed(@"startPoint")];
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    
    else if ([annotation isKindOfClass:HPShareMapAnnotation.class]) {//目标位置点/地图中心点/店铺位置点
        HPShareMapAnnotationView *annotationView = [[HPShareMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Share_Annotation"];
        [annotationView setImage:ImageNamed(@"endPoint")];
        annotationView.canShowCallout = NO;
        annotationView.callOutOffset = CGPointMake(0.f, -getWidth(50.f));
        if (_model && _model.title && _model.address) {
            annotationView.title.text = [NSString stringWithFormat:@"%@\n%@",_model.title,_model.address];
            NSRange range = [annotationView.title.text rangeOfString:_model.title];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:annotationView.title.text];
            [attr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_333333 range:NSMakeRange(0, range.length)];
            [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_999999 range:NSMakeRange(range.length, annotationView.title.text.length - range.length)];
            [attr addAttribute:NSFontAttributeName value:kFont_Medium(14.f) range:NSMakeRange(0, range.length)];
            [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(range.length, annotationView.title.text.length - range.length)];
            annotationView.title.attributedText = attr;
        }
        self.destinationPoint = annotation.coordinate;

        return annotationView;
    }else{//地图上其他位置点--->清除
        static NSString *reuserIdentifier = @"reuserIdentifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuserIdentifier];
        if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
            if (!annotationView) {
                annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuserIdentifier];
            }
        }
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
//    [view setSelected:YES];
    if ([view isKindOfClass:HPShareMapAnnotationView.class]) {
        //路径规划
        [self clearRoute];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view bringSubviewToFront:self.menu];
//            self.menu.hidden = NO;
            [self.menu mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.top uninstall];
                make.top.mas_equalTo(g_statusBarHeight + 44.f);
            }];

        } completion:^(BOOL finished) {
            
        }];
        
        
        [self routePlanWithDestination:self.destinationPoint];
    }else{
        [self clearRoute];
        [view setSelected:NO];
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    [view setSelected:NO];
    [self clearRoute];
    if (self.routeArray.count == 0) {
        
    }
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [self seachReGeocodeWithCoord:mapView.centerCoordinate];
    }
}


- (void)seachReGeocodeWithCoord:(CLLocationCoordinate2D)coord {
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
    [point setLatitude:coord.latitude];
    [point setLongitude:coord.longitude];
    [request setLocation:point];
    
    [_searchAPI AMapReGoecodeSearch:request];
}

/* 清空地图上已有的路线. */
- (void)clearRoute
{
    if(self.routeArray.count==0){
        return;
    }
    for(int i=0;i<self.routeArray.count;i++){
        
        MANaviRoute * naviRoute = self.routeArray[0];
        [naviRoute removeFromMapView];
        
        if(i == self.routeArray.count - 1){
            [self.routeArray removeAllObjects];
        }
    }
}

#pragma mark - 路径规划展示当前路线方案
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    if (_routeType == HPRouteTypeWalking) {
        type = MANaviAnnotationTypeWalking;
    }else if (_routeType == HPRouteTypeRiding) {
        type = MANaviAnnotationTypeRiding;
    }else if (_routeType == HPRouteTypeBus) {
        type = MANaviAnnotationTypeBus;
    }else if (_routeType == HPRouteTypeDriving) {
        type = MANaviAnnotationTypeDrive;
    }else if (_routeType == HPRouteTypeRailway) {
        type = MANaviAnnotationTypeRailway;
    }
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:NO startPoint:[AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationPoint.latitude longitude:self.destinationPoint.longitude]];
    [self clearRoute];
    [self.routeArray addObject:self.naviRoute];
    [self.naviRoute addToMapView:self.mapView];
    /* 缩放地图使其适应polylines的展示. */
    self.naviRoute.anntationVisible=YES;
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
}

#pragma mark - 根据终点坐标做路径规划
- (void)routePlanWithDestination:(CLLocationCoordinate2D)destination{
    
    if (self.routeType == HPRouteTypeWalking) {
        [self waikingNavWithDestination:self.destinationPoint];
    }else if (self.routeType == HPRouteTypeBus) {
        [self WithBusNavDestination:self.destinationPoint];
    }else if (self.routeType == HPRouteTypeDriving) {
        [self driveNavWithDestination:self.destinationPoint];
    }else if (self.routeType == HPRouteTypeRiding) {
        [self ridingNavWithDestination:self.destinationPoint];
    }else if (self.routeType == HPRouteTypeRailway) {//地铁 尚无具体api
//        [self ridingNavWithDestination:self.destinationPoint];
    }
    [self presentCurrentCourse];
}

#pragma mark - 步行
-(void)waikingNavWithDestination:(CLLocationCoordinate2D)destination{
    
    //步行
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destination.latitude
                                                longitude:destination.longitude];
    [self.mapSearch AMapWalkingRouteSearch:navi];
}

#pragma mark - 驾车行驶
-(void)driveNavWithDestination:(CLLocationCoordinate2D)destination{
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;//是否返回扩展信息，默认为 NO
    navi.strategy = 5;// 驾车导航策略([default = 0]) 0-速度优先（时间）；1-费用优先（不走收费路段的最快道路）；2-距离优先；3-不走快速路；4-结合实时交通（躲避拥堵）；5-多策略（同时使用速度优先、费用优先、距离优先三个策略）；6-不走高速；7-不走高速且避免收费；8-躲避收费和拥堵；9-不走高速且躲避收费和拥堵
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.location.coordinate.latitude
                                           longitude:_mapView.userLocation.location.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destination.latitude
                                                longitude:destination.longitude];
    [self.mapSearch AMapDrivingRouteSearch:navi];//驾车路线规划
}

#pragma mark - 骑车行驶
-(void)ridingNavWithDestination:(CLLocationCoordinate2D)destination{
    
    AMapRidingRouteSearchRequest *navi = [[AMapRidingRouteSearchRequest alloc] init];
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.location.coordinate.latitude
                                           longitude:_mapView.userLocation.location.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destination.latitude
                                                longitude:destination.longitude];
    [self.mapSearch AMapRidingRouteSearch:navi];//驾车路线规划
}

#pragma mark - 公交行驶
-(void)WithBusNavDestination:(CLLocationCoordinate2D)destination{

    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.strategy = 4;//公交换乘策略([default = 0])0-最快捷模式；1-最经济模式；2-最少换乘模式；3-最少步行模式；4-最舒适模式；5-不乘地铁模式
    navi.city =@"chongqing";
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_mapView.userLocation.location.coordinate.latitude
                                           longitude:_mapView.userLocation.location.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destination.latitude
                                                longitude:destination.longitude];
    [self.mapSearch AMapTransitRouteSearch:navi];//公共交通路线规
}

#pragma mark - AMapSearchDelegate
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    self.route = response.route;
    self.currentCourse = 0;
    if (response.count > 0)
    {
        /* 预加载*/
        if (self.routeType == HPRouteTypeDriving) {
            self.route = response.route;
            [MBProgressHUD hideHUDForView:self.view animated:YES];//隐藏菊花
        }
        if (self.routeType == HPRouteTypeBus) {
            self.route = response.route;
            if (response.route.transits!=nil && response.route.transits.count!=0) {
                if(response.route.transits.lastObject!=nil){
                    
                }
            }else{

            }

        }
        if (self.routeType == HPRouteTypeWalking) {
            self.route = response.route;
            if (response.route.paths) {
                [self presentCurrentCourse];
            }
            else{

            }

        }
        self.route = response.route;
        self.currentCourse = 0;
    }
}

/* 路径规划搜索失败回调. */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    if (self.routeType==HPRouteTypeDriving) {
//        self.driveDration.text=@"暂无";
//        self.carBtn.enabled=false;
    }
    if (self.routeType==HPRouteTypeBus) {
//        self.busDration.text=@"暂无";
//        self.busBtn.enabled=false;
        [self WithBusNavDestination:self.destinationPoint];
    }
    if (self.routeType==HPRouteTypeWalking) {
//        self.walkDration.text=@"暂无";
//        self.walkBtn.enabled=false;
        [self WithBusNavDestination:self.destinationPoint];
    }
}

#pragma mark - MAMapviewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 5;
        polylineRenderer.lineCapType = kMALineCapSquare;
        polylineRenderer.strokeColor = [UIColor colorWithHexString:@"5DA9FF"];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        polylineRenderer.lineCapType = kMALineCapRound;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineWidth = 5;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - 时间格式转换，距离格式转换，string类型的经纬度转换
//距离格式转换
-(NSString *)disFormat:(double)meters {
    double intDistance=(int)round(meters);
    return [NSString stringWithFormat:@"距离:%0.2fKM",intDistance/1000 ];
}

-(AMapGeoPoint *)pointFormat:(NSString *)point{
    //经纬度格式转换
    NSArray *arry= [point componentsSeparatedByString:@","];
    double p2=((NSString *)arry[0]).doubleValue;
    double p1=((NSString *)arry[1]).doubleValue;
    return [AMapGeoPoint locationWithLatitude:CLLocationCoordinate2DMake(p1,p2).latitude
                                    longitude:CLLocationCoordinate2DMake(p1,p2).longitude];
}

//时间格式转换
-(NSString *)timeFomart:(double)duration{
    return [NSString stringWithFormat:@"%0.0f分钟",duration/60];
}

//笨方法，隐藏加载中的控件
-(void)isHideNavView:(BOOL) ishide{
//    self.busBtn.hidden=ishide;
//    self.busDration.hidden=ishide;
//    self.driveDration.hidden=ishide;
//    self.carBtn.hidden=ishide;
//    self.walkDration.hidden=ishide;
//    self.walkBtn.hidden=ishide;
}

@end
