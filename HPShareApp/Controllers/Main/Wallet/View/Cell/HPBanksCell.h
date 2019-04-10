//
//  HPBanksCell.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "HPBanksListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPBanksCell : HPBaseTableViewCell

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) HPBanksListModel *model;

@end

NS_ASSUME_NONNULL_END
