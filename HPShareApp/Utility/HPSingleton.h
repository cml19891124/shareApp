//
//  HPSingleton.h
//  HPShareApp
//
//  Created by HP on 2019/1/17.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPSingleton : NSObject

@property (nonatomic, strong) NSArray *bannerArray;

+ (instancetype)sharedSingleton;

@end

NS_ASSUME_NONNULL_END
