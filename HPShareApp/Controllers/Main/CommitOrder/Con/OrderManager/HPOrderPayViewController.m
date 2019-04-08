//
//  HPOrderPayViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/28.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderPayViewController.h"

#import "WXApiObject.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "payRequsestHandler.h"

#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "APRSASigner.h"

#import "HPPayModel.h"

#import "HPPayStyleCell.h"

#import "HOOrderListModel.h"
@interface HPOrderPayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) HOOrderListModel *model;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *tipLabel;
/**
 支付类型
 */
@property(nonatomic,assign) PayType payType;

@property (nonatomic, strong) NSArray *imageArr;

@property (strong, nonatomic) NSArray *titleArr;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, copy) NSString *payWay;

@property (assign, nonatomic) NSInteger Status;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) HPPayModel *payModel;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation HPOrderPayViewController

static NSString *payStyleCell = @"payStyleCell";

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.model = self.param[@"model"];
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self setPayConfig];

    [self setUpCommitSubviews];
    
    [self setUpCommitSubviewsMasonry];
}

- (void)setPayConfig
{
    //默认为微信支付
    self.payType = kPayTypeWeChat;
    
    //注册支付宝支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAliPayReturn:) name:notice_AliPayReturnData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXPayReturn:) name:notice_WXPayReturnData object:nil];
    
    self.imageArr = @[@"weixin_pay",@"zhifubao"];
    self.titleArr = @[@"微信支付",@"支付宝支付"];
    self.Status = 1;
    
}

- (void)setUpCommitSubviews
{
    [self.view addSubview:self.headerView];

    [self.headerView addSubview:self.backBtn];

    [self.headerView addSubview:self.titleLabel];

    [self.headerView addSubview:self.backBtn];
    
    [self.view addSubview:self.tableHeaderView];
    
    [self.tableHeaderView addSubview:self.tipLabel];
    
    [self.tableHeaderView addSubview:self.lineView];
    
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.confirmBtn];

}

- (void)setUpCommitSubviewsMasonry
{
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(g_statusBarHeight + 44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(16.f));
        make.width.height.mas_equalTo(getWidth(13.f));
        make.top.mas_equalTo(g_statusBarHeight + 15.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(getWidth(-60.f));
    }];
    
    [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.mas_equalTo(getWidth(53.f));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.tableHeaderView);
        make.height.mas_equalTo(getWidth(52.f));
        make.left.mas_equalTo(getWidth(15.f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.bottom.mas_equalTo(self.tableHeaderView);
        make.height.mas_equalTo(1);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(getWidth(330.f), getWidth(44.f)));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(getWidth(-10.f));
    }];
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = COLOR_RED_EA0000;
        _confirmBtn.layer.cornerRadius = 6.f;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _lineView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.backgroundColor = COLOR_GRAY_FFFFFF;
        _tipLabel.text = @"支付方式";
        _tipLabel.font = kFont_Bold(16.f);
        _tipLabel.textColor = COLOR_BLACK_333333;
        
    }
    return _tipLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:HPPayStyleCell.class forCellReuseIdentifier:payStyleCell];
        
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [UIView new];
        _tableHeaderView.backgroundColor = COLOR_GRAY_FFFFFF;

    }
    return _tableHeaderView;
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
        [_backBtn setBackgroundImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
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
        _titleLabel.text = @"支付方式";
    }
    return _titleLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPPayStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:payStyleCell];
    
    NSString *title = self.titleArr[indexPath.row];
    NSString *imageName = self.imageArr[indexPath.row];
    cell.imaV.image =[UIImage imageNamed:imageName];
    cell.titleLabel.text = title;
    
    if (_selectedRow == indexPath.row) {
        cell.selectedButton.selected = YES;
    }else{
        cell.selectedButton.selected = NO;
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArr.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(50.f);

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectedIndexBlock) {
        self.selectedIndexBlock(indexPath.row);
    }
    if (indexPath.section == 0) {
        self.selectedRow = indexPath.row;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
        if (indexPath.row == payWeChat) {//微信支付
            self.payType = kPayTypeWeChat;
        }else if (indexPath.row == payAlipay) {//支付宝支付
            self.payType = kPayTypeAlipay;
        }
    }
}

#pragma mark - 确认订单详情

- (void)onClickConfirmBtn:(UIButton *)button
{
    [HPProgressHUD alertWithLoadingText:@"正在调起支付..."];
    
    [self realyToPay];
    
}

#pragma mark - 真正调用接口去支付
- (void)realyToPay{
    
    // key == wx:微信 alipay:支付宝
    NSString * key;
    
    switch (self.payType) {
            
        case kPayTypeAlipay:
            key = @"alipay";
            break;
        case kPayTypeWeChat:
            key = @"wx";
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"totalFee"] = _model.order.totalFee;
    dict[@"orderId"] = _model.order.orderId;
    dict[@"tradeType"] = @"APP";
    
    [HPHTTPSever HPPostServerWithMethod:@"/v1/wxpay/unifiedOrder" paraments:dict needToken:YES complete:^(id  _Nonnull responseObject) {
        //不是余额调用支付宝或者微信
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"预支付成功"];
            
            self.payModel = [HPPayModel mj_objectWithKeyValues:DATA];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = self.payModel.partnerid;//微信支付分配的商户ID
            req.prepayId            = self.payModel.prepayid;// 预支付交易会话ID
            req.nonceStr            = self.payModel.noncestr;//随机字符串
            req.timeStamp           = self.payModel.timestamp.intValue;//当前时间
            req.package             = self.payModel.package;//固定值
            req.sign                = self.payModel.sign;//签名，除了sign，剩下6个组合的再次签名字符串
            req.openID              = self.payModel.appid;//微信开放平台审核通过的AppID
            //            [WXApi sendReq:req];
            
            if ([WXApi isWXAppInstalled] == YES) {
                //此处会调用微信支付界面
                BOOL success = [WXApi sendReq:req];
                if (!success) {
                    HPLog(@"sdk错误");
                }else
                {
                    
                }
            }else {
                //微信未安装
                [HPProgressHUD alertMessage:@"您没有安装微信"];
            }
            
        }else{
            [HPProgressHUD alertMessage:MSG];
            
        }
        
    } Failure:^(NSError * _Nonnull error) {
        
        ErrorNet
        
    }];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
    [kNotificationCenter removeObserver:self];
    
}

//处理支付宝支付返回结果
- (void)handleAliPayReturn:(NSNotification * )notification{
    NSDictionary * dict = notification.object;
    HPLog(@"++++++++%@",dict);
    switch ([[dict objectForKey:@"resultStatus"] intValue]) {
        case 9000://订单支付成功
        {
            
            [HUD HUDWithString:@"支付成功！"];
            [HUD HUDHidden];
            [self.navigationController popToRootViewControllerAnimated:YES];
            if(self.paySuccessBlock){
                self.paySuccessBlock();
            }
        }
            break;
        case 4000://订单支付失败
        {
            [HUD HUDWithString:@"订单支付失败"];
        }
            break;
        case 6001://用户中途取消
        {
            [HUD HUDWithString:@"取消支付"];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)handleWXPayReturn:(NSNotification * )notification{
    PayResp * payResp = notification.object;
    if(payResp.errCode == 0){
        
//        [HUD HUDHidden];
        [self pushVCByClassName:@"HPPayResultViewController" withParam:@{@"orderNo":self.payModel.out_trade_no}];
        if(self.paySuccessBlock){
            self.paySuccessBlock();
        }
    }else{
//        [HUD HUDWithString:@"支付失败！"];
//        [HUD HUDHidden];
        [HPProgressHUD alertMessage:@"支付失败！"];
    }
    
}
@end
