//
//  ClusterAnnotationView.h
//  DriveBei
//
//  Created by Seraphic on 2017/11/15.
//  Copyright © 2017年 YSZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "ClusterAnnotation.h"
#import "Masonry.h"
#import "HPGlobalVariable.h"
#import "Macro.h"

@interface ClusterAnnotationView : MAAnnotationView

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) NSUInteger carNum;//可用车数量

@property (nonatomic, strong) UIImageView * distanceImageView;
/**
 距离 
 */
@property(nonatomic,copy) NSString * distance;
/**
 当前用户位置
 */
@property(nonatomic,assign) CLLocationCoordinate2D userLocation;

@property (nonatomic, strong) ClusterAnnotation *storeAnnotation;

@end
