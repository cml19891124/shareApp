//
//  HPCommonData.h
//  HPShareApp
//
//  Created by Jay on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPAreaModel.h"
#import "HPIndustryModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 获取全局的区域分类和行业分类等数据
 */
@interface HPCommonData : NSObject

+ (NSArray<HPIndustryModel *> *)getIndustryData;

+(NSString *)getIndustryNameById:(NSString *)industryId;

/**
 根据name 获取id
 */
+(NSString *)getIndustryIdByIndustryName:(NSString *)industryName;

+ (NSArray<HPAreaModel *> *)getAreaData;

+ (NSString *)getAreaNameById:(NSString *)areaId;

+ (NSString *)getAreaIdByName:(NSString *)name;

+ (NSString *)getDistrictNameByAreaId:(NSString *)areaId districtId:(NSString *)districtId;

+ (NSString *)getDistrictIdByAreaName:(NSString *)areaName districtName:(NSString *)districtName;
@end

NS_ASSUME_NONNULL_END
