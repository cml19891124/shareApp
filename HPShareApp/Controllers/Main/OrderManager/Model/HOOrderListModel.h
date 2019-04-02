//
//  HOOrderListModel.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/2.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPSpaceDetailModel,HPPicture,HPOrderlModel;

NS_ASSUME_NONNULL_BEGIN

@interface HOOrderListModel : NSObject

@property (nonatomic, strong) HPOrderlModel *order;

@property (nonatomic, copy) NSString *orderDetail;

@property (nonatomic, strong) HPSpaceDetailModel *spaceDetail;

@end

@interface HPOrderlModel : NSObject

@property (nonatomic, copy) NSString *admitTime;
@property (nonatomic, copy) NSString *bossId;
@property (nonatomic, copy) NSString *cancelReason;
@property (nonatomic, copy) NSString *closeTime;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *deleteBossId;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *deleteUserId;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *spaceId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *totalFee;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userId;


@end
@interface HPSpaceDetailModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaRange;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *completeDegree;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *deleteUserId;
@property (nonatomic, copy) NSString *districtId;
@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *intention;
@property (nonatomic, copy) NSString *intentionIndustry;
@property (nonatomic, copy) NSString *isApproved;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, strong) HPPicture *picture;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *rent;
@property (nonatomic, copy) NSString *rentMode;
@property (nonatomic, copy) NSString *rentOutside;
@property (nonatomic, copy) NSString *rentPlace;
@property (nonatomic, copy) NSString *rentType;
@property (nonatomic, copy) NSString *shareDays;
@property (nonatomic, copy) NSString *shareTime;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *spaceId;
@property (nonatomic, copy) NSString *subIndustryId;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userId;

@end

@interface HPPicture : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *pictureId;
@property (nonatomic, copy) NSString *pictureName;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *userId;

@end
NS_ASSUME_NONNULL_END
