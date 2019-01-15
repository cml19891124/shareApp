//
//  PoiDetailViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "HPPoiDetailViewController.h"
#import "Macro.h"
#import "HPGlobalVariable.h"

#define TemporaryNotOpened @"暂未开通"

@interface HPPoiDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HPPoiDetailViewController
@synthesize poi = _poi;
@synthesize tableView = _tableView;

#pragma mark - Utility

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0 : title = @"店铺/用户全局唯一ID";    break;
            case 1 : title = @"用户名称";            break;
//            case 2 : title = @"兴趣点类型";       break;
            case 2 : title = @"经纬度";          break;
            case 3 : title = @"地址";            break;
            case 4 : title = @"电话";            break;
            default: title = @"距中心点距离";     break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0   : title = @"邮编";            break;
            case 1   : title = @"网址";            break;
            case 2   : title = @"电子邮件";         break;
            case 3   : title = @"省(省编码)";       break;
            case 4   : title = @"市(市编码)";       break;
            case 5   : title = @"区域(区域编码)";    break;
            case 6   : title = @"地理格ID";         break;
            case 7   : title = @"导航点ID";         break;
            case 8   : title = @"入口经纬度";        break;
            case 9   : title = @"出口经纬度";        break;
            case 10  : title = @"权重";             break;
            case 11  : title = @"匹配";             break;
            case 12  : title = @"推荐标识";          break;
            case 13  : title = @"时间戳";           break;
            case 14  : title = @"方向";             break;
            case 15  : title = @"是否有室内地图";      break;
            case 16  : title = @"室内地图来源";       break;
                
            default  :  break;
        }
    }
    
    return title;
}

- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *subTitle = nil;
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0 : subTitle = self.poi.userId;                       break;
            case 1 : subTitle = self.poi.contact;                      break;
//            case 2 : subTitle = [@(self.poi.type) stringValue];                      break;
            case 2 : subTitle = [NSString stringWithFormat:@"%.2lf,%.2lf",self.poi.longitude,self.poi.latitude];    break;
            case 3 : subTitle = self.poi.address;                   break;
            case 4 : subTitle = self.poi.contactMobile;                       break;
            default: subTitle = [NSString stringWithFormat:@"%@(米)", @"25"];                                                   break;
                
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0  : subTitle = self.poi.userId;             break;
            case 1  : subTitle = self.poi.userId;              break;
            case 2  : subTitle = self.poi.userId;                break;
            case 3  : subTitle = self.poi.userId;                              break;
            case 4  : subTitle = self.poi.description;                             break;
            case 5  : subTitle = self.poi.address;                             break;
            case 6  : subTitle = TemporaryNotOpened;            break;
            case 7  : subTitle = TemporaryNotOpened;            break;
            case 8  : subTitle = self.poi.address;   break;
            case 9  : subTitle = self.poi.address;    break;
            case 10 : subTitle = TemporaryNotOpened;            break;
            case 11 : subTitle = TemporaryNotOpened;            break;
            case 12 : subTitle = TemporaryNotOpened;            break;
            case 13 : subTitle = TemporaryNotOpened;            break;
            case 14 : subTitle = self.poi.address;            break;
            case 15 : subTitle = self.poi.address;                                              break;
            default : break;
        }
    }
    
    return subTitle;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 6 : 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *poiDetailCellIdentifier = @"poiDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:poiDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poiDetailCellIdentifier];
    }
    
    cell.textLabel.text         = [self titleForIndexPath:indexPath];
    cell.detailTextLabel.text   = [self subTitleForIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, g_statusBarHeight + 44.f, kScreenWidth, kScreenHeight - g_statusBarHeight - 44.f) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)initTitle:(NSString *)title
{
//    UILabel *titleLabel = [[UILabel alloc] init];
//
//    titleLabel.backgroundColor  = [UIColor clearColor];
//    titleLabel.textColor        = [UIColor blackColor];
//    titleLabel.text             = title;
//    [titleLabel sizeToFit];
//
//    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    [self setupNavigationBarWithTitle:title];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.poi = self.param[@"poi"];
    [self initTitle:@"店铺详情列表"];
    
    [self initTableView];
}

@end
