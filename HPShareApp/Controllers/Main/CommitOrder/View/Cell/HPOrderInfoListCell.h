//
//  HPOrderInfoListCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/26.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPOrderInfoListCell : HPBaseTableViewCell

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UILabel *priceLabel;


@end

NS_ASSUME_NONNULL_END
