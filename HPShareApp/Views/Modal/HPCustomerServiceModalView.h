//
//  HPCustomerServiceModalView CustomerService.h
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCustomerServiceModalView : HPBaseModalView
@property (nonatomic, strong) UIButton *callBtn;
@property (nonatomic, copy) NSString *phone;
/**
 设置电话号码

 @param phone <#phone description#>
 */
- (void)setPhoneString:(NSString *)phone;
@end

NS_ASSUME_NONNULL_END
