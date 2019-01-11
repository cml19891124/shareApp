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


#define CELL_ID @"HPShareListCell"

@interface HPShareMapController () <UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate, AMapSearchDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) MAMapView *mapView;

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

@property(nonatomic,strong) ClusterAnnotation * selectedNetPointModel;//选中店铺模型

@end

@implementation HPShareMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AMapServices sharedServices].enableHTTPS = YES;
    _dataArray = [[NSMutableArray alloc] init];
    _shareListParam = [HPShareListParam new];
    
    [self configLocationManager];
    [self configSearchAPI];
    [self setupUI];
    [self requestLocationIfNeedData:YES];
}

- (void)setupUI {
    UIView *navigationView = [self setupNavigationBarWithTitle:@"共享地图"];
    
    MAMapView *mapView = [[MAMapView alloc] init];
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.zoomLevel = 15.f;
    [mapView setDelegate:self];
    [self.view addSubview:mapView];
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

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self showDataView:NO];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    HPLog(@"title:%@",annotation.title);
    if ([annotation isKindOfClass:ClusterAnnotation.class]) {
        ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Share_Annotation"];
        
        [annotationView setImage:ImageNamed(@"hasStoreAnnotation")];
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
        pan.delegate = self;
        [annotationView addGestureRecognizer:pan];
        
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
    if ([view isKindOfClass:HPShareAnnotationView.class]) {
        ClusterAnnotation *shareAnnotation = (ClusterAnnotation *)view.annotation;
        
        [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        [self.mapView setZoomLevel:18.f animated:YES];
        [self showDataView:YES];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:shareAnnotation.index inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
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
    [self.mapView setZoomLevel:15.f animated:YES];
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
        self.annotations = [HPShareAnnotation annotationArrayWithModels:models];
//        [self.mapView addAnnotations:annotations];
//        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        [self  creatAnnotation];
        if (self.annotations.count != 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /* 建立四叉树. */
                //if (self.coordinateQuadTree == nil) {
                self.coordinateQuadTree = [[CoordinateQuadTree alloc] init];
                //}
                [self.coordinateQuadTree buildTreeWithPOIs:self.annotations];
                self.shouldRegionChangeReCalculate = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addAnnotationsToMapView:self.mapView];
                });
            });
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark -- 创建店铺标注
- (void)creatAnnotation {
    self.annoArray = [NSMutableArray array];
    for (int i = 0; i < self.annotations.count; i++) {
        //创建大头针对象
        HPShareAnnotation *model = self.annotations[i];
        _pointAnnotation = [[ClusterAnnotation alloc] initWithCoordinate:model.coordinate count:self.annotations.count];
        _pointAnnotation.title = model.title;
//        _pointAnnotation.pois = [NSMutableArray arrayWithObject:model];
        [self.annoArray addObject:_pointAnnotation];
    }
    [self.mapView addAnnotations:self.annoArray];
}

#pragma mark - 标注聚合方法
- (void)addAnnotationsToMapView:(MAMapView *)mapView
{
    if (self.coordinateQuadTree.root != nil || self.shouldRegionChangeReCalculate == YES)
    {
        //        NSLog(@"tree is not ready.");
        /* 根据当前zoomLevel和zoomScale 进行annotation聚合. */
        double zoomScale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:mapView.visibleMapRect
                                                                            withZoomScale:zoomScale
                                                                             andZoomLevel:self.mapView.zoomLevel];
        /* 更新annotation. */
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    }
}

// 更新annotation
- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations
{
    if(annotations.count == 0){
        return;
    }
    
    //判断是否是已经选中的标注，设置选中状态，更新标注图片状态
    NSMutableArray * currentAnnotationArray = [NSMutableArray arrayWithArray:self.mapView.annotations];
    BOOL flag = YES;
    
    for(int i=0;i<currentAnnotationArray.count;i++){
        
        id  anno = currentAnnotationArray[i];
        if([anno isKindOfClass:[ClusterAnnotation class]]){
            
            ClusterAnnotation * cluAn = (ClusterAnnotation *)anno;
            
            ClusterAnnotation  *  netPointModel = currentAnnotationArray[i];//cluAn.pois[0];
            
            if([netPointModel.model.spaceId isEqualToString:self.selectedNetPointModel.model.spaceId]){
                netPointModel.selected = YES;
                [self.mapView removeAnnotation:cluAn];
                [self.mapView addAnnotation:cluAn];
                flag  = NO;
            }else{
                if(netPointModel.selected){//上一次选中的网点
                    netPointModel.selected = NO;
                    [self.mapView removeAnnotation:cluAn];
                    [self.mapView addAnnotation:cluAn];
                    flag  = NO;
                }
                
                //保证必有一个网点更新，一次来调用代理方法
                if(flag){
                    [self.mapView removeAnnotation:cluAn];
                    [self.mapView addAnnotation:cluAn];
                    flag  = NO;
                }
            }
        }
        
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

- (void)recognizer:(UIPanGestureRecognizer *)ger {
    HPShareAnnotationView *view = (HPShareAnnotationView *)ger.view;
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {//用户位置点
        
    } else {
        ClusterAnnotation *annotation = (ClusterAnnotation *)view.annotation;
        if (annotation.count == 1) {
            //非聚合网点
            ClusterAnnotation * model = annotation;
            if(self.selectedNetPointModel != model){
                [self setupSelectNetPointWithModel:model];
            }
            
        } else {
            for (int i = 0; i < annotation.count; i++) {
                ClusterAnnotation * model = annotation;
                if(self.selectedNetPointModel != model){
                    [self setupSelectNetPointWithModel:model];
                }
            }
            
            //点击聚合网点 地图缩放
            [self.mapView setRegion:MACoordinateRegionMake(annotation.coordinate, MACoordinateSpanMake(self.mapView.region.span.latitudeDelta/2, self.mapView.region.span.longitudeDelta/2)) animated:YES];
        }
    }
}

#pragma mark - 传入店铺标注模型，设置地图选中此网点效果，包括路径规划等
- (void)setupSelectNetPointWithModel:(ClusterAnnotation *)annotation{
    
    if(!annotation){
        return;
    }
    
    annotation.selected = YES;
    self.selectedNetPointModel = annotation;
    [self.mapView addAnnotation:annotation];
    [self addAnnotationsToMapView:self.mapView];
}
@end
