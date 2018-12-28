//
//  HPLinkageData.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPLinkageData : NSObject

@property (nonatomic, copy) NSString *parentNameKey;

@property (nonatomic, copy) NSString *childNameKey;

- (instancetype)initWithModels:(NSArray * _Nonnull)models;

- (void)setModels:(NSArray *)models;

- (NSString *)getParentNameAtIndex:(NSInteger)index;

- (NSString *)getChildNameOfParentIndex:(NSInteger)parentIndex atChildIndex:(NSInteger)childIndex;

- (NSObject *)getChildModelOfParentIndex:(NSInteger)parentIndex atChildIndex:(NSInteger)childIndex;

- (NSInteger)getParentCount;

- (NSInteger)getChildrenCountOfParentIndex:(NSInteger)index;

- (void)addParentAllModel;

- (void)addChildrenAllModelWithParentIdKey:(NSString *)parentIdKey childParentIdKey:(NSString *)childParentIdKey;

@end

NS_ASSUME_NONNULL_END
