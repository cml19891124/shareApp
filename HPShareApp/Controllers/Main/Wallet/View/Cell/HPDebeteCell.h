//
//  HPDebeteCell.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "HPAccountInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPDebeteCell : HPBaseTableViewCell

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *nameSubLabel;

@property (strong, nonatomic) UILabel *amountLabel;

@property (strong, nonatomic) UILabel *amountSubLabel;

@property (strong, nonatomic) HPAccountInfoModel *model;

@end

NS_ASSUME_NONNULL_END
