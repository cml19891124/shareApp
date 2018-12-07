

#import "HPLoginModel.h"

@implementation HPLoginModel
+(instancetype)AccountStatusWithDict:(NSDictionary *)dict
{
    HPLoginModel *account= [[self alloc]init];
    account.token = dict[@"token"];
    account.cardInfo = dict[@"cardInfo"];
    account.userInfo = dict[@"userInfo"];
    return account;
}
+ (NSDictionary *)objectClassInArray

{
    
    return @{@"cardInfo":[HPCardInfo class],
             @"userInfo":[HPUserInfo class]
             };
    
}
/**
 *  当一个对象要归档进沙盒的时候就会调用  归档
 *  目的，在这个方法中说明这个对象的哪些属性写进沙盒
 */
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.cardInfo forKey:@"cardInfo"];
    [encoder encodeObject:self.userInfo forKey:@"userInfo"];
}

/**
 *  反归档 的时候会调用这个方法  解档
 *  目的：在这个方法中说明这个对象的哪些属性从沙河中解析出来
 从沙河中解析对象 反归档会调用这个方法 需要解析哪些属性
 */
-(instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self=[super init]) {
        self.token=[decoder decodeObjectForKey:@"token"];
        self.cardInfo=[decoder decodeObjectForKey:@"cardInfo"];
        self.userInfo=[decoder decodeObjectForKey:@"userInfo"];
    }
    return self;
}

@end


@implementation HPCardInfo

@end

@implementation HPUserInfo

@end
