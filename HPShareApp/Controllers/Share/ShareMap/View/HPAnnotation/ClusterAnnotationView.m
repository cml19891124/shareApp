//
//  ClusterAnnotationView.m
//  DriveBei
//
//  Created by Seraphic on 2017/11/15.
//  Copyright © 2017年 YSZH. All rights reserved.
//

#import "ClusterAnnotationView.h"
#import "ClusterAnnotation.h"
#import "HPShareListModel.h"

#define kCalloutWidthOnPOICount(count)  count==1? 250.0 :250.0
#define kCalloutHeightOnPOICount(count) count==1? 55.0  :130.0

/* 返回rect的中心. */
CGPoint RectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/* 返回中心为center，尺寸为rect.size的rect. */
CGRect CenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGFloat const ScaleFactorAlpha = 0.3;
static CGFloat const ScaleFactorBeta = 0.4;

CGFloat ScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * ScaleFactorAlpha * powf(value, ScaleFactorBeta)));
}

@interface ClusterAnnotationView ()

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UIImageView * distanceImageView;


@end

@implementation ClusterAnnotationView

#pragma mark - Override

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}



#pragma mark - Initialization

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.annotation = annotation;
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
    }
    
    return self;
}

#pragma mark - Utility

- (void)setupLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, 20, 20)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:14];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
    
//    UIImageView * distanceImageView = [[UIImageView alloc] init];
//    distanceImageView.image = [UIImage imageNamed:@"netPoint_distance"];
//    [self addSubview:distanceImageView];
//    [distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.mas_top);
//        make.height.mas_equalTo(24);
//        make.width.mas_equalTo(52);
//        make.centerX.equalTo(self);
//    }];
//    self.distanceImageView = distanceImageView;
//    _distanceLabel = [[UILabel alloc] init];
//    _distanceLabel.backgroundColor = [UIColor clearColor];
//    _distanceLabel.textColor = [UIColor whiteColor];
//    _distanceLabel.textAlignment = NSTextAlignmentCenter;
//    _distanceLabel.adjustsFontSizeToFitWidth = YES;
//    _distanceLabel.numberOfLines = 1;
//    _distanceLabel.font = [UIFont boldSystemFontOfSize:10];
//    _distanceLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//    _distanceLabel.text = @"";
//    [distanceImageView addSubview:_distanceLabel];
//    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(distanceImageView);
//        make.centerY.mas_equalTo(distanceImageView.mas_centerY).offset(-2);
//    }];

}

- (NSInteger)getNetPointCarNumWithModelArray:(NSMutableArray *)netPointArray{
    NSInteger num = 0;
    for(int i = 0;i<netPointArray.count;i++){
        HPShareListModel * HPShareListModel = netPointArray[i];
//        num += [HPShareListModel.EVCNumber integerValue];
    }
    return num;
}

- (void)setCount:(NSUInteger)count
{
    _count = count;

    [self addSubview:self.countLabel];
    NSInteger num = [self getNetPointCarNumWithModelArray:self.annotation.pois];
    self.countLabel.text = [@(num) stringValue];

    if(num == 0){
        self.image = [UIImage imageNamed:@"noCarAnnotaion"];
    }else{
        self.image = [UIImage imageNamed:@"hasStoreAnnotation"];
    }
    
    if(_count == 1){//非聚合网点标注
        HPShareListModel * HPShareListModel =  [self.annotation.pois lastObject];
        if(HPShareListModel.selected){
            self.image = [UIImage imageNamed:@"hasStoreAnnotation_selected"];//要点击选中状态
//            self.distanceImageView.hidden = NO;
//            //计算距离网点距离
//            NSString * distance =  [Util getDistanceWithStartLocation:self.userLocation EndLocation:CLLocationCoordinate2DMake(HPShareListModel.Latitude_AMap, HPShareListModel.Longitude_AMap)];
//            if([distance intValue] < 1000 ){
//                self.distanceLabel.text  =  [NSString stringWithFormat:@"%@m",distance];
//            }else if ([distance intValue] > 1000){
//                double newDis = [distance intValue] / 1000.0;
//                self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",newDis];
//
//            }
        }else{
            self.image = [UIImage imageNamed:@"hasStoreAnnotation"];
            self.distanceImageView.hidden = YES;


        }
        if(num == 0){
            if(HPShareListModel.selected){
                self.image = [UIImage imageNamed:@"hasStoreAnnotation_selected"];

            }else{
                self.image = [UIImage imageNamed:@"noStoreAnnotaion"];

            }

        }
    }else{//聚合网点标注
        self.distanceImageView.hidden = YES;

    }
  
    
    self.carNum = num;
    [self setNeedsDisplay];
}


@end
