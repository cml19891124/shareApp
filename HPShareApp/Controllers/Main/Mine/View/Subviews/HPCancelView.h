//
//  HPCancelView.h
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^onClickBtnCancelViewBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPCancelView : HPBaseModalView

@property (nonatomic, strong) UIView *bgview;

@property (nonatomic, strong) UIButton *tipBtn;

@property (nonatomic, strong) UILabel *focusLabel;

@property (nonatomic, strong) UIView *lineV;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *bottomV;

@property (nonatomic, copy) onClickBtnCancelViewBlock cancelBlock;
@end

NS_ASSUME_NONNULL_END
