//
//  HPUpdateVersionTool.m
//  HPShareApp
//
//  Created by HP on 2019/2/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUpdateVersionTool.h"
#import "Macro.h"

@implementation HPUpdateVersionTool

+ ( BOOL)updateAppVersionTool
{
        // 耗时的操作
        
        //获取本地版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *newVersion = [NSString stringWithFormat:@"%@", version];
        NSArray *currentVersionArr = [newVersion componentsSeparatedByString:@"."];
        NSString *currentVersion =@"";
        for (int i = 0;i < currentVersionArr.count; i++) {
            currentVersion = [currentVersion stringByAppendingString:currentVersionArr[i]];
        }
        //获取appStore网络版本号
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kAppleId]];
        NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [file dataUsingEncoding:NSUTF8StringEncoding];
        // 判断是否取到信息
        if (![data isKindOfClass:[NSData class]]) {
            return NO;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //获得上线版本号
        NSString *getVersion = [[[dic objectForKey:@"results"]firstObject]objectForKey:@"version"];
        NSArray *appStoreVersionArr = [getVersion componentsSeparatedByString:@"."];
        NSString *onlineVersion = @"";
        for (int i = 0;i < appStoreVersionArr.count; i++) {
            onlineVersion = [onlineVersion stringByAppendingString:appStoreVersionArr[i]];
        }
    
            // 更新界面
            //如果不一样去更新
            if([currentVersion intValue] < [onlineVersion intValue])
            {
                return YES;
            }else{
                return NO;
            }
    
}

@end
