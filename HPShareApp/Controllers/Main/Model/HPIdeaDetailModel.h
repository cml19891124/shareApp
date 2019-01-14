//
//  HPIdeaDetailModel.h
//  HPShareApp
//
//  Created by HP on 2019/1/14.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HPShareArticlePictures;
NS_ASSUME_NONNULL_BEGIN

@interface HPIdeaDetailModel : NSObject
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *readingQuantity;
@property (nonatomic, strong) NSArray *shareArticlePictures;

@end

@interface HPshareArticlePictures : NSObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *pictureId;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *updateTime;
@end
NS_ASSUME_NONNULL_END
