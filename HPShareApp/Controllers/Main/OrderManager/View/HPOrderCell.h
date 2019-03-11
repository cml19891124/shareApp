//
//  HPOrderCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "HPShareDetailModel.h"

typedef void (^PayOrderClickBlock)(NSInteger payOrder);

typedef NS_ENUM(NSInteger, PayOrder){
    PayOrderConsult = 3000,
    PayOrderToPay,//待支付
    PayOrderReturn//退款
};
NS_ASSUME_NONNULL_BEGIN

@interface HPOrderCell : HPBaseTableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *orderLabel;

@property (nonatomic, strong) UIView *firstLine;

@property (nonatomic, strong) UILabel *contactLabel;

@property (nonatomic, strong) UILabel *shopLabel;

@property (nonatomic, strong) HPShareDetailModel *model;

@property (nonatomic, strong) UILabel *industryLabel;

@property (nonatomic, strong) UIView *payLine;

/**
 订单查询
 */
@property (nonatomic, strong) UIButton *consultBtn;

/**
 待付款
 */
@property (nonatomic, strong) UIButton *topayBtn;


/**
 退款
 */
@property (nonatomic, strong) UIButton *returnBtn;

@property (nonatomic, copy) PayOrderClickBlock payBlock;

@end

NS_ASSUME_NONNULL_END
