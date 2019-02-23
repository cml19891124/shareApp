//
//  HPHotKeywordCell.h
//  HPShareApp
//
//  Created by HP on 2019/2/23.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
typedef void (^HotSearchKeywordBlock)(NSString *keyword);

NS_ASSUME_NONNULL_BEGIN

@interface HPHotKeywordCell : HPBaseTableViewCell

@property (nonatomic, copy) HotSearchKeywordBlock hotSearchBlock;

@property (nonatomic, strong) UIButton *hotSearchBtn;

@property (nonatomic, strong) NSArray<NSString *> *hotSearchArray;

+ (CGFloat)hotCellHeightWithData:(NSArray *)hotSearchArray;

- (void)setHotViewWithArray:(NSArray *)hotSearchArray;

@end

NS_ASSUME_NONNULL_END
