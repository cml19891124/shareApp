//
//  HPRentAmountItemView.h
//  HPShareApp
//
//  Created by HP on 2018/12/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"
typedef void (^RentAmountItemClickBtnBlock)(NSString *model);

NS_ASSUME_NONNULL_BEGIN

@interface HPRentAmountItemView : UIView
/**
 当前选中的租赁价格 block
 */
@property (nonatomic, copy) RentAmountItemClickBtnBlock rentAmountItemClickBtnBlock;
@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UIView *fillView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) NSArray *rightButtonArray;
@property (nonatomic, strong) UITextField *fillField;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
