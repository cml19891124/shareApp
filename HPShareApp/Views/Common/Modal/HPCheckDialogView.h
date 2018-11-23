//
//  HPCheckDialogView.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"
#import "HPCheckDialogLayout.h"

/**
 对话框的选择类型。

 - HPCheckDialogSelectTypeSingle: 单选
 - HPCheckDialogSelectTypeMutiple: 多选
 */
typedef NS_ENUM(NSInteger, HPCheckDialogSelectType) {
    HPCheckDialogSelectTypeSingle = 0,
    HPCheckDialogSelectTypeMutiple
};

NS_ASSUME_NONNULL_BEGIN

/**
 选择对话框，可单选或多选
 */
@interface HPCheckDialogView : HPBaseDialogView

/**
 对话框选择类型
 */
@property (nonatomic) HPCheckDialogSelectType selectType;

/**
 对话框选中的多选选项
 */
@property (nonatomic, strong) NSMutableArray *checkItems;

/**
 对话框选中的单选选项
 */
@property (nonatomic, copy) NSString *checkItem;

/**
 根据布局对象 HPCheckDialogLayout 和选项数组初始化

 @param layout 对话框布局对象
 @param itemArray 可供选择的选项数组
 @return HPCheckDialogView
 */
- (instancetype)initWithLayout:(HPCheckDialogLayout *)layout itemArray:(NSArray *)itemArray;

/**
 清空所有选项
 */
- (void)clearCheck;

@end

NS_ASSUME_NONNULL_END
