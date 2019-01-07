//
//  HPShareMapDetailAnnotation.h
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "HPShareDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPShareMapAnnotation : NSObject <MAAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@property(retain,nonatomic) NSDictionary *locationInfo;//callout吹出框要显示的各信息

@property (nonatomic, strong) HPShareDetailModel *model;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithModel:(HPShareDetailModel *)model;

+ (NSArray *)annotationArrayWithModels:(NSArray<HPShareDetailModel *> *)models;

@end

NS_ASSUME_NONNULL_END
