//
//  HPFollowController.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPFollowController.h"
#import "HPFollowListCell.h"
#import "HPTextDialogView.h"

#define CELL_ID @"HPFollowListCell"

@interface HPFollowController () <UITableViewDelegate, UITableViewDataSource, HPFollowListCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HPFollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *dataArray = @[@{@"userName":@"刘晓玉", @"company":@"深圳市斯蒂格环保设备有限公司", @"portrait":[UIImage imageNamed:@"shared_shop_details_head_portrait"]},
                           @{@"userName":@"董晓丽", @"company":@"深圳市瑞鹏宠物医疗集团股份有限公司xxxxxxxxxxx", @"portrait":[UIImage imageNamed:@"personal_center_login_head"]},
                           @{@"userName":@"周XX", @"company":@"深圳市前海合派科技有限公司", @"portrait":[UIImage imageNamed:@"customizing_business_cards_entrepreneur's_head_portrait"]},
                           @{@"userName":@"王彤彤", @"company":@"广州区势时代品牌咨询管理有限...", @"portrait":[UIImage imageNamed:@"customizing_business_cards_owner's_head_portrait"]},
                           @{@"userName":@"刘晓玉", @"company":@"深圳市斯蒂格环保设备有限公司", @"portrait":[UIImage imageNamed:@"shared_shop_details_head_portrait"]},
                           @{@"userName":@"董晓丽", @"company":@"深圳市瑞鹏宠物医疗集团股份有...", @"portrait":[UIImage imageNamed:@"personal_center_login_head"]},
                           @{@"userName":@"周XX", @"company":@"深圳市前海合派科技有限公司", @"portrait":[UIImage imageNamed:@"customizing_business_cards_entrepreneur's_head_portrait"]},
                           @{@"userName":@"王彤彤", @"company":@"广州区势时代品牌咨询管理有限...", @"portrait":[UIImage imageNamed:@"customizing_business_cards_owner's_head_portrait"]},
                           @{@"userName":@"刘晓玉", @"company":@"深圳市斯蒂格环保设备有限公司", @"portrait":[UIImage imageNamed:@"shared_shop_details_head_portrait"]},
                           @{@"userName":@"董晓丽", @"company":@"深圳市瑞鹏宠物医疗集团股份有...", @"portrait":[UIImage imageNamed:@"personal_center_login_head"]},
                           @{@"userName":@"周XX", @"company":@"深圳市前海合派科技有限公司", @"portrait":[UIImage imageNamed:@"customizing_business_cards_entrepreneur's_head_portrait"]},
                           @{@"userName":@"王彤彤", @"company":@"广州区势时代品牌咨询管理有限...", @"portrait":[UIImage imageNamed:@"customizing_business_cards_owner's_head_portrait"]}];
    
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    [self setupUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"关注"];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPFollowListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *userName = dict[@"userName"];
    NSString *company = dict[@"company"];
    UIImage *portrait = dict[@"portrait"];
    
    [cell setUserName:userName];
    [cell setCompany:company];
    [cell setPortrait:portrait];
    [cell setDelegate:self];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - HPFollowListCellDelegate

- (void)followListCell:(HPFollowListCell *)cell didClickFollowBtn:(UIButton *)btn {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setText:@"确定取消关注此人？"];
        [textDialogView setModalTop:279.f * g_rateHeight];
        _textDialogView = textDialogView;
    }
    
    [_textDialogView setConfirmCallback:^{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSLog(@"indexPath: %ld", (long)indexPath.row);
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [_textDialogView show:YES];
}

@end
