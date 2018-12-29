//
//  HPSearchBar.h
//  HPShareApp
//
//  Created by HP on 2018/12/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
typedef void(^SearchClickBtnBlock) (NSString *model);

NS_ASSUME_NONNULL_BEGIN

@interface HPSearchBar : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *centerView;
/**
 搜索按钮
 */
@property (nonatomic, strong) UIButton *searchImage;

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, copy) SearchClickBtnBlock searchClickBtnBlock;

@end

NS_ASSUME_NONNULL_END
