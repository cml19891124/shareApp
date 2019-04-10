//
//  HPBanksViewController.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"

#import "HPBanksCell.h"

@class HPBanksViewController;

@protocol BanksInfoDelegate  <NSObject>

/**
 点击选择银行信息
 */
- (void)selecetBankRow:(HPBanksViewController *)banks andModel:(HPBanksListModel *)model;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HPBanksViewController : HPBaseViewController

@property (nonatomic, weak) id<BanksInfoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
