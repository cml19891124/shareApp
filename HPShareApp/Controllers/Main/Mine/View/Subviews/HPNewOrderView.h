//
//  HPNewOrderView.h
//  HPShareApp
//
//  Created by HP on 2019/3/28.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^NewOrderBtnBlock)(NSInteger newIndex);

typedef NS_ENUM(NSInteger, NewOrderState) {
    HPNewOrderStateCommunicate = 4900,
    HPNewOrderStateReceive,
    HPNewOrderStateCalender,
    HPNewOrderStateCloseOrder
};

NS_ASSUME_NONNULL_BEGIN

@interface HPNewOrderView : HPBaseModalView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *userInfoView;

@property (nonatomic, strong) UILabel *nameInfoLabel;

@property (nonatomic, strong) UIView *nameInfoView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UIView *rentDaysView;

@property (nonatomic, strong) UILabel *rentDaysLabel;

@property (nonatomic, strong) UIView *daysView;

@property (nonatomic, strong) UILabel *daysLabel;

@property (nonatomic, strong) UIButton *calendBtn;

@property (nonatomic, strong) UIView *rentDesView;

@property (nonatomic, strong) UILabel *rentDesLabel;

@property (nonatomic, strong) UILabel *rentInfoLabel;

@property (nonatomic, strong) UIButton *communicateBtn;

@property (nonatomic, strong) UIButton *receiveBtn;

@property (nonatomic, strong) UIButton *closed_order_btn;

@property (nonatomic, copy) NewOrderBtnBlock newBlock;

@property (nonatomic, strong) UIView *view;
@end

NS_ASSUME_NONNULL_END
