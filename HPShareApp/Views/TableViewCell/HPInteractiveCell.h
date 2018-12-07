//
//  HPInteractiveCellTableViewCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/6.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPBaseTableViewCell.h"
#import "HPInterActiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPInteractiveCell : HPBaseTableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *badgeValue;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) HPInterActiveModel *model;
@end

NS_ASSUME_NONNULL_END
