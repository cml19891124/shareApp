//
//  HPFollowListCell.h
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPFansListModel.h"

@class HPFollowListCell;
@protocol HPFollowListCellDelegate <NSObject>

@optional

- (void)followListCell:(HPFollowListCell *)cell didClickFollowBtn:(UIButton *)btn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPFollowListCell : HPBaseTableViewCell

@property (nonatomic, weak) NSString *userName;

@property (nonatomic, weak) NSString *company;

/**
 是否关注按钮
 */
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, weak) id<HPFollowListCellDelegate> delegate;

@property (nonatomic, strong) HPFansListModel *model;

- (void)setPortrait:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
