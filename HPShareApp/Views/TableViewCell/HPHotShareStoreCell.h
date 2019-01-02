//
//  HPHotShareStoreCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPHotImageView.h"
#import "HPRightImageButton.h"
typedef void (^ClickMoreBtnBlock)(void);
typedef void (^TapHotImageViewBlock)(NSInteger tag);

typedef NS_ENUM(NSInteger, HPStoresShareAreaIndex) {
    HPStoresShareAreaIndexBaoan = 100,
    HPStoresShareAreaIndexLonghua,
    HPStoresShareAreaIndexNanshan
};
NS_ASSUME_NONNULL_BEGIN

@interface HPHotShareStoreCell : HPBaseTableViewCell

/**
 标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *hotShareImageArr;

@property (nonatomic, strong) HPHotImageView *areaImageView;
@property (nonatomic, strong) NSArray *areaArray;

@property (nonatomic, strong) HPRightImageButton *moreBtn;
@property (nonatomic, copy) ClickMoreBtnBlock clickMoreBtnBlock;
@property (nonatomic, copy) TapHotImageViewBlock tapHotImageViewBlock;
@end

NS_ASSUME_NONNULL_END
