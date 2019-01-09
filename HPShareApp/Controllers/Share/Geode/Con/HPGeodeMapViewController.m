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


@end

@implementation HPGeodeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化地图
    [self initMapView];
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
        make.top.mas_equalTo(navView.mas_bottom);
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
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
//    CLLocationCoordinate2D center;
//    center.latitude = [_model.latitude doubleValue];
//    center.longitude = [_model.longitude doubleValue];
    
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
    
    HPShareDetailModel *model = self.param[@"loaction"];
    HPShareMapAnnotation *storeAnnotion = [[HPShareMapAnnotation alloc] initWithModel:model];
    //添加店铺位置点
    [self.mapView addAnnotation:storeAnnotion];
    
    //添加屏幕中心点
//    [self.mapView addAnnotation:self.centerPoint];
//    [self.mapView setCenterCoordinate:self.centerPoint.coordinate];
}

- (MAPointAnnotation *)centerPoint
{
    if (!_centerPoint)
    {
        _centerPoint = [[MAPointAnnotation alloc] init];
        _centerPoint.coordinate = self.mapView.userLocation.location.coordinate;
        
        _centerPoint.lockedToScreen = YES;
        _centerPoint.lockedScreenPoint = self.mapView.center;
    }
    return _centerPoint;
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    //===============用户位置点
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *pointReuseIdentifier = @"UserLocation";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        [annotationView setImage:ImageNamed(@"gps_location")];
        return annotationView;
    }
    
//    if ([annotation isKindOfClass:HPShareMapAnnotation.class]) {
//        HPShareMapAnnotationView *annotationView = [[HPShareMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Share_Annotation"];
//        [annotationView setImage:ImageNamed(@"gps_location")];
//        return annotationView;
//    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    [view setSelected:YES];
    if ([view isKindOfClass:HPShareMapAnnotationView.class]) {
//        HPShareMapAnnotationView *shareAnnotation = (HPShareMapAnnotationView *)view.annotation;
        [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        [self.mapView setZoomLevel:18.f animated:YES];
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    [view setSelected:NO];
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
- (void)presentCurrentCourse{
    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:NO startPoint:[AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationPoint.latitude longitude:self.destinationPoint.longitude]];
    [self clearRoute];
    [self.routeArray addObject:self.naviRoute];
    [self.naviRoute addToMapView:self.mapView];
}

#pragma mark - 根据终点坐标做路径规划
- (void)routePlanWithDestination:(CLLocationCoordinate2D)destination{
    //步行
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destination.latitude
                                                longitude:destination.longitude];
    [self.mapSearch AMapWalkingRouteSearch:navi];
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
        [self presentCurrentCourse];
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

@end
