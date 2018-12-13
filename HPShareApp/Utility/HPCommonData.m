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

static NSArray<HPAreaModel *> *areaModels;

@implementation HPCommonData

+ (NSArray<HPAreaModel *> *)getAreaData {
    if (areaModels == nil) {
        [HPCommonData requestAreaData];
    }
    
    return areaModels;
}

+ (void)requestAreaData {
    [HPHTTPSever HPGETServerWithMethod:@"/v1/area/list" isNeedToken:NO paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            areaModels = [HPAreaModel mj_objectArrayWithKeyValuesArray:DATA];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

+ (NSString *)getAreaNameWithId:(NSString *)areaId {
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

+ (NSString *)getDistrictNameWithId:(NSString *)districtId {
    [HPCommonData getAreaData];
    return nil;
}

@end
