//
//  HPSearchResultViewController.m
//  HPShareApp
//
//  Created by HP on 2019/2/19.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSearchViewController.h"
#import "AJSearchBar.h"
#import "Masonry.h"
#import "HPGlobalVariable.h"
#import "HPHistoryViewCell.h"
#import "HPHotKeywordCell.h"
#import "HPSearchHeaderView.h"
#import "HPKeywordsModel.h"

@interface HPSearchViewController ()<UITableViewDelegate,UITableViewDataSource,SearchDelegate,UITextFieldDelegate>


@property (nonatomic, strong) AJSearchBar *searchBar;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HPSearchHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray<NSString *> *hotSearchArray;

@end

@implementation HPSearchViewController

static NSString *defaultCell = @"defaultCell";
static NSString *historyViewCell = @"historyViewCell";
static NSString *hotKeywordCell = @"hotKeywordCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;

    [self setUpUi];
    [self setUpUiMasonry];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (_searchBar.historyArray) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
    self.hotSearchArray = [NSMutableArray array];
    [self getHotKeywordsData];
}


- (void)getHotKeywordsData
{
    [HPHTTPSever HPGETServerWithMethod:@"/v1/hotWord/queryHotWordList" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *hotSearchArray = [HPKeywordsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for (HPKeywordsModel *hotModel in hotSearchArray) {
                [self.hotSearchArray addObject:hotModel.keyword];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
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
        make.top.mas_equalTo(g_statusBarHeight);
        make.height.mas_equalTo(getWidth(39.f));
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

- (HPSearchHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [HPSearchHeaderView new];
        _headerView.backgroundColor = COLOR_GRAY_F7F7F7;
        
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_GRAY_EBEBEB;
        [_tableView registerClass:HPHistoryViewCell.class forCellReuseIdentifier:historyViewCell];
        [_tableView registerClass:HPHotKeywordCell.class forCellReuseIdentifier:hotKeywordCell];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)clickPopToHomeVC
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchWithStr:(NSString *)text
{
    HPLog(@"搜索的是。。。。。。");
    [self pushVCByClassName:@"HPShareShopListController" withParam:@{@"text":text}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1.f;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView = [[HPSearchHeaderView alloc] initWithFrame:kRect(0, 0, kScreenWidth, getWidth(38.f))];
    _headerView.backgroundColor = COLOR_GRAY_FFFFFF;
    kWEAKSELF
    _headerView.block = ^{//删除历史
        [weakSelf.searchBar clear];
        [weakSelf.tableView reloadData];
    };
    
    if (section == 0) {
        self.headerView.leftImage.hidden = NO;
        self.headerView.headerLab.text = @"热门搜索";
        self.headerView.deleteBtn.hidden = YES;

        return _headerView;
    }else{
        self.headerView.headerLab.text = @"历史记录";
        self.headerView.leftImage.hidden = YES;
        self.headerView.deleteBtn.hidden = NO;
        self.headerView.hidden = YES;
        return _headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return CGFLOAT_MIN;
    }else{
        return 8.f;
    }
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
        return [HPHotKeywordCell hotCellHeightWithData:self.hotSearchArray];
    }else{
        return [HPHistoryViewCell historyCellHeightWithData:self.searchBar.historyArray];
    }
    return getWidth(40.f);

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    switch (indexPath.section) {
        case 0:
            return [self setUpHotSearchCell:tableView];
            break;
        case 1:
            return [self setUpHistoryCell:tableView];
            break;
        default:
            break;
    }
    return cell;
}
    
- (HPHotKeywordCell *)setUpHotSearchCell:(UITableView *)tableView
{
    HPHotKeywordCell *cell = [tableView dequeueReusableCellWithIdentifier:hotKeywordCell];
    [cell setHotViewWithArray:self.hotSearchArray];
    kWEAKSELF
    cell.hotSearchBlock = ^(NSString *keyword) {
        [weakSelf pushVCByClassName:@"HPShareShopListController" withParam:@{@"text":keyword}];
    };
    return cell;
}
    
- (HPHistoryViewCell *)setUpHistoryCell:(UITableView *)tableView
{
    HPHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyViewCell];
    if (_searchBar.historyArray.count || _searchBar.historyArray) {
        [cell setHistroyViewWithArray:_searchBar.historyArray];
    }
    kWEAKSELF
    cell.keywordBlcok = ^(NSString *keyword) {
        [weakSelf pushVCByClassName:@"HPShareShopListController" withParam:@{@"text":keyword}];
        
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
