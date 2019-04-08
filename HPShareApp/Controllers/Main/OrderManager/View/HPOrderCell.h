//
//  HPOrderCell.h
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"

#import "HPShareDetailModel.h"

#import "HPRightImageButton.h"

#import "HOOrderListModel.h"

#import "HPPredictView.h"

#import "HPQuitOrderView.h"

#import "HPUserReceiveView.h"

typedef void (^PayOrderClickBlock)(NSInteger payOrder);

typedef NS_ENUM(NSInteger, PayOrder){
    
    PayOrderToCancel = 3000,//待支付
    PayOrderToPay//右边支付按钮
};
NS_ASSUME_NONNULL_BEGIN

@interface HPOrderCell : HPBaseTableViewCell

@property (strong, nonatomic) HPUserReceiveView *receiveView;

@property (strong, nonatomic) HPQuitOrderView *quitView;

@property (strong, nonatomic) HPPredictView *predictView;

@property (strong, nonatomic) HOOrderListModel *model;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *shopIcon;

@property (nonatomic, strong) UIImageView *leftIcon;

@property (nonatomic, strong) HPRightImageButton *shopNamebtn;

@property (nonatomic, strong) UIButton *dustbinBtn;

@property (nonatomic, strong) UILabel *waitingReceiveLabel;

@property (nonatomic, strong) UIView *firstLine;

@property (nonatomic, strong) UILabel *shopNameLabel;

@property (nonatomic, strong) UILabel *rentDuringLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UIView *payLine;

@property (nonatomic, strong) UILabel *totalLabel;

/**
 订单取消
 */
@property (nonatomic, strong) UIButton *cancelBtn;

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
