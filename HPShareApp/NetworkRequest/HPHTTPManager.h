//
//  FSHTTPManager.h
//  FishState
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 caominglei. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@interface HPHTTPManager : AFHTTPSessionManager
+ (HPHTTPManager*)shareHPHTTPManage;

@end
