//
//  HPPayOrderViewController.h
//  HPShareApp
//
//  Created by HP on 2019/3/9.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"

typedef void(^SelectedIndexBlock)(NSInteger row);
typedef void(^PaySuccessBlock)(void);


typedef enum PayStyleRow {

    payWeChat = 0,
    
    payAlipay
    
} PayState;

typedef NS_ENUM(NSInteger,PayType){

    /**
     微信支付
     */
    kPayTypeWeChat = 0,
    /**
     支付宝支付
     */
    kPayTypeAlipay
};

NS_ASSUME_NONNULL_BEGIN

@interface HPPayOrderViewController : HPBaseViewController

@property (nonatomic, copy) SelectedIndexBlock selectedIndexBlock;

@property (nonatomic, copy) PaySuccessBlock paySuccessBlock;

@end

NS_ASSUME_NONNULL_END
