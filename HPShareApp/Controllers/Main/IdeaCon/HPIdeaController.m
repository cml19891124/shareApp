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
    
    _navTitleView = [self setupNavigationBarWithTitle:@"享法"];
    [self.view addSubview:self.tableView];
    
//    UIControl *howToPlayShareSpace = [[UIControl alloc] init];
//    [howToPlayShareSpace.layer setCornerRadius:6.5f];
//    [howToPlayShareSpace.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
//    [howToPlayShareSpace.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
//    [howToPlayShareSpace.layer setShadowRadius:11.f];
//    [howToPlayShareSpace.layer setShadowOpacity:1.f];
//    [howToPlayShareSpace setBackgroundColor:UIColor.whiteColor];
//    [howToPlayShareSpace setTag:1];
//    [howToPlayShareSpace addTarget:self action:@selector(onClickShareSpaceCtrl:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:howToPlayShareSpace];
//    [howToPlayShareSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(whatIsShareSpace.mas_bottom).with.offset(15.f * g_rateWidth);
//        make.centerX.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 150.f * g_rateWidth));
//    }];
//    [self setupHowToPlayShareSpace:howToPlayShareSpace];
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

/*
- (void)setupHowToPlayShareSpace:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"共享空间怎么玩?" ofView:view];
    UIImageView *iconView = [self setupIcon:[UIImage imageNamed:@"idea_how_to_play_share_space"] ofView:view];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    [questionLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [questionLabel setTextColor:COLOR_BLACK_4A4A4B];
    [questionLabel setText:@"概念太抽象？"];
    [view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(questionLabel.font.pointSize);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [answerLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [answerLabel setTextColor:COLOR_RED_FF4562];
    [answerLabel setText:@"莫慌 !!!"];
    [view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(questionLabel.mas_right).with.offset(5.f * g_rateWidth);
        make.centerY.equalTo(questionLabel);
        make.height.mas_equalTo(answerLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setNumberOfLines:0];
    [descLabel setText:@"不怕你不会玩，就怕你玩不过来！我们一起“享”未来！"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(iconView.mas_left).with.offset(11.f * g_rateWidth);
        make.top.equalTo(questionLabel.mas_bottom).with.offset(15.f * g_rateWidth);
    }];
}*/

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
//    HPLoginModel *account = [HPUserTool account];
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
