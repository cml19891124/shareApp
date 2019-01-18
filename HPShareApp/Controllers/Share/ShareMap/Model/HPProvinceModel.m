//
//  HPProvinceModel.m
//  HPShareApp
//
//  Created by HP on 2019/1/18.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPProvinceModel.h"
#import "MJExtension.h"
@implementation HPProvinceModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"subDistricts":HPSubDistricts.class};
}
@end

@implementation HPSubDistricts
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"subDistricts":HPSubDistrictsAreaModel.class};
}
@end

@implementation HPSubDistrictsAreaModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"subDistricts":HPSubDistrictsAreaModel.class};
}
@end

@implementation HPSubDistrictsBlockModel

@end

