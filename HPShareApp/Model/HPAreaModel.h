//
//  HPCityModel.h
//  HPShareApp
//
//  Created by caominglei on 2018/12/8.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPDistrictModel;
NS_ASSUME_NONNULL_BEGIN

@interface HPAreaModel : NSObject <NSCopying>
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *name;

@end

@interface HPDistrictModel : NSObject <NSCopying>
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *districtId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *updateTime;

@end
NS_ASSUME_NONNULL_END
