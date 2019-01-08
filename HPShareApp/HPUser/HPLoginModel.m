

#import "HPLoginModel.h"
#import "MJExtension.h"
#import <objc/runtime.h>

@implementation HPLoginModel

+(instancetype)AccountStatusWithDict:(NSMutableDictionary *)dict
{
    HPLoginModel *account = [HPLoginModel mj_objectWithKeyValues:dict];
    HPUserInfo *userInfo = [HPUserInfo UserInfoWithDict:dict[@"userInfo"]];
    account.userInfo = userInfo;

    HPCardInfo *cardInfo = [HPCardInfo CardInfoWithDict:dict[@"cardInfo"]];
    account.cardInfo = cardInfo;
    
    HPSalesman *salesman = [HPSalesman SalesmanInfoWithDict:dict[@"salesman"]];
    account.salesman = salesman;
    return account;
}

/**
 *  当一个对象要归档进沙盒的时候就会调用  归档
 *  目的，在这个方法中说明这个对象的哪些属性写进沙盒
 */
-(void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    Ivar *ivarList =  class_copyIvarList(HPLoginModel.class, &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivarList);
}

/**
 *  反归档 的时候会调用这个方法  解档
 *  目的：在这个方法中说明这个对象的哪些属性从沙河中解析出来
 从沙河中解析对象 反归档会调用这个方法 需要解析哪些属性
 */
-(instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self=[super init]) {
        unsigned int count = 0;
        Ivar *ivarList =  class_copyIvarList(self.class, &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivarList[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [decoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivarList);
    }
    return self;
}

@end


@implementation HPCardInfo
+(instancetype)CardInfoWithDict:(NSDictionary *)dict
{
    HPCardInfo *account = [HPCardInfo mj_objectWithKeyValues:dict];
    
    return account;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivarList =  class_copyIvarList(HPCardInfo.class, &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivarList);
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        unsigned int count = 0;
        Ivar *ivarList =  class_copyIvarList(HPCardInfo.class, &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivarList[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivarList);

    }
    return self;
}
@end

@implementation HPUserInfo

+(instancetype)UserInfoWithDict:(NSDictionary *)dict
{
    HPUserInfo *account = [HPUserInfo mj_objectWithKeyValues:dict];
    return account;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivarList =  class_copyIvarList(HPUserInfo.class, &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivarList);
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        unsigned int count = 0;
        Ivar *ivarList =  class_copyIvarList(HPUserInfo.class, &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivarList[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivarList);
        
    }
    return self;
}

@end

@implementation HPSalesman

+(instancetype)SalesmanInfoWithDict:(NSDictionary *)dict
{
    HPSalesman *account = [HPSalesman mj_objectWithKeyValues:dict];
    return account;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivarList =  class_copyIvarList(HPSalesman.class, &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivarList);
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        unsigned int count = 0;
        Ivar *ivarList =  class_copyIvarList(HPSalesman.class, &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivarList[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivarList);
        
    }
    return self;
}

@end
