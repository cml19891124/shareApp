//
//  HPAlertAction.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 HPAlertAction 的回调类型
 */
typedef void (^Completion)(void);

/**
 定义HPAlertSheet的选项
 */
@interface HPAlertAction : NSObject

/**
 选项标题
 */
@property (nonatomic, strong) NSString *title;

/**
 选项回调
 */
@property (nonatomic, strong) Completion completion;

/**
 根据标题和选项回调初始化

 @param title 选项标题
 @param completion 选项回调
 @return HPAlertAction
 */
- (instancetype)initWithTitle:(NSString *)title completion:(Completion)completion;

@end
