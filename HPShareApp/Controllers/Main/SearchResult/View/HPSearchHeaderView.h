//
//  HPSearchHeaderView.h
//  HPShareApp
//
//  Created by HP on 2019/2/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"
typedef void (^DeleteBtnClickBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface HPSearchHeaderView : HPBaseView

@property (nonatomic, strong) UIImageView *leftImage;

@property (nonatomic, strong) UILabel *headerLab;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) BOOL hidden;

@property (nonatomic, copy) DeleteBtnClickBlock block;
@end

NS_ASSUME_NONNULL_END
