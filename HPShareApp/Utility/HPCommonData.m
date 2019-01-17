//
//  HPCommonData.m
//  HPShareApp
//
//  Created by Jay on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCommonData.h"
#import "HPHTTPSever.h"
#import "Macro.h"

static NSArray<HPIndustryModel *> *industryModels;
static NSArray<HPAreaModel *> *areaModels;

@implementation HPCommonData

+ (NSArray<HPIndustryModel *> *)getIndustryData {
    if (industryModels == nil) {
        [HPCommonData requestIndustryData];
    }
    
    if (industryModels) {
        return [[NSArray alloc] initWithArray:industryModels copyItems:YES];
    }
    
    return industryModels;
}

+ (void)requestIndustryData {
    HPLog(@"**********requestIndustryData************");
    [HPHTTPSever HPGETServerWithMethod:@"/v1/industry/listWithChildren" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            industryModels = [HPIndustryModel mj_objectArrayWithKeyValuesArray:DATA];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

+(NSString *)getIndustryNameById:(NSString *)industryId {
    [HPCommonData getIndustryData];
    if (industryModels) {
        for (HPIndustryModel *model in industryModels) {
            if ([model.industryId isEqualToString:industryId]) {
                return model.industryName;
            }
            
            for (HPIndustryModel *subModel in model.children) {
                if ([subModel.industryId isEqualToString:industryId]) {
                    return subModel.industryName;
                }
            }
        }
    }
    
    return nil;
}

+(NSString *)getIndustryIdByIndustryName:(NSString *)industryName {
    [HPCommonData getIndustryData];
    if (industryModels) {
        for (HPIndustryModel *model in industryModels) {
            if ([model.industryName isEqualToString:industryName]) {
                return model.industryId;
            }
            
            for (HPIndustryModel *subModel in model.children) {
                if ([subModel.industryName isEqualToString:industryName]) {
                    return subModel.industryId;
                }
            }
        }
    }
    
    return nil;
}

+ (NSArray<HPAreaModel *> *)getAreaData {
    if (areaModels == nil) {
        [HPCommonData requestAreaData];
    }
    
    if (areaModels) {
        return [[NSArray alloc] initWithArray:areaModels copyItems:YES];
    }
    
    return areaModels;
}

+ (void)requestAreaData {
    NSLog(@"**********requestAreaData************");
    [HPHTTPSever HPGETServerWithMethod:@"/v1/area/list" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            areaModels = [HPAreaModel mj_objectArrayWithKeyValuesArray:DATA];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (NSString *)getAreaNameById:(NSString *)areaId {
    [HPCommonData getAreaData];
    if (areaModels) {
        for (HPAreaModel *model in areaModels) {
            if ([areaId isEqualToString:model.areaId]) {
                return model.name;
            }
        }
    }
    
    return nil;
}

+ (NSString *)getAreaIdByName:(NSString *)name {
    [HPCommonData getAreaData];
    if (areaModels) {
        for (HPAreaModel *model in areaModels) {
            if ([name isEqualToString:model.name]) {
                return model.areaId;
            }
        }
    }
    
    return nil;
}

+ (NSString *)getDistrictNameByAreaId:(NSString *)areaId districtId:(NSString *)districtId {
    [HPCommonData getAreaData];
    if (areaModels) {
        for (HPAreaModel *model in areaModels) {
            if ([areaId isEqualToString:model.areaId]) {
                NSArray<HPDistrictModel *> *dModels = model.children;
                for (HPDistrictModel *dModel in dModels) {
                    if ([dModel.districtId isEqualToString:districtId]) {
                        return dModel.name;
                    }
                }
            }
        }
    }
    
    return nil;
}

+ (NSString *)getDistrictIdByAreaName:(NSString *)areaName districtName:(NSString *)districtName {
    [HPCommonData getAreaData];
    if (areaModels) {
        for (HPAreaModel *model in areaModels) {
            if ([areaName isEqualToString:model.name]) {
                NSArray<HPDistrictModel *> *dModels = model.children;
                for (HPDistrictModel *dModel in dModels) {
                    if ([dModel.name isEqualToString:districtName]) {
                        return dModel.districtId;
                    }
                }
            }
        }
    }
    
    return nil;
}
@end
