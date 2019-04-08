//
//  HPTimeString.h
//  HPShareApp
//
//  Created by HP on 2018/12/6.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  PATTERN_STANDARD08W  @"yyyyMMdd"
#define  PATTERN_STANDARD12W  @"yyyyMMddHHmm"
#define  PATTERN_STANDARD14W  @"yyyyMMddHHmmss"
#define  PATTERN_STANDARD17W  @"yyyyMMddHHmmssSSS"
#define  PATTERN_STANDARD10H  @"yyyy-MM-dd"
#define  PATTERN_STANDARD16H  @"yyyy-MM-dd HH:mm"
#define  PATTERN_STANDARD19H  @"yyyy-MM-dd HH:mm:ss"
#define  PATTERN_STANDARD10X  @"yyyy/MM/dd"
#define  PATTERN_STANDARD16X  @"yyyy/MM/dd HH:mm"
#define  PATTERN_STANDARD19X  @"yyyy/MM/dd HH:mm:ss"
#define  PATTERN_STANDARD20H  @"HH:mm"
#define  PATTERN_STANDARD21H  @"HH"

NS_ASSUME_NONNULL_BEGIN

@interface HPTimeString : NSObject
//获取当前的时间

+(NSString*)getCurrentTimes;
//获取当前时间戳有两种方法(以秒为单位)

/**
 20190319格式 的当前日期
 */
+(NSString*)getCurrentTimesWithSeconds;

/*
 *服务器要的日期格式
*/
+ (NSString *)getNeedDateFormatter:(NSString *)time;

//服务器要的日期格式2019-04-08 00:00:00
+ (NSString *)getNeedLineDateFormatter:(NSString *)date;

//字符串日期转秒数
+(NSTimeInterval)dateStrToSeconds:(NSString *)str;

//秒数转字符串日期
+ (NSString *)secondsToDateStr:(NSTimeInterval)seconds;
/*
 *20190408转字符串日期2019年04月08日
 */
+ (NSString *)noPortraitLineToDateStr:(NSString *)dateTime;
/**
 获取日期数组字符串
 */
+ (NSString *)getDatesStringWithStartTime:(long long)startTime andEndTime:(long long)endTime;

+ (NSString *)getYearMonthDayDates:(long long)startTime andEndTime:(long long)endTime;

/*
 *获取两天之间的所有日期
 */
+ (NSString *)getDatesWithStartDate:(NSString *)startDate endDate:(NSString *)endDate;

+(NSString *)getNowTimeTimestamp;

+(NSString *)getNowTimeTimestamp2;
//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp:(NSString *)timeStr;
//计算时间差
+ (NSString *)gettimeInternalFromPassedTimeToNowDate:(NSString *)passTime;

/**
 今天/昨天的时间字符串
 */
/**
 获取时间戳转换为date的数据流 今天/昨天/过去的具体z日期加时间点
 */
+ (NSString *)getPassTimeSometimeWith:(NSDate *)date;

+ (NSString *)getPassTimeSometimeWithHorFormatter:(NSDate *)date;

+ (NSDate *)getLocateTime:(unsigned int)timeStamp ;
//获取当前系统时间的时间戳

#pragma mark - 获取当前时间的 时间戳

+(NSInteger)getNowTimestamp;

//时间格式的字符串转date
+ (NSDate *)getDateWithString:(NSString *)dateString;






#pragma mark - 给字符串返回格式日期

/**
 给日期返回固定格式的字符串
 */
+(NSString *)date2StringWithDate:(NSDate *)date pattern:(NSString *)pattern;
/**
 给字符串返回日期
 */
+(NSDate *)string2DateWithString:(NSString *)strDate pattern:(NSString *)pattern;
/**
 获取指定格式的当前日期
 */
+(NSString *)getCurrentTimeWithPattern:(NSString *)pattern;
/**
 获取当前时间 mm:ss
 */
+(NSString *)getCurrentTime;
/**
 获取当前时间过后多少秒
 */
+(NSString *)getBeforeDateWithM:(double)m;
@end

NS_ASSUME_NONNULL_END
