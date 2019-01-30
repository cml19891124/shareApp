//
//  CustomCalloutView.h
//  iOS_3D_ClusterAnnotation
//
//  Created by PC on 15/7/9.
//  Copyright (c) 2015年 FENGSHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "HPShareListModel.h"

@protocol CustomCalloutViewTapDelegate <NSObject>

- (void)didDetailButtonTapped:(NSInteger)index;
- (void)didSelectedIndexpathinRowTapped:(HPShareListModel *)model andIndex:(NSInteger)index;

@end



@interface CustomCalloutView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *poiArray;

@property (nonatomic, weak) id<CustomCalloutViewTapDelegate> delegate;

- (void)dismissCalloutView;

@end
