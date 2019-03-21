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

@class HPHeaderViewCell;

@protocol HPHeaderViewCellDelegate <NSObject>

/**
 编辑名片按钮点击事件
 */
- (void)onTapped:(HPHeaderViewCell *)tableviewCell HeaderView:(UITapGestureRecognizer *)tap;

/**
 编辑名片按钮点击事件
 */
- (void)onClicked:(HPHeaderViewCell *)tableviewCell EditProfileInfoBtn:(UIButton *)button;

/**
 切换身份按钮点击事件
 */
- (void)onClicked:(HPHeaderViewCell *)tableviewCell OptionalBtn:(UIButton *)optionalBtn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPHeaderViewCell : HPBaseTableViewCell

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

/**
 登录按钮的功能
 */
@property (nonatomic, strong) UIButton *phoneBtn;

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

@property (nonatomic, strong) UIButton *optionalBtn;

@property (nonatomic, weak) id<HPHeaderViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
