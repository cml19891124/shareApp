//
//  HPSystemNotiController.m
//  HPShareApp
//
//  Created by HP on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSystemNotiController.h"
#import "HPSystemNotiCell.h"
#import "HPSystemNotiModel.h"

@interface HPSystemNotiController ()<UITableViewDelegate,UITableViewDataSource,HPSystemNotiCellDelegate,HPBaseViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *systemNotiArray;
@end

@implementation HPSystemNotiController
static NSString *systemNotiCell = @"systemNotiCell";
- (void)clickRightButtonToHandle
{
    HPLog(@"delegate");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setupUI];
    [self setupNavigationBarWithTitle:@"系统通知"];
    [self setupRightBarbuttonBtn:@"一键已读"];
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    NSArray *systemNotiArray = @[@{@"createTime":@"1495453213",@"title":@"版本更新",@"message":@"合店站1.1.0版本更新。新版本中'人力共享'功能正式上线，店主可以通过该板块招募短工，降低招募正式员工的人力成本。同时用户也可以发…"},
                               @{@"createTime":@"1495453229",@"title":@"注册成功",@"message":@"尊敬的用户，恭喜您成为“合店站”会员，赶紧去制作你的专属名片，开启共享之旅吧!"}];
    _systemNotiArray = [HPSystemNotiModel mj_objectArrayWithKeyValuesArray:systemNotiArray];
    [_tableView reloadData];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView setBackgroundColor:COLOR_GRAY_FFFFFF];
    [tableView setSeparatorColor:COLOR_GRAY_F7F7F7];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    
    [tableView registerClass:HPSystemNotiCell.class forCellReuseIdentifier:systemNotiCell];
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
    return _systemNotiArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPSystemNotiModel *model = _systemNotiArray[indexPath.row];
    HPSystemNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:systemNotiCell];
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
    return getWidth(195.f);
}

#pragma mark - HPSystemNotiCellDelegate
- (void)clickToCheckMoreNoti:(HPSystemNotiModel *)model
{
    HPLog(@"HPSystemNotiModel");
}
@end
