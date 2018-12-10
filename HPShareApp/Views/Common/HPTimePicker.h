//
//  HPTimePicker.h
//  HPShareApp
//
//  Created by Jay on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPTimePicker : HPBaseDialogView

/**
 获取选择的时间段

 @return 时间段字符串，格式为"06:30,23:59"
 */
- (NSString *)getTimeStr;

@end

NS_ASSUME_NONNULL_END
