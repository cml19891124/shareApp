//
//  HPLinkageSheetView.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
#import "HPLinkageData.h"

/**
 点击确认按钮触发的回调 Block 类型

 @param selectedParent 选中的父类选项
 @param checkItems 选中的子类选项
 */
typedef void(^BtnConfirmCallback)(NSString * _Nullable selectedParent, NSArray * _Nullable checkItems, NSObject * _Nullable selectedChildModel);

NS_ASSUME_NONNULL_BEGIN

/**
 底部弹出的联动选择列表 SheetView
 */
@interface HPLinkageSheetView : HPBaseModalView

/**
 最大可选个数
 */
@property (nonatomic, assign) NSInteger maxCheckNum;

/**
 是否全部选项单选
 */
@property (nonatomic, assign) BOOL isAllSingleCheck;

/**
 选中的父类选项
 */
@property (nonatomic, strong) NSString *selectedParent;

/**
 选中的子类选项数组
 */
@property (nonatomic, strong) NSMutableArray *checkItems;

/**
 选中的子类选项model
 */
@property (nonatomic, strong) NSObject * _Nullable selectedChildModel;

/**
 点击确认按钮触发回调
 */
@property (nonatomic, strong) BtnConfirmCallback confirmCallback;

/**
 根据选项数据，单选选项数组，是否全部单选初始化

 @param data 选项数据
 @param singleTitles 单选选项数组（选中单选选项，其余选项变为非选中状态）
 @param isAllSingle 是否全部单选，如为YES，全部选项单选，如为NO，则 singleTitles 中的选项单选。
 @return HPLinkageSheetView
 */
- (instancetype)initWithData:(HPLinkageData *)data singleTitles:(NSArray *)singleTitles allSingleCheck:(BOOL)isAllSingle;

/**
 选项描述语

 @param desc 选项描述语
 */
- (void)setSelectDescription:(NSString *)desc;

/**
 选中父选项，及父选项中对应的子选项

 @param pIndex 父选项索引
 @param cIndex 父选项中的子选项索引
 */
- (void)selectCellAtParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex;

/**
 每个子选项都有一个对应的model，model包含父选项子选项的信息， 根据model对应父选项的key，value和对应子选项的key，value选择相应位置的cell

 @param pKey model对应父选项的key
 @param pValue model对应父选项key的value
 @param cKey model对应子选项的key
 @param cValue model对应子选项key的value
 */
- (void)selectCellWithParentKey:(NSString *)pKey value:(NSString *)pValue ChildKey:(NSString *)cKey value:(NSString *)cValue;

@end

NS_ASSUME_NONNULL_END
