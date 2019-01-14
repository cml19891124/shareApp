

#import "ClusterAnnotation.h"
@interface ClusterAnnotation ()
{
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
}

@end

@implementation ClusterAnnotation

#pragma mark - compare
- (instancetype)initWithModel:(HPShareListModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        _title = model.title;
        _coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    }
    return self;
}

- (NSUInteger)hash
{
    NSString *toHash = [NSString stringWithFormat:@"%.5F%.5F%ld", self.coordinate.latitude, self.coordinate.longitude, (long)self.count];
    return [toHash hash];
}

- (BOOL)isEqual:(id)object
{
    return [self hash] == [object hash];
}

#pragma mark - Life Cycle
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate count:(NSInteger)count
{
    self = [super init];
    if (self)
    {
        _coordinate = coordinate;
        _count = count;
        _pois  = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

+ (NSArray *)annotationArrayWithModels:(NSArray<HPShareListModel *> *)models {
    NSMutableArray *storesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < models.count; i++) {
        HPShareListModel *model = models[i];
        
        if (model.latitude || model.longitude) {
            continue;
        }
        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] initWithModel:model];
        [annotation setIndex:i];
        [storesArray addObject:annotation];
    }
    return storesArray;
}
@end
