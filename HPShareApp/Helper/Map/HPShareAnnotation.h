//
//  HPShareAnnotation.h
//  HPShareApp
//
//  Created by Jay on 2018/12/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "HPShareListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPShareAnnotation : NSObject <MAAnnotation>

@property (nonatomic, strong) HPShareListModel *model;

@property (nonatomic, assign) NSInteger index;

/**
 每次请求的店铺
 */
@property (nonatomic, assign) NSInteger *count;
/**
 店铺是否选中状态
 */
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithModel:(HPShareListModel *)model;

+ (NSArray *)annotationArrayWithModels:(NSArray<HPShareListModel *> *)models;

@end

NS_ASSUME_NONNULL_END
