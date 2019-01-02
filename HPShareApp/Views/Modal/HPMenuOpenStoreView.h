//
//  HPMenuOpenStoreView.h
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
typedef void(^ClickCityBtnBlock) (void);

NS_ASSUME_NONNULL_BEGIN

@interface HPMenuOpenStoreView : UIView

/**
 背景视图
 */
@property (nonatomic, strong) UIImageView *tipimageView;

/**
 开店提示语视图
 */
@property (nonatomic, strong) UIImageView *sloganImageView;

@property (nonatomic, strong) UIButton *cityBtn;

@property (nonatomic, copy) ClickCityBtnBlock clickCityBtnBlock;

@end

NS_ASSUME_NONNULL_END
