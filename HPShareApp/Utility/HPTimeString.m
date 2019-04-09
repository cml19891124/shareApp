//
//  HPTimeString.m
//  HPShareApp
//
//  Created by HP on 2018/12/6.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTimeString.h"
#import "Macro.h"

@implementation HPTimeString
//获取当前的时间

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"HH:mm"];

    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//字符串日期转秒数
+ (NSTimeInterval)dateStrToSeconds:(NSString *)str
{
     NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
     [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
     NSDate *date = [formatter dateFromString:str];
     NSTimeInterval seconds = [date timeIntervalSince1970];
     return seconds;
}

//秒数转字符串日期
+ (NSString *)secondsToDateStr:(NSTimeInterval)seconds
{
     NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
     NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
     [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
     return [formatter stringFromDate:date];
}

//20190408转字符串日期2019年04月08日
+ (NSString *)noPortraitLineToDateStr:(NSString *)dateTime
{
    NSMutableString *time = [[NSMutableString alloc] initWithString:dateTime];
    [time insertString:@"年" atIndex:4];
    [time insertString:@"月" atIndex:7];
    [time insertString:@"日" atIndex:10];

    return time;
}

+ (NSString *)getDatesStringWithStartTime:(long long)startTime andEndTime:(long long)endTime
{
    NSMutableArray *dates = [NSMutableArray array];
//    long long nowTime = 1471491674, //开始时间
//    endTime = 1472528474,//结束时间
    long long dayTime = 24*60*60,
    time = startTime - startTime%dayTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    while (time < endTime) {
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [dates addObject:showOldDate];
        time += dayTime;
    }
    return [dates componentsJoinedByString:@","];
}

//服务器要的日期格式2019-04-08 00:00:00
+ (NSString *)getNeedLineDateFormatter:(NSString *)date
{
    NSString *firstDate = [date stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *monthDate = [firstDate stringByReplacingOccurrencesOfString:@"月" withString:@"-"];

    NSString *finalDate = [monthDate stringByReplacingOccurrencesOfString:@"日" withString:@""];
    
    return [NSString stringWithFormat:@"%@ 23:59:59",finalDate];
}

//服务器要的日期格式
+ (NSString *)getNeedDateFormatter:(NSString *)time
{
    NSString *y = [time substringToIndex:4];
    NSString *m = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *d = [time substringWithRange:NSMakeRange(time.length - 3, 2)];
    NSString *stTime = [NSString stringWithFormat:@"%@%@%@",y,m,d];
    return stTime;
}

+(NSString*)getCurrentTimesWithSeconds{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
        [formatter setDateFormat:PATTERN_STANDARD08W];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当前时间戳有两种方法(以秒为单位)

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}



+(NSString *)getNowTimeTimestamp2{
    
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    
    return timeString;
    
}

//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp:(NSString *)timeStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSString *dateStr = timeStr;
    
//    dateFormatter.dateFormat=@"yyyy-mm-dd "//后面的hh:mm:ss不写可以吗?答案不写不可以
    
    HPLog(@"%@",[formatter dateFromString:dateStr]);//现在时间,你可以输出来看下是什么格式
    
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateStr timeIntervalSince1970]*1000];
    
    return dateStr;
    
}

+ (NSString *)getYearMonthDayDates:(long long)startTime andEndTime:(long long)endTime
{
    NSMutableArray *dates = [NSMutableArray array];
    startTime = 1471491674; //开始时间
    endTime = 1472528474;//结束时间
    long dayTime = 24*60*60;
    long time = startTime - startTime%dayTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    while (time < endTime) {
        NSString *showOldDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [dates addObject:showOldDate];
        time += dayTime;
    }
    return [dates componentsJoinedByString:@","];
}

+ (NSString *)getDatesWithStartDate:(NSString *)startDate endDate:(NSString *)endDate {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    
    //字符串转时间
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"yyyyMMdd";
    NSDate *start = [matter dateFromString:startDate];
    NSDate *end = [matter dateFromString:endDate];
    
    NSMutableArray *componentAarray = [NSMutableArray array];
    NSComparisonResult result = [start compare:end];
    NSDateComponents *comps;
    while (result != NSOrderedDescending) {
        comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitWeekday fromDate:start];
        [componentAarray addObject:start];
        
        //后一天
        [comps setDay:([comps day]+1)];
        start = [calendar dateFromComponents:comps];
        
        //对比日期大小
        result = [start compare:end];
    }
    return [componentAarray componentsJoinedByString:@","];
}

+ (NSString *)getPassTimeSometimeWith:(NSDate *)date
{
    //首先，我们设置一下时间格式：
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"YYYY年MM月dd日"];
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"HH:mm"];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0*3600]];
    [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0*3600]];

    //获取传过来的时间的时分
    NSString *hoursandSec = [fo stringFromDate:date];
    
    //获取传过来的时间的date
    NSString *createDate = [format stringFromDate:date];
    //然后获取今天和昨天的年月日：
    
    
    //获取今天
    NSDate *nowDate = [NSDate date];
    NSString *today = [format stringFromDate:nowDate];
    
    //获取昨天
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterday = [format stringFromDate:yesterdayDate];
    
    //然后对比返回数据即可：

    if ([createDate isEqualToString:today]) {
        return [NSString stringWithFormat:@"今天%@",hoursandSec];
    }else if ([createDate isEqualToString:yesterday])
    {
        return [NSString stringWithFormat:@"昨天%@",hoursandSec];
    }else
    {
        return [NSString stringWithFormat:@"%@ %@",createDate,hoursandSec];
    }

}

+ (NSString *)gettimeInternalFromPassedTimeToNowDate:(NSString *)passTime
{
    NSDate *nowDate = [NSDate date]; // 当前时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
//    NSDate *creat = [formatter dateFromString:passTime]; // 传入的时间
    
    // 这里有个需要注意的地方，不要将时间戳的字符串直接作为creat_time ，如果是时间戳，那么
//    NSString *timeString = @"1532754000"; // 时间戳字符串
    NSTimeInterval time = [passTime doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000 (注意： 这句话不要全盘复制，如果传入的时间戳没有精确到毫秒不要除1000)
    NSDate *creat =[NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:creat toDate:nowDate options:0];
    HPLog(@"year=%zd  month=%zd  day=%zd hour=%zd  minute=%zd",compas.year,compas.month,compas.day,compas.hour,compas.minute);
    NSString *leftTime = [NSString stringWithFormat:@"%zd小时:%zd分钟",compas.hour,compas.minute];
    return leftTime;
}

+ (NSString *)getPassTimeSometimeWithHorFormatter:(NSDate *)date
{
    //首先，我们设置一下时间格式：
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"YYYY-MM-dd"];
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"HH:mm"];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0*3600]];
    [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0*3600]];
    
    //获取传过来的时间的时分
    NSString *hoursandSec = [fo stringFromDate:date];
    
    //获取传过来的时间的date
    NSString *createDate = [format stringFromDate:date];
    //然后获取今天和昨天的年月日：
    
    
    //获取今天
    NSDate *nowDate = [NSDate date];
    NSString *today = [format stringFromDate:nowDate];
    
    //获取昨天
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterday = [format stringFromDate:yesterdayDate];
    
    //然后对比返回数据即可：
    
    if ([createDate isEqualToString:today]) {
        return [NSString stringWithFormat:@"今天%@",hoursandSec];
    }else if ([createDate isEqualToString:yesterday])
    {
        return [NSString stringWithFormat:@"昨天%@",hoursandSec];
    }else
    {
        return [NSString stringWithFormat:@"%@ %@",createDate,hoursandSec];
    }
    
}


+ (NSDate *)getLocateTime:(unsigned int)timeStamp {
    
    double dTimeStamp = (double)timeStamp;
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dTimeStamp];
    
    return confromTimesp;
    
}

//获取当前系统时间的时间戳

#pragma mark - 获取当前时间的 时间戳

+(NSInteger)getNowTimestamp{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间
    
    
    
    HPLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    
    
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    
    
    
    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值
    
    
    
    return timeSp;
    
}

//时间格式的字符串转date
+ (NSDate *)getDateWithString:(NSString *)dateString
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:dateString.doubleValue];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    
    NSLog(@"localDate = %@",localDate);

    return localDate;
}




+(NSString *)date2StringWithDate:(NSDate *)date pattern:(NSString *)pattern{
    if(!date){
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = pattern;
    return  [formatter stringFromDate:date];
    
}
+(NSDate *)string2DateWithString:(NSString *)strDate pattern:(NSString *)pattern{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = PATTERN_STANDARD19H;
    return  [formatter dateFromString:strDate];
}
+(NSString *)getCurrentTimeWithPattern:(NSString *)pattern{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = pattern;
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    return  [formatter stringFromDate:[NSDate date]];
    
}
+(NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"HH:mm";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    return  [formatter stringFromDate:[NSDate date]];
}
+(NSString *)getBeforeDateWithM:(double)m{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:m];
    return [self date2StringWithDate:date pattern:PATTERN_STANDARD10H];;
}
@end
