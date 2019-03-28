//
//  HPDistrictItemView.h
//  HPShareStore
//
//  Created by HP on 2019/3/4.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Macro.h"

#import "Masonry.h"

#import "HPGlobalVariable.h"

typedef NS_ENUM(NSInteger, HPAreaItemsMenu) {
    HPAreaItemsMenuBaoan = 2200,
    HPAreaItemsMenuLonghua,
    HPAreaItemsMenuNanshan
};

typedef NS_ENUM(NSInteger, HPAreaItemsMenuLine) {
    HPAreaItemsMenuBaoanLine = 2300,
    HPAreaItemsMenuLonghuaLine,
    HPAreaItemsMenuNanshanLine
};

typedef void(^AreaItemMenuClickBlock) (NSInteger menuItem);
NS_ASSUME_NONNULL_BEGIN

@interface HPChooseItemView : UIView

@property (nonatomic, strong) NSArray *areaArray;

//临时lineView 与 临时 btn
@property (strong, nonatomic) UIView * lineViewTemp;

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) UIButton *selectedBtn;

//lineView数组
@property (strong, nonatomic) NSMutableArray * buttonArray;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy) AreaItemMenuClickBlock block;
@end

NS_ASSUME_NONNULL_END
