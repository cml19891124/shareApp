//
//  HPAccountInfoModel.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAccountInfoModel.h"

@implementation HPAccountInfoModel

/* 设置模型属性名和字典key之间的映射关系 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"desc" : @"description"
             };
}


+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"desc" : @"HPDescriptionModel"};//前边，是属性数组的名字，后边就是类名
}
@end

@implementation HPDescriptionModel


@end
