//
//  HPLocateHistory.m
//  HPShareApp
//
//  Created by Jay on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLocateHistory.h"

#define HPLocateHistoryPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"locateHistory.plist"]

@implementation HPLocateHistory

+ (void)saveHistory:(NSArray<HPAddressModel *> *)history {
    //将一个对象写入沙盒 需要用到一个NSKeyedArchiver 自定义对象的存储必须用这个
    [NSKeyedArchiver archiveRootObject:history toFile:HPLocateHistoryPath];
    //    NSLog(@"0000:%@",YYCAccountPath);
}

/**
 21  *  返回账号信息
 22  *
 23  *  @return 账号模型（如果账号过期，我们会返回nil）
 24  */
+ (NSArray<HPAddressModel *> *)history {
    //加载模型
    NSArray<HPAddressModel *> *history=[NSKeyedUnarchiver unarchiveObjectWithFile:HPLocateHistoryPath];
    
    return history;
    
}

+ (void)addHistory:(HPAddressModel *)history {
    NSArray<HPAddressModel *> *histories = [HPLocateHistory history];
    NSMutableArray *mutableHistories;
    if (histories == nil) {
        mutableHistories = [[NSMutableArray alloc] init];
    }
    else {
        mutableHistories = [[NSMutableArray alloc] initWithArray:histories];
    }
    
    for (HPAddressModel *modelItem in mutableHistories) {
        if ([modelItem.formattedAddress isEqualToString:history.formattedAddress]) {
            return;
        }
    }
    [mutableHistories addObject:history];
    [HPLocateHistory saveHistory:mutableHistories];
}

/**
 35  *  删除账号信息
 38  */
+ (BOOL)deleteHistory {
    return [[NSFileManager defaultManager] removeItemAtPath:HPLocateHistoryPath error:nil];
}

@end
