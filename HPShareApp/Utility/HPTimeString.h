//
//  HPTimeString.h
//  HPShareApp
//
//  Created by HP on 2018/12/6.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPTimeString : NSObject
//获取当前的时间

+(NSString*)getCurrentTimes;
//获取当前时间戳有两种方法(以秒为单位)

+(NSString *)getNowTimeTimestamp;
+(NSString *)getNowTimeTimestamp2;
//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3;
@end

NS_ASSUME_NONNULL_END
