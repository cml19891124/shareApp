//
//  UIView + Tag.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 为 UIView 添加标签字符串属性。
 */
@interface UIView (Tag)

/**
 标签字符串。
 */
@property (nonatomic, copy) NSString *tagStr;

@end

NS_ASSUME_NONNULL_END
