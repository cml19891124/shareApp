//
//  RCRefreshNoDataView.h
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYLRefreshNoDataViewDelegate <NSObject>

/**
 去逛逛点击事件
 */
- (void)clickToCheckSTHForRequirments;

@end
@interface YYLRefreshNoDataView : UIView

@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *tipBtn;

@property (nonatomic, weak) id<YYLRefreshNoDataViewDelegate> delegate;
@end
