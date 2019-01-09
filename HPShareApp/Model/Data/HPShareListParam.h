//
//  HPShareListParam.h
//  HPShareApp
//
//  Created by Jay on 2018/12/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPShareListParam : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *areaIds; //多个区域筛选，英文逗号拼接，如1,3

@property (nonatomic, copy) NSString *districtId; //街道筛选，属于区下面的

@property (nonatomic, copy) NSString *industryId; //行业筛选，一级行业

@property (nonatomic, copy) NSString *subIndustryId; //行业筛选，二级行业

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *createTimeOrderType; //发布时间排序，1升序，0降序

@property (nonatomic, copy) NSString *rentOrderType; //租金排序排序，1升序，0降序

@property (nonatomic, assign) NSString *type; //类型筛选，1业主， 2创客

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *longitude;

@end

NS_ASSUME_NONNULL_END
