

#import <UIKit/UIKit.h>
#import "HPBaseViewController.h"
#import "HPShareListParam.h"

@interface HPAreaStoreItemListViewController : HPBaseViewController

@property(strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, strong) NSMutableArray *dataArray;

#pragma mark - network - 拼租发布数据

- (void)getAreaShareListDataReload:(BOOL)isReload;
@end
