//
//  HPDistrictModel.h
//  HPShareApp
//
//  Created by HP on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class HPSubArrayModel;
NS_ASSUME_NONNULL_BEGIN

@interface HPReleaseDistrictModel : NSObject
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSMutableArray *subArray;

@end


@interface HPSubArrayModel : NSObject


@end
NS_ASSUME_NONNULL_END
