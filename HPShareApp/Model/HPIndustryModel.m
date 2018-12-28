//
//  HPIndustryModel.m
//  HPShareApp
//
//  Created by Jay on 2018/12/11.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIndustryModel.h"
#import <objc/runtime.h>

@implementation HPIndustryModel

+ (NSDictionary *)objectClassInArray {
    return @{@"children":[HPIndustryModel class]};
}

- (id)copyWithZone:(NSZone *)zone {
    HPIndustryModel *model = [self.class allocWithZone:zone];
    
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(self.class, &count);
    
    for (int i = 0; i<count; i++) {
        const char* char_f  =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        NSObject *valueObj = [self valueForKey:propertyName];
        if (valueObj) {
            [model setValue:valueObj forKey:propertyName];
        }
    }
    
    free(properties);
    return model;
}

@end
