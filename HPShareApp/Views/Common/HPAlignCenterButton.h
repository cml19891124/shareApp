//
//  HPAlignCenterButton.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPBaseControl.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Image 在 title 正上方的 Button。
 */
@interface HPAlignCenterButton : HPBaseControl

/**
 image 和 title 的间距，默认为 -1.f, 即不设定间距，image 对齐顶部， title 对齐底部，间距随Button大小变化。
 */
@property (nonatomic, assign) CGFloat space;

/**
 title 字体。
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 title 字体颜色。
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 title 字符串。
 */
@property (nonatomic, copy) NSString *text;

/**
 根据传入 image 初始化。

 @param image button 的 icon
 @return self
 */
- (instancetype)initWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
