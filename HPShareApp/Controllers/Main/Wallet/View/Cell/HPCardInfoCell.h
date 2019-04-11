//
//  HPCardInfoCell.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "HPCardsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCardInfoCell : HPBaseTableViewCell

@property (strong, nonatomic) HPCardsInfoModel *model;

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *cardLabel;

@property (nonatomic, strong) UIButton *colorBtn;

@end

NS_ASSUME_NONNULL_END
