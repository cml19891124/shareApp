

#import "HPUserTool.h"
//账号信息存储路径
#define YYCAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.plist"]
@implementation HPUserTool
/**
   9  *  存储账号信息
   10  *
   11  *  @param account 账号模型
   12  */
 +(void)saveAccount:(HPLoginModel *)account
{
    //将一个对象写入沙盒 需要用到一个NSKeyedArchiver 自定义对象的存储必须用这个
    [NSKeyedArchiver archiveRootObject:account toFile:YYCAccountPath];
//    NSLog(@"0000:%@",YYCAccountPath);
}

/**
    21  *  返回账号信息
    22  *
    23  *  @return 账号模型（如果账号过期，我们会返回nil）
    24  */
+(HPLoginModel *)account
{
    //加载模型
    HPLoginModel *account=[NSKeyedUnarchiver unarchiveObjectWithFile:YYCAccountPath];
    
    return account;
    
}
/**
    35  *  删除账号信息
    38  */
+(BOOL)deleteAccount
{
       return [[NSFileManager defaultManager] removeItemAtPath:YYCAccountPath error:nil];
}
@end
