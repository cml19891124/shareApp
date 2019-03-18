//
//  JCHATLoginTool.m
//  HPShareStore
//
//  Created by HP on 2019/3/18.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "JCHATLoginTool.h"

#import <JMessage/JMessage.h>

@implementation JCHATLoginTool

+ (void)regiestJMessage:(HPLoginModel *)account result:(JpushRegiest)result
{
    JMSGUserInfo *userInfo = [JMSGUserInfo new];
    userInfo.nickname = account.userInfo.username;
    userInfo.signature = account.cardInfo.signature;
    NSString *imAccount = [NSString stringWithFormat:@"hepai%@",account.userInfo.userId];
    
    [JMSGUser registerWithUsername:imAccount password:@"hepai123" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //极光注册成功
            if (resultObject) {
                result(resultObject,error);
            }
        } else {
            //极光注册失败
            [HPProgressHUD alertMessage:@"注册极光失败"];
        }
    }];
}

#pragma mark - 登录im
+ (void)loginJMessage:(HPLoginModel *)account result:(JpushLogin)result
{
     if (!account.token) {
        [HPProgressHUD alertMessage:@"请登录"];
        return;
    }
    NSString *imAccount = [NSString stringWithFormat:@"hepai%@",account.userInfo.userId];
    
    [JMSGUser loginWithUsername:imAccount password:@"hepai123" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //登录成功
            if (!kObjectIsEmpty(resultObject)) {
                result(resultObject,error);
            }
            
        } else {
            //登录失败
            NSString * errorStr = [JCHATStringUtils errorAlert:error];
            if ([errorStr isEqualToString:@"用户名不合法"]||[errorStr isEqualToString:@"用户名还没有被注册过"]) {
                HPLog(@"登录极光失败");
            }
        }
    }];
}

+ (void)updateMyAvatar:(HPLoginModel *)account result:(JpushUploadAvatar)result
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:account.userInfo.avatarUrl]];
    [JMSGUser updateMyAvatarWithData:imageData avatarFormat:@"" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            HPLog(@"图像上传成功");

            result(resultObject,error);
        }else{
            HPLog(@"图像上传失败");
        }
    } ];
}

+ (void)getThumbAvatar:(JMSGUser *)user Result:(JpushGetVartar)result
{
    return [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        result(data,objectId,error);
    }];
}
@end
