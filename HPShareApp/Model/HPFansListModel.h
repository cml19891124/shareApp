//
//  HPFansListModel.h
//  HPShareApp
//
//  Created by HP on 2018/12/11.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPFansListModel : NSObject
@property (nonatomic, copy) NSString *followed_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *email;

@end

NS_ASSUME_NONNULL_END
