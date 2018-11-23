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

@property (nonatomic, assign) BOOL isPopGestureRecognize;

- (void)setupBackBtn;

- (UIView *)setupNavigationBarWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
