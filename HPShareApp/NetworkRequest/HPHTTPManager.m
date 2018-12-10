//
//  FSHTTPManager.m
//  FishState
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 caominglei. All rights reserved.
//

#import "HPHTTPManager.h"

@implementation HPHTTPManager

+ (HPHTTPManager*)shareHPHTTPManage{
    
    static  HPHTTPManager * manage = nil ;
    static dispatch_once_t onceManager;
    dispatch_once(&onceManager, ^{
        manage = [[self class]new];
    });
    return manage ;
}

@end
