//
//  HPUploadImageHandle.m
//  HPShareApp
//
//  Created by HP on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUploadImageHandle.h"
#import "AFNetworking.h"

@implementation HPUploadImageHandle
//网络请求数据
+ (void)sendGETWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}

+ (void)sendPOSTWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    //上传图片/文字，只能POST
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id  _Nonnull formData) {
        //对于图片进行压缩
        UIImage *image = [UIImage imageNamed:@"personal_center_not_login_head"];
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"obj = %@",obj);
        
        successBlock(obj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"error = %@",error);
        ErrorNet
    }];
}

+ (void)sendPOSTWithUrlStr:(NSString *)url parameters:(NSString *)string success:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:string progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}

+ (void)upLoadImages:(NSArray *)images withUrl:(NSString *)url parameterName:(NSString *)name success:(SuccessBlock)successBlock fail:(FailBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    //上传图片/文字，只能POST
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        for (int i = 0; i < images.count; i ++) {
            UIImage *image = images[i];
            //对于图片进行压缩
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
            [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"image_%d.jpg", i] mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"obj = %@",obj);
        
        successBlock(obj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"error = %@",error);
        ErrorNet
    }];
}

@end
