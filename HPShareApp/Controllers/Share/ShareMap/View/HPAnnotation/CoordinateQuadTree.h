//
//  CoordinateQuadTree.h
//  DriveBei
//
//  Created by Seraphic on 2017/11/15.
//  Copyright © 2017年 YSZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "QuadTree.h"

@interface CoordinateQuadTree : NSObject

@property (nonatomic, assign) QuadTreeNode * root;

- (void)buildTreeWithPOIs:(NSArray *)pois;
- (void)clean;

- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withZoomScale:(double)zoomScale andZoomLevel:(double)zoomLevel;

@end
