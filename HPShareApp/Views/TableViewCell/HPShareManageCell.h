//
//  HPShareManageCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPShareListModel.h"

typedef NS_ENUM(NSInteger, HPShareListCellType) {
    HPShareListCellTypeOwner = 1,
    HPShareListCellTypeStartup
};

typedef NS_ENUM(NSInteger, HPSharePriceUnitType) {
    HPSharePriceUnitTypeHour = 1,
    HPSharePriceUnitTypeDay = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface HPShareManageCell : HPBaseTableViewCell

@property (nonatomic, strong) HPShareListModel *model;

@property (nonatomic, weak, readonly) UIButton *editBtn;

@property (nonatomic, weak, readonly) UIButton *deleteBtn;

- (void)setTitle:(NSString *)title;

- (void)setPrice:(NSString *)price;

- (void)setUnitType:(HPSharePriceUnitType)type;

- (void)setType:(HPShareListCellType)type;

- (void)setReleaseTime:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
