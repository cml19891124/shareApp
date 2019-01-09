

#import <Foundation/Foundation.h>
@class HPCardInfo,HPUserInfo,HPSalesman;
@interface HPLoginModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong) HPSalesman *salesman;

@property (nonatomic, strong) HPCardInfo *cardInfo;

@property (nonatomic, strong) HPUserInfo *userInfo;

+(instancetype)AccountStatusWithDict:(NSMutableDictionary *)dict;

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
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userId;
+(instancetype)UserInfoWithDict:(NSDictionary *)dict;

@end


@interface HPSalesman : NSObject<NSCoding>
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *salesmanId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *staffCode;
@property (nonatomic, copy) NSString *salesmanName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *avatar;

+(instancetype)SalesmanInfoWithDict:(NSDictionary *)dict;

@end
