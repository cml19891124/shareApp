//
//  HPOpenNumberTool.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPOperationNumberTool : NSObject

/*
 * 将数字转为每隔3位整数由逗号“,”分隔的字符串
 */
+ (NSString *)separateNumberUseCommaWith:(NSString *)number;

@end

NS_ASSUME_NONNULL_END
