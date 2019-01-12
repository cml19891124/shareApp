//
//  HPIdeaListModel.h
//  HPShareApp
//
//  Created by HP on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPIdeaListModel : NSObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSArray *pictures;
@property (nonatomic, copy) NSString *readingQuantity;
@property (nonatomic, copy) NSString *title;
@end


@interface HPIdeaPicturesModel : NSObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *pictureId;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *updateTime;
@end
NS_ASSUME_NONNULL_END
