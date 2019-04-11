//
//  HPOwnnerItemView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/6.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HPOrderBtn.h"

#import "HPAlignCenterButton.h"

typedef void(^BusinessBtnClickBlcok)(NSInteger businessIndex);

typedef NS_ENUM(NSInteger, HPBusinessCellIndex) {
    HPBusinessCellIndexStores = 4100,
    HPBusinessCellIndexOrder,
    HPBusinessCellIndexWallet,
    HPBusinessCellIndexName,
};

typedef NS_ENUM(NSInteger, HPOrderCellIndex) {
    HPOrderCellIndexToReceiveOrder = 4601,
    HPOrderCellIndexToPay,
    HPOrderCellIndexToGet,
    HPOrderCellIndexComplete,
};

NS_ASSUME_NONNULL_BEGIN

@interface HPOwnnerItemView : UIView


/**
 待接单
 */
@property (strong, nonatomic) HPOrderBtn *toReceiveBtn;

/**
 待付款
 */
@property (strong, nonatomic) HPOrderBtn *toPayBtn;
/**
 待收货
 */
@property (strong, nonatomic) HPOrderBtn *toGetBtn;
/**
 已完成
 */
@property (strong, nonatomic) HPOrderBtn *compelteBtn;

@property (nonatomic, strong) UIView *businessView;

@property (strong, nonatomic) HPAlignCenterButton *storeBtn;

@property (strong, nonatomic) HPAlignCenterButton *orderBtn;

@property (strong, nonatomic) HPAlignCenterButton *walletBtn;

@property (strong, nonatomic) HPAlignCenterButton *creditCardBtn;

@property (nonatomic, copy) BusinessBtnClickBlcok busiBlock;

@end

NS_ASSUME_NONNULL_END
