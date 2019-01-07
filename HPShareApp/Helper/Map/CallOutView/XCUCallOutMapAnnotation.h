//
//  XCUCallOutMapAnnotation.h
//  xyt-cu
//
//  Created by wangChunPeng on 16/10/27.
//  Copyright © 2016年 wangtiansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface XCUCallOutMapAnnotation : NSObject<MAAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@property(retain,nonatomic) NSDictionary *locationInfo;//callout吹出框要显示的各信息



- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;

@end
