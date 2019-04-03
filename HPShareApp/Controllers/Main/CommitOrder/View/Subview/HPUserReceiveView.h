//
//  HPUserReceiveView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/3.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^NobtnBlock)(void);

typedef void(^OkbtnBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPUserReceiveView : HPBaseModalView

@property (nonatomic, strong) UIView *bgView;

@property (strong, nonatomic) UILabel *confirmLabel;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIButton *noBtn;

@property (strong, nonatomic) UIButton *okbtn;

@property (nonatomic, copy) NobtnBlock noBlock;

@property (nonatomic, copy) OkbtnBlock okBlock;

@end

NS_ASSUME_NONNULL_END
