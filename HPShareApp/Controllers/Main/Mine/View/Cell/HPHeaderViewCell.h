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

#import "HPOwnnerItemView.h"

#import "HPUserHeaderView.h"

#import "HPSingleton.h"

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

@property (strong, nonatomic) HPOwnnerItemView *ownnerView;

@property (strong, nonatomic) HPUserHeaderView *userView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIView *rentLineView;
/**
 登录按钮的功能
 */
@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UILabel *identifiLabel;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIButton *optionalBtn;

@property (nonatomic, weak) id<HPHeaderViewCellDelegate> delegate;

/**
 身份认证状态
 */
@property (nonatomic, assign) NSInteger identifyTag;

@end

NS_ASSUME_NONNULL_END
