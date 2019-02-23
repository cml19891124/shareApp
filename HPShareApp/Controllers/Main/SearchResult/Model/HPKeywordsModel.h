//
//  HPKeywordsModel.h
//  HPShareApp
//
//  Created by HP on 2019/2/23.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPKeywordsModel : NSObject

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *deleteTime;

@property (nonatomic, copy) NSString *hotKeywordId;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
