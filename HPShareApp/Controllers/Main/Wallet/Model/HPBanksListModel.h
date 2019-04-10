//
//  HPBanksListModel.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/10.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPBanksListModel : NSObject

@property (nonatomic, assign) NSInteger bankId;

@property (nonatomic, assign) NSInteger shareBankId;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *logUrl;

@end

NS_ASSUME_NONNULL_END
