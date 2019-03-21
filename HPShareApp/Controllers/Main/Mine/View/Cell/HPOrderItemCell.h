//
//  HPOrderItemCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPOrderItemCell : HPBaseTableViewCell

@property (nonatomic, strong) UIView *orderView;


@property (nonatomic, strong) UILabel *orderTipLabel;

@property (nonatomic, strong) UILabel *allOrderLabel;

@end

NS_ASSUME_NONNULL_END
