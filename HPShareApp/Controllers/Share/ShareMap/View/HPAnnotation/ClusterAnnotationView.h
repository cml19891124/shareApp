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

@interface ClusterAnnotationView : MAAnnotationView

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, assign) NSUInteger carNum;//可用车数量

/**
 距离 
 */
@property(nonatomic,copy) NSString * distance;
/**
 当前用户位置
 */
@property(nonatomic,assign) CLLocationCoordinate2D userLocation;

@property (nonatomic, strong) ClusterAnnotation *annotation;

@end
