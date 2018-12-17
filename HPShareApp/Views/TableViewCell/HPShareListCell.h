//
//  HPShareListCell.h
//  HPShareApp
//
//  Created by HP on 2018/11/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPShareListModel.h"

typedef NS_ENUM(NSInteger, HPShareListCellType) {
    HPShareListCellTypeOwner = 1,
    HPShareListCellTypeStartup = 2
};

typedef NS_ENUM(NSInteger, HPSharePriceUnitType) {
    HPSharePriceUnitTypeHour = 1,
    HPSharePriceUnitTypeDay = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface HPShareListCell : HPBaseTableViewCell

@property (nonatomic, assign) BOOL isChecked;

@property (nonatomic, strong) HPShareListModel *model;

- (void)setTitle:(NSString *)title;

- (void)setPrice:(NSString *)price;

- (void)setType:(HPShareListCellType)type;

- (void)setUnitType:(HPSharePriceUnitType)type;

- (void)setTags:(NSArray *)tags;

- (void)setPhotoUrl:(NSString *)url;

- (void)setCheckEnabled:(BOOL)enabled;

- (void)setChecked:(BOOL)isChecked;

@end

NS_ASSUME_NONNULL_END
