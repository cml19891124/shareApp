//
//  HPProvinceModel.h
//  HPShareApp
//
//  Created by HP on 2019/1/18.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPSubDistricts,HPSubDistrictsAreaModel,HPSubDistrictsBlockModel;
NS_ASSUME_NONNULL_BEGIN

@interface HPProvinceModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *center;
@property (nonatomic, assign) int count;
@property (nonatomic, copy) NSArray *subDistricts;
@end

@interface HPSubDistricts : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *center;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSArray *subDistricts;
@end

@interface HPSubDistrictsAreaModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *center;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSArray *subDistricts;

@end

@interface HPSubDistrictsBlockModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *center;
@property (nonatomic, copy) NSString *count;

@end
NS_ASSUME_NONNULL_END
