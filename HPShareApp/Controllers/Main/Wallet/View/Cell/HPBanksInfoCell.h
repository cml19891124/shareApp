//
//  HPBanksInfoCell.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "HPCardsInfoModel.h"

typedef void(^SelectCardBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPBanksInfoCell : HPBaseTableViewCell

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *selectedButton;

@property (strong, nonatomic) HPCardsInfoModel *model;

@property (nonatomic, copy) SelectCardBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
