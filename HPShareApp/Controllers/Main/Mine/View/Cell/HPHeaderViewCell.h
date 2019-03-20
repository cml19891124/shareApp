//
//  HPHeaderViewCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "HPAlignCenterButton.h"

#import "HPOrderBtn.h"

typedef void(^OrderBtnClickBlcok)(NSInteger orderIndex);

typedef void(^BusinessBtnClickBlcok)(NSInteger businessIndex);

typedef NS_ENUM(NSInteger, HPOrderCellIndex) {
    HPOrderCellIndexToReceive = 4000,
    HPOrderCellIndexToPay,
    HPOrderCellIndexToRent,
    HPOrderCellIndexToReturnFuns,
    HPOrderCellIndexToComment
};

typedef NS_ENUM(NSInteger, HPBusinessCellIndex) {
    HPBusinessCellIndexStores = 4100,
    HPBusinessCellIndexOrder,
    HPBusinessCellIndexWallet,
    HPBusinessCellIndexname,
};

NS_ASSUME_NONNULL_BEGIN

@interface HPHeaderViewCell : HPBaseTableViewCell

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *identifiLabel;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIView *orderStatesView;

@property (nonatomic, strong) NSArray *orderNameArray;

@property (nonatomic, strong) NSArray *businessImageArray;

@property (nonatomic, strong) NSArray *businessNameArray;

@property (nonatomic, strong) HPAlignCenterButton *orderBtn;

@property (nonatomic, copy) OrderBtnClickBlcok orderBlock;

@property (nonatomic, copy) BusinessBtnClickBlcok busiBlock;

@property (nonatomic, strong) UIView *businessView;

@end

NS_ASSUME_NONNULL_END
