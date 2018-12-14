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

+ (NSArray<HPAreaModel *> *)getAreaData;

+ (NSString *)getAreaNameById:(NSString *)areaId;

+ (NSString *)getDistrictNameByAreaId:(NSString *)areaId districtId:(NSString *)districtId;

@end

NS_ASSUME_NONNULL_END
