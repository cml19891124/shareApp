//
//  HPShareDetailModel.h
//  HPShareApp
//
//  Created by Jay on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPPictureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPShareDetailModel : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *districtId;

@property (nonatomic, copy) NSString *industryId;

@property (nonatomic, copy) NSString *subIndustryId;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *rent;

@property (nonatomic, assign) NSInteger rentType;

@property (nonatomic, copy) NSString *shareDays;

@property (nonatomic, copy) NSString *shareTime;

@property (nonatomic, copy) NSString *spaceId;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *contact;

@property (nonatomic, copy) NSString *contactMobile;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, strong) NSArray<HPPictureModel *> *pictures;

@end

NS_ASSUME_NONNULL_END
