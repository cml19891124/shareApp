//
//  HPLocateHistory.h
//  HPShareApp
//
//  Created by Jay on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPLocateHistory : NSObject

+ (void)saveHistory:(NSArray<HPAddressModel *> *)history;

+ (NSArray<HPAddressModel *> *)history;

+ (void)addHistory:(HPAddressModel *)history;

+ (BOOL)deleteHistory;

@end

NS_ASSUME_NONNULL_END
