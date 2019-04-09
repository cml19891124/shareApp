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

@class HPOrderCell;

typedef void (^PayOrderClickBlock)(NSInteger payOrder);

typedef NS_ENUM(NSInteger, PayOrder){
    
    PayOrderToCancel = 3000,//待支付
    PayOrderToPay,//右边支付按钮
    PayOrderToDelete//删除订单
};

@protocol OrderCellDelegate  <NSObject>

/**
 删除订单事件
 */
- (void)onClickCell:(HPOrderCell *)cell toDeleteOrderBtn:(UIButton *)deleteButton andModel:(HOOrderListModel *)model;
/**
 取消订单事件
 */
- (void)onClickCell:(HPOrderCell *)cell toCancelOrderBtn:(UIButton *)cancelButton;

/**
 支付订单事件
 */
- (void)onClickCell:(HPOrderCell *)cell toPayOrderBtn:(UIButton *)payButton andModel:(HOOrderListModel *)model;

/**
 评价订单事件
 */
- (void)onClickCell:(HPOrderCell *)cell toCommentOrderBtn:(UIButton *)commentButton andModel:(HOOrderListModel *)model;

/**
 查看评价事件
 */
- (void)onClickCell:(HPOrderCell *)cell toCheckCommentOrderBtn:(UIButton *)checkButton andModel:(HOOrderListModel *)model;

/**
 订单投诉事件
 */
- (void)onClickCell:(HPOrderCell *)cell toComplainOrderBtn:(UIButton *)complainButton andModel:(HOOrderListModel *)model;

/**
 催单事件
 */
- (void)onClickCell:(HPOrderCell *)cell toImergencyOrderBtn:(UIButton *)imergencyButton andModel:(HOOrderListModel *)model;

/**
 再来一单事件
 */
- (void)onClickCell:(HPOrderCell *)cell toCreateAnotherOrderBtn:(UIButton *)createButton andModel:(HOOrderListModel *)model;

/**
 查看原因事件
 */
- (void)onClickCell:(HPOrderCell *)cell toCheckReasonOrderBtn:(UIButton *)reasonButton andModel:(HOOrderListModel *)model;

/**
 付款提醒事件
 */
- (void)onClickCell:(HPOrderCell *)cell toWarnRenterToPayOrderBtn:(UIButton *)warnButton andModel:(HOOrderListModel *)model;

/**
 确认收货事件
 */
- (void)onClickCell:(HPOrderCell *)cell toConfirmToReceiveOrderBtn:(UIButton *)receiveButton andModel:(HOOrderListModel *)model;
@end
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

@property (nonatomic, weak) id<OrderCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
