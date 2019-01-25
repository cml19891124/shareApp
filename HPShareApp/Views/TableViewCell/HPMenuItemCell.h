//
//  HPMenuItemCell.h
//  HPShareApp
//
//  Created by HP on 2019/1/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPMenuCellbutton.h"

typedef NS_ENUM(NSInteger, HPHomeShareMenuItem) {
    HPHome_page_store_sharing = 50,
    HPHome_page_lobby_sharing,
    HPHome_page_other_sharing,
    HPHome_page_map,
    HPHome_page_stock_purchase,
    HPHome_page_shelf_rental,
    HPHome_page_used_shelves,
    HPHome_page_new_store_opens
};

typedef void (^ClickMenuItemBlock)(NSInteger HPHomeShareMenuItem,NSString *menuString);

NS_ASSUME_NONNULL_BEGIN

@interface HPMenuItemCell : HPBaseTableViewCell

@property (nonatomic, strong) HPMenuCellbutton * menuBtn;

@property (nonatomic, copy) ClickMenuItemBlock clickMenuItemBlock;

@end

NS_ASSUME_NONNULL_END
