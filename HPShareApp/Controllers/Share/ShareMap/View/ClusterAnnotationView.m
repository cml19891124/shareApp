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

@property (nonatomic, strong) UILabel *distanceLabel;


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
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
        [self setupSubviewsmaonry];

    }
    
    return self;
}

#pragma mark - Utility

- (void)setupSubviews
{
    [self addSubview:self.countLabel];
}

- (void)setupSubviewsmaonry
{
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(11.f));
        make.top.mas_equalTo(getWidth(10.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(20.f), getWidth(20.f)));
    }];
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, 20, 20)];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.adjustsFontSizeToFitWidth = YES;
        _countLabel.numberOfLines = 1;
        _countLabel.font = [UIFont boldSystemFontOfSize:14];
        _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    return _countLabel;
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    if (_count <= 0) {
        self.image = [UIImage imageNamed:@"noStoreAnnotation"];

        return;
    }
    if(_count == 1){//非聚合网点标注
        if(self.storeAnnotation.selected){
            self.image = [UIImage imageNamed:@"hasStoreAnnotation_selected"];//要点击选中状态
        }else{
            self.image = [UIImage imageNamed:@"hasStoreAnnotation"];
        }
        
    }else{//聚合网点标注
        self.image = [UIImage imageNamed:@"hasStoreAnnotation_selected"];

    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld",count];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subViews = self.subviews;
    if ([subViews count] > 1)
    {
        for (UIView *aSubView in subViews)
        {
            if ([aSubView pointInside:[self convertPoint:point toView:aSubView] withEvent:event])
            {
                return YES;
            }
        }
    }
    if (point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < self.frame.size.height)
    {
        return YES;
    }
    return NO;
}
@end
