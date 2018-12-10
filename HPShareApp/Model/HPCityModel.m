//
//  HPCityModel.m
//  HPShareApp
//
//  Created by caominglei on 2018/12/8.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCityModel.h"

@implementation HPCityModel
+ (NSDictionary *)objectClassInArray

{
    
    return @{@"children":[HPDistrictModel class]
             };
    
}
@end


@implementation HPDistrictModel


@end
