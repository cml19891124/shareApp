//
//  HPPayModel.h
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPPayModel : NSObject

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *noncestr;

@property (nonatomic, copy) NSString *package;

@property (nonatomic, copy) NSString *partnerid;

@property (nonatomic, copy) NSString *prepayid;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, copy) NSString *out_trade_no;
@end

NS_ASSUME_NONNULL_END
