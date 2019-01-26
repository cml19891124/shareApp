//
//  LTPersonalMainPageTestVC.h
//  OCExample
//
//  Created by 高刘通 on 2018/6/28.
//  Copyright © 2018年 LT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPBaseViewController.h"
#import "HPShareListParam.h"

@interface LTPersonalMainPageTestVC : HPBaseViewController

@property(assign, nonatomic) NSInteger totalCount;

@property(strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) HPShareListParam *shareListParam;
#pragma mark - network - 共享发布数据

- (void)getAreaShareListDataReload:(BOOL)isReload;
@end
