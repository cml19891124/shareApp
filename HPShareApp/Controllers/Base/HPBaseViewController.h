//
//  HPBaseViewController.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPBaseViewController : UIViewController

@property (nonatomic, strong) NSDictionary *param;

@property (nonatomic, assign) BOOL isPopGestureRecognize;

- (void)setupBackBtn;

- (UIView *)setupNavigationBarWithTitle:(NSString *)title;

- (void)pushVCByClassName:(NSString *)name;

- (void)pushVCByClassName:(NSString *)name withParam:(NSDictionary * _Nullable)param;

@end

NS_ASSUME_NONNULL_END