//
//  HPCommonBannerData.h
//  HPShareApp
//
//  Created by HP on 2019/1/17.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPHomeBannerModel.h"
#import "Macro.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCommonBannerData : NSObject

+ (NSArray<HPHomeBannerModel *> *)getHPHomeBannerData;

@end

NS_ASSUME_NONNULL_END
