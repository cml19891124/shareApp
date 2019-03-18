//
//  JCHATLoginTool.h
//  HPShareStore
//
//  Created by HP on 2019/3/18.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JpushRegiest)(id _Nullable obj,NSError * _Nullable error);

typedef void(^JpushLogin)(id _Nullable obj,NSError * _Nullable error);

typedef void(^JpushUploadAvatar)(id _Nullable obj,NSError * _Nullable error);

typedef void (^JpushGetVartar)(NSData *data, NSString *objectId, NSError *error);

#import "JCHATStringUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCHATLoginTool : NSObject

/**
 登录im
 */
+ (void)regiestJMessage:(HPLoginModel *)account result:(JpushRegiest)result;

/**
 登录im
 */
+ (void)loginJMessage:(HPLoginModel *)account result:(JpushLogin)result;

/**
 上传用户头像到im服务器
 */
+ (void)updateMyAvatar:(HPLoginModel *)account result:(JpushUploadAvatar)result;


/**
 获取极光用户头像,根据返回结果判断是否需要上传头像
 */
+ (void)getThumbAvatar:(JMSGUser *)user Result:(JpushGetVartar)result;

@end

NS_ASSUME_NONNULL_END
