//
//  HPRelationViewCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPRelationViewCell : HPBaseTableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *arrowImage;
@end

NS_ASSUME_NONNULL_END
