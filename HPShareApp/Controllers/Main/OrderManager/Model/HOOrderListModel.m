//
//  HOOrderListModel.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/2.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HOOrderListModel.h"

@implementation HOOrderListModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"order" : @"HPOrderlModel",
             @"spaceDetail":@"spaceDetail",
             @"spaceDetail":@"spaceDetail",};//前边，是属性数组的名字，后边就是类名
}

@end

@implementation HPOrderlModel

@end

@implementation HPSpaceDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"picture" : @"HPPicture"
             
             };//前边，是属性数组的名字，后边就是类名
}

@end

@implementation HPPicture

@end
