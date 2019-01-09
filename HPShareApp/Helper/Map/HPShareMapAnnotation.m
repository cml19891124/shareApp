//
//  HPShareMapDetailAnnotation.m
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareMapAnnotation.h"
@interface HPShareMapAnnotation () {
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
}

@end
@implementation HPShareMapAnnotation
- (instancetype)initWithModel:(HPShareDetailModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        _title = model.title;
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

+ (NSArray *)annotationArrayWithModels:(NSArray<HPShareDetailModel *> *)models {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < models.count; i++) {
        HPShareDetailModel *model = models[i];
        
        if (model.latitude == nil || model.longitude == nil) {
            continue;
        }
        HPShareMapAnnotation *annotation = [[HPShareMapAnnotation alloc] initWithModel:model];
        [annotation setIndex:i];
        [array addObject:annotation];
    }
    return array;
}

@end
