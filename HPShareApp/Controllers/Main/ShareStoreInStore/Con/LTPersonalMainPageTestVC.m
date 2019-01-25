//
//  LTPageViewTestOneVC.m
//  OCExample
//
//  LTPageViewTestOneVC.m
//  OCExample
//
//  Created by 高刘通 on 2018/4/19.
//  Copyright © 2018年 LT. All rights reserved.
//
//  如有疑问，欢迎联系本人QQ: 1282990794
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

#import "LTPersonalMainPageTestVC.h"
#import "LTScrollView-Swift.h"
#import "HPShareListCell.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "HPShareListParam.h"


#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)

@interface LTPersonalMainPageTestVC () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@end

@implementation LTPersonalMainPageTestVC
static NSString *shareListCell = @"shareListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataArray = [NSMutableArray array];

    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
//    if (self.totalCount == 0) {
//        self.totalCount = 20;
//    }
    
#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    _dataArray = [NSMutableArray array];
    
    _shareListParam = [HPShareListParam new];
    _shareListParam.pageSize = 10;
    _shareListParam.page = 1;
    _shareListParam.createTimeOrderType = @"0";
    
    _shareListParam.areaIds = [NSString stringWithFormat:@"9,7,1"]; //宝安，龙华，南山
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getShareListDataReload:NO];
    }];
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
//    [self setupRefreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    if (self.isPop) {
        self.isPop = NO;
    }
    else {
        [self getShareListDataReload:YES];
    }
}
- (void)setupRefreshData {
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.totalCount += 10;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.totalCount = 20;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.totalCount;
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:shareListCell];
        HPShareListModel *model = _dataArray[indexPath.row];
        cell.model = model;
    cell.backgroundColor = UIColor.whiteColor;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HPLog(@"第 %ld 行", indexPath.row + 1);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 137.0f;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
        //这个44为导航高度
        CGFloat Y = statusBarH + 44;
        //这个44为切换条的高度
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y - 44;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;

        [_tableView registerClass:HPShareListCell.class forCellReuseIdentifier:shareListCell];
    }
    return _tableView;
}

#pragma mark - network - 共享发布数据

- (void)getShareListDataReload:(BOOL)isReload {
    
    if (isReload) {
        _shareListParam.page = 1;
    }
    
    NSMutableDictionary *param = _shareListParam.mj_keyValues;
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:NO paraments:param complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (models) {
                if (isReload) {
                    [weakSelf.dataArray removeAllObjects];
                }
                
                [weakSelf.dataArray addObjectsFromArray:models];
            }
            
            if ([responseObject[@"data"][@"total"] integerValue] == 0 || weakSelf.dataArray.count == 0) {
                
            }
            
            if (models.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [weakSelf.tableView.mj_footer endRefreshing];
                weakSelf.shareListParam.page ++;
            }
            
            [weakSelf.tableView reloadData];
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
        
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
@end
