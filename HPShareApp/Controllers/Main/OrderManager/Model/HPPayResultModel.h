//
//  HPPayResultModel.h
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPPayResultModel : NSObject

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *attach;

@property (nonatomic, copy) NSString *bank_type;

@property (nonatomic, copy) NSString *cash_fee;

@property (nonatomic, copy) NSString *fee_type;

@property (nonatomic, copy) NSString *is_subscribe;

@property (nonatomic, copy) NSString *mch_id;

@property (nonatomic, copy) NSString *nonce_str;

@property (nonatomic, copy) NSString *openid;

@property (nonatomic, copy) NSString *out_trade_no;

@property (nonatomic, copy) NSString *result_code;

@property (nonatomic, copy) NSString *return_code;

@property (nonatomic, copy) NSString *return_msg;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *time_end;

@property (nonatomic, copy) NSString *total_fee;

@property (nonatomic, copy) NSString *trade_state;

@property (nonatomic, copy) NSString *trade_state_desc;

@property (nonatomic, copy) NSString *trade_type;

@property (nonatomic, copy) NSString *transaction_id;

@end

NS_ASSUME_NONNULL_END
