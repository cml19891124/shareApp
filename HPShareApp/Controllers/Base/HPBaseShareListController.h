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

#define CELL_ID @"HPShareListCell"

NS_ASSUME_NONNULL_BEGIN

@interface HPBaseShareListController : HPBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *testDataArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) UITableView *tableView;

- (UIView *)setupFilterBar;

- (void)getShareListData;

@end

NS_ASSUME_NONNULL_END
