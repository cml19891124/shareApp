//
//  HPOwnnerHeaderCell.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/3.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "UIView+Corner.h"

#import "HPOrderBtn.h"

#import "HPAlignCenterButton.h"

@class HPOwnnerHeaderCell;

@protocol HPOwnnerHeaderViewCellDelegate <NSObject>

/**
 登录按钮点击事件
 */
- (void)onClicked:(HPOwnnerHeaderCell *)tableviewCell LoginBtn:(UIButton *)button;

/**
 头像点击事件
 */
- (void)onTapped:(HPOwnnerHeaderCell *)tableviewCell HeaderView:(UITapGestureRecognizer *)tap;

/**
 编辑名片按钮点击事件
 */
- (void)onClicked:(HPOwnnerHeaderCell *)tableviewCell EditProfileInfoBtn:(UIButton *)button;

/**
 切换身份按钮点击事件
 */
- (void)onClicked:(HPOwnnerHeaderCell *)tableviewCell OptionalBtn:(UIButton *)optionalBtn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPOwnnerHeaderCell : HPBaseTableViewCell

@property (nonatomic, strong) NSArray *orderNameArray;

@property (nonatomic, strong) NSArray *businessImageArray;

@property (nonatomic, strong) NSArray *businessNameArray;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIView *rentLineView;
/**
 登录按钮的功能
 */
@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UILabel *identifiLabel;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIView *myInfoView;

@property (nonatomic, strong) UIView *rentView;

@property (nonatomic, strong) UIButton *optionalBtn;


@property (nonatomic, strong) HPOrderBtn *orderBtn;

@property (strong, nonatomic) HPAlignCenterButton *busiBtn;

@property (nonatomic, strong) HPOrderBtn *receiveBtn;

@property (nonatomic, strong) HPOrderBtn *topayBtn;

@property (nonatomic, strong) HPOrderBtn *toRentBtn;

@property (nonatomic, strong) HPOrderBtn *returnBtn;

@property (nonatomic, strong) HPOrderBtn *commentBtn;

@property (nonatomic, weak) id<HPOwnnerHeaderViewCellDelegate> delegate;

@property (nonatomic, strong) UILabel *orderTipLabel;

@property (nonatomic, strong) UILabel *rentTipLabel;

@property (nonatomic, strong) UIView *orderStatesView;

@property (nonatomic, strong) UIView *businessView;
@end

NS_ASSUME_NONNULL_END
