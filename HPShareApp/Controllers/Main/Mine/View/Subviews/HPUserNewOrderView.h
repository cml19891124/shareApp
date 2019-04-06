//
//  HPUserNewOrderView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/6.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^UserNewBlock)(NSInteger userindex);
typedef NS_ENUM(NSInteger, UserNewOrderState) {
    UserNewOrderStateCommunicate = 5100,
    UserNewOrderStateReceive,
    UserNewOrderStateCloseOrder,
};
NS_ASSUME_NONNULL_BEGIN

@interface HPUserNewOrderView : HPBaseModalView

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *rentInfoView;

@property (nonatomic, strong) UIImageView *storeView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *rentOutsideLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UILabel *rentDaysLabel;

@property (nonatomic, strong) UILabel *toPayLabel;

@property (nonatomic, strong) UIButton *communicateBtn;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, copy) UserNewBlock newBlock;

@property (nonatomic, strong) UIButton *closed_order_btn;

@end

NS_ASSUME_NONNULL_END
