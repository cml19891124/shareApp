//
//  LTPersonMainPageDemo.m
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

#import "LTPersonMainPageDemo.h"
#import "LTPersonalMainPageTestVC.h"
#import "MJRefresh.h"
#import "LTScrollView-Swift.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "HPShareListParam.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0)
#define HeaderHeight getWidth(110.f)
#define NavHeight ([UIApplication sharedApplication].statusBarFrame.size.height + 44)

@interface LTPersonMainPageDemo () <LTSimpleScrollViewDelegate>

@property(copy, nonatomic) NSArray <UIViewController *> *viewControllers;
@property(copy, nonatomic) NSArray <NSString *> *titles;
@property(strong, nonatomic) LTLayout *layout;
@property(strong, nonatomic) LTSimpleManager *managerView;
@property(strong, nonatomic) UIView *headerView;
@property(strong, nonatomic) UIImageView *headerImageView;
@property(assign, nonatomic) CGFloat currentProgress;
@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, strong) LTPersonalMainPageTestVC *testVC;

@property (nonatomic, strong) NSMutableArray *testVCs;
@end

@implementation LTPersonMainPageDemo

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = self.currentProgress;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0f]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _testVCs = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //默认三个区域
//    _shareListParam.areaIds = [NSString stringWithFormat:@"9,7,1"]; //宝安，龙华，南山

    _shareListParam = self.param[@"area"];
    
    self.testVC.shareListParam = self.shareListParam;
//    [self.testVC getShareListDataReload:YES];
    
    [self setupNavigationBarWithTitle:@"热门店铺推荐"];
    [self setupSubViews];
}


-(void)setupSubViews {
    
    [self.view addSubview:self.managerView];
    
    kWEAKSELF
    
    //配置headerView
    [self.managerView configHeaderView:^UIView * _Nullable{
        [weakSelf.headerView addSubview:weakSelf.headerImageView];
        return weakSelf.headerView;
    }];
    
    if ([_shareListParam.areaIds isEqualToString:@"9"]) {
        [self.managerView scrollToIndexWithIndex:0]; //宝安
    }else if ([_shareListParam.areaIds isEqualToString:@"7"]){
        [self.managerView scrollToIndexWithIndex:1];//龙华区
    }else if ([_shareListParam.areaIds isEqualToString:@"1"]){
        [self.managerView scrollToIndexWithIndex:2]; //南山区
    }else if ([_shareListParam.areaIds isEqualToString:@"9,7,1"]){
        [self.managerView scrollToIndexWithIndex:0]; //宝安\龙华区\南山区
    }
    self.testVC.shareListParam = self.shareListParam;

    //pageView点击事件
    [self.managerView didSelectIndexHandle:^(NSInteger index) {
        HPLog(@"点击了 -> %ld", index);
        if (index == 0) {
            weakSelf.shareListParam.areaIds = [NSString stringWithFormat:@"9"]; //宝安
        }else if (index == 1){
            weakSelf.shareListParam.areaIds = [NSString stringWithFormat:@"7"]; //龙华
        }else if (index == 2){
            weakSelf.shareListParam.areaIds = [NSString stringWithFormat:@"1"]; //南山
        }
        weakSelf.testVC = weakSelf.testVCs[index];
        weakSelf.testVC.shareListParam = weakSelf.shareListParam;
        [weakSelf.testVC getAreaShareListDataReload:NO];
        [weakSelf.testVC.tableView reloadData];
    }];
    
    //控制器刷新事件
//    [self.managerView refreshTableViewHandle:^(UIScrollView * _Nonnull scrollView, NSInteger index) {
//        __weak typeof(scrollView) weakScrollView = scrollView;
//        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            __strong typeof(weakScrollView) strongScrollView = weakScrollView;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                HPLog(@"对应控制器的刷新自己玩吧，这里就不做处理了🙂-----%ld", index);
//                [strongScrollView.mj_header endRefreshing];
//            });
//        }];
//    }];
    
}


-(void)tapGesture:(UITapGestureRecognizer *)gesture {
    HPLog(@"tapGesture");
}

-(void)glt_scrollViewDidScroll:(UIScrollView *)scrollView {
    HPLog(@"---> %lf", scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat headerImageY = offsetY;
    CGFloat headerImageH = HeaderHeight - offsetY;
    if (offsetY <= 0.0) {
        self.navigationController.navigationBar.alpha = 0.0;
        self.currentProgress = 0.0;
    }else {
        headerImageY = 0;
        headerImageH = HeaderHeight;
        
        CGFloat adjustHeight = HeaderHeight - NavHeight;
        
        CGFloat progress = 1 - (offsetY / adjustHeight);
        self.navigationController.navigationBar.barStyle = progress > 0.5 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
        
        self.navigationController.navigationBar.alpha = 1 - progress;
        self.currentProgress = 1 - progress;
    }
    CGRect headerImageFrame = self.headerImageView.frame;
    headerImageFrame.origin.y = headerImageY;
    headerImageFrame.size.height = headerImageH;
    self.headerImageView.frame = headerImageFrame;
}

-(LTSimpleManager *)managerView {
    if (!_managerView) {
        CGFloat Y = 0.0;
        CGFloat H = kIPhoneX ? (self.view.bounds.size.height - Y - 34) : self.view.bounds.size.height - Y;
        _managerView = [[LTSimpleManager alloc] initWithFrame:CGRectMake(0, g_statusBarHeight + 44.f, self.view.bounds.size.width, H) viewControllers:self.viewControllers titles:self.titles currentViewController:self layout:self.layout];
        
        /* 设置代理 监听滚动 */
        _managerView.delegate = self;
        
        /* 设置悬停位置 */
        _managerView.hoverY = 0;//NavHeight;
        
    }
    return _managerView;
}

-(UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width, HeaderHeight)];
        _headerImageView.image = [UIImage imageNamed:@"hot_shop_background"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        _headerImageView.userInteractionEnabled = YES;
        [_headerImageView addGestureRecognizer:gesture];
    }
    return _headerImageView;
}

-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, HeaderHeight)];
    }
    return _headerView;
}

-(LTLayout *)layout {
    if (!_layout) {
        _layout = [[LTLayout alloc] init];
    }
    return _layout;
}


- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"宝安区", @"龙华区", @"南山区"];
    }
    return _titles;
}


-(NSArray <UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [self setupViewControllers];
    }
    return _viewControllers;
}


-(NSArray <UIViewController *> *)setupViewControllers {
    kWEAKSELF
    NSMutableArray <UIViewController *> *testVCS = [NSMutableArray arrayWithCapacity:0];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LTPersonalMainPageTestVC *testVC = [[LTPersonalMainPageTestVC alloc] init];
        weakSelf.testVCs = testVCS;
        [weakSelf.testVCs addObject:testVC];
//        weakSelf.testVC = testVC;
//        testVC.shareListParam = weakSelf.shareListParam;
        [testVCS addObject:testVC];
    }];
    return testVCS.copy;
}

-(void)dealloc {
    HPLog(@"%s",__func__);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //侧滑出现的透明细节调整
    self.navigationController.navigationBar.alpha = self.currentProgress;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.alpha = 0;
}

@end

