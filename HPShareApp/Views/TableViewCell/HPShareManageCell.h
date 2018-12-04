//
//  HPShareManageCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

typedef NS_ENUM(NSInteger, HPShareListCellType) {
    HPShareListCellTypeStartup = 0,
    HPShareListCellTypeOwner
};

NS_ASSUME_NONNULL_BEGIN

@interface HPShareManageCell : HPBaseTableViewCell

@property (nonatomic, weak, readonly) UIButton *editBtn;

@property (nonatomic, weak, readonly) UIButton *deleteBtn;

- (void)setTitle:(NSString *)title;

- (void)setTrade:(NSString *)trade;

- (void)setRentTime:(NSString *)rentTime;

- (void)setArea:(NSString *)area;

- (void)setPrice:(NSString *)price;

- (void)setTagType:(HPShareListCellType)type;

- (void)setReleaseTime:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
