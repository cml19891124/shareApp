//
//  CoordinateQuadTree.m
//  DriveBei
//
//  Created by Seraphic on 2017/11/15.
//  Copyright © 2017年 YSZH. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "CoordinateQuadTree.h"
#import "ClusterAnnotation.h"
#import "Macro.h"

QuadTreeNodeData QuadTreeNodeDataForAMapPOI(ClusterAnnotation* poi)
{
    return QuadTreeNodeDataMake(poi.coordinate.latitude, poi.coordinate.longitude, (__bridge_retained void *)(poi));
}

BoundingBox BoundingBoxForMapRect(MAMapRect mapRect)
{
    CLLocationCoordinate2D topLeft = MACoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MACoordinateForMapPoint(MAMapPointMake(MAMapRectGetMaxX(mapRect), MAMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return BoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

float CellSizeForZoomLevel(double zoomLevel)
{
    /*zoomLevel越大，cellSize越小. */
    HPLog(@"zoomLevel: %f",zoomLevel);
    if (zoomLevel < 13.0)
    {
        return 64;
    }
    else if (zoomLevel <15.0)
    {
        return 32;
    }
    else if (zoomLevel <18.0)
    {
        return 16;
    }
    else if (zoomLevel < 20.0)
    {
        return 8;
    }
    
    return 64;
}

BoundingBox quadTreeNodeDataArrayForPOIs(QuadTreeNodeData *dataArray, NSArray * pois)
{
    if (pois.count != 0) {
        CLLocationDegrees minX = ((ClusterAnnotation *)pois[0]).coordinate.latitude;
        CLLocationDegrees maxX = ((ClusterAnnotation *)pois[0]).coordinate.latitude;
        
        CLLocationDegrees minY = ((ClusterAnnotation *)pois[0]).coordinate.longitude;
        CLLocationDegrees maxY = ((ClusterAnnotation *)pois[0]).coordinate.longitude;
        for (NSInteger i = 0; i < [pois count]; i++)
        {
            dataArray[i] = QuadTreeNodeDataForAMapPOI(pois[i]);
            
            if (dataArray[i].x < minX)
            {
                minX = dataArray[i].x;
            }
            
            if (dataArray[i].x > maxX)
            {
                maxX = dataArray[i].x;
            }
            
            if (dataArray[i].y < minY)
            {
                minY = dataArray[i].y;
            }
            
            if (dataArray[i].y > maxY)
            {
                maxY = dataArray[i].y;
            }
        }
        return BoundingBoxMake(minX, minY, maxX, maxY);
    }
    else {
        return BoundingBoxMake(0, 0, 0, 0);
    }
}

#pragma mark -

@implementation CoordinateQuadTree

#pragma mark Utility

- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withZoomScale:(double)zoomScale andZoomLevel:(double)zoomLevel
{
    double CellSize = CellSizeForZoomLevel(zoomLevel);
    double scaleFactor = zoomScale / CellSize;
    
    NSInteger minX = floor(MAMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MAMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MAMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MAMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++)
    {
        for (NSInteger y = minY; y <= maxY; y++)
        {
            MAMapRect mapRect = MAMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int     count = 0;
            
            NSMutableArray *pois = [[NSMutableArray alloc] init];
            
            /* 查询区域内数据的个数. */
            QuadTreeGatherDataInRange(self.root, BoundingBoxForMapRect(mapRect), ^(QuadTreeNodeData data)
                                      {
                                          totalX += data.x;
                                          totalY += data.y;
                                          count++;
                                          
                                          [pois addObject:(__bridge ClusterAnnotation *)data.data];
                                          
                                      });
            
            /* 若区域内仅有一个数据. */
            if (count == 1)
            {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                ClusterAnnotation *clusterAnnotation = [[ClusterAnnotation alloc] initWithCoordinate:coordinate count:count];
                clusterAnnotation.pois = pois;
                ClusterAnnotation * annotation = [pois lastObject];
                annotation.title = annotation.title;
//                annotation.type  = poi.type;
////                annotation.numb = poi.numb;
                [clusteredAnnotations addObject:annotation];
            }
            
            /* 若区域内有多个数据 按数据的中心位置画点. */
            if (count > 1)
            {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                ClusterAnnotation *annotation = [[ClusterAnnotation alloc] initWithCoordinate:coordinate count:count];
                annotation.pois  = pois;
                [clusteredAnnotations addObject:annotation];
            }
        }
    }
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}

#pragma mark Initilization

- (void)buildTreeWithPOIs:(NSArray *)pois
{
    QuadTreeNodeData *dataArray = malloc(sizeof(QuadTreeNodeData) * [pois count]);
    
    BoundingBox maxBounding = quadTreeNodeDataArrayForPOIs(dataArray, pois);
    
    /*若已有四叉树，清空.*/
    [self clean];
    
    NSLog(@"build tree.");
    /*建立四叉树索引. */
    self.root = QuadTreeBuildWithData(dataArray, (int)pois.count, maxBounding, 4);
}

#pragma mark Life Cycle

- (void)clean
{
    if (self.root)
    {
        NSLog(@"free tree.");
        FreeQuadTreeNode(self.root);
    }
    
}

@end
