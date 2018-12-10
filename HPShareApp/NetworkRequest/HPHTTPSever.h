//
//  FSHTTPSever.h
//  FishState
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 caominglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Sucesse)( id  _Nonnull responseObject) ;
typedef void(^Failure)(NSError * _Nonnull  error) ;

@interface HPHTTPSever : NSObject

+ (void)HPServerWithMethod:(nonnull NSString*)method  paraments:(nonnull NSDictionary *)dic complete:(nonnull Sucesse)secesse Failure:(nonnull Failure)failure;
+ (void)HPGETServerWithMethod:(nonnull NSString*)method  paraments:(nonnull NSDictionary *)dic complete:(nonnull Sucesse)secesse Failure:(nonnull Failure)failure;
+ (void)HPSecretServerWithMethod:(nonnull NSString*)method  paraments:(nonnull NSDictionary *)dic complete:(nonnull Sucesse)secesse Failure:(nonnull Failure)failure;
+ (void)HPGETTokenServerWithMethod:(nonnull NSString*)method  paraments:(nonnull NSDictionary *)dic complete:(nonnull Sucesse)secesse Failure:(nonnull Failure)failure;
@end