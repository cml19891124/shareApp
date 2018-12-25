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
typedef void(^SearchClickBtnBlock) (NSString *model);

NS_ASSUME_NONNULL_BEGIN

@interface HPMenuOpenStoreView : UIView<UITextFieldDelegate>

/**
 背景视图
 */
@property (nonatomic, strong) UIImageView *tipimageView;

/**
 开店提示语视图
 */
@property (nonatomic, strong) UIImageView *sloganImageView;

@property (nonatomic, strong) UIButton *cityBtn;

/**
 搜索栏
 */
@property (nonatomic, strong) UIView *searchView;

/**
 搜索按钮
 */
@property (nonatomic, strong) UIButton *searchImage;

@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic, copy) ClickCityBtnBlock clickCityBtnBlock;
@property (nonatomic, copy) SearchClickBtnBlock searchClickBtnBlock;

@end

NS_ASSUME_NONNULL_END
