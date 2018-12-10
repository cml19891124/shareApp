

#import <Foundation/Foundation.h>
@class HPCardInfo,HPUserInfo;
@interface HPLoginModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) HPCardInfo *cardInfo;
@property (nonatomic, copy) HPUserInfo *userInfo;

+(instancetype)AccountStatusWithDict:(NSDictionary *)dict;

@end

@interface HPCardInfo : NSObject<NSCoding>
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *cardcaseId;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userId;
+(instancetype)CardInfoWithDict:(NSDictionary *)dict;

@end

@interface HPUserInfo : NSObject<NSCoding>
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *signatureContext;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *username;
+(instancetype)UserInfoWithDict:(NSDictionary *)dict;

@end