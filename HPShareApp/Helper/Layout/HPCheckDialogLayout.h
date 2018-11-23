//
//  HPCheckDialogLayout.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 选择对话框的布局对象
 */
@interface HPCheckDialogLayout : NSObject

/**
 选项距离对话框左边的距离，默认 36.f。
 */
@property (nonatomic, assign) CGFloat checkViewLeft;

/**
 选项列间（水平方向）的距离，默认 10.f。
 */
@property (nonatomic, assign) CGFloat itemSpaceX;

/**
 选项行间（水平方向）的距离，默认34.f。
 */
@property (nonatomic, assign) CGFloat itemSpaceY;

/**
 单列选项所占的宽度，默认125.f。
 */
@property (nonatomic, assign) CGFloat colWidth;

/**
 选项的列数，默认1，即单列。
 */
@property (nonatomic, assign) NSInteger colNum;

@end

NS_ASSUME_NONNULL_END
