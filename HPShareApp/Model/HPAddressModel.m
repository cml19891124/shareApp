//
//  HPLocationModel.m
//  HPShareApp
//
//  Created by Jay on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAddressModel.h"
#import <objc/runtime.h>

@implementation HPAddressModel

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeDouble:_lat forKey:@"lat"];
    [aCoder encodeDouble:_lon forKey:@"lon"];
    [aCoder encodeObject:_formattedAddress forKey:@"formattedAddress"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_province forKey:@"province"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_district forKey:@"district"];
    [aCoder encodeObject:_citycode forKey:@"citycode"];
    [aCoder encodeObject:_adcode forKey:@"adcode"];
    [aCoder encodeObject:_street forKey:@"street"];
    [aCoder encodeObject:_number forKey:@"number"];
    [aCoder encodeObject:_POIName forKey:@"POIName"];
    [aCoder encodeObject:_AOIName forKey:@"AOIName"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.lat = [aDecoder decodeDoubleForKey:@"lat"];
        self.lon = [aDecoder decodeDoubleForKey:@"lon"];
        self.formattedAddress = [aDecoder decodeObjectForKey:@"formattedAddress"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.district = [aDecoder decodeObjectForKey:@"district"];
        self.citycode = [aDecoder decodeObjectForKey:@"citycode"];
        self.adcode = [aDecoder decodeObjectForKey:@"adcode"];
        self.street = [aDecoder decodeObjectForKey:@"street"];
        self.number = [aDecoder decodeObjectForKey:@"number"];
        self.POIName = [aDecoder decodeObjectForKey:@"POIName"];
        self.AOIName = [aDecoder decodeObjectForKey:@"AOIName"];
    }
    return self;
}

- (void)setData:(NSObject *)data {
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(self.class, &count);
    
    u_int count_2;
    objc_property_t *properties_2  =class_copyPropertyList(data.class, &count_2);
    
    for (int i = 0; i<count; i++) {
        const char* char_f  =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        for (int j = 0; j < count_2; j ++) {
            const char* char_h  =property_getName(properties_2[j]);
            NSString *propertyName_2 = [NSString stringWithUTF8String:char_h];
            
            if ([propertyName isEqualToString:propertyName_2]) {
                NSObject *valueObj = [data valueForKey:propertyName];
                if (valueObj) {
                    [self setValue:valueObj forKey:propertyName];
                }
                
                break;
            }
        }
    }
    
    free(properties);
    free(properties_2);
}

@end
