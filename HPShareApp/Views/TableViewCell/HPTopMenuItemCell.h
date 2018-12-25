//
//  HPTopMenuItemCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPMenuOpenStoreView.h"
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
typedef void (^SelectItemInICarouselBlock)(NSString *model);
typedef void (^ClickMenuItemBlock)(NSInteger HPHomeShareMenuItem);

NS_ASSUME_NONNULL_BEGIN

@interface HPTopMenuItemCell : HPBaseTableViewCell

@property (nonatomic, strong) UIView *bannerView;

@property (nonatomic, copy) SelectItemInICarouselBlock selectItemInICarouselBlock;
@property (nonatomic, copy) ClickMenuItemBlock clickMenuItemBlock;
@end

NS_ASSUME_NONNULL_END
