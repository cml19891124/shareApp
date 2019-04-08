//
//  HPOrderInfoListView.h
//  HPShareApp
//
//  Created by HP on 2019/3/26.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"

#import "HPOrderInfoListCell.h"

#import "HPRightImageButton.h"

#import "HPTotalFeeCell.h"

#import "HOOrderListModel.h"

#import "HPTimeString.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPOrderInfoListView : HPBaseDialogView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray * days;

@property (strong, nonatomic) HOOrderListModel *model;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) HPRightImageButton *feeBtn;

@property (nonatomic, strong) UILabel *feeLabel;

@property (nonatomic, strong) UILabel *totalFeeLabel;

/**
 日租金
 */
@property (nonatomic, copy) NSString *dayRent;

@property (strong, nonatomic) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
