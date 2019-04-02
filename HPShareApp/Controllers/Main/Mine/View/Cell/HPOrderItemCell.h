//
//  HPOrderItemCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

typedef void(^OnClickOrderReturnBlock)(NSInteger HPReturnOrderIndex);

typedef NS_ENUM(NSInteger, HPMineOrderCellIndex) {
    HPMineOrderCellToReceive = 4400,
    HPMineOrderCellToPay,
    HPMineOrderCellToRent,
    HPMineOrderCellToReturnFuns,
    HPMineOrderCellToComment,
    HPMineOrderCellAllOrders
};

typedef NS_ENUM(NSInteger, HPRentOrderCellIndex) {
    HPRentOrderCellToFindStores = 4500,
    HPRentOrderCellToSendQuery,
    HPRentOrderCellToReceive,
    HPRentOrderCellToPay,
    HPRentOrderCellToStart
};
NS_ASSUME_NONNULL_BEGIN

@interface HPOrderItemCell : HPBaseTableViewCell

@property (nonatomic, strong) UIView *orderView;

@property (nonatomic, strong) UILabel *orderLabel;

@property (nonatomic, strong) UIButton *allOrderBtn;

@property (nonatomic, strong) NSArray *orderArray;

@property (nonatomic, strong) NSArray *orderImageArray;

@property (nonatomic, copy) OnClickOrderReturnBlock returnBlock;


@end

NS_ASSUME_NONNULL_END
