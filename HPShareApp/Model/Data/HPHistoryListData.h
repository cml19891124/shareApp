//
//  HPHistoryListModel.h
//  HPShareApp
//
//  Created by Jay on 2018/12/18.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPShareListModel.h"
#import "HPBrowseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPHistoryListData : NSObject

@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSMutableArray<HPShareListModel *> *items;

+ (NSMutableArray<HPHistoryListData *> *)getHistroyListDataFromModels:(NSArray<HPBrowseModel *> *)models;

@end

NS_ASSUME_NONNULL_END
