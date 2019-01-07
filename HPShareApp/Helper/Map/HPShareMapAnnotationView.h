//
//  HPShareMapAnnotationView.h
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPShareMapAnnotationView : MAAnnotationView
@property (nonatomic, strong) CustomCalloutView *calloutView;

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, weak) UILabel * _Nullable titleLabel;

@property (nonatomic, weak) UILabel * _Nullable subTitleLabel;

@end

NS_ASSUME_NONNULL_END
