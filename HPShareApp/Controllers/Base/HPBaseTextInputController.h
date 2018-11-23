//
//  HPBaseTextInputController.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 实现了输入时常用的基本交互逻辑，含有输入框（UITextField, UITextView）的 Controller 应继承该类。
 */
@interface HPBaseTextInputController : HPBaseViewController <UITextFieldDelegate, UITextViewDelegate>

@end

NS_ASSUME_NONNULL_END
