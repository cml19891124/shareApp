//
//  HPBaseShareListController.h
//  HPShareApp
//
//  Created by HP on 2018/11/30.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"
#import "HPShareListCell.h"
#import "HPShareListModel.h"
#import "HPShareListParam.h"

#define CELL_ID @"HPShareListCell"

NS_ASSUME_NONNULL_BEGIN

@interface HPBaseShareListController : HPBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *testDataArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) HPShareListParam *shareListParam;

- (UIView *)setupFilterBar;

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload;

- (void)loadTableViewFreshUI;

@end

NS_ASSUME_NONNULL_END
