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

typedef void(^OnClickOnlineBlock)(NSInteger HPOnlineOrderIndex);

typedef NS_ENUM(NSInteger, HPOrderCellIndex) {
    HPOrderCellIndexToCollection = 4000,
    HPOrderCellIndexToFocus,
    HPOrderCellIndexToFoot,
    HPOrderCellIndexTodiscount
};

typedef NS_ENUM(NSInteger, HPBusinessCellIndex) {
    HPBusinessCellIndexStores = 4100,
    HPBusinessCellIndexOrder,
    HPBusinessCellIndexWallet,
    HPBusinessCellIndexName,
};

typedef NS_ENUM(NSInteger, HPMineCellRecordIndex) {//我的售后
    HPMineCellWaitingToReceive = 4600,
    HPMineCellWaitingToPay,
    HPMineCellWaitingToGet,
    HPMineCellComplete,
};

@class HPHeaderViewCell;

@protocol HPHeaderViewCellDelegate <NSObject>

/**
 登录按钮点击事件
 */
- (void)onClicked:(HPHeaderViewCell *)tableviewCell LoginBtn:(UIButton *)button;

/**
 头像点击事件
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

@property (nonatomic, strong) UIView *rentLineView;
/**
 登录按钮的功能
 */
@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UILabel *identifiLabel;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIView *orderStatesView;

@property (nonatomic, strong) UIView *myInfoView;

@property (nonatomic, strong) NSArray *myInfoArray;

@property (nonatomic, strong) NSArray *orderNameArray;

@property (nonatomic, strong) NSArray *businessImageArray;

@property (nonatomic, strong) NSArray *businessNameArray;

@property (nonatomic, strong) NSArray *rentArray;

@property (nonatomic, strong) NSArray *rentImageArray;

@property (nonatomic, strong) HPOrderBtn *orderBtn;

@property (strong, nonatomic) HPAlignCenterButton *busiBtn;

@property (nonatomic, strong) HPOrderBtn *receiveBtn;

@property (nonatomic, strong) HPOrderBtn *topayBtn;

@property (nonatomic, strong) HPOrderBtn *toRentBtn;

@property (nonatomic, strong) HPOrderBtn *returnBtn;

@property (nonatomic, copy) OrderBtnClickBlcok orderBlock;

@property (nonatomic, copy) BusinessBtnClickBlcok busiBlock;

@property (nonatomic, strong) UIView *businessView;

@property (nonatomic, strong) UIButton *optionalBtn;

@property (nonatomic, weak) id<HPHeaderViewCellDelegate> delegate;

/**
 身份认证状态
 */
@property (nonatomic, assign) NSInteger identifyTag;

@property (nonatomic, strong) UIView *rentView;

@property (nonatomic, strong) UILabel *orderTipLabel;

@property (nonatomic, strong) UILabel *rentTipLabel;

@property (nonatomic, copy) OnClickOnlineBlock onlineBlock;
@end

NS_ASSUME_NONNULL_END
