//
//  HPPayOrderViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/9.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPayOrderViewController.h"

#import "HPPayStyleCell.h"

#import "WXApiObject.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "payRequsestHandler.h"

#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "APRSASigner.h"

#import "HPGradientUtil.h"

#import "HPShareDetailModel.h"

#import "HPBaseModalView.h"

#import "HPRowPanel.h"

#import "HPStoreItemButton.h"

@interface HPPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imageArr;

@property (strong, nonatomic) NSArray *titleArr;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, copy) NSString *payWay;

/**
 支付类型
 */
@property(nonatomic,assign) PayType payType;

@property (assign, nonatomic) NSInteger Status;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIButton *confirmOrderBtn;

@property (nonatomic, strong) HPShareDetailModel *model;

@property (nonatomic, strong) HPBaseModalView *modelView;

@property (nonatomic, strong) UIButton *coverView;

@property (nonatomic, strong) UILabel *shopNameLabel;

@property (nonatomic, strong) HPStoreItemButton *tagBtn;

@property (nonatomic, strong) UILabel *contactField;

@property (nonatomic, strong) UILabel *phoneLabel;
@end

@implementation HPPayOrderViewController

static NSString *payStyleCell = @"payStyleCell";

- (UIButton *)coverView{
    if (!_coverView) {
        _coverView = [UIButton new];
        [_coverView addTarget:self action:@selector(hiddenCoverView:) forControlEvents:UIControlEventTouchUpInside];
        [_coverView setBackgroundColor:COLOR(0, 0, 0, 0.4)];
        _coverView.hidden = YES;
    }
    return _coverView;
}

- (void)hiddenCoverView:(UIButton *)button
{
    self.coverView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self setupNavigationBarWithTitle:@"订单支付"];
    
    _model = self.param[@"order"];
    
    [self setupOrderInfoUI];
    
    //默认为微信支付
    self.payType = kPayTypeWeChat;
    
    //注册支付宝支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAliPayReturn:) name:notice_AliPayReturnData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXPayReturn:) name:notice_WXPayReturnData object:nil];
    
    self.imageArr = @[@"wechatPay",@"alipay"];
    self.titleArr = @[@"微信支付",@"支付宝支付"];
    self.Status = 1;
    
    [self.view addSubview:self.confirmOrderBtn];

    [self.confirmOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(getWidth(15.f));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(getWidth(-20.f));
        make.height.mas_equalTo(getWidth(44.f));
    }];
}

#pragma mark - setupUI

- (void)setupOrderInfoUI {
    for (int i = 0; i < 3; i++) {
//        [self setupPanelAtIndex:i ofView:self.scrollView];
    }
    
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        CGSize btnSize = CGSizeMake(kScreenWidth/3, 44.f);
        UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(btnSize.width, 0.f) endPoint:CGPointMake(0.f, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR_ORANGE_FF9B5E endColor:COLOR_RED_FF3455];
        UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn.layer setCornerRadius:5.f];
        [_confirmBtn.layer setMasksToBounds:YES];
        [_confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIButton *)confirmOrderBtn
{
    if (!_confirmOrderBtn) {
        CGSize btnSize = CGSizeMake(kScreenWidth/3, 44.f);
        UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(btnSize.width, 0.f) endPoint:CGPointMake(0.f, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR_ORANGE_FF9B5E endColor:COLOR_RED_FF3455];
        UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _confirmOrderBtn = [[UIButton alloc] init];
        [_confirmOrderBtn.layer setCornerRadius:5.f];
        [_confirmOrderBtn.layer setMasksToBounds:YES];
        [_confirmOrderBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
        [_confirmOrderBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmOrderBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        [_confirmOrderBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_confirmOrderBtn addTarget:self action:@selector(onClickConfirmOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmOrderBtn;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HPPayStyleCell class] forCellReuseIdentifier:payStyleCell];
        
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
        
        _tableView.layer.cornerRadius = 5.f;
        _tableView.layer.masksToBounds = YES;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

#pragma mark - tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(50.f);
}
#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr count];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    dict[@"totalFee"] = @(1);
    
    dict[@"tradeType"] = @"APP";
    
    [HPHTTPSever HPPostServerWithMethod:@"/v1/wxpay/unifiedOrder" paraments:dict needToken:YES complete:^(id  _Nonnull responseObject) {
        //不是余额调用支付宝或者微信
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"预支付成功"];
            
            NSMutableString *stamp  = [responseObject objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [responseObject objectForKey:@"partnerid"];//微信支付分配的商户ID
            req.prepayId            = [responseObject objectForKey:@"prepayid"];// 预支付交易会话ID
            req.nonceStr            = [responseObject objectForKey:@"noncestr"];//随机字符串
            req.timeStamp           = stamp.intValue;//当前时间
            req.package             = [responseObject objectForKey:@"package"];//固定值
            req.sign                = [responseObject objectForKey:@"sign"];//签名，除了sign，剩下6个组合的再次签名字符串
            req.openID              = [responseObject objectForKey:@"appid"];//微信开放平台审核通过的AppID
//            [WXApi sendReq:req];
            
            if ([WXApi isWXAppInstalled] == YES) {
                //此处会调用微信支付界面
                BOOL success = [WXApi sendReq:req];
                if (!success) {
                    HPLog(@"sdk错误");
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


- (void)payMoneyWithOrderNo:(NSString *)orderNo{
    [HPHTTPSever HPPostServerWithMethod:@"" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        //不是余额调用支付宝或者微信
        [self payMoneyWithOrderNo:[responseObject[@"data"] objectForKey:@"orderNo"]];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark - 根据返回的秘钥开始支付宝或者微信支付
- (void)startPayWithParamDict:(NSDictionary *) paramDict orderNo:(NSString *)orderNo{
    //alipay  wx wxNotifyUrl alipayNotifyUrl
    [HUD HUDHidden];
    //支付宝支付
    if(self.payType == kPayTypeAlipay){
        APOrderInfo * order = [[APOrderInfo alloc] init];
        order.app_id = kAppleId;   //appid设置
        order.method = @"alipay.trade.app.pay";//支付接口名称
        order.charset = @"utf-8";  //参数编码格式
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        order.version = @"1.0";   //支付版本
        NSString * rsa2PrivateKey ;
        NSString *rsaPrivateKey = @"";
        rsa2PrivateKey = [paramDict objectForKey:@"alipay"]; //商户私钥
        order.sign_type = @"RSA";
        
        //商品的数据
        order.biz_content = [APBizContent new];
        order.biz_content.body = @"合店站支付";
        order.biz_content.subject = @"合店站支付";
        order.biz_content.out_trade_no = orderNo;//订单ID（商家决定）
        order.biz_content.timeout_express = @"30m";//超时时间
        
        order.biz_content.total_amount = [NSString stringWithFormat:@"%@",_model.rent];  //商品价格
        order.notify_url = [paramDict objectForKey:@"alipayNotifyUrl"];//回调URL
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        HPLog(@"orderSpec = %@",orderInfo);
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        
        
        NSString *signedString = nil;
        APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
        if ((rsa2PrivateKey.length > 1)) {
            signedString = [signer signString:orderInfo withRSA2:NO];
        } else {
            signedString = [signer signString:orderInfo withRSA2:NO];
        }
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"JIABEI";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                switch ([[resultDic objectForKey:@"resultStatus"] intValue]) {
                    case 9000://订单支付成功
                    {
                        
                        [HUD HUDWithString:@"支付成功！"];
                        [HUD HUDHidden];
                        [self.navigationController popViewControllerAnimated:YES];
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
            }];
        }
        
    }
    
    //微信支付
    if(self.payType == kPayTypeWeChat){
        
        if([WXApi isWXAppInstalled]){
            
            //创建微信支付签名对象
            payRequsestHandler * req = [[payRequsestHandler alloc] init];
            [req initAPPID:WeiXinKey mch_id:@"1487395772" notifyUrl_url:[paramDict objectForKey:@"wxNotifyUrl"]];
            //密钥
            NSString * priyKey = [paramDict objectForKey:@"wx"];
            [req setKey:priyKey];
            //获取到实际调起微信支付的参数后，在APP端调起支付
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            NSString * amount = [NSString stringWithFormat:@"%@",_model.rent];
            NSString * comes = [NSString stringWithFormat:@"fee =%@,out_trade_no =%@",amount,orderNo];
            dict = [req sendPay_demo:@"合店站支付" :[amount doubleValue] :comes tradeNo:orderNo];
            if(dict == nil){
                [HUD HUDWithString:@"微信支付稍后重试"];
                return;
            }
            NSMutableString * stamp = dict[@"timestamp"];
            //需要创建这个支付对象
            PayReq *payReq   = [[PayReq alloc] init];
            //由用户微信号和AppID组成的唯一标识，用于校验微信用户
            payReq.openID = dict[@"appid"];
            // 商家id，在注册的时候给的
            payReq.partnerId = dict[@"partnerid"];
            payReq.prepayId = dict[@"prepayid"];
            payReq.nonceStr = dict[@"noncestr"];
            payReq.package = dict[@"package"];
            payReq.sign = dict[@"sign"];
            payReq.timeStamp = stamp.intValue;
            [WXApi sendReq:payReq];
            
        }else{
            [HUD HUDWithString:@"检测到手机未安装微信"];
        }
    }
    
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
        
        [HUD HUDHidden];
        [self.navigationController popToRootViewControllerAnimated:YES];
        if(self.paySuccessBlock){
            self.paySuccessBlock();
        }
    }else{
        [HUD HUDWithString:@"支付失败！"];
        [HUD HUDHidden];
        
    }
    
}

#pragma mark - 确认订单详情

- (void)onClickConfirmOrderBtn:(UIButton *)button
{
    [self.view addSubview:self.coverView];
    self.coverView.hidden = NO;
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.coverView addSubview:self.tableView];

    [self.tableView addSubview:self.confirmBtn];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth *0.7);
        make.height.mas_equalTo(getWidth(150.f));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView).offset(getWidth(15.f));
        make.centerX.mas_equalTo(self.tableView);
        make.top.mas_equalTo(getWidth(110.f));
        make.height.mas_equalTo(getWidth(30.f));
    }];
    
}

#pragma mark - row view
- (void)setupPanelAtIndex:(NSInteger)index ofView:(UIView *)view {
    HPRowPanel *panel = [[HPRowPanel alloc] init];
    [view addSubview:panel];
    if (index == 0) {
        //店铺简称
        [panel addRowView:[self setupStoreNameRowView]];
        [panel addRowView:[self setupStoreTagRowView] withHeight:46.f * g_rateWidth];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(92.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }
    else if (index == 1) {
//        [panel addRowView:[self setupAreaRowView]];
        [panel addRowView:[self setupDetailAddressRowView]];
        [panel addRowView:[self setupManagerIndustryRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(138.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        
        
    }
    else if (index == 2) {
        [panel addRowView:[self setupContactRowView]];
        [panel addRowView:[self setupPhoneNumRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(90.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
    }

}

#pragma mark - 店铺简称
- (UIView *)setupStoreNameRowView {
    UIView *view = [[UIView alloc] init];
    
    [self setupTitleLabelWithText:@"店铺简称" ofView:view];
    _shopNameLabel = [self setupOptTitleLabelWithText:_model.title ofView:view];
    _shopNameLabel.font = kFont_Regular(13.f);
    
    return view;
}

#pragma mark - 店铺标签
- (UIView *)setupStoreTagRowView {
    UIView *view = [[UIView alloc] init];

    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kFont_Medium(15.f)];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"店铺标签"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    HPStoreItemButton *addBtn = [[HPStoreItemButton alloc] init];
    [addBtn setTitle:@"" forState:UIControlStateNormal];
    [addBtn setImage:ImageNamed(@"customizing_business_cards_add_to") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(onClickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    _tagBtn = addBtn;
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(getWidth(122.f));
        make.right.equalTo(view).offset(getWidth(-21.f));
        make.height.mas_equalTo(getWidth(20.f));
        make.centerY.mas_equalTo(view);
    }];
    
    return view;
}
#pragma mark - 所在区域
/*
- (UIView *)setupAreaRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    [self setupTitleLabelWithText:@"所在区域" ofView:view];
    HPAreaButton *cityBtn = [HPAreaButton new];
    [cityBtn setTitle:@"深圳市" forState:UIControlStateNormal];
    [cityBtn setImage:ImageNamed(@"transfer_down") forState:UIControlStateNormal];
    [cityBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    cityBtn.tag = HPSelectItemIndexCity;
    [view addSubview:cityBtn];
    _cityBtn = cityBtn;
    [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(getWidth(122.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(64.f), getWidth(20.f)));
        make.centerY.mas_equalTo(view);
    }];
    
    HPAreaButton *areaBtn = [HPAreaButton new];
    [areaBtn setTitle:@"请选择区域" forState:UIControlStateNormal];
    [areaBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [areaBtn setImage:ImageNamed(@"transfer_down") forState:UIControlStateNormal];
    [areaBtn addTarget:self action:@selector(callPickerViewWithDataSource:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:areaBtn];
    areaBtn.tag = HPSelectItemIndexArea;
    
    _areaBtn = areaBtn;
    [areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cityBtn.mas_right).offset(getWidth(36.f));
        make.right.mas_equalTo(view).offset(getWidth(-20.f));
        make.height.mas_equalTo(getWidth(20.f));
        make.centerY.mas_equalTo(view);
    }];
    
    return view;
}*/

#pragma mark -详细地址
- (UIView *)setupDetailAddressRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    [self setupTitleLabelWithText:@"详细地址" ofView:view];
    
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    UIButton *addressBtn = [[UIButton alloc] init];
    [addressBtn.titleLabel setFont:kFont_Regular(13.f)];
    [addressBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [addressBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
    [addressBtn setTitle:@"请选择" forState:UIControlStateNormal];
//    addressBtn.tag = HPSelectItemIndexAddress;
    [addressBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [addressBtn addTarget:self action:@selector(callDetailAddressVc:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addressBtn];
//    _detailAddressBtn = addressBtn;
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(122.f * g_rateWidth);
        make.right.equalTo(downIcon.mas_left).with.offset(-20.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

#pragma mark - 经营行业
- (UIView *)setupManagerIndustryRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    [self setupTitleLabelWithText:@"经营行业" ofView:view];
    UIImageView *downIcon = [self setupDownIconOfView:view];
    
    return view;
}

#pragma mark - 联系人
- (UIView *)setupContactRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    [self setupTitleLabelWithText:@"联系人" ofView:view];
    _contactField = [self setupOptTitleLabelWithText:@"完善称呼交流更方便" ofView:view];
    _contactField.textColor = COLOR_BLACK_333333;
    _contactField.font = kFont_Regular(13.f);
    return view;
}

#pragma mark - 联系方式
- (UIView *)setupPhoneNumRowView {
    UIView *view = [[UIView alloc] init];
    UIButton *starBtn = [UIButton new];
    [starBtn setTitle:@"*" forState:UIControlStateNormal];
    [starBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [view addSubview:starBtn];
    [starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(12), getWidth(12)));
    }];
    
    [self setupTitleLabelWithText:@"联系方式" ofView:view];
    HPLoginModel *account = [HPUserTool account];
    
    UILabel *phoneLabel = [self setupOptTitleLabelWithText:account.userInfo.mobile ofView:view];
    phoneLabel.text = account.userInfo.mobile?:@"";
    phoneLabel.textColor = COLOR_BLACK_333333;
    phoneLabel.font = kFont_Regular(13.f);
    _phoneLabel = phoneLabel;
    return view;
}
@end
