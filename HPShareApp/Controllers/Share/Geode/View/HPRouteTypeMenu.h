//
//  HPRouteTypeMenu.h
//  HPShareApp
//
//  Created by HP on 2019/1/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"
#import "HPRouteButton.h"
#import "HPImageUtil.h"

typedef void (^RouteTypeBtnBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPRouteTypeMenu : UIView

/**
 行驶路线图片数组
 */
@property (nonatomic, strong) NSArray *routeImageArray;


/**
 点击事件block
 */
@property (nonatomic, copy) RouteTypeBtnBlock routeBtnBlock;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) HPRouteButton *btn;
@end

NS_ASSUME_NONNULL_END
