//
//  HPLinkageData.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLinkageData.h"
#import <objc/runtime.h>

@interface HPLinkageData () {
    NSMutableArray *_models;
}

@property (nonatomic, copy) NSString *childrenKey;

@property (nonatomic, assign) Class parentClass;

@property (nonatomic, assign) Class childClass;

@end

@implementation HPLinkageData

- (instancetype)initWithModels:(NSArray *)models {
    self = [super init];
    if (self) {
        [self setModels:models];
    }
    return self;
}

- (void)setModels:(NSArray *)models {
    _parentClass = NSObject.class;
    _childClass = NSObject.class;
    
    if (!models || ![models isKindOfClass:NSArray.class] || models.count <= 0) {
        return;
    }
    
    _models = [NSMutableArray arrayWithArray:models];
    _parentClass = ((NSObject *)models[0]).class;
    _parentNameKey = @"name";
    _childNameKey = @"name";
    _childrenKey = [self getChildrenKey];
    
    NSObject *firstParent = [models objectAtIndex:0];
    NSArray *children = [firstParent valueForKey:_childrenKey];
    if (children && [children isKindOfClass:NSArray.class] && children.count > 0) {
        NSObject *child = children[0];
        _childClass = child.class;
    }
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
//        return _models[parentIndex];
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

- (void)addParentAllModel {
    if (_parentClass == NSObject.class || _childClass == NSObject.class) {
        return;
    }
    
    NSObject *allModel = [_parentClass alloc];
    allModel = [allModel init];
    [allModel setValue:@"全部" forKey:_parentNameKey];
    NSObject *childModel = [_childClass alloc];
    childModel = [childModel init];
    [childModel setValue:@"全部" forKey:_childNameKey];
    NSArray *children = [NSArray arrayWithObject:childModel];
    [allModel setValue:children forKey:_childrenKey];
    [_models insertObject:allModel atIndex:0];
}

- (void)addChildrenAllModelWithParentIdKey:(NSString *)parentIdKey childParentIdKey:(NSString *)childParentIdKey {
    if (_parentClass == NSObject.class || _childClass == NSObject.class) {
        return;
    }
    
    if (!parentIdKey || !childParentIdKey) {
        return;
    }
    
    for (NSObject *parentModel in _models) {
        NSArray *children = [parentModel valueForKey:_childrenKey];
        NSMutableArray *mutableChildren = [NSMutableArray arrayWithArray:children];
        NSObject *childModel = [_childClass alloc];
        childModel = [childModel init];
        [childModel setValue:@"不限" forKey:_childNameKey];
        NSString *parentId = [parentModel valueForKey:parentIdKey];
        [childModel setValue:parentId forKey:childParentIdKey];
        [mutableChildren insertObject:childModel atIndex:0];
        [parentModel setValue:mutableChildren forKey:_childrenKey];
    }
}

@end
