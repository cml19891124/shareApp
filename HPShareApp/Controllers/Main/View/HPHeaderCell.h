//
//  HPHeaderCell.h
//  HPShareApp
//
//  Created by HP on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

typedef void (^HeaderClickBlock)(NSInteger ideaIndex);
NS_ASSUME_NONNULL_BEGIN

@interface HPHeaderCell : HPBaseTableViewCell

@property (nonatomic, strong) UIControl *whatIsShareSpace;

@property (nonatomic, copy) HeaderClickBlock headerClickBlock;

@property (nonatomic, strong) UIImageView *bgView;

/**
 享法des
 */
@property (nonatomic, strong) UILabel *ideaLabel;

@property (nonatomic, strong) UILabel *headTitlelabel;

@property (nonatomic, strong) UIImageView *headImageview;

@end

NS_ASSUME_NONNULL_END
