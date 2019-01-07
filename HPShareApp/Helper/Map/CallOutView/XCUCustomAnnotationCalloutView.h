//
//  XCUCustomAnnotationCalloutView.h
//  xyt-cu
//
//  Created by wangChunPeng on 16/10/27.
//  Copyright © 2016年 wangtiansoft. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "XCUCustomContentView.h"

@interface XCUCustomAnnotationCalloutView : MAAnnotationView

@property(nonatomic,retain) UIView *contentView;

@property(nonatomic,retain) XCUCustomContentView *infoView;//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView

@end
