//
//  FSHTTPSever.m
//  FishState
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 caominglei. All rights reserved.
//

#import "HPHTTPSever.h"
#import "HPHTTPManager.h"
#import "Macro.h"
#import <CommonCrypto/CommonDigest.h>
#define MHBaseUrl kBaseUrl


@implementation HPHTTPSever

+ (void)HPPostServerWithMethod:(nonnull NSString*)method paraments:(nonnull NSDictionary *)dic needToken:(BOOL)isNeed complete:(nonnull Success)success Failure:(nonnull Failure)failure{
   
    [HPHTTPSever HPPostServerWithMethod:method paraments:dic needToken:isNeed complete:success Progress:nil Failure:failure];
}

+ (void)HPPostServerWithMethod:(nonnull NSString*)method paraments:(nonnull NSDictionary *)dic needToken:(BOOL)isNeed complete:(nonnull Success)success Progress:(Progress)progress Failure:(nonnull Failure)failure{
    
    HPHTTPManager *manager = [HPHTTPManager shareHPHTTPManage];
    // 解析数据需要
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    
    if (isNeed) {
        HPLoginModel *account = [HPUserTool account];
        [manager.requestSerializer setValue:account.token?:@"" forHTTPHeaderField:@"token"];//@"3ef815416f775098fe977004015c6193"
    }
    
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
    
    [manager.requestSerializer setTimeoutInterval:10];
    NSString * urlString  = [NSString stringWithFormat:@"%@%@",MHBaseUrl,method];
    
    [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            请求失败。
        
        //  NSString * str1 = [[urlString componentsSeparatedByString:@"method="]lastObject];
        //  NSString * nameStr =[[str1 componentsSeparatedByString:@"&sign"] firstObject];
        //    [XHToast showCenterWithText:[NSString stringWithFormat:@"%@-链接超时",nameStr]];
        
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HPSecretServerWithMethod:(nonnull NSString*)method  paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure{
    
    //  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    HPHTTPManager *manager = [HPHTTPManager shareHPHTTPManage];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
    
    
    [manager.requestSerializer setTimeoutInterval:15];
    NSString * urlString  = [NSString stringWithFormat:@"%@%@",MHBaseUrl,method];
    
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            请求失败。
        
       
        
        
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)HPGETServerWithMethod:(nonnull NSString*)method isNeedToken:(BOOL)isNeed paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure{
    HPHTTPManager *manager = [HPHTTPManager shareHPHTTPManage];
    if (isNeed) {
        HPLoginModel *account = [HPUserTool account];
        [manager.requestSerializer setValue:account.token?:@"" forHTTPHeaderField:@"token"];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
    [manager.requestSerializer setTimeoutInterval:10];
    NSString * urlString  = [NSString stringWithFormat:@"%@%@",MHBaseUrl,method];
    
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            请求失败。
        
        //  NSString * str1 = [[urlString componentsSeparatedByString:@"method="]lastObject];
        //  NSString * nameStr =[[str1 componentsSeparatedByString:@"&sign"] firstObject];
        //    [XHToast showCenterWithText:[NSString stringWithFormat:@"%@-链接超时",nameStr]];
        
        
        if (failure) {
            failure(error);
        }
    }];

}


+ (void)HPGETServerWithMethodNoAppendingUrl:(nonnull NSString*)method isNeedToken:(BOOL)isNeed paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure{
    HPHTTPManager *manager = [HPHTTPManager shareHPHTTPManage];
    if (isNeed) {
        HPLoginModel *account = [HPUserTool account];
        [manager.requestSerializer setValue:account.token?:@"" forHTTPHeaderField:@"token"];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
    [manager.requestSerializer setTimeoutInterval:10];
    NSString * urlString  = [NSString stringWithFormat:@"%@",method];
    
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            请求失败。
        
        //  NSString * str1 = [[urlString componentsSeparatedByString:@"method="]lastObject];
        //  NSString * nameStr =[[str1 componentsSeparatedByString:@"&sign"] firstObject];
        //    [XHToast showCenterWithText:[NSString stringWithFormat:@"%@-链接超时",nameStr]];
        
        
        if (failure) {
            failure(error);
        }
    }];
    
}

- (NSString* _Nonnull)returnMD5StrWithDict:(NSMutableDictionary* _Nonnull)mutDict{
    [mutDict setValue:@"app_key" forKey:@"HLXWDHXB6BXAK0XLWD"];
    NSArray *keysArray = [mutDict allKeys];
    NSArray *resultArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    NSString * endStr ;
    for (int i =0; i<resultArray.count; i++) {
        
        
        NSString * tempStr =[NSString stringWithFormat:@"%@=%@",resultArray[i],[mutDict objectForKey:resultArray[i]]];
        
        
        
        endStr = [NSString stringWithFormat:@"%@&%@",endStr,tempStr];
        if (!endStr) {
            endStr = tempStr;
        }
        
    }
    
    //return nil;
    return [self md5:endStr];
}
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
