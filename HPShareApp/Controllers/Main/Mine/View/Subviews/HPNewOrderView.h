//
//  HPNewOrderView.h
//  HPShareApp
//
//  Created by HP on 2019/3/28.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

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

@property (nonatomic, strong) UILabel *daysLabel;

@property (nonatomic, strong) UIButton *calendBtn;

@property (nonatomic, strong) UIView *rentDesView;

@property (nonatomic, strong) UILabel *rentDesLabel;

@property (nonatomic, strong) UILabel *rentInfoLabel;

@property (nonatomic, strong) UIButton *communicateBtn;

@property (nonatomic, strong) UIButton *receiveBtn;

@property (nonatomic, strong) UIButton *closed_order_btn;
@end

NS_ASSUME_NONNULL_END
