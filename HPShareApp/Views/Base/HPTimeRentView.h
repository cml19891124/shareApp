//
//  HPTimeRentView.h
//  HPShareApp
//
//  Created by caominglei on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTimeRentButton.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"
#import "HPRentAmountItemView.h"

typedef void (^RentTypeClickBtnBlock)(NSString *model);
NS_ASSUME_NONNULL_BEGIN

@interface HPTimeRentView : UIView

/**
 当前选中的租赁类型 block
 */
@property (nonatomic, copy) RentTypeClickBtnBlock rentTypeClickBtnBlock;
@property (nonatomic, strong) HPTimeRentButton *selectedBtn;
@property (nonatomic, strong) HPRentAmountItemView *rentItemView;
@end

NS_ASSUME_NONNULL_END
