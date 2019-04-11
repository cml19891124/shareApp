//
//  HPAccountItemView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Macro.h"

#import "Masonry.h"

#import "HPGlobalVariable.h"

typedef void(^AccountItemBlock)(NSInteger accountIndex);

typedef NS_ENUM(NSInteger, HPAccountItemIndex) {
    HPAccountItemIndexAll = 5300,
    HPAccountItemIndexOutcome,
    HPAccountItemIndexIncome,
};

NS_ASSUME_NONNULL_BEGIN

@interface HPAccountItemView : UIView

@property (strong, nonatomic) UIButton *allBtn;

@property (strong, nonatomic) UIButton *outcomeBtn;

@property (strong, nonatomic) UIButton *incomBtn;

@property (strong, nonatomic) UIButton *selectedBtn;

@property (nonatomic, copy) AccountItemBlock accountBlock;

//临时lineView 与 临时 btn
@property (strong, nonatomic) UIView * lineViewTemp;

//lineView数组
@property (strong, nonatomic) NSMutableArray * buttonArray;

@property (nonatomic, strong) UIView *bottomView;

- (void)scrolling:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
