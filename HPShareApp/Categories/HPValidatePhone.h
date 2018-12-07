//
//  NSString+validatePhone.h
//  HPShareApp
//
//  Created by HP on 2018/12/6.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPValidatePhone : NSObject
+ (BOOL)validateContactNumber:(NSString *)mobileNum;
@end

NS_ASSUME_NONNULL_END
