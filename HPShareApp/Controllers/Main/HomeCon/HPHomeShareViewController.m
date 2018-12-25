//
//  HPHomeShareViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHomeShareViewController.h"
#import "HPTopMenuItemCell.h"
#import "HPMenuOpenStoreView.h"

typedef NS_ENUM(NSInteger, HPDisplaycellIndexpath) {
    HPDisplaycellIndexpathMenu = 50
};

@interface HPHomeShareViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) HPMenuOpenStoreView *openView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HPHomeShareViewController
static NSString *defaultCell = @"defaultCell";
static NSString *topMenuItemCell = @"topMenuItemCell";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.openView];
    [self.view setBackgroundColor:COLOR_GRAY_F6F6F6];
    
    [self.view addSubview:self.tableView];
    [self setUpSubviewsFrame];
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
    [self setUpHomeUi];
}

- (void)setUpSubviewsFrame
{
    [self.openView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(getWidth(140.f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.openView.mas_bottom);
    }];
}
- (void)setUpHomeUi
{

    
}

- (HPMenuOpenStoreView *)openView
{
    if (!_openView) {
        _openView = [HPMenuOpenStoreView new];
        _openView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _openView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCell];
        [_tableView registerClass:HPTopMenuItemCell.class forCellReuseIdentifier:topMenuItemCell];
    }
    return _tableView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerV = [[UIView alloc] initWithFrame:kRect(0, 0, kScreenWidth, getWidth(48.f))];
        headerV.backgroundColor = COLOR_GRAY_FFFFFF;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRect(getWidth(15.f), getWidth(14.f), headerV.frame.size.width, getWidth(48.f))];
        titleLabel.textColor = COLOR_BLACK_333333;
        titleLabel.font = kFont_Bold(20.f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"活动专区";
        [headerV addSubview:titleLabel];
        return headerV;
    }else if(section == 2){
        UIView *headerV = [[UIView alloc] initWithFrame:kRect(0, 0, kScreenWidth, getWidth(48.f))];
        headerV.backgroundColor = COLOR_GRAY_FFFFFF;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:kRect(getWidth(15.f), getWidth(14.f), headerV.frame.size.width, getWidth(48.f))];
        titleLabel.textColor = COLOR_BLACK_333333;
        titleLabel.font = kFont_Bold(20.f);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"热门共享店铺";
        [headerV addSubview:titleLabel];
        return headerV;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return getWidth(48.f);

    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    switch (indexPath.section) {
        case 0:
            return [self setUpMenuCell:tableView];
            break;
            
        default:
            break;
    }
    return cell;
}

- (HPTopMenuItemCell *)setUpMenuCell:(UITableView *)tableView
{
    HPTopMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:topMenuItemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    kWeakSelf(weakSlef);
    [cell setClickMenuItemBlock:^(NSInteger HPHomeShareMenuItem) {
        switch (HPHomeShareMenuItem) {
            case HPHome_page_store_sharing:
                HPLog(@"HPHome_page_store_sharing");
                break;
            case HPHome_page_lobby_sharing:
                HPLog(@"HPHome_page_lobby_sharing");
                break;
            case HPHome_page_other_sharing:
                HPLog(@"HPHome_page_other_sharing");
                break;
            case HPHome_page_map:
                HPLog(@"HPHome_page_map");
                break;
            case HPHome_page_stock_purchase:
                HPLog(@"HPHome_page_stock_purchase");
                break;
            case HPHome_page_shelf_rental:
                HPLog(@"HPHome_page_shelf_rental");
                break;
            case HPHome_page_used_shelves:
                HPLog(@"HPHome_page_used_shelves");
                break;
            case HPHome_page_new_store_opens:
                HPLog(@"HPHome_page_new_store_opens");
                break;
            default:
                break;
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return getWidth(150.f);
            break;
            
        default:
            break;
    }
    return CGFLOAT_MIN;
}

#pragma mark - 取消下拉  允许上拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.y < -g_statusBarHeight) {
        offset.y = -g_statusBarHeight;
        scrollView.contentOffset = offset;
    }
}
@end
