//
//  HPLinkageData.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLinkageData.h"
#import <objc/runtime.h>

@interface HPLinkageData ()

@property (nonatomic, strong) NSArray *models;

@property (nonatomic, copy) NSString *childrenKey;

@property (nonatomic, assign) Class parentClass;

@end

@implementation HPLinkageData

- (instancetype)initWithModels:(NSArray *)models {
    self = [super init];
    if (self) {
        _models = models;
        if (models.count > 0) {
            _parentClass = ((NSObject *)models[0]).class;
        }
        _parentNameKey = @"name";
        _childNameKey = @"name";
        _childrenKey = [self getChildrenKey];
    }
    return self;
}

- (NSString *)getParentNameAtIndex:(NSInteger)index {
    if (index >= _models.count || index < 0) {
        return nil;
    }
    
    return [_models[index] valueForKey:_parentNameKey];;
}

- (NSInteger)getParentCount {
    return _models.count;
}

- (NSInteger)getChildrenCountOfParentIndex:(NSInteger)index {
    if (index >= _models.count) {
        return 0;
    }
    
    NSArray *childrenArray = [_models[index] valueForKey:_childrenKey];
    
    if (childrenArray && [childrenArray isKindOfClass:NSArray.class]) {
        return childrenArray.count;
    }
    else
        return 0;
}

- (NSString *)getChildNameOfParentIndex:(NSInteger)parentIndex atChildIndex:(NSInteger)childIndex {
    if (parentIndex >= _models.count) {
        return nil;
    }
    
    NSArray *childrenArray = [_models[parentIndex] valueForKey:_childrenKey];
    
    if (childrenArray && [childrenArray isKindOfClass:NSArray.class] &&childIndex < childrenArray.count && childIndex >= 0) {
        return [childrenArray[childIndex] valueForKey:_childNameKey];
    }
    else
        return nil;
}

- (NSObject *)getChildModelOfParentIndex:(NSInteger)parentIndex atChildIndex:(NSInteger)childIndex {
    if (parentIndex >= _models.count) {
        return nil;
    }
    
    NSArray *childrenArray = [_models[parentIndex] valueForKey:_childrenKey];
    
    if (childrenArray && [childrenArray isKindOfClass:NSArray.class] &&childIndex < childrenArray.count && childIndex >= 0) {
        return childrenArray[childIndex];
    }
    else
        return nil;
}

- (NSString *)getChildrenKey {
    if (_models.count <= 0){
        return @"children";
    }else {
        NSObject *valueObj = [_models[0] valueForKey:@"children"];
        if ([valueObj isKindOfClass:NSArray.class]) {
            return @"children";
        }
    }
    
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(_parentClass, &count);
    
    for (int i = 0; i<count; i++) {
        const char* char_f  =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        NSObject *valueObj = [_models[0] valueForKey:propertyName];
        if ([valueObj isKindOfClass:NSArray.class]) {
            free(properties);
            return propertyName;
        }
    }
    
    free(properties);
    
    return @"children";
}

@end
