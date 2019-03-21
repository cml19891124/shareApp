//
//  HPProfileViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPProfileViewController.h"

#import "HPHeaderViewCell.h"

#import "HPRelationViewCell.h"

#import "HPCustomerServiceModalView.h"

#import "HPSingleton.h"

#import "HPOrderItemCell.h"

typedef NS_ENUM(NSInteger, HPProfileSelectedRow) {
    HPProfileSelectedRowIdentify = 0,//资格认证
    HPProfileSelectedRowAccountSafe,//账号安全
    HPProfileSelectedRowEmotion,//意见反馈
    HPProfileSelectedRowOnlineServer,//在线客服
    HPProfileSelectedRowAbountUs//关于我们
};

@interface HPProfileViewController ()<UITableViewDelegate,UITableViewDataSource,HPHeaderViewCellDelegate>

@property (nonatomic, weak) HPCustomerServiceModalView *customerServiceModalView;

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation HPProfileViewController

static NSString *headerViewCell = @"HPHeaderViewCell";

static NSString *relationViewCell = @"HPRelationViewCell";

static NSString *orderItemCell = @"HPOrderItemCell";

#pragma mark - HPHeaderViewCellDelegate

- (void)onTapped:(HPHeaderViewCell *)tableviewCell HeaderView:(UITapGestureRecognizer *)tap
{
    HPLog(@"tap");
    HPLoginModel *model = [HPUserTool account];
    if (!model.token) {
        //        [HPProgressHUD alertMessage:@"用户未登录"];
        [self pushVCByClassName:@"HPLoginController"];
        
        return;
    }else{
        
        [self pushVCByClassName:@"HPConfigCenterController"];
    }
}

- (void)onClicked:(HPHeaderViewCell *)tableviewCell EditProfileInfoBtn:(UIButton *)button
{
    HPLog(@"edit");
    [self pushVCByClassName:@"HPEditPersonOInfoController"];
}

- (void)onClicked:(HPHeaderViewCell *)tableviewCell OptionalBtn:(UIButton *)optionalBtn
{
    HPLog(@"optional");
    optionalBtn.selected = !optionalBtn.selected;
    if (optionalBtn.selected) {
        [HPSingleton sharedSingleton].identifyTag = 1;
    }else{
        [HPSingleton sharedSingleton].identifyTag = 0;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        
        _tableView.estimatedRowHeight = 0;
        
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
    [HPSingleton sharedSingleton].identifyTag = 0;

    self.view.backgroundColor = COLOR_GRAY_f9fafd;

    self.imageArray = @[@"",@"",@[@"me_business_identify",@"me_business_safe",@"me_business_emotion",@"me_business_server",@"me_business_ours"]];
    
    self.titleArray = @[@"",@"",@[@"资格认证",@"账号安全",@"意见反馈",@"在线客服",@"关于我们"]];
//    [self.tableView reloadData];
    [self setUpSubviewsUI];
    
    [self setUpSubviewsUIMasonry];

}

- (void)setUpSubviewsUI
{
    [self.view addSubview:self.tableView];
}

- (void)setUpSubviewsUIMasonry
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(-g_statusBarHeight);
    }];
}

#pragma mark - 初始化控件

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_GRAY_f9fafd;
        _tableView.separatorColor = COLOR_GRAY_FAFAFA;
        [_tableView registerClass:HPHeaderViewCell.class forCellReuseIdentifier:headerViewCell];
        [_tableView registerClass:HPRelationViewCell.class forCellReuseIdentifier:relationViewCell];
        [_tableView registerClass:HPOrderItemCell.class forCellReuseIdentifier:orderItemCell];

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 5;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            return getWidth(300.f);

        }else{
            return getWidth(285.f);
        }
    }else if (indexPath.section == 1){
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            return getWidth(112.f);
            
        }else{
            return getWidth(67.f);
        }
    }else if (indexPath.section == 2){
        return getWidth(53.f);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:kRect(0, 0, kScreenWidth, getWidth(15.f))];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return getWidth(15.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCell = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        HPHeaderViewCell *cell = [self setUpHeaderViewCell:tableView];
        
        return cell;
    }
    else if(indexPath.section == 1){
        
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            HPOrderItemCell *cell = [self setOrderItemCell:tableView];
            return cell;
        }else{
            UIImageView *protectView = [UIImageView new];
            protectView.image = ImageNamed(@"me_business_protect");
            
            [cell.contentView addSubview:protectView];
            [protectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(cell);
                make.left.mas_equalTo(getWidth(15.f));
                make.right.mas_equalTo(getWidth(-15.f));
                
            }];
            cell.backgroundColor = COLOR_GRAY_f9fafd;
            
            return cell;
        }
        
        
    }
        else if (indexPath.section == 2){
        HPRelationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:relationViewCell];
        cell.backgroundColor = COLOR_GRAY_f9fafd;
            
        UIImage *image = ImageNamed(self.imageArray[indexPath.section][indexPath.row]);
            cell.iconView.image = image;
        cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
            return cell;
    }
    return cell;
}


- (HPOrderItemCell *)setOrderItemCell:(UITableView *)tableView
{
    HPOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:orderItemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    HPLoginModel *account = [HPUserTool account];
    return cell;
}

- (HPHeaderViewCell *)setUpHeaderViewCell:(UITableView *)tableView
{
    HPHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headerViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.identifyTag = [HPSingleton sharedSingleton].identifyTag;

    HPLoginModel *account = [HPUserTool account];
    if (!account.token) {
        cell.optionalBtn.hidden = YES;
        [cell.phoneBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        cell.identifiLabel.text = @"登录即可在线拼租";
        cell.iconImageView.image = ImageNamed(@"personal_center_not_login_head");
        
    }else{
        cell.optionalBtn.hidden = NO;
        cell.identifiLabel.text = @"租客信息，资质认证";
        [cell.phoneBtn setTitle:account.userInfo.mobile forState:UIControlStateNormal];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.userInfo.avatarUrl] placeholderImage:ImageNamed(@"personal_center_not_login_head")];
    }
    
    cell.orderBlock = ^(NSInteger orderIndex) {
        if (orderIndex == HPOrderCellIndexToReceive) {
            HPLog(@"toreceive");
        }else if (orderIndex == HPOrderCellIndexToPay){
            HPLog(@"to pay");
        }else if (orderIndex == HPOrderCellIndexToRent){
            HPLog(@"to rent");
        }else if (orderIndex == HPOrderCellIndexToReturnFuns){
            HPLog(@"to return");
        }else if (orderIndex == HPOrderCellIndexToComment){
            HPLog(@"to comment");
        }
    };
    
    cell.busiBlock = ^(NSInteger businessIndex) {
        if (businessIndex == HPBusinessCellIndexStores) {
            [self pushVCByClassName:@"HPShareShopListController"];
        }else if (businessIndex == HPBusinessCellIndexOrder){
            HPLog(@"order");
        }else if (businessIndex == HPBusinessCellIndexWallet){
            HPLog(@"wallet");
        }else if (businessIndex == HPBusinessCellIndexName){
            HPLog(@"name");
            [self pushVCByClassName:@"HPMyCardController" withParam:@{@"userId":account.userInfo.userId}];
        }
    };
    return cell;
}
//设置分割线的位置 在willDisplayCell上增加如下代码

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.separatorInset = UIEdgeInsetsMake(0, getWidth(62.f), 0, getWidth(35.f));
    
    //缩进50pt
    
    //去了最后一行cell的分割线需要这样
//    if (indexPath.row== self.imageArray.count-1) {
//        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth , 0, 0);
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HPLoginModel *account = [HPUserTool account];
    if (indexPath.section == 2) {
        if (indexPath.row == HPProfileSelectedRowIdentify) {
//            [self pushVCByClassName:@"HPFeedbackController"];
        }else if (indexPath.row == HPProfileSelectedRowAccountSafe) {
            if (account.token) {
                [self pushVCByClassName:@"HPConfigCenterController"];
            }
        }else if (indexPath.row == HPProfileSelectedRowEmotion) {
            [self pushVCByClassName:@"HPFeedbackController"];
        }else if (indexPath.row == HPProfileSelectedRowOnlineServer) {
            if (_customerServiceModalView == nil) {
                HPCustomerServiceModalView *customerServiceModalView = [[HPCustomerServiceModalView alloc] initWithParent:self.parentViewController.view];
                customerServiceModalView.phone = @"0755-86713128";
                [customerServiceModalView setPhoneString:@"0755-86713128"];
                _customerServiceModalView = customerServiceModalView;
            }
            
            [_customerServiceModalView show:YES];
            [self.parentViewController.view bringSubviewToFront:_customerServiceModalView]; 
        }else if (indexPath.row == HPProfileSelectedRowAbountUs) {
            [self pushVCByClassName:@"HPAboutUsViewController"];
        }
    }
}

@end
