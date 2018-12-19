//
//  HPBrowseModel.h
//  HPShareApp
//
//  Created by Jay on 2018/12/18.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPShareListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPBrowseModel : NSObject

@property (nonatomic, copy) NSString *browseId;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *deleteTime;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *spaceId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) HPShareListModel *shareSpaceDetail;

@end

NS_ASSUME_NONNULL_END
