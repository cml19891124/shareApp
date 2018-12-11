//
//  HPPictureModel.h
//  HPShareApp
//
//  Created by Jay on 2018/12/11.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPPictureModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *pictureId;

@property (nonatomic, copy) NSString *pictureName;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
