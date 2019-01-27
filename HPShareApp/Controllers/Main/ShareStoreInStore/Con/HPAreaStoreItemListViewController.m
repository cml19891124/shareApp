
//  如有疑问，欢迎联系本人QQ: 1282990794
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

#import "HPAreaStoreItemListViewController.h"
#import "LTScrollView-Swift.h"
#import "HPShareListCell.h"
#import "Macro.h"
#import "HPGlobalVariable.h"

@interface HPAreaStoreItemListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HPAreaStoreItemListViewController
static NSString *shareListCell = @"shareListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];

    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];

#warning 重要 必须赋值
    self.glt_scrollView = self.tableView;
    _dataArray = [NSMutableArray array];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getAreaShareListDataReload:NO];
    }];
    
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }

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
        [self getAreaShareListDataReload:YES];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    HPShareListModel *model = _dataArray[indexPath.row];

        HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [self pushVCByClassName:@"HPShareDetailController" withParam:@{@"model":model}];
        }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 137.0f;
}

- (UITableView *)tableView {
    if (!_tableView) {
        //这个44为导航高度
        CGFloat Y = g_statusBarHeight + 44;
        //这个44为切换条的高度
        CGFloat H = IPHONE_HAS_NOTCH ? (self.view.bounds.size.height - Y - g_bottomSafeAreaHeight) : self.view.bounds.size.height - Y - 44;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44,kScreenWidth, H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;

        [_tableView registerClass:HPShareListCell.class forCellReuseIdentifier:shareListCell];
    }
    return _tableView;
}

#pragma mark - network - 共享发布数据

- (void)getAreaShareListDataReload:(BOOL)isReload {
    
    if (isReload) {
        _shareListParam.page = 1;
    }
    [HPProgressHUD alertWithLoadingText:@"加载数据中..."];
    NSMutableDictionary *param = _shareListParam.mj_keyValues;
    kWEAKSELF
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/list" isNeedToken:NO paraments:param complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [weakSelf.dataArray removeAllObjects];

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
            [HPProgressHUD alertWithFinishText:@"加载完成"];
        }
        else {
            [HPProgressHUD alertMessage:MSG];
        }
        
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
@end
