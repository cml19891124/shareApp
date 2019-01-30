//
//  HPHomeBannerModel.h
//  HPShareApp
//
//  Created by HP on 2019/1/16.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPHomeBannerModel : NSObject
@property (nonatomic, copy) NSString *bannerId;

/**
 跳转对应的目标控制器
 */
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *bannerName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *linkType;

@property (nonatomic, copy) NSString *pictureId;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
