//
//  HPUploadImageHandle.h
//  HPShareApp
//
//  Created by HP on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPLoginModel.h"
#import "HPUserTool.h"
#import "Macro.h"

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSError *error);
NS_ASSUME_NONNULL_BEGIN

@interface HPUploadImageHandle : NSObject
+ (void)sendGETWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

/**
 发送一张图片
 */
+ (void)sendPOSTWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;
+ (void)sendPOSTWithUrlStr:(NSString *)url parameters:(NSString *)string success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
