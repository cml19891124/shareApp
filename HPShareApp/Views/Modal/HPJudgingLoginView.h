//
//  HPJudgingLoginView.h
//  HPShareApp
//
//  Created by HP on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
typedef void(^BtnClickCallback)(void);
typedef void(^ViewTapClickCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPJudgingLoginView : HPBaseModalView
@property (nonatomic, strong) UIView *bgview;
@property (nonatomic, strong) UILabel *quitReleaseLabel;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView *lineView;
/**
 确认按钮点击回调。
 */
@property (nonatomic, copy) BtnClickCallback confirmCallback;

@property (nonatomic, copy) ViewTapClickCallback viewTapClickCallback;

@end

NS_ASSUME_NONNULL_END
