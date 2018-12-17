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
#import "HPShareListCell.h"
#import "HPShareListParam.h"
#import "HPShareAnnotationView.h"

#define CELL_ID @"HPShareListCell"

@interface HPShareMapController () <UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate>

@property (nonatomic, weak) MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UILabel *locationLabel;

@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, assign) BOOL firstLocate;

@end

@implementation HPShareMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [AMapServices sharedServices].enableHTTPS = YES;
    _dataArray = [[NSMutableArray alloc] init];
    _shareListParam = [HPShareListParam new];
    _firstLocate = YES;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"共享地图"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.and.width.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    MAMapView *mapView = [[MAMapView alloc] init];
    mapView.showsUserLocation = YES;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.zoomLevel = 15.f;
    [mapView setDelegate:self];
    [scrollView addSubview:mapView];
    _mapView = mapView;
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.and.width.and.equalTo(scrollView);
        make.height.mas_equalTo(getWidth(237.f));
    }];
    
    UIView *dataView = [[UIView alloc] init];
    [dataView setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:dataView];
    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(mapView.mas_bottom);
        make.height.mas_equalTo(getWidth(367.f));
        make.bottom.equalTo(scrollView);
    }];
    
    UIView *headerView = [[UIView alloc] init];
    [dataView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(dataView);
        make.height.mas_equalTo(getWidth(44.f));
    }];
    
    UILabel *locationLabel = [[UILabel alloc] init];
    [locationLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [locationLabel setTextColor:COLOR_BLACK_333333];
    [locationLabel setText:@"南山区-科技园"];
    [headerView addSubview:locationLabel];
    _locationLabel = locationLabel;
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(getWidth(16.f));
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    [countLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [countLabel setTextColor:COLOR_BLACK_666666];
    [countLabel setText:@"15个铺位可共享"];
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
    [scrollView addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom).with.offset(getWidth(34.f));
        make.right.equalTo(self.view).with.offset(-getWidth(20.f));
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
    }];
    
    UIButton *locateBtn = [self setupMapBtnWithImage:[UIImage imageNamed:@"map_locate"]];
    [locateBtn addTarget:self action:@selector(onClickLocateBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:locateBtn];
    [locateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refreshBtn.mas_bottom).with.offset(getWidth(14.f));
        make.right.equalTo(refreshBtn);
        make.size.equalTo(refreshBtn);
    }];
}

- (void)loadTableViewFreshUi {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.shareListParam.page = 1;
        [self getShareListData:self.shareListParam reload:YES];
    }];
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
    if (cell) {
        if (cell.model) {
            //            NSString *spaceId = cell.model.spaceId;
            for (HPShareAnnotation *annotation in self.mapView.annotations) {
                if ([annotation.model.spaceId isEqualToString:cell.model.spaceId]) {
                    NSLog(@"selectAnnotation");
                    [self.mapView selectAnnotation:annotation animated:YES];
                }
                else {
                    [self.mapView deselectAnnotation:annotation animated:YES];
                }
            }
        }
    }
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

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!_firstLocate) {
        return;
    }
    _firstLocate = NO;
    double lat = userLocation.coordinate.latitude;
    double lon = userLocation.coordinate.longitude;
    NSString *latitude = [NSString stringWithFormat:@"%lf", lat];
    NSString *longitude = [NSString stringWithFormat:@"%lf", lon];
    [_shareListParam setLatitude:latitude];
    [_shareListParam setLongitude:longitude];
    [self.tableView.mj_header beginRefreshing];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:HPShareAnnotation.class]) {
        HPShareAnnotationView *annotationView = [[HPShareAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Share_Annotation"];
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"didSelectAnnotationView");
    [view setSelected:YES];
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    [self.mapView setZoomLevel:15.f animated:YES];
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    [view setSelected:NO];
}

#pragma mark - OnClick

- (void)onClickRefreshBtn {
    [self.tableView.mj_header beginRefreshing];
}

- (void)onClickLocateBtn {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    [self.mapView setZoomLevel:15.f animated:YES];
}

#pragma mark - NetWork

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload {
    NSMutableDictionary *dict = param.mj_keyValues;
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:NO paraments:dict complete:^(id  _Nonnull responseObject) {
        NSArray<HPShareListModel *> *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:DATA[@"list"]];
        
        if (models.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_header endRefreshing];
            NSLog(@"no more data");
        }
        else {
            [self setCount:models.count];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (isReload) {
            self.dataArray = [NSMutableArray arrayWithArray:models];
        }
        else {
            [self.dataArray addObjectsFromArray:models];
        }
        [self.tableView reloadData];
        [self.mapView removeAnnotations:self.mapView.annotations];
        NSArray *annotations = [HPShareAnnotation annotationArrayWithModels:models];
        [self.mapView addAnnotations:annotations];
        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

@end
