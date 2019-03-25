//
//  HPAccountCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

typedef void(^OnClickBindBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface HPAccountCell : HPBaseTableViewCell


@property (nonatomic, strong) UIButton *icon;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *bindBtn;

@property (nonatomic, copy) OnClickBindBlock bindBlock;

@property (nonatomic, assign) BOOL isSelected;


@end

NS_ASSUME_NONNULL_END
