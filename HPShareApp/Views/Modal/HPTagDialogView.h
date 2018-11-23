//
//  HPTagDialogView.h
//  HPShareApp
//
//  Created by HP on 2018/11/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 标签选择对话框
 */
@interface HPTagDialogView : HPBaseDialogView

/**
 最多选择标签数
 */
@property (nonatomic, assign) NSInteger maxCheckNum;

/**
 选择的标签
 */
@property (nonatomic, copy, readonly) NSMutableArray *checkItems;

/**
 根据可选择的标签数组初始化

 @param items 可供选择的标签数组
 @return HPTagDialogView
 */
- (instancetype)initWithItems:(NSArray *)items;

@end

NS_ASSUME_NONNULL_END
