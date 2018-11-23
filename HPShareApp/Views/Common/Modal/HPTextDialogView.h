//
//  HPTextDialogView.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 提示对话框。
 */
@interface HPTextDialogView : HPBaseDialogView

/**
 设置对话框提示语

 @param text 提示语
 */
- (void)setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
