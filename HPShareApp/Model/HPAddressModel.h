//
//  HPLocationModel.h
//  HPShareApp
//
//  Created by Jay on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPAddressModel : NSObject <NSCoding>

@property (nonatomic, assign) double lat;

@property (nonatomic, assign) double lon;

///格式化地址
@property (nonatomic, copy) NSString *formattedAddress;

///国家
@property (nonatomic, copy) NSString *country;

///省/直辖市
@property (nonatomic, copy) NSString *province;

///市
@property (nonatomic, copy) NSString *city;

///区
@property (nonatomic, copy) NSString *district;

///城市编码
@property (nonatomic, copy) NSString *citycode;

///区域编码
@property (nonatomic, copy) NSString *adcode;

///街道名称
@property (nonatomic, copy) NSString *street;

///门牌号
@property (nonatomic, copy) NSString *number;

///兴趣点名称
@property (nonatomic, copy) NSString *POIName;

///所属兴趣点名称
@property (nonatomic, copy) NSString *AOIName;

- (void)setData:(NSObject *)data;

@end

NS_ASSUME_NONNULL_END
