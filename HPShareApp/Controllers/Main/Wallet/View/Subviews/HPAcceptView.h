//
//  HPAcceptView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^KnownBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPAcceptView : HPBaseModalView

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UILabel *confirmLabel;

@property (strong, nonatomic) UIButton *kownBtn;

@property (nonatomic, copy) KnownBlock kownBlock;
@end

NS_ASSUME_NONNULL_END
