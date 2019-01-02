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

@interface HPRentAmountItemView : UIView<UITextFieldDelegate>
/**
 当前选中的租赁价格 block
 */
@property (nonatomic, copy) RentAmountItemClickBtnBlock rentAmountItemClickBtnBlock;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (strong, nonatomic) UIButton *selectedItemBtn;

@property (nonatomic, strong) UIView *fillView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) NSArray *rightButtonArray;
@property (nonatomic, strong) UITextField *fillField;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIButton *typeBtnHour;

@property (strong, nonatomic) UIButton *typeBtnDay;
@property (strong, nonatomic) UIButton *typeBtnMonth;
@property (strong, nonatomic) UIButton *typeBtnYear;

@property (nonatomic, strong) UIView *lineView;
@property (strong, nonatomic) NSArray *itemArray;

/**
 价格按钮
 */
@property (strong, nonatomic) UIButton *itemBtn;
@property (strong, nonatomic) UIButton *itemBtnOne;
@property (strong, nonatomic) UIButton *itemBtnTwo;
@property (strong, nonatomic) UIButton *itemBtnThree;


/**
 租赁类型
 */
@property (strong, nonatomic) NSArray *rectTypeArr;
@end

NS_ASSUME_NONNULL_END
