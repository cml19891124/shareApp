//
//  HPUserHeaderView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/6.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HPOrderBtn.h"

#import "HPAlignCenterButton.h"

typedef void(^UserBtnClickBlcok)(NSInteger businessIndex);

typedef void(^ProfileBtnClickBlcok)(NSInteger profileIndex);


typedef NS_ENUM(NSInteger, HPOrderItemCellIndex) {
    HPOrderCellIndexToCollection = 4000,
    HPOrderCellIndexToFocus,
    HPOrderCellIndexToFoot,
    HPOrderCellIndexTodiscount
};

typedef NS_ENUM(NSInteger, HPProfileCellFowIndex) {//拼租流程
    HPProfileCellFowFindStore = 4600,
    HPProfileCellFowQuest,
    HPProfileCellFowReceiveOrder,
    HPProfileCellFowToPay,
    HPProfileCellFowBeginRent
};

NS_ASSUME_NONNULL_BEGIN

@interface HPUserHeaderView : UIView
/**
 收藏
 */
@property (strong, nonatomic) HPOrderBtn *collectionBtn;

/**
 关注
 */
@property (strong, nonatomic) HPOrderBtn *focusBtn;
/**
 足迹
 */
@property (strong, nonatomic) HPOrderBtn *footerBtn;
/**
 卡券
 */
@property (strong, nonatomic) HPOrderBtn *couperBtn;

@property (nonatomic, strong) UIView *userView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) HPAlignCenterButton *findStoreBtn;

@property (strong, nonatomic) HPAlignCenterButton *questBtn;

@property (strong, nonatomic) HPAlignCenterButton *receiveOrderBtn;

@property (strong, nonatomic) HPAlignCenterButton *rentToPayBtn;

@property (strong, nonatomic) HPAlignCenterButton *beginRentBtn;

@property (nonatomic, copy) UserBtnClickBlcok userBlock;

@property (nonatomic, copy) ProfileBtnClickBlcok profileBlock;
@end

NS_ASSUME_NONNULL_END
