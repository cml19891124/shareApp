//
//  HPShareAddressController.m
//  HPShareApp
//
//  Created by Jay on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareAddressController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "HPLocateHistory.h"
#import "HPTextDialogView.h"
#import "HPSearchPOICell.h"

#define CELL_HISTORY @"cell_history"
#define CELL_POI @"cell_POI"

@interface HPShareAddressController () <UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, UITextFieldDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, strong) HPTextDialogView *textDialogView;

@property (nonatomic, weak) UITableView *historyTableView;

@property (nonatomic, strong) NSArray *locateHistory;

@property (nonatomic, weak) UIView *searchInputView;

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UITableView *searchTableView;

@property (nonatomic, strong) NSMutableArray *searchPOIs;

@end

@implementation HPShareAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _locateHistory = [HPLocateHistory history];
    if (!_locateHistory) {
        _locateHistory = @[];
    }
    _searchPOIs = [[NSMutableArray alloc] init];
    [self configLocationManager];
    [self configSearchAPI];
    [self setupUI];
}

- (void)dealloc {
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

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_GRAY_FAF9FE];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"共享地址"];
    
    UIView *inputRow = [[UIView alloc] init];
    [inputRow setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:inputRow];
    [inputRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
        make.height.mas_equalTo(getWidth(65.f));
    }];
    
    UIButton *inputBtn = [[UIButton alloc] init];
    [inputBtn.layer setCornerRadius:4.f];
    [inputBtn.titleLabel setFont:kFont_Medium(15.f)];
    [inputBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
    [inputBtn setBackgroundColor:[COLOR_GRAY_DDDDDD colorWithAlphaComponent:0.35f]];
    [inputBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [inputBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [inputBtn setTitle:@"输入关键字进行搜索" forState:UIControlStateNormal];
    [inputBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, getWidth(12.f), 0.f, -getWidth(12.f))];
    [inputBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, getWidth(22.f), 0.f, -getWidth(-22.f))];
    [inputBtn addTarget:self action:@selector(onClickInputBtn:) forControlEvents:UIControlEventTouchUpInside];
    [inputRow addSubview:inputBtn];
    [inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(inputRow);
        make.size.mas_equalTo(CGSizeMake(getWidth(345.f), getWidth(35.f)));
    }];
    
    UIButton *locateBtn = [[UIButton alloc] init];
    [locateBtn.titleLabel setFont:kFont_Medium(15.f)];
    [locateBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [locateBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locateBtn setTitle:@"点击定位当前位置" forState:UIControlStateNormal];
    [locateBtn setTitle:@"定位中..." forState:UIControlStateDisabled];
    [locateBtn setTitle:@"定位成功" forState:UIControlStateSelected];
    [locateBtn setTitle:@"定位成功" forState:UIControlStateSelected|UIControlStateHighlighted];
    [locateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 9.f, 0.f, -9.f)];
    [locateBtn setBackgroundColor:UIColor.whiteColor];
    [locateBtn addTarget:self action:@selector(onClickLocateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locateBtn];
    [locateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(inputRow.mas_bottom).with.offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(45.f));
    }];
    
    UIView *historyRow = [[UIView alloc] init];
    [historyRow setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:historyRow];
    [historyRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(locateBtn.mas_bottom).with.offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(40.f));
    }];
    [self setupHistoryRow:historyRow];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(historyRow.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
    
    UITableView *historyTableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];;
    [historyTableView setDelegate:self];
    [historyTableView setDataSource:self];
    [historyTableView registerClass:UITableViewCell.class forCellReuseIdentifier:CELL_HISTORY];
    [historyTableView setBackgroundColor:UIColor.clearColor];
    [historyTableView setSeparatorColor:COLOR_GRAY_EEEEEE];
    [self.view addSubview:historyTableView];
    _historyTableView = historyTableView;
    [historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)setupHistoryRow:(UIView *)view {
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:[UIImage imageNamed:@"history"]];
    [view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(getWidth(15.f));
        make.centerY.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kFont_Medium(13.f)];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"历史地址"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).with.offset(6.f);
        make.centerY.equalTo(view);
    }];
    
    UIButton *clearBtn = [[UIButton alloc] init];
    [clearBtn.titleLabel setFont:kFont_Medium(13.f)];
    [clearBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(onClickClearBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.top.and.bottom.equalTo(view);
        make.width.mas_equalTo(getWidth(58.f));
    }];
}

- (void)setupSearchInputView {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[COLOR_BLACK_090103 colorWithAlphaComponent:0.5f]];
    [self.view addSubview:view];
    _searchInputView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_navigationBarHeight);
        make.left.and.width.and.bottom.equalTo(self.view);
    }];
    
    UIView *inputRow = [[UIView alloc] init];
    [inputRow setBackgroundColor:UIColor.whiteColor];
    [view addSubview:inputRow];
    [inputRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(view);
        make.height.mas_equalTo(getWidth(65.f));
    }];
    
    UIView *inputRectView = [[UIView alloc] init];
    [inputRectView setBackgroundColor:[COLOR_GRAY_DDDDDD colorWithAlphaComponent:0.35f]];
    [inputRectView.layer setCornerRadius:4.f];
    [inputRow addSubview:inputRectView];
    [inputRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputRow);
        make.left.equalTo(inputRow).with.offset(getWidth(15.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(305.f), getWidth(35.f)));
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:[UIImage imageNamed:@"search"]];
    [inputRectView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputRectView);
        make.left.equalTo(inputRectView).with.offset(getWidth(12.f));
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    [textField setTextColor:COLOR_BLACK_333333];
    [textField setFont:kFont_Medium(15.f)];
    NSString *text = @"输入关键字进行搜索";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:text];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:COLOR_GRAY_999999
                        range:NSMakeRange(0, text.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:FONT_MEDIUM size:15.f]
                        range:NSMakeRange(0, text.length)];
    [textField setAttributedPlaceholder:placeholder];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setDelegate:self];
    [inputRectView addSubview:textField];
    _textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).with.offset(getWidth(10.f));
        make.right.equalTo(inputRectView).with.offset(-getWidth(10.f));
        make.centerY.equalTo(inputRectView);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn.titleLabel setFont:kFont_Medium(15.f)];
    [cancelBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [inputRow addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputRectView.mas_right);
        make.right.equalTo(inputRow);
        make.top.and.bottom.equalTo(inputRectView);
    }];
    
    UITableView *searchTableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    [searchTableView setBackgroundColor:COLOR_GRAY_FAF9FE];
    [searchTableView setSeparatorColor:COLOR_GRAY_EEEEEE];
    [searchTableView setDelegate:self];
    [searchTableView setDataSource:self];
    [searchTableView registerClass:HPSearchPOICell.class forCellReuseIdentifier:CELL_POI];
    [view addSubview:searchTableView];
    _searchTableView = searchTableView;
    [searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputRow.mas_bottom);
        make.left.and.width.equalTo(view);
        make.bottom.equalTo(view);
    }];
    [searchTableView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:@"UITextFieldTextDidChangeNotification" object:textField];
}

#pragma mark - LocationManager

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:YES];
}

- (void)onClickLocateBtn:(UIButton *)btn {
    [btn setEnabled:NO];
    [btn setSelected:NO];
    
    //开始定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (!error) {
            NSLog(@"lat: %lf, lon: %lf", location.coordinate.latitude, location.coordinate.longitude);
            NSLog(@"Address: %@", regeocode.formattedAddress);
            [btn setEnabled:YES];
            [btn setSelected:YES];
            
            HPAddressModel *addressModel = [[HPAddressModel alloc] init];
            [addressModel setLat:location.coordinate.latitude];
            [addressModel setLon:location.coordinate.longitude];
            [addressModel setData:regeocode];
            
            if (self.textDialogView == nil) {
                HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
                self.textDialogView = textDialogView;
            }
            
            NSString *text = [NSString stringWithFormat:@"定位到 “%@”，确定使用？", regeocode.formattedAddress];
            [self.textDialogView setText:text];
            kWeakSelf(weakSelf);
            [self.textDialogView setConfirmCallback:^{
                [HPLocateHistory addHistory:addressModel];
                [weakSelf popWithParam:@{@"address":addressModel}];
            }];
            [self.textDialogView show:YES];
        }
        else {
            [btn setEnabled:YES];
            [HPProgressHUD alertMessage:@"定位失败"];
            NSLog(@"error: %@", error);
        }
    }];
}

#pragma mark - AMapSearchAPI

- (void)configSearchAPI {
    self.searchAPI = [[AMapSearchAPI alloc] init];
    [self.searchAPI setDelegate:self];
}

- (void)seachPOIs {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords = _textField.text;
    request.city = @"深圳";
    request.cityLimit = YES;
    
    [_searchAPI AMapPOIKeywordsSearch:request];
}

#pragma mark - AMapSearchDelegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (_searchTableView.isHidden) {
        [_searchTableView setHidden:NO];
    }
    
    [_searchPOIs removeAllObjects];
    
    for (AMapPOI *poi in response.pois) {
        HPAddressModel *addressModel = [[HPAddressModel alloc] init];
        [addressModel setData:poi];
        [addressModel setPOIName:poi.name];
        [addressModel setFormattedAddress:poi.address];
        [addressModel setLat:poi.location.latitude];
        [addressModel setLon:poi.location.longitude];
        [_searchPOIs addObject:addressModel];
    }
    
    [_searchTableView reloadData];
}

//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
//    NSLog(@"乡镇街道: %@", response.regeocode.addressComponent.township);
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _historyTableView) {
        HPAddressModel *addressModel = _locateHistory[indexPath.row];
        [self popWithParam:@{@"address":addressModel}];
//        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
//        AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:addressModel.lat longitude:addressModel.lon];
//        [request setLocation:point];
//        [self.searchAPI AMapReGoecodeSearch:request];
    }
    else if (tableView == _searchTableView) {
        HPAddressModel *addressModel = _searchPOIs[indexPath.row];
        [HPLocateHistory addHistory:addressModel];
        [self popWithParam:@{@"address":addressModel}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _historyTableView) {
        return getWidth(40.f);
    }
    else
        return getWidth(50.f);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _historyTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_HISTORY forIndexPath:indexPath];
        [cell.textLabel setFont:kFont_Medium(13.f)];
        [cell.textLabel setTextColor:COLOR_BLACK_333333];
        HPAddressModel *model = _locateHistory[indexPath.row];
        NSString *text = model.POIName;
        [cell.textLabel setText:text];
        return cell;
    }
    else {
        HPSearchPOICell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_POI forIndexPath:indexPath];
        HPAddressModel *model = _searchPOIs[indexPath.row];
        [cell setName:model.POIName];
        [cell setAddress:model.formattedAddress];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _historyTableView) {
        return _locateHistory.count;
    }
    else
        return _searchPOIs.count;
}

#pragma mark - NSNotification

- (void)textFieldDidChange:(NSNotification *)notification {
    [self seachPOIs];
}

#pragma mark - OnClick

- (void)onClickClearBtn:(UIButton *)btn {
    [HPLocateHistory deleteHistory];
    _locateHistory = @[];
    [_historyTableView reloadData];
}

- (void)onClickInputBtn:(UIButton *)btn {
    if (_searchInputView == nil) {
        [self setupSearchInputView];
    }
    
    [_searchInputView setHidden:NO];
    [_textField becomeFirstResponder];
}

- (void)onClickCancelBtn:(UIButton *)btn {
    [_textField endEditing:YES];
    [_textField setText:@""];
    [_searchInputView setHidden:YES];
    [_searchPOIs removeAllObjects];
    [_searchTableView reloadData];
    [_searchTableView setHidden:YES];
}

@end
