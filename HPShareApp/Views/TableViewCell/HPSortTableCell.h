//
//  HPSelectTableCell.h
//  HPShareApp
//
//  Created by Jay on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPSortTableCell : HPBaseTableViewCell

@property (nonatomic, readonly) BOOL isCheck;

@property (nonatomic, strong) NSString *title;

- (void)setCheck:(BOOL)isCheck;

@end

NS_ASSUME_NONNULL_END
