//
//  HPSelectTable.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"
#import "HPSelectTableLayout.h"

@class HPSelectTable;
/**
 HPSelectTable代理
 */
@protocol HPSelectTableDelegate

@optional

/**
 选中某个选项之后的代理回调

 @param selectTable 代理的 HPSelectTable
 @param text 选中的选项标题
 @param index 选中的选项索引
 */
- (void)selectTable:(HPSelectTable *)selectTable didSelectText:(NSString *)text atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 单选矩阵表，类似checkBox
 */
@interface HPSelectTable : HPBaseView

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<HPSelectTableDelegate> delegate;

/**
 根据选项数组初始化，单列

 @param options 选项数组
 @return HPSelectTable
 */
- (instancetype)initWithOptions:(NSArray *)options;

/**
 根据选项数组和布局对象初始化

 @param options 选项数组
 @param layout 布局对象
 @return HPSelectTable
 */
- (instancetype)initWithOptions:(NSArray *)options layout:(HPSelectTableLayout *)layout;

/**
 设置某个选项的选中状态

 @param index 要设置选项的索引
 @param selected 选中状态
 */
- (void)setBtnAtIndex:(NSInteger)index selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
