//
//  HPStoreLeavesViewController.h
//  HPShareApp
//
//  Created by HP on 2018/12/24.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseReleaseController.h"
@class HPStoreLeavesViewController;
@protocol HPLeavesVCDelegate <NSObject>

/**
 留言信息
 */
- (void)backVcIn:(HPStoreLeavesViewController *)vc andLeaves:(NSString *)leaves;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HPStoreLeavesViewController : HPBaseReleaseController
@property (nonatomic, weak) id<HPLeavesVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
