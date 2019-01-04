//
//  HPShareReleaseParam.h
//  HPShareApp
//
//  Created by Jay on 2018/12/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPShareReleaseParam : NSObject

@property (nonatomic, copy) NSString *title;

/**
 面积
 */
@property (nonatomic, copy) NSString *area;

/**
 区域id
 */
@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *longitude;

/**
 街道id
 */
@property (nonatomic, copy) NSString *districtId;

/**
 一级行业id
 */
@property (nonatomic, copy) NSString *industryId;

@property (nonatomic, copy) NSString *subIndustryId;

@property (nonatomic, copy) NSString *rent;

/**
 数字: 1: 元/小时， 2: 元/天, 3: 元/月
 */
@property (nonatomic, copy) NSString *rentType;

@property (nonatomic, copy) NSString *shareTime;

/**
 共享天数，后台检验格式：2018-11-12,2018-12-12. 建议用英语逗号拼接，方便你们后续处理
 */
@property (nonatomic, copy) NSString *shareDays;

@property (nonatomic, copy) NSString *contact;

@property (nonatomic, copy) NSString *contactMobile;

@property (nonatomic, copy) NSString *intention;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *tag;

/**
 1业主， 2创客
 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *userId;

/**
 0没认证， 1认证 - required
 */
@property (nonatomic, copy) NSString *isApproved;

/**
 空间id不用，我们后台发布后生成
 */
@property (nonatomic, copy) NSString *spaceId;

/**
 图片数组id, 先调用图片上传得到相关的返回id
 */
@property (nonatomic, copy) NSMutableArray *pictureIdArr;

@property (nonatomic, copy) NSMutableArray *pictureUrlArr;

//新增

/**
 资料完善度，百分号前面的数字，如：75.3
 */
@property (nonatomic, copy) NSString *completeDegree;

/**
 面积范围
 */
@property (nonatomic, copy) NSString *areaRange;

/**
 意向行业名称，英文逗号拼接
 */
@property (nonatomic, copy) NSString *intentionIndustry;

/**
 出租模式： 1按小时，2按天，3按月，4按年,如2,3
 */
@property (nonatomic, copy) NSString *rentMode;

/**
 代替用户发布,业务员的userId, 不是代替发布不需要
 */
@property (nonatomic, copy) NSString *salesmanUserId;

/**
 店铺简称
 */
@property (nonatomic, copy) NSString *shortName;
@end

NS_ASSUME_NONNULL_END
