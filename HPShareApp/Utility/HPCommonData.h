//
//  HPCommonData.h
//  HPShareApp
//
//  Created by Jay on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPAreaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCommonData : NSObject

+ (NSArray<HPAreaModel *> *)getAreaData;

@end

NS_ASSUME_NONNULL_END
