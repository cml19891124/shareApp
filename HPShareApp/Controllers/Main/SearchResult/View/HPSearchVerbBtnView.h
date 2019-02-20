//
//  HPSearchVerbBtnView.h
//  HPShareApp
//
//  Created by HP on 2019/2/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"
typedef void (^SearchBtnClickBlock)(NSString *searchStr);

typedef NS_ENUM(NSInteger, SearchIndex){
    HPSearchVerbTypeCloth,//服装门店
    HPSearchVerbTypeLargeShop,//大户型商铺
    HPSearchVerbTypeSmallStore,//小商店
    HPSearchVerbTypeLargeStore,//超级大大的店铺
    HPSearchVerbTypeClothSellPieces,//服装批发大开间
    HPSearchVerbTypeBig//各种大一点的门店
};

NS_ASSUME_NONNULL_BEGIN

@interface HPSearchVerbBtnView : HPBaseView

@property (nonatomic, strong) UIButton *searchbtn;

@property (nonatomic, copy) SearchBtnClickBlock searchBlock;

@end

NS_ASSUME_NONNULL_END
