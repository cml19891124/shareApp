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

- (instancetype)initWithParents:( NSArray * _Nonnull )parents Children:( NSDictionary * _Nonnull )children;

- (NSString *)getParentAtIndex:(NSInteger)index;

- (NSString *)getChildOfParent:(NSString *)parent atIndex:(NSInteger)index;

- (NSInteger)getParentCount;

- (NSInteger)getChildrenCountOfParent:(NSString *)parent;

@end

NS_ASSUME_NONNULL_END
