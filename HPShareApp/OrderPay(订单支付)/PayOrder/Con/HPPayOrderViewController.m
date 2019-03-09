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

@property (nonatomic, strong) HPShareDetailModel *model;

@property (nonatomic, strong) HPBaseModalView *modelView;

@property (nonatomic, strong) UIButton *coverView;
@end

@implementation HPPayOrderViewController

static NSString *payStyleCell = @"payStyleCell";

- (UIButton *)coverView{
    if (!_coverView) {
        _coverView = [UIButton new];
        [_coverView addTarget:self action:@selector(hiddenCoverView:) forControlEvents:UIControlEventTouchUpInside];
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

    [self.view addSubview:self.coverView];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];

    [self.coverView setBackgroundColor:COLOR(0, 0, 0, 0.4)];
    
    //默认为微信支付
    self.payType = kPayTypeWeChat;
    
    //注册支付宝支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAliPayReturn:) name:notice_AliPayReturnData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXPayReturn:) name:notice_WXPayReturnData object:nil];
    
    self.imageArr = @[@"wechatPay",@"alipay"];
    self.titleArr = @[@"微信支付",@"支付宝支付"];
    self.Status = 1;
    
    [self.coverView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth *0.7);
        make.height.mas_equalTo(getWidth(150.f));
    }];
    
    [self.tableView addSubview:self.confirmBtn];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView).offset(getWidth(15.f));
        make.centerX.mas_equalTo(self.tableView);
        make.top.mas_equalTo(getWidth(110.f));
        make.height.mas_equalTo(getWidth(30.f));
    }];
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
            req.partnerId           = [responseObject objectForKey:@"partnerid"];
            req.prepayId            = [responseObject objectForKey:@"prepayid"];
            req.nonceStr            = [responseObject objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [responseObject objectForKey:@"package"];
            req.sign                = [responseObject objectForKey:@"sign"];
            [WXApi sendReq:req];
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
@end
