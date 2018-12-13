//
//  HPSystemNotiModel.h
//  HPShareApp
//
//  Created by HP on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPSystemNotiModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *createTime;
@end

NS_ASSUME_NONNULL_END
