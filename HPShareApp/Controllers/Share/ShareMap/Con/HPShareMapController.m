//
//  HPShareMapController.m
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareMapController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "HPShareListCell.h"
#import "HPShareListParam.h"
#import "HPShareAnnotationView.h"
#import "HPShareMapAnnotationView.h"

#import "HPCommonData.h"
#import "ClusterAnnotation.h"
#import "HPShareAnnotation.h"
//四叉树
#import "CoordinateQuadTree.h"
#import "ClusterAnnotationView.h"

#import "CustomCalloutView.h"

#define kCalloutViewMargin  -12
#define Button_Height       70.0

#define CELL_ID @"HPShareListCell"

@interface HPShareMapController () <UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate, AMapSearchDelegate,UIGestureRecognizerDelegate,CustomCalloutViewTapDelegate>

@property (nonatomic, weak) MAMapView *mapView;

@property (nonatomic, strong) CustomCalloutView *customCalloutView;
@property (nonatomic, strong) MAPointAnnotation *centerPoint;

@property (nonatomic, strong) UILabel *TipsLab;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, weak) UIView *dataView;

@property (nonatomic, strong) MASConstraint *dataViewTopConstraint;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UILabel *locationLabel;

@property (nonatomic, weak) UILabel *countLabel;


/**
 店铺标注数组
 */
@property (nonatomic,strong) NSMutableArray *annoArray;

@property (nonatomic, strong) ClusterAnnotation *pointAnnotation;
@property (nonatomic, strong) NSArray *annotations;

/**
 四叉树对象
 */
@property (nonatomic, strong) CoordinateQuadTree *coordinateQuadTree;
@property (nonatomic, assign) BOOL shouldRegionChangeReCalculate;

@property (nonatomic,strong) HPShareListModel * selectedPoiModel;//选中店铺模型

@property (nonatomic, strong) NSMutableArray *selectedPoiArray;
@end

@implementation HPShareMapController

- (CustomCalloutView *)customCalloutView
{
    if (!_customCalloutView) {
        _customCalloutView = [CustomCalloutView new];
        _customCalloutView.delegate = self;
    }
    return _customCalloutView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isPop) {//从详情列表页返回时重新加载地图数据，避免返回时地图空空如也
//        [self getShareListData:_shareListParam reload:YES];
    }else{

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AMapServices sharedServices].enableHTTPS = YES;
    _dataArray = [[NSMutableArray alloc] init];
    _shareListParam = [HPShareListParam new];
    _selectedPoiArray = [NSMutableArray array];
    [self configLocationManager];
    [self configSearchAPI];
    [self setupUI];
    [self requestLocationIfNeedData:YES];
}


- (MAPointAnnotation *)centerPoint
{
    if (!_centerPoint)
    {
        _centerPoint = [[MAPointAnnotation alloc] init];
        _centerPoint.coordinate = self.mapView.userLocation.location.coordinate;
        _centerPoint.lockedToScreen = YES;
        _centerPoint.lockedScreenPoint = CGPointMake(kScreenWidth * 0.5, (kScreenHeight - g_statusBarHeight - 44.f) * 0.5);
    }
    return _centerPoint;
}

- (void)setupUI {
    UIView *navigationView = [self setupNavigationBarWithTitle:@"共享地图"];
    
    MAMapView *mapView = [[MAMapView alloc] init];
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.zoomLevel = 11.f;
    [mapView setDelegate:self];
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;

    MAUserLocationRepresentation *UserLocationRep = [[MAUserLocationRepresentation alloc] init];
    UserLocationRep.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    [mapView updateUserLocationRepresentation:UserLocationRep];
    //设置定位距离
    mapView.distanceFilter = 5.0f;
    //添加屏幕中心点
    [mapView addAnnotation:self.centerPoint];
    
    [self.view addSubview:mapView];
    
//    _TipsLab = [UILabel new];
//    _TipsLab.backgroundColor = COLOR_GRAY_FFFFFF;
//    _TipsLab.layer.cornerRadius = 4.f;
//    _TipsLab.layer.masksToBounds = YES;
//    _TipsLab.numberOfLines = 0;
//    [_TipsLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//
//    NSString *str=@"提示：如果定位不准，\n请拖动地图，标记出准确的店铺位置，才能更快找到";
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10,17)];
//    _TipsLab.attributedText=string;
//    [mapView addSubview:_TipsLab];
//    [mapView bringSubviewToFront:_TipsLab];
//    [_TipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(getWidth(335.f));
//        make.top.mas_equalTo(15.f);
//        make.centerX.mas_equalTo(mapView);
//    }];
    
    _mapView = mapView;
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.and.width.and.equalTo(self.view);
    }];
    
    UIView *dataView = [[UIView alloc] init];
    [dataView setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:dataView];
    _dataView = dataView;
    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        self.dataViewTopConstraint = make.top.equalTo(self.view.mas_bottom).with.offset(-getWidth(44.f));
        make.height.mas_equalTo(getWidth(367.f));
    }];
    
    [mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dataView.mas_top);
    }];
    
    UIView *headerView = [[UIView alloc] init];
    [dataView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(dataView);
        make.height.mas_equalTo(getWidth(44.f));
    }];
    
    UISwipeGestureRecognizer *swipeDownGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHeadeView:)];
    [swipeDownGest setDirection:UISwipeGestureRecognizerDirectionDown];
    [headerView addGestureRecognizer:swipeDownGest];
    
    UISwipeGestureRecognizer *swipeUpGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHeadeView:)];
    [swipeUpGest setDirection:UISwipeGestureRecognizerDirectionUp];
    [headerView addGestureRecognizer:swipeUpGest];
    
    UILabel *locationLabel = [[UILabel alloc] init];
    [locationLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [locationLabel setTextColor:COLOR_BLACK_333333];
    [locationLabel setText:@"定位中..."];
    [headerView addSubview:locationLabel];
    _locationLabel = locationLabel;
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(getWidth(16.f));
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    [countLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [countLabel setTextColor:COLOR_BLACK_666666];
    [countLabel setText:@"0个铺位可共享"];
    [headerView addSubview:countLabel];
    _countLabel = countLabel;
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationLabel.mas_right).with.offset(getWidth(16.f));
        make.centerY.equalTo(locationLabel);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_E0E0E0];
    [dataView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.and.width.equalTo(dataView);
        make.height.mas_equalTo(1.f);
    }];
    
    UITableView *tableView  = [[UITableView alloc] init];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [dataView addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.and.width.equalTo(dataView);
        make.bottom.equalTo(dataView);
    }];
    
    [self loadTableViewFreshUi];
    
    UIButton *refreshBtn = [self setupMapBtnWithImage:[UIImage imageNamed:@"map_refresh"]];
    [refreshBtn addTarget:self action:@selector(onClickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(getWidth(34.f));
        make.right.equalTo(self.view).with.offset(-getWidth(20.f));
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
    }];
    
    UIButton *locateBtn = [self setupMapBtnWithImage:[UIImage imageNamed:@"map_locate"]];
    [locateBtn addTarget:self action:@selector(onClickLocateBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locateBtn];
    [locateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refreshBtn.mas_bottom).with.offset(getWidth(14.f));
        make.right.equalTo(refreshBtn);
        make.size.equalTo(refreshBtn);
    }];
}

- (void)loadTableViewFreshUi {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.shareListParam.page ++;
        [self getShareListData:self.shareListParam reload:NO];
    }];
}

- (void)setLocation:(NSString *)location {
    [_locationLabel setText:location];
}

- (void)setCount:(NSInteger)count {
    NSString *str = [NSString stringWithFormat:@"%ld个铺位可共享",(long)count];
    [_countLabel setText:str];
}

- (UIButton *)setupMapBtnWithImage:(UIImage *)image {
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:UIColor.whiteColor];
    [btn setImage:image forState:UIControlStateNormal];
    [btn.layer setCornerRadius:4.f];
    [btn.layer setShadowColor:COLOR_GRAY_808080.CGColor];
    [btn.layer setShadowRadius:6.f];
    [btn.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [btn.layer setShadowOpacity:0.4f];
    
    return btn;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self pushVCByClassName:@"HPShareDetailController" withParam:@{@"model":cell.model}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f * g_rateWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return getWidth(7.5f);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return getWidth(20.f);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    HPShareListModel *model = _dataArray[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

# pragma mark - Locate

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setLocationTimeout:2];
    [self.locationManager setPausesLocationUpdatesAutomatically:YES];
}

- (void)requestLocationIfNeedData:(BOOL)ifNeedData {
    [HPProgressHUD alertWithLoadingText:@"定位中"];
    //开始定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (!error) {
            NSString *areaId;
            
            if (regeocode) {
                NSString *areaName = regeocode.district;
                [self.locationLabel setText:areaName];
                areaId = [HPCommonData getAreaIdByName:areaName];
            }
            
            if (!areaId) {
                areaId = @"1";
                [self.locationLabel setText:@"南山区"];
            }
            
            [self.shareListParam setPage:1];
            [self.shareListParam setAreaId:areaId];
            
            if (ifNeedData) {
                [self getShareListData:self.shareListParam reload:YES];
            }
            else {
                [HPProgressHUD alertWithFinishText:@"定位成功"];
            }
        }
        else {
            [HPProgressHUD alertMessage:@"定位失败"];
            HPLog(@"error: %@", error);
        }
    }];
}

#pragma mark - AMapSearchAPI

- (void)configSearchAPI {
    self.searchAPI = [[AMapSearchAPI alloc] init];
    [self.searchAPI setDelegate:self];
}

- (void)seachReGeocodeWithCoord:(CLLocationCoordinate2D)coord {
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
    [point setLatitude:coord.latitude];
    [point setLongitude:coord.longitude];
    [request setLocation:point];
    
    [_searchAPI AMapReGoecodeSearch:request];
}

#pragma mark - AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    NSString *areaName = response.regeocode.addressComponent.district;
    NSString *areaId = [HPCommonData getAreaIdByName:areaName];
    if (![areaId isEqualToString:_shareListParam.areaId]) {
        [_locationLabel setText:areaName];
        [_shareListParam setAreaId:areaId];
        [self getShareListData:_shareListParam reload:YES];
    }
}

#pragma mark - DataView

- (void)showDataView:(BOOL)isShow {
    [_dataView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (isShow) {
            [self.dataViewTopConstraint uninstall];
            self.dataViewTopConstraint = make.top.equalTo(self.view.mas_bottom).with.offset(-getWidth(367.f));
        }
        else {
            [self.dataViewTopConstraint uninstall];
            self.dataViewTopConstraint = make.top.equalTo(self.view.mas_bottom).with.offset(-getWidth(44.f));;
        }
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UIGestureRecogizerDelegate

- (void)swipeHeadeView:(UISwipeGestureRecognizer *)swipeGest {
    if (swipeGest.direction == UISwipeGestureRecognizerDirectionDown) {
        [self showDataView:NO];
        [_mapView showAnnotations:_mapView.annotations animated:YES];
    }
    else if (swipeGest.direction == UISwipeGestureRecognizerDirectionUp) {
        [self showDataView:YES];
    }
}

#pragma mark - OnClick

- (void)onClickRefreshBtn {
    [self showDataView:NO];
    [_shareListParam setPage:1];
    if (!_shareListParam.areaId) {
        [self requestLocationIfNeedData:YES];
    }
    else {
        [self getShareListData:_shareListParam reload:YES];
    }
}

- (void)onClickLocateBtn {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    [self.mapView setZoomLevel:18.f animated:YES];
}

#pragma mark - NetWork

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload {
    NSMutableDictionary *dict = param.mj_keyValues;
    
    [HPProgressHUD alertWithLoadingText:@"数据加载中"];
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:NO paraments:dict complete:^(id  _Nonnull responseObject) {
        [HPProgressHUD alertWithFinishText:@"加载完成"];
        
        NSArray<HPShareListModel *> *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:DATA[@"list"]];
        
        if (models.count < param.pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (isReload) {
            self.dataArray = [NSMutableArray arrayWithArray:models];
        }
        else {
            [self.dataArray addObjectsFromArray:models];
        }
        
        [self setCount:self.dataArray.count];
        [self.tableView reloadData];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
//        [self.mapView addAnnotations:annotations];
        [self creatAnnotation];
        
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self showDataView:NO];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    HPLog(@"title:%@",annotation.title);
    if ([annotation isKindOfClass:ClusterAnnotation.class]) {
        ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Share_Annotation"];
        
        /* 设置annotationView的属性. */
        annotationView.annotation = annotation;
        annotationView.count = [(ClusterAnnotation *)annotation count];
        
        /* 不弹出原生annotation */
        annotationView.canShowCallout = NO;
//        int i = rand() % 5;
//        annotationView.count = i;
        
//        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
//        pan.delegate = self;
//        [annotationView addGestureRecognizer:pan];
        
        return annotationView;
    }
    //===============用户位置点
    else if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *pointReuseIdentifier = @"UserLocation";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        annotationView.canShowCallout = NO;
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
    [view setSelected:YES];

//    ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    [self.mapView setZoomLevel:15.1f animated:YES];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:annotation.index inSection:0];
//    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self recognizer:view];
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    [view setSelected:NO];
    [self.selectedPoiArray removeAllObjects];
    [self.customCalloutView dismissCalloutView];
    self.customCalloutView.delegate = nil;
    [self.mapView deselectAnnotation:view.annotation animated:YES];
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    //    if (wasUserAction) {
    //        [self seachReGeocodeWithCoord:mapView.centerCoordinate];
    //    }
}

/*
 在mapView显示区域改变时，需要重算并更新annotations。
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    /* mapView区域变化时重算annotation. */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addAnnotationsToMapView:self.mapView];
    });
}


#pragma mark -- 创建店铺标注
- (void)creatAnnotation {
    self.annoArray = [NSMutableArray array];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        //创建大头针对象
        HPShareListModel *model = self.dataArray[i];
        CLLocationCoordinate2D cordote = CLLocationCoordinate2DMake(115.93,23.5);
        if (!model.latitude || !model.longitude) {
            _pointAnnotation = [[ClusterAnnotation alloc] initWithCoordinate:cordote count:0];

        }else{
            _pointAnnotation = [[ClusterAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longitude) count:0];
        }
        _pointAnnotation.pois = [NSMutableArray arrayWithObject:model];;
        _pointAnnotation.title = model.title;
        [self.annoArray addObject:_pointAnnotation];
    }
    
    if (self.annoArray.count != 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 建立四叉树. */
            
            self.coordinateQuadTree = [[CoordinateQuadTree alloc] init];
            
            [self.coordinateQuadTree buildTreeWithPOIs:self.annoArray];
            self.shouldRegionChangeReCalculate = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                //点聚合
                [self addAnnotationsToMapView:self.mapView];
            });
        });
    }
    
    [self.mapView addAnnotations:self.annoArray];

//    [self.mapView showAnnotations:self.mapView.annotations animated:YES];//---这行代码会导致定图定位到h非洲

}

#pragma mark - 标注聚合方法
- (void)addAnnotationsToMapView:(MAMapView *)mapView
{
    if (self.coordinateQuadTree.root != nil || self.shouldRegionChangeReCalculate == YES)
    {
        //        NSLog(@"tree is not ready.");
        /* 根据当前zoomLevel和zoomScale 进行annotation聚合. */
        MAMapRect visibleRect = self.mapView.visibleMapRect;

        double zoomScale = self.mapView.bounds.size.width / visibleRect.size.width;
        
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:mapView.visibleMapRect
                                                                            withZoomScale:zoomScale
                                                                             andZoomLevel:self.mapView.zoomLevel];
        /* 更新annotation. */
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    }
}

// 更新annotation 对比mapView里已有的annotations，吐故纳新
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    if(annotations.count == 0){
        return;
    }
    
    /* 用户滑动时，保留仍然可用的标注，去除屏幕外标注，添加新增区域的标注 */
    NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    
    /* 保留仍然位于屏幕内的annotation. */
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    /* 需要添加的annotation. */
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    /* 删除位于屏幕外的annotation. */
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    /* 更新. */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
        
    });
}

#pragma  mark - 点击店铺标注事件

- (void)recognizer:(MAAnnotationView *)view {
    
    [view setSelected:YES];
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {//用户位置点
        
    } else {
        ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
        if (annotation.count <= 1) {//pois数组里只有一个元素，所以下面可以直接取第一个元素
            //非聚合网点
            HPShareListModel * model = annotation.pois[0];
            if(self.selectedPoiModel != model){
                [self setupSelectNetPointWithModel:model];
            }
            
            for (HPShareListModel *poi in annotation.pois)
            {
                [self.selectedPoiArray addObject:poi];
            }
            [self.customCalloutView setPoiArray:self.selectedPoiArray];
            
            // 调整位置
            self.customCalloutView.center = CGPointMake(CGRectGetMidX(view.bounds), -CGRectGetMidY(self.customCalloutView.bounds) - CGRectGetMidY(view.bounds) - kCalloutViewMargin);
            self.customCalloutView.delegate = self;
            [view addSubview:self.customCalloutView];
            
        } else {
            
            for (ClusterAnnotation *poi in annotation.pois)
            {
                [self.selectedPoiArray addObjectsFromArray:poi.pois];
            }
            
            [self.customCalloutView setPoiArray:self.selectedPoiArray];

            ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
            [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
            // 调整位置
            self.customCalloutView.center = CGPointMake(CGRectGetMidX(view.bounds), -CGRectGetMidY(self.customCalloutView.bounds) - CGRectGetMidY(view.bounds) - 2 * kCalloutViewMargin);
            self.customCalloutView.delegate = self;

            [view addSubview:self.customCalloutView];
            
//            [self.mapView deselectAnnotation:annotation animated:YES];//设置为非选中状态
            
            //点击聚合网点 地图缩放
            [self.mapView setRegion:MACoordinateRegionMake(annotation.coordinate, MACoordinateSpanMake(self.mapView.region.span.latitudeDelta/2, self.mapView.region.span.longitudeDelta/2)) animated:YES];
        }
    }
}

#pragma mark - 传入店铺标注模型，设置地图选中此点效果，包括路径规划等
- (void)setupSelectNetPointWithModel:(HPShareListModel *)model{
    
    if(!model){
        return;
    }
    
    model.selected = YES;
    self.selectedPoiModel = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        //点聚合
        [self addAnnotationsToMapView:self.mapView];
    });

}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    /* 为新添的annotationView添加弹出动画. */
//    for (UIView *view in views)
//    {
//        [self addBounceAnnimationToView:view];
//    }
}

/* annotation弹出的动画. */
- (void)addBounceAnnimationToView:(UIView *)view
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    bounceAnimation.duration = 0.6;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++)
    {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    
    bounceAnimation.removedOnCompletion = NO;
    
    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

#pragma mark - 呼出框代理事件
- (void)didDetailButtonTapped:(NSInteger)index {
    HPShareListModel *poi = self.selectedPoiArray[index];
    [self pushVCByClassName:@"HPPoiDetailViewController" withParam:@{@"poi":poi}];
}

- (void)didSelectedIndexpathinRowTapped:(HPShareListModel *)model andIndex:(NSInteger)index
{
    HPShareListModel *poi = self.selectedPoiArray[index];
    [self pushVCByClassName:@"HPPoiDetailViewController" withParam:@{@"poi":poi}];
}
@end
