//
//  HPOrderManagerViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderManagerViewController.h"

#import "HPShareDetailModel.h"

#import "HPOrderCell.h"

#import "HPPayStyleCell.h"

#import "WXApiObject.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "payRequsestHandler.h"

#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "APRSASigner.h"

#import "HPGradientUtil.h"

#import "HPPayModel.h"

@interface HPOrderManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *payTableView;

@property (nonatomic, strong) HPShareDetailModel *model;

@property (nonatomic, strong) UIButton *coverView;


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

@end

@implementation HPOrderManagerViewController

static NSString *orderCell = @"orderCell";


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
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    UIView *navtitleView = [self setupNavigationBarWithTitle:@"订单管理"];
    
    _model = self.param[@"order"];
    
    [self setPayConfig];

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(navtitleView.mas_bottom);
    }];
}

- (void)setPayConfig
{
    //默认为微信支付
    self.payType = kPayTypeWeChat;
    
    //注册支付宝支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAliPayReturn:) name:notice_AliPayReturnData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXPayReturn:) name:notice_WXPayReturnData object:nil];
    
    self.imageArr = @[@"wechatPay",@"alipay"];
    self.titleArr = @[@"微信支付",@"支付宝支付"];
    self.Status = 1;
    
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
        
        [_tableView registerClass:HPOrderCell.class forCellReuseIdentifier:orderCell];
        
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UITableView *)payTableView
{
    if (!_payTableView) {
        _payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        [_payTableView registerClass:[HPPayStyleCell class] forCellReuseIdentifier:payStyleCell];
        
        _payTableView.tableFooterView = [UIView new];
        _payTableView.separatorStyle = UITableViewCellAccessoryNone;
        
        _payTableView.layer.cornerRadius = 5.f;
        _payTableView.layer.masksToBounds = YES;
        _payTableView.scrollEnabled = NO;
    }
    return _payTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCell = @"defaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCell];
    
    if (tableView == self.payTableView) {
        
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
    }else{
        HPOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCell];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        kWEAKSELF
        cell.payBlock = ^(NSInteger payOrder) {
        if (payOrder == PayOrderToPay) {
            [weakSelf onClickConfirmPay];
           
        }else if(payOrder == PayOrderConsult){

            [weakSelf pushVCByClassName:@"HPPayResultViewController" withParam:@{@"orderNo":weakSelf.payModel.out_trade_no}];
        }
    };
    cell.model = _model;
    
    return cell;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _payTableView) {
        return self.imageArr.count;
    }else{
        return 10.f;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.payTableView) {
        return getWidth(50.f);

    }else{
        return getWidth(200.f);

    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.payTableView) {
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
}

#pragma mark - 确认订单详情

- (void)onClickConfirmPay
{
    [self.view addSubview:self.coverView];
    self.coverView.hidden = NO;
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.coverView addSubview:self.payTableView];
    
    [self.payTableView addSubview:self.confirmBtn];
    
    
    [self.payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth *0.7);
        make.height.mas_equalTo(getWidth(150.f));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.payTableView);
        make.width.mas_equalTo(kScreenWidth/3);
        make.top.mas_equalTo(getWidth(110.f));
        make.height.mas_equalTo(getWidth(30.f));
    }];
    
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
        
        [HUD HUDHidden];
        [self pushVCByClassName:@"HPPayResultViewController" withParam:@{@"orderNo":self.payModel.out_trade_no}];
        if(self.paySuccessBlock){
            self.paySuccessBlock();
        }
    }else{
        [HUD HUDWithString:@"支付失败！"];
        [HUD HUDHidden];
        
    }
    
}
@end
