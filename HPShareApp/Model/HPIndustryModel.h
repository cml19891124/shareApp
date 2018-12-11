//
//  HPIndustryModel.h
//  HPShareApp
//
//  Created by Jay on 2018/12/11.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPIndustryModel : NSObject

@property (nonatomic, copy) NSString *industryId;

@property (nonatomic, copy) NSString *industryName;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, strong) NSArray *children;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *deleteTime;

@end

NS_ASSUME_NONNULL_END
