//
//  HPIdeaController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdeaController.h"
#import "HPHeaderCell.h"
#import "HPIdeaListCell.h"
#import "HPIdeaListModel.h"
#import "HPShareListParam.h"

@interface HPIdeaController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *navTitleView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation HPIdeaController

static NSString *ideaCell = @"ideaCell";
static NSString *ideaListCell = @"ideaListCell";

static NSString *headerCell = @"headerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shareListParam = [HPShareListParam new];
    _shareListParam.pageSize = 10;
    _shareListParam.page = 1;

    [self setupUI];
    [self setupUISubviewsMasonry];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isPop) {
        self.isPop = NO;
    }
    else {
    self.dataArray = [NSMutableArray array];

        //获取文章列表
        [self getRichList:YES];
    }

}

#pragma mark - 获取文章列表
- (void)getRichList:(BOOL)isReload
{
    
    if (isReload) {
        _shareListParam.page = 1;
    }
    
    NSMutableDictionary *param = _shareListParam.mj_keyValues;
    kWeakSelf(weakSelf);
    [HPHTTPSever HPGETServerWithMethod:@"/v1/rich/list" isNeedToken:YES paraments:param complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *models = [HPIdeaListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
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

- (void)setupUISubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(getWidth(281.f));
        make.top.mas_equalTo(self.navTitleView.mas_bottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
        make.bottom.mas_equalTo(getWidth(-49.f));
    }];
}

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_WHITE_FAF9FE];
    
    _navTitleView = [self setupNavigationBarWithTitle:@"拼法"];
    [self.view addSubview:self.tableView];

}

#pragma mark - 初始化控件

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.001];;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ideaCell];
        
        [_tableView registerClass:HPHeaderCell.class forCellReuseIdentifier:headerCell];

        [_tableView registerClass:HPIdeaListCell.class forCellReuseIdentifier:ideaListCell];
        
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

#pragma mark - OnClick

- (void)onClickShareSpaceCtrl:(UIControl *)ctrl {
    if (ctrl.tag == 0) {
        [self pushVCByClassName:@"HPWhatIsShareSpaceController"];
    }
    else if (ctrl.tag == 1) {
        [self pushVCByClassName:@"HPHowToPlayShareSpaceController"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _dataArray.count;
    }
    return 1.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideaCell];
    switch (indexPath.section) {
        case 0:
            return [self setUpHeaderCell:tableView];
            break;
        case 1:
            return [self setUpIdeaListCell:tableView withIndexPath:indexPath];
            
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - 享法头部专区
- (HPHeaderCell *)setUpHeaderCell:(UITableView *)tableView
{
    HPHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell setHeaderClickBlock:^(NSInteger ideaIndex) {
        if (ideaIndex == 0) {
            [self pushVCByClassName:@"HPWhatIsShareSpaceController"];
        }
    }];
    return cell;
}

#pragma mark - 合店专区
- (HPIdeaListCell *)setUpIdeaListCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    HPIdeaListCell *cell = [tableView dequeueReusableCellWithIdentifier:ideaListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HPIdeaListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return getWidth(329.f);
            break;
        case 1:
            return getWidth(113.f);
            break;
        
        default:
            return CGFLOAT_MIN;
            break;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HPIdeaListModel *model = self.dataArray[indexPath.row];
    if (indexPath.section == 1) {
        HPIdeaListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {

            [self pushVCByClassName:@"HPIdeaDetailViewController" withParam:@{@"model":model?:@1}];
        }
    }
}


#pragma mark - 取消下拉  允许上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.tableView.contentOffset = offset;
}
@end
