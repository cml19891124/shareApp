//
//  HPOrderManagerViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "HPQuitOrderView.h"

#import "HPOrderListViewController.h"

#import "HPShareDetailModel.h"

#import "HPOrderCell.h"

#import "HPChooseItemView.h"

#import "HPSingleton.h"

#import "HPShareListParam.h"

#import "HOOrderListModel.h"

#import "HPSingleton.h"

typedef NS_ENUM(NSInteger, HPOrderType) {
    HPOrderTypeRentCreateOrder = 4901,//租客下单，等待商家确认
    HPOrderTypeOwnnerConfirmOrder,//商家确认，等待租客确认
    HPOrderTypeOwnnerPayed,//已经付款，拼租进行
    HPOrderTypeOwnnerRentComplete,//确认拼租完成
    HPOrderTypeOwnnerOwnnerCancel,//商家取消
    HPOrderTypeOwnnerRenterCancel,//租客取消
    HPOrderTypeOwnnerOwnnerTimerOutOfReceiveCancel,//超时未接单取消
    HPOrderTypeOwnnerRenterTimerOutOfToPayCancel//超时未付款取消
};

@interface HPOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) HPOrderCell *cell;

@property (strong, nonatomic) HPQuitOrderView *quitView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HPShareDetailModel *model;

@property (nonatomic, strong) NSArray *imageArr;

@property (strong, nonatomic) NSArray *titleArr;

@property (nonatomic, strong) HPChooseItemView *orderItemView;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (strong, nonatomic) NSMutableArray *orderArray;

/**
 订单状态
 */
@property (assign, nonatomic) NSNumber *status;

@property (assign, nonatomic) NSNumber *orderStaus;
@end

@implementation HPOrderListViewController

static NSString *orderCell = @"orderCell";


- (HPQuitOrderView *)quitView
{
    if (!_quitView) {
        
        _quitView = [HPQuitOrderView new];
        kWEAKSELF
        _quitView.holderBlock = ^{
            HPLog(@"dfsdg");
            [weakSelf.quitView show:NO];
        };
        
    }
    return _quitView;
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_EEEEEE];
    
    self.status = @(0);
    _model = self.param[@"order"];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getOrderListApiReload:NO];
    }];

    [self setUpListSubviews];
    
    [self setUpListSubviesMasonry];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.orderArray = [NSMutableArray array];

    self.orderStaus = self.param[@"orderStaus"];
    
    NSInteger add = 0;
    self.status = @(0);
    if (self.orderStaus.integerValue == 0) {
        add = 0;
        self.status = @(0);

    }else if (self.orderStaus.integerValue == 1){
        add = 1;
        self.status = @(1);

    }else if (self.orderStaus.integerValue == 2){
        add = 2;
        self.status = @(2);

    }else if (self.orderStaus.integerValue == 3){// 待收货
        add = 3;
        self.status = @(3);

    }else if (self.orderStaus.integerValue == 4){// 已完成/待评论
        add = 4;
        self.status = @(4);

    }
    [self.orderItemView scrolling:2200 + add];
    [self getOrderListApiReload:YES];
}

#pragma mark - 获取订单列表
- (void)getOrderListApiReload:(BOOL)isReload
{
    self.shareListParam = [HPShareListParam new];
    
    self.shareListParam.page = 1;
    
    self.shareListParam.pageSize = 20;
    
    if (isReload) {
        _shareListParam.page = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isBoss"] = [NSString stringWithFormat:@"%ld",[HPSingleton sharedSingleton].identifyTag];//商家还是租户：1商家，0租户
    dic[@"page"] = @(self.shareListParam.page);
    dic[@"pageSize"] = @(self.shareListParam.pageSize);
    dic[@"status"] = self.status.integerValue == 0?@"":self.status.stringValue;
//    dic[@"isReviewed"] = @"1";//交易完成是否评价 1 是 0 否
    [HPHTTPSever HPGETServerWithMethod:@"/v1/order" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *listArray = [HOOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (listArray) {
                if (isReload) {
                    [self.orderArray removeAllObjects];
                }
                
                [self.orderArray addObjectsFromArray:listArray];
            }
            
            if ([responseObject[@"data"][@"total"] integerValue] == 0 || self.orderArray.count == 0) {
                [HPProgressHUD alertMessage:@"暂无数据"];
            }
            
            if (listArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.tableView.mj_footer endRefreshing];
                self.shareListParam.page ++;
            }
            
            [self.tableView reloadData];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setUpListSubviews
{
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.view addSubview:self.orderItemView];
    
    [self setupShadowOfPanel:self.orderItemView];

    [self.view addSubview:self.tableView];

}

- (HPChooseItemView *)orderItemView
{
    if (!_orderItemView) {
        kWEAKSELF
        _orderItemView = [HPChooseItemView new];
        _orderItemView.backgroundColor = COLOR_GRAY_FFFFFF;
        _orderItemView.block = ^(NSInteger menuItem) {
            HPLog(@"fsgfsg");
            if (menuItem == HPAreaItemsMenuAllOrder) {
                weakSelf.status = @(0);
            }else if (menuItem == HPAreaItemsMenuToReceive){
                weakSelf.status = @(1);
            }else if (menuItem == HPAreaItemsMenuToPay){
                weakSelf.status = @(2);
            }else if (menuItem == HPAreaItemsMenuToRent){
                weakSelf.status = @(3);
            }else if (menuItem == HPAreaItemsMenuToComment){
                weakSelf.status = @(4);
            }
            [weakSelf.orderItemView scrolling:menuItem];
            [weakSelf getOrderListApiReload:YES];
        };
    }
    return _orderItemView;
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.image = ImageNamed(@"order_head");
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];
        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_GRAY_FFFFFF;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"我的订单";
    }
    return _titleLabel;
}

- (void)setupShadowOfPanel:(UIView *)view {
    [view.layer setShadowColor:COLOR_GRAY_D5D5D5.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [view.layer setShadowRadius:6.f];
    [view.layer setShadowOpacity:0.9f];
    [view.layer setCornerRadius:6.f];
    [view setBackgroundColor:UIColor.whiteColor];
}

- (void)setUpListSubviesMasonry
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(g_statusBarHeight + 44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.orderItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self.view);
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
        make.height.mas_equalTo(getWidth(45.f));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.orderItemView.mas_bottom);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:HPOrderCell.class forCellReuseIdentifier:orderCell];
        
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    kWEAKSELF
    HOOrderListModel *model = self.orderArray[indexPath.row];
    HPOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCell];
    
    if (!cell) {
        cell = [[HPOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCell];
    }
    self.cell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    cell.payBlock = ^(NSInteger payOrder) {
        if (payOrder == 4800) {
            [weakSelf deleteOrderFromList:model];
            
        }else if (payOrder == PayOrderToCancel){///{version}/orderReview/orderReview 订单评价
            ///{version}/orderReview/queryOrderReview
            //查看订单评价
            
            [weakSelf.view addSubview:weakSelf.quitView];
            
            weakSelf.quitView.signTextView.placehText = @"  请填写取消此订单原因";
            
            [weakSelf.quitView show:YES];
            weakSelf.quitView.quitBlock = ^{
                HPLog(@"5555");
                [weakSelf.quitView show:NO];
                [weakSelf cancelOrder:model];
                
            };
            
        }else if (payOrder == PayOrderToPay){
            
            [self clickToPayBtn:weakSelf.cell with:model];
            
        }
    };

    return cell;
}

- (void)clickToPayBtn:(HPOrderCell *)cell with:(HOOrderListModel *)model
{
    HPLog(@"---:%ld",(long)[HPSingleton sharedSingleton].identifyTag);
    
    if ( model.order.status.integerValue == 2) {
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            [self pushVCByClassName:@"HPOrderDetailViewController" withParam:@{@"model":model}];
        }else{
            if ([cell.topayBtn.currentTitle isEqualToString:@"在线催单"]) {
                [self pushVCByClassName:@"HPImergencyManagerViewController" withParam:@{@"model":model}];
                
            }else if([cell.topayBtn.currentTitle isEqualToString:@"确认接单"]){
                [self pushVCByClassName:@"HPOrderManagerViewController" withParam:@{@"model":model}];

            }else if ([cell.topayBtn.currentTitle isEqualToString:@"立即支付"]) {
                [self pushVCByClassName:@"HPOrderDetailViewController" withParam:@{@"model":model}];
            }
        }
        
    }else if( model.order.status.integerValue == 1){
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            if([cell.topayBtn.currentTitle isEqualToString:@"在线催单"]){
                [self pushVCByClassName:@"HPUserImergencyDetailViewController" withParam:@{@"model":model}];
                
            }
           
        }else
        {//确认接单
                [self pushVCByClassName:@"HPOrderManagerViewController" withParam:@{@"model":model}];
        }
    }else if( model.order.status.integerValue == 3){
        if ([HPSingleton sharedSingleton].identifyTag == 0) {//付款后 确认收货
            [self pushVCByClassName:@"HPUserImergencyDetailViewController" withParam:@{@"model":model}];

        }
    }
//    else if( model.order.status.integerValue == 11){
//        if ([HPSingleton sharedSingleton].identifyTag == 0) {//评价
//            [self pushVCByClassName:@"HPUserImergencyDetailViewController" withParam:@{@"model":model}];
//
//        }
//    }
}

- (void)cancelOrder:(HOOrderListModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cancelReason"] = self.quitView.signTextView.text;
    dic[@"orderId"] = model.order.orderId;

    [HPHTTPSever HPPostServerWithMethod:@"/v1/order/tenantCancel" paraments:dic needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self getOrderListApiReload:YES];
        }else{
            [HPProgressHUD alertMessage:MSG];

        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)deleteOrderFromList:(HOOrderListModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isBoss"] = @([HPSingleton sharedSingleton].identifyTag);
    dic[@"orderId"] = model.order.orderId;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/order/delete" isNeedToken:NO paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self getOrderListApiReload:YES];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HOOrderListModel *model = self.orderArray[indexPath.row];
    if (model.order.status.integerValue == 13 || model.order.status.integerValue == 3 || model.order.status.integerValue == 14 || model.order.status.integerValue == 15 || model.order.status.integerValue == 12) {
        if ([HPSingleton sharedSingleton].identifyTag == 1) {
            return getWidth(154.f);

        }else{
            return getWidth(200.f);

        }
    }
    return getWidth(200.f);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HOOrderListModel *model = self.orderArray[indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 确认订单详情

@end
