//
//  HPShareListCell.h
//  HPShareApp
//
//  Created by HP on 2018/11/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

typedef NS_ENUM(NSInteger, HPShareListCellType) {
    HPShareListCellTypeStartup = 0,
    HPShareListCellTypeOwner
};

NS_ASSUME_NONNULL_BEGIN

@interface HPShareListCell : HPBaseTableViewCell

- (void)setTitle:(NSString *)title;

- (void)setTrade:(NSString *)trade;

- (void)setRentTime:(NSString *)rentTime;

- (void)setArea:(NSString *)area;

- (void)setPrice:(NSString *)price;

- (void)setTagType:(HPShareListCellType)type;

@end

NS_ASSUME_NONNULL_END
