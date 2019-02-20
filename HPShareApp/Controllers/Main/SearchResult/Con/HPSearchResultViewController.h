//
//  HPSearchResultViewController.h
//  HPShareApp
//
//  Created by HP on 2019/2/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"
#import "HPShareListParam.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPSearchResultViewController : HPBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HPShareListParam *shareListParam;

- (UIView *)setupFilterBar;

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload;

- (void)loadTableViewFreshUI;
@end

NS_ASSUME_NONNULL_END
