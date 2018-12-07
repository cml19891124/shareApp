//
//  HPInteractiveController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPInteractiveController.h"
#import "HPInteractiveCell.h"
#import "HPInterActiveModel.h"

@interface HPInteractiveController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *interArray;
@end

@implementation HPInteractiveController
static NSString *interactiveCell = @"interactiveCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSArray *interArray = @[@{@"photo":@"system notification",@"title":@"系统通知",@"subtitle":@"注册成功，欢迎进入“合店站”"},@{@"photo":@"activity center",@"title":@"活动中心",@"subtitle":@"锦鲤附身，您有1份新用户大礼包待领取"}];
    [self setupUI];
    _interArray = [HPInterActiveModel mj_objectArrayWithKeyValuesArray:interArray];
    [_tableView reloadData];
    [self setupNavigationBarWithTitle:@"互动"];
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];

}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:COLOR_GRAY_F7F7F7];
    [tableView setSeparatorColor:COLOR_GRAY_F7F7F7];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.scrollEnabled = NO;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];

    [tableView registerClass:HPInteractiveCell.class forCellReuseIdentifier:interactiveCell];
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
    return _interArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_interArray count];
    }else if (section == 1) {
        return 1.f;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPInterActiveModel *model = _interArray[indexPath.row];
    HPInteractiveCell *cell = [tableView dequeueReusableCellWithIdentifier:interactiveCell];
    if (indexPath.section == 0) {
        
        cell.model = model;
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        [cell.contentView removeFromSuperview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImage *image = ImageNamed(@"waiting");
        UIImageView *waitingView = [[UIImageView alloc] init];
        waitingView.image = image;
        [cell addSubview:waitingView];
        [waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(72.f * g_rateWidth);
            make.size.mas_equalTo(CGSizeMake(343.f * g_rateWidth, 197.f * g_rateWidth));
            make.centerX.mas_equalTo(cell);
        }];
        
        UILabel *waitingLabel = [[UILabel alloc] init];
        waitingLabel.text = @"在线互动即将开启，敬情期待 ~";
        waitingLabel.font = [UIFont fontWithName:FONT_MEDIUM size:12];
        waitingLabel.textColor = COLOR_GRAY_BBBBBB;
        waitingLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:waitingLabel];
        [waitingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell);
            make.top.mas_equalTo(waitingView.mas_top).offset(158.f * g_rateWidth);
            make.width.mas_equalTo(kScreenWidth);
        }];
    }

    return cell;
}

- (void)viewLayoutMarginsDidChange
{
    [super viewLayoutMarginsDidChange];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone5) {
        if (indexPath.section == 1) {
            return kScreenHeight - g_navigationBarHeight - g_tabBarHeight - 20.f * g_rateWidth - 120.f * g_rateWidth;
        }else{
            return 60.f;
        }
    }else{
        if (indexPath.section == 1) {
            return kScreenHeight - g_navigationBarHeight - g_tabBarHeight - 20.f * g_rateWidth - 150.f;
        }else{
            return 75.f * g_rateWidth;
        }
    }
    return 75.f * g_rateWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    footerV.backgroundColor = COLOR_GRAY_F7F7F7;
    return footerV;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.f * g_rateHeight)];
    headerV.backgroundColor = COLOR_GRAY_F7F7F7;
    return headerV;
}
@end
