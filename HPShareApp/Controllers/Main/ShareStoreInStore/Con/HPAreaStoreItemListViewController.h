

#import <UIKit/UIKit.h>
#import "HPBaseViewController.h"
#import "HPShareListParam.h"

@interface HPAreaStoreItemListViewController : HPBaseViewController

@property(strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) HPShareListParam *shareListParam;
#pragma mark - network - 共享发布数据

- (void)getAreaShareListDataReload:(BOOL)isReload;
@end
