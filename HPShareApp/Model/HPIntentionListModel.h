//
//  HPIntentionListModel.h
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPIntentionListModel : NSObject
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *deleteTime;
@property (nonatomic, copy) NSString *industryName;
@property (nonatomic, copy) NSString *intentionIndustryId;
@property (nonatomic, copy) NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
