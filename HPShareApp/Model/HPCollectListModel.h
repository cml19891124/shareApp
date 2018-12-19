//
//  HPCollectListModel.h
//  HPShareApp
//
//  Created by HP on 2018/12/11.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPCollectListModel : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSArray<NSDictionary *> *list;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END
