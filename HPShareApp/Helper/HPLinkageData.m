//
//  HPLinkageData.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLinkageData.h"

@interface HPLinkageData ()

@property (nonatomic, copy) NSArray *parents;

@property (nonatomic, copy) NSDictionary *children;

@end

@implementation HPLinkageData

- (instancetype)initWithParents:( NSArray * _Nonnull )parents Children:( NSDictionary * _Nonnull )children {
    self = [self init];
    if (self) {
        _parents = parents;
        _children = children;
    }
    return self;
}

- (NSString *)getParentAtIndex:(NSInteger)index {
    if (index >= _parents.count || index < 0) {
        return nil;
    }
    
    return _parents[index];
}

- (NSInteger)getParentCount {
    return _parents.count;
}

- (NSInteger)getChildrenCountOfParent:(NSString *)parent {
    NSArray *childrenArray = _children[parent];
    
    if (childrenArray && [childrenArray isKindOfClass:NSArray.class]) {
        return childrenArray.count;
    }
    else
        return 0;
}

- (NSString *)getChildOfParent:(NSString *)parent atIndex:(NSInteger)index {
    NSArray *childrenArray = _children[parent];
    
    if (childrenArray && [childrenArray isKindOfClass:NSArray.class] &&index < childrenArray.count && index >= 0) {
        return childrenArray[index];
    }
    else
        return nil;
}

@end
