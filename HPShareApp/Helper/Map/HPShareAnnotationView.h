//
//  HPShareAnnotationView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "HPShareAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPShareAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, weak) UILabel * _Nullable titleLabel;

@end

NS_ASSUME_NONNULL_END
