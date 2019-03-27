//
//  HPPredictView.h
//  HPShareApp
//
//  Created by HP on 2019/3/27.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"


typedef void(^OnClickKnownBtnBlock)(void);

typedef void(^OnClickImergencyBtnBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPPredictView : HPBaseModalView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *tipBtn;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *knownBtn;

@property (nonatomic, strong) UIButton *imergencyBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) NSString *knowText;

@property (nonatomic, copy) NSString *onlineText;

@property (nonatomic, copy) OnClickKnownBtnBlock knownBlock;

@property (nonatomic, copy) OnClickImergencyBtnBlock onlineBlock;


- (void)setKnownBtnText:(NSString *)knowText;

- (void)setOnlineText:(NSString *)onlineText;

@end

NS_ASSUME_NONNULL_END
