//
//  HPQuitOrderView.h
//  HPShareApp
//
//  Created by HP on 2019/3/27.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

#import "HPlaceholdTextView.h"

#import "MyTextView.h"

typedef void(^OnClickHolderBtnBlock)(void);

typedef void(^OnClickQuitBtnBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface HPQuitOrderView : HPBaseModalView<UITextViewDelegate>

@property (nonatomic, strong) MyTextView *textView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *holderBtn;

@property (nonatomic, strong) UIButton *quitBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UITextView *reasonView;

@property (nonatomic, copy) NSString *knowText;

@property (nonatomic, copy) NSString *onlineText;

@property (nonatomic, copy) OnClickHolderBtnBlock holderBlock;

@property (nonatomic, copy) OnClickQuitBtnBlock quitBlock;

@property (nonatomic, strong) UIView *signContentView;

@property (nonatomic, strong) HPlaceholdTextView *signTextView;

@property (nonatomic, assign) NSInteger number;

@end

NS_ASSUME_NONNULL_END
