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

/**
 今天/昨天的时间字符串
 */
/**
 获取时间戳转换为date的数据流 今天/昨天/过去的具体z日期加时间点
 */
+ (NSString *)getPassTimeSometimeWith:(NSDate *)date;
+ (NSDate *)getLocateTime:(unsigned int)timeStamp ;
//获取当前系统时间的时间戳

#pragma mark - 获取当前时间的 时间戳

+(NSInteger)getNowTimestamp;

//时间格式的字符串转date
+ (NSDate *)getDateWithString:(NSString *)dateString;
@end

NS_ASSUME_NONNULL_END
