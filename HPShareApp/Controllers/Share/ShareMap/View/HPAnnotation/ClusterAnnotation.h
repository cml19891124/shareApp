

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

#import "HPShareListModel.h"

@interface ClusterAnnotation : NSObject<MAAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate; //poi的平均位置
@property (assign, nonatomic) NSInteger count;
@property (nonatomic, strong) NSMutableArray *pois;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) HPShareListModel *model;

@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithModel:(HPShareListModel *)model;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count;

+ (NSArray *)annotationArrayWithModels:(NSArray<HPShareListModel *> *)models;
@end
