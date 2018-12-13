//
//  HPPartyCenterController.m
//  HPShareApp
//
//  Created by caominglei on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPartyCenterController.h"
#import "HPPartyCenterModel.h"
#import "HPPartyCenterCell.h"

@interface HPPartyCenterController ()<UITableViewDelegate,UITableViewDataSource,HPBaseViewControllerDelegate,HPPartyCenterCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *partyArray;
@end

@implementation HPPartyCenterController
static NSString *partyCenterCell = @"partyCenterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setupUI];
    [self setupNavigationBarWithTitle:@"系统通知"];
    [self setupRightBarbuttonBtn:@"一键已读"];
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    NSArray *partyArray = @[@{@"createTime":@"1495453213",@"image":@"party",@"title":@"锦鲤附身，您有1份新用户大礼包待领取",@"message":@"为了感谢广大用户对“合店站”的支持与信任，我们给每一位新入驻“合店站”的小伙伴精心准备了一份大礼包～戳我领取"},
                                 @{@"createTime":@"1495453229",@"image":@"party",@"title":@"锦鲤附身，您有1份新",@"message":@"对“合店站”的支持与信任，我们给每一位新入驻“合店站”的小伙伴精心准备了一份"}];
    _partyArray = [HPPartyCenterModel mj_objectArrayWithKeyValuesArray:partyArray];
    [_tableView reloadData];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView setBackgroundColor:COLOR_GRAY_FFFFFF];
    [tableView setSeparatorColor:COLOR_GRAY_F7F7F7];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.scrollEnabled = NO;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    [tableView registerClass:HPPartyCenterCell.class forCellReuseIdentifier:partyCenterCell];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.mas_equalTo(g_navigationBarHeight);
        make.bottom.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _partyArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPPartyCenterModel *model = _partyArray[indexPath.row];
    HPPartyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:partyCenterCell];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(335.f);
}

#pragma mark - HPSystemNotiCellDelegate
- (void)clickTocheckMoreInfo:(HPPartyCenterModel *)model
{
    HPLog(@"HPPartyCenterModel");
}

- (void)clickRightButtonToHandle
{
    HPLog(@"clickRightButtonToHandle");
}
@end
