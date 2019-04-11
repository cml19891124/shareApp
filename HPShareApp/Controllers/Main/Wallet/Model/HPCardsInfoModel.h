//
//  HPCardsInfoModel.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPCardsInfoModel : NSObject

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *accountNo;

/**
 银行卡类型 1 储蓄卡 0 信用卡
 */
@property (nonatomic, copy) NSString *shareBankCardId;

@property (nonatomic, copy) NSString *logUrl;

@property (nonatomic, copy) NSString *bankId;

@end

NS_ASSUME_NONNULL_END
