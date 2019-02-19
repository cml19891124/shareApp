//
//  HPSearchResultViewController.m
//  HPShareApp
//
//  Created by HP on 2019/2/19.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSearchResultViewController.h"
#import "AJSearchBar.h"
#import "Masonry.h"
#import "HPGlobalVariable.h"
#import "HPHistoryViewCell.h"
#import "SearchCollectionView.h"
#import "SearchFlowLayout.h"

@interface HPSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,historyDelegate,SearchDelegate>

@property (nonatomic, strong) AJSearchBar *searchBar;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyArray;

@property (nonatomic, strong) SearchCollectionView *collectionView;
/*! 布局 */
@property(nonatomic,strong) SearchFlowLayout *searchFlowLayout;
@end

@implementation HPSearchResultViewController

static NSString *historyViewCell = @"historyViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    _historyArray = [NSMutableArray array];
    [self setUpUi];
    [self setUpUiMasonry];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setUpUi
{
    [self.view addSubview:self.searchBar];
    
    self.searchBar.SearchDelegate = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setUpUiMasonry
{
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(getWidth(25.f));
        make.height.mas_equalTo(getWidth(32.f));
        make.right.mas_equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(getWidth(7.f));
    }];
}

#pragma mark - 初始化控件
- (AJSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [AJSearchBar new];
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_GRAY_EBEBEB;
        [_tableView registerClass:HPHistoryViewCell.class forCellReuseIdentifier:historyViewCell];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (SearchCollectionView *)collectionView{
    if (!_collectionView) {
//        row = [_searchVM rowForCollection:[_searchVM readHistory]];
//        HPLog(@"row = %li",(long)row);
        NSArray *array = @[@"动画风格",@"发广告",@"风格"];
        _searchFlowLayout = [[SearchFlowLayout alloc]init];
        _collectionView = [[SearchCollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (5 * 45)+64) collectionViewLayout:_searchFlowLayout array:[array mutableCopy]];
        _collectionView.historyDelegate = self;
    }
    return _collectionView;
}

- (void)clickPopToHomeVC
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchWithStr:(NSString *)text
{
    HPLog(@"搜索的是。。。。。。");
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1.f;
    }else{
        return 5.f;//self.historyArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerV = [[UIView alloc] initWithFrame:kRect(0, 0, kScreenWidth, getWidth(8.f))];
    headerV.backgroundColor = COLOR_GRAY_EEEEEE;
    if (section == 1) {
        return nil;
    }else{
        return headerV;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return getWidth(240.f);
    }else{
        return getWidth(40.f);
    }
    return getWidth(40.f);

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyViewCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
