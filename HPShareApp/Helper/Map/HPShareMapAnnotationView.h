//
//  HPShareMapAnnotationView.h
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
//#import "HPCustomAnnotationCalloutView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPShareMapAnnotationView : MAAnnotationView

@property (nonatomic, weak) UILabel * _Nullable titleLabel;
@property (nonatomic, strong) UIView *customerCallOutView;

/**
 展示的标题和副标题
 */
@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIImageView *loc_imageView;
@end

NS_ASSUME_NONNULL_END
