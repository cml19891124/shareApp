//
//  HPShareAnnotation.m
//  HPShareApp
//
//  Created by Jay on 2018/12/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareAnnotation.h"

@interface HPShareAnnotation () {
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
}

@end

@implementation HPShareAnnotation

- (instancetype)initWithModel:(HPShareListModel *)model {
    self = [super init];
    if (self) {
        _model = model;
//        _title = @"1";
        _coordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (NSString *)title {
    return _title;
}

+ (NSArray *)annotationArrayWithModels:(NSArray<HPShareListModel *> *)models {
    NSMutableArray *storesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < models.count; i++) {
        HPShareListModel *model = models[i];
        
        if (model.latitude == nil || model.longitude == nil) {
            continue;
        }
        HPShareAnnotation *annotation = [[HPShareAnnotation alloc] initWithModel:model];
        [annotation setIndex:i];
        [storesArray addObject:annotation];
    }
    return storesArray;
}


@end


