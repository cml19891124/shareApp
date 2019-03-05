//
//  HPShareDialView.h
//  HPShareApp
//
//  Created by HP on 2019/3/5.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void (^ClickPhoneCallBlock)(void);

typedef void (^TouchViewCancelBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPShareDialView : HPBaseModalView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UIButton *knownBtn;

@property (nonatomic, copy) ClickPhoneCallBlock block;

- (void)setPhoneText:(NSString *)phoneText;

@end

NS_ASSUME_NONNULL_END
