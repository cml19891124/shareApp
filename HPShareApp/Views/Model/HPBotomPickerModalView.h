//
//  HPBotomPickerModalView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/28.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

#import "HPLinkageData.h"

typedef void(^PickerViewConfirmCallBack)(NSInteger parentIndex, NSInteger childIndex, NSObject *model);

NS_ASSUME_NONNULL_BEGIN

@interface HPBotomPickerModalView : HPBaseModalView

@property (nonatomic, strong) PickerViewConfirmCallBack confirmCallBack;

- (instancetype)initWithData:(HPLinkageData *)data;

@end

NS_ASSUME_NONNULL_END
