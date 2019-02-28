//
//  HPShareTempHumanController.m
//  HPShareApp
//
//  Created by Jay on 2018/12/23.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareTempHumanController.h"
#import "YYLRefreshNoDataView.h"

@interface HPShareTempHumanController ()

@end

@implementation HPShareTempHumanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    UIView *navigationView = [self setupNavigationBarWithTitle:@"人力拼租"];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBounces:NO];
    tableView.loadErrorType = YYLLoadErrorTypeNoData;
    tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"list_default_page");
    tableView.refreshNoDataView.tipLabel.text = @"人力拼租即将开启，敬请期待～";
    [tableView.refreshNoDataView.tipBtn setHidden:YES];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.and.width.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

@end
