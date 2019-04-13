//
//  HPPassportModel.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/13.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPPassportModel : NSObject

@property (nonatomic, copy) NSString *number;

@property (nonatomic, strong) NSNumber *auditStatus;

@end

NS_ASSUME_NONNULL_END
