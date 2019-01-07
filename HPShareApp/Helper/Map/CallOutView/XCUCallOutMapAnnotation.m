//
//  XCUCallOutMapAnnotation.m
//  xyt-cu
//
//  Created by wangChunPeng on 16/10/27.
//  Copyright © 2016年 wangtiansoft. All rights reserved.
//

#import "XCUCallOutMapAnnotation.h"

@implementation XCUCallOutMapAnnotation

@synthesize latitude;
@synthesize longitude;
@synthesize locationInfo;

- (id)initWithLatitude:(CLLocationDegrees)lat
          andLongitude:(CLLocationDegrees)lon {
    if (self = [super init]) {
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}


-(CLLocationCoordinate2D)coordinate{
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
    
    
}


@end
