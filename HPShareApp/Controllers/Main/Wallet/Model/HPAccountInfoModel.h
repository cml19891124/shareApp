//
//  HPAccountInfoModel.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPDescriptionModel;
NS_ASSUME_NONNULL_BEGIN

@interface HPAccountInfoModel : NSObject

@property (nonatomic, copy) NSString *balanceAfter;

@property (nonatomic, copy) NSString *balanceBefore;

@property (nonatomic, copy) NSString *businessId;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *deleteTime;

/**
 json字符串 "{\"days\":\"20190418\",\"orderNo\":\"HD201904042\",\"spaceName\":\"\U5357\U5c71\U533a-\U767d\U77f3\U6d32\U5e97\U6709\U7a7a\U95f4\U53ef\U4f9b\U51fa\U79df\",\"tenantName\":\"\"}"
 */
@property (nonatomic, strong) HPDescriptionModel *desc;

@property (nonatomic, copy) NSString *serviceCharge;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *transactionAmount;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *userAccountLogId;

@property (nonatomic, copy) NSString *userId;

@end

@interface HPDescriptionModel : NSObject

@property (nonatomic, copy) NSString *days;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *spaceName;

@property (nonatomic, copy) NSString *tenantName;

@end

NS_ASSUME_NONNULL_END
