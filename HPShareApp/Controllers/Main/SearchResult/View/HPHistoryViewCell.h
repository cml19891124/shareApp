//
//  HPHistoryViewCell.h
//  HPShareApp
//
//  Created by HP on 2019/2/19.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
typedef void (^SearchTapHistoryBlock)(NSString *keyword);
NS_ASSUME_NONNULL_BEGIN

@interface HPHistoryViewCell : HPBaseTableViewCell

@property (nonatomic, strong) UIButton *historyBtn;

@property (nonatomic, strong) NSArray<NSString *> *historyArray;

@property (nonatomic, copy) SearchTapHistoryBlock keywordBlcok;

+ (CGFloat)historyCellHeightWithData:(NSArray *)historyArray;

- (void)setHistroyViewWithArray:(NSArray *)historyArray;
@end

NS_ASSUME_NONNULL_END
