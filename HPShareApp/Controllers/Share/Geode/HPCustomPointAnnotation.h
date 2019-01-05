//
//  HPCustomPointAnnotation.h
//  HPShareApp
//
//  Created by HP on 2019/1/5.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPCustomPointAnnotation : MAPinAnnotationView

/**
 标注点传递的callout吹出框显示的信息
 */
@property (nonatomic, retain) NSDictionary *pointCalloutInfo;
@end

NS_ASSUME_NONNULL_END
