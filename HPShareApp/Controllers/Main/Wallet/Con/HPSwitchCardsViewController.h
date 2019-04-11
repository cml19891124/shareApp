//
//  HPSwitchCardsViewController.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"

#import "HPBanksInfoCell.h"

@class HPSwitchCardsViewController;

@protocol CardsInfoDelegate  <NSObject>

/**
 选择提现银行的信息
 */
- (void)onClickBank:(HPSwitchCardsViewController *)cards andCardsModel:(HPCardsInfoModel *)model;

@end;
NS_ASSUME_NONNULL_BEGIN

@interface HPSwitchCardsViewController : HPBaseViewController

@property (nonatomic, weak) id<CardsInfoDelegate> cardsDelegate;

@end

NS_ASSUME_NONNULL_END
