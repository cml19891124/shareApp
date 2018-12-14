//
//  HPShareDetailModel.m
//  HPShareApp
//
//  Created by Jay on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareDetailModel.h"

@implementation HPShareDetailModel

+ (NSDictionary *)objectClassInArray {
    return @{@"pictures":[HPPictureModel class]
             };
}

@end
