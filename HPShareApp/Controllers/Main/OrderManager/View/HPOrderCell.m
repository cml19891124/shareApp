//
//  HPOrderCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderCell.h"
#import "HPCommonData.h"

#import "Macro.h"

#import "HPSingleton.h"

@implementation HPOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpOrderSubviews];
        
        [self setUpOrderSubviewsMasonry];

    }
    return self;
}

- (void)setUpOrderSubviews
{
    [self.contentView addSubview:self.bgView];
    
    [self setupShadowOfPanel:self.bgView];
    
    [self.bgView addSubview:self.shopIcon];

    [self.bgView addSubview:self.leftIcon];

    [self.bgView addSubview:self.shopNamebtn];
    
    [self.bgView addSubview:self.dustbinBtn];

    [self.bgView addSubview:self.waitingReceiveLabel];

    [self.bgView addSubview:self.firstLine];
    
    [self.bgView addSubview:self.shopNameLabel];
    
    [self.bgView addSubview:self.rentDuringLabel];
    
    [self.bgView addSubview:self.desLabel];
    
    [self.bgView addSubview:self.totalLabel];

    [self.bgView addSubview:self.payLine];
    
    [self.bgView addSubview:self.topayBtn];

    [self.bgView addSubview:self.cancelBtn];
    
}

- (void)setUpOrderSubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(7.5f));
        
        make.left.mas_equalTo(self.contentView).offset(getWidth(15.f));;
        
        make.right.mas_equalTo(self.contentView).offset(getWidth(-15.f));;

        make.bottom.mas_equalTo(getWidth(-7.5f));
    }];
    
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(7.5f));
        make.width.height.mas_equalTo(getWidth(20.f));
        make.left.mas_equalTo(self.contentView).offset(getWidth(15.f));;
        
    }];
    
    CGFloat titleW = BoundWithSize(self.shopNamebtn.text, kScreenWidth, 12).size.width + getWidth(30.f);
    [self.shopNamebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(getWidth(10.f));
        make.width.mas_equalTo(titleW);
        make.left.mas_equalTo(self.leftIcon.mas_right).offset(getWidth(5.f));
        make.height.mas_equalTo(self.shopNamebtn.font.pointSize);
    }];
    
    self.shopNamebtn.space = getWidth(6.f);
    
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(10.f));
        make.top.mas_equalTo(self.shopNamebtn.mas_bottom).offset(getWidth(10.f));
        make.width.height.mas_equalTo(getWidth(65.f));
    }];
    
    [self.dustbinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-10.f));
        make.top.mas_equalTo(getWidth(10.f));
        make.width.height.mas_equalTo(getWidth(13.f));
    }];
    
    [self.waitingReceiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.dustbinBtn.mas_left).offset(getWidth(-10.f));
        make.top.mas_equalTo(self.shopNamebtn.mas_top);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(self.waitingReceiveLabel.font.pointSize);
    }];
    
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopIcon.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.shopNameLabel.font.pointSize);
        make.right.mas_equalTo(getWidth(-10.f));
        make.top.mas_equalTo(self.shopIcon.mas_top);
    }];
    
    [self.rentDuringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopIcon.mas_right).offset(getWidth(10.f));
        make.top.mas_equalTo(self.shopNameLabel.mas_bottom).offset(getWidth(18.f));
        make.right.mas_equalTo(self.bgView.mas_right).offset(getWidth(-15.f));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-10.f));
        make.left.mas_equalTo(self.shopIcon.mas_right).offset(getWidth(10.f));
        make.bottom.mas_equalTo(self.shopIcon.mas_bottom);
        make.height.mas_equalTo(self.desLabel.font.pointSize);
    }];
    
    CGFloat tw = BoundWithSize(self.totalLabel.text, kScreenWidth, 12.f).size.width + 10;
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(getWidth(15.f));
        make.width.mas_equalTo(tw);
        make.height.mas_equalTo(self.totalLabel.font.pointSize);
    }];
    
    [self.payLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.firstLine);
        
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(getWidth(10.f));
    }];
    
    CGFloat topayW = BoundWithSize(@"在线催单", kScreenWidth, 12.f).size.width + 20.f;

    [self.topayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-10.f));
        
        make.bottom.mas_equalTo(getWidth(-10.f));
        
        make.width.mas_equalTo(topayW);

        make.height.mas_equalTo(getWidth(25.f));
    }];
    
    CGFloat consultW = BoundWithSize(self.cancelBtn.currentTitle, kScreenWidth, 12.f).size.width + 20.f;

    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topayBtn.mas_left).offset(getWidth(-10.f));
        
        make.bottom.mas_equalTo(getWidth(-10.f));
        
        make.width.mas_equalTo(consultW);

        make.height.mas_equalTo(getWidth(25.f));
    }];
}

- (void)setupShadowOfPanel:(UIView *)view {
    [view.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [view.layer setShadowRadius:6.f];
    [view.layer setShadowOpacity:0.3f];
    [view.layer setCornerRadius:6.f];
    [view setBackgroundColor:UIColor.whiteColor];
}

#pragma mark - 初始化控件
- (UIImageView *)leftIcon
{
    if (!_leftIcon) {
        _leftIcon = [UIImageView new];
//        _leftIcon.backgroundColor = COLOR_GRAY_CCCCCC;
        _leftIcon.image = ImageNamed(@"dianpu");
    }
    return _leftIcon;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _bgView;
}

- (HPRightImageButton *)shopNamebtn
{
    if (!_shopNamebtn) {
        _shopNamebtn = [HPRightImageButton new];
        _shopNamebtn.color = COLOR_GRAY_666666;
        _shopNamebtn.text = @"小女当家";
        _shopNamebtn.image = ImageNamed(@"shouye_gengduo");
        _shopNamebtn.font = kFont_Medium(14.f);
    }
    return _shopNamebtn;
}

- (UIButton *)dustbinBtn
{
    if (!_dustbinBtn) {
        _dustbinBtn = [UIButton new];
        _dustbinBtn.tag = 4800;
        [_dustbinBtn setBackgroundImage:ImageNamed(@"dustbin") forState:UIControlStateNormal];
        [_dustbinBtn addTarget:self action:@selector(clickManagerFunds:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dustbinBtn;
}

- (UIImageView *)shopIcon
{
    if (!_shopIcon) {
        _shopIcon = [UIImageView new];
        _shopIcon.image = ImageNamed(@"loading_logo_small");
    }
    return _shopIcon;
}

- (UILabel *)waitingReceiveLabel
{
    if (!_waitingReceiveLabel) {
        _waitingReceiveLabel = [UILabel new];
        _waitingReceiveLabel.textColor = COLOR_YELLOW_FF8447;
        _waitingReceiveLabel.font = kFont_Medium(12.f);
        _waitingReceiveLabel.textAlignment = NSTextAlignmentRight;
        _waitingReceiveLabel.text = @"等待商家接单";
    }
    return _waitingReceiveLabel;
}

- (UIView *)firstLine
{
    if (!_firstLine) {
        _firstLine = [UIView new];
        [_firstLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    }
    return _firstLine;
}

- (UIView *)payLine
{
    if (!_payLine) {
        _payLine = [UIView new];
        [_payLine setBackgroundColor:COLOR_GRAY_EEEEEE];
    }
    return _payLine;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel new];
        _shopNameLabel.textColor = COLOR_BLACK_333333;
        _shopNameLabel.font = kFont_Bold(14.f);
        _shopNameLabel.textAlignment = NSTextAlignmentLeft;
        _shopNameLabel.text = @"小女当家场地拼租";
    }
    return _shopNameLabel;
}

- (UILabel *)rentDuringLabel
{
    if (!_rentDuringLabel) {
        _rentDuringLabel = [UILabel new];
        _rentDuringLabel.textColor = COLOR_BLACK_333333;
        _rentDuringLabel.font = kFont_Regular(12.f);
        _rentDuringLabel.text = @"租期（共7天）：3月21、3月22、3月23...";
        _rentDuringLabel.textAlignment = NSTextAlignmentLeft;
//        _rentDuringLabel.numberOfLines = 2;
//        [_rentDuringLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _rentDuringLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.textColor = COLOR_BLACK_333333;
        _desLabel.font = kFont_Regular(12.f);
        _desLabel.text = @"拼租说明：我想用来做做推广，奶茶免费试喝";
        _desLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _desLabel;
}

- (UILabel *)totalLabel
{
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textColor = COLOR_GRAY_666666;
        _totalLabel.font = kFont_Medium(12.f);
        _totalLabel.text = @"合计：¥199.00";
        
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.numberOfLines = 2;
        [_totalLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
    }
    return _totalLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.tag = PayOrderToCancel;
        _cancelBtn.layer.cornerRadius = 13.f;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.titleLabel.font = kFont_Medium(12.f);
        _cancelBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _cancelBtn.layer.borderColor = COLOR_GRAY_CCCCCC.CGColor;
        _cancelBtn.layer.borderWidth = 1;
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_GRAY_666666 forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickManagerFunds:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

- (UIButton *)topayBtn
{
    if (!_topayBtn) {
        _topayBtn = [UIButton new];
        _topayBtn.tag = PayOrderToPay;
        _topayBtn.layer.cornerRadius = 13.f;
        _topayBtn.layer.masksToBounds = YES;
        _topayBtn.titleLabel.font = kFont_Medium(12.f);
        _topayBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _topayBtn.layer.borderColor = COLOR_RED_EA0000.CGColor;
        _topayBtn.layer.borderWidth = 1;
        [_topayBtn setTitle:@"" forState:UIControlStateNormal];
        [_topayBtn setTitleColor:COLOR_RED_EA0000 forState:UIControlStateNormal];
        [_topayBtn addTarget:self action:@selector(clickManagerFunds:) forControlEvents:UIControlEventTouchUpInside];
        _topayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

        [_topayBtn sizeToFit];

    }
    return _topayBtn;
}

- (UIButton *)returnBtn
{
    if (!_returnBtn) {
        _returnBtn = [UIButton new];
//        _returnBtn.tag = PayOrderImergency;
        _returnBtn.layer.cornerRadius = 5.f;
        _returnBtn.layer.masksToBounds = YES;
        _returnBtn.titleLabel.font = kFont_Medium(13.f);
        [_returnBtn setTitle:@"我要退款" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(clickManagerFunds:) forControlEvents:UIControlEventTouchUpInside];
        _returnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _returnBtn.backgroundColor = COLOR_GRAY_EEEEEE;
        [_returnBtn sizeToFit];

    }
    return _returnBtn;
}

- (HPPredictView *)predictView
{
    if (!_predictView) {
        _predictView = [HPPredictView new];
        kWEAKSELF
        _predictView.knownBlock = ^{
            [weakSelf.predictView show:NO];
            if ([weakSelf.topayBtn.currentTitle isEqualToString:@"确认接单"]) {
                if (weakSelf.payBlock) {
                    weakSelf.payBlock(weakSelf.topayBtn.tag);
                }
            }
        };
        
        _predictView.onlineBlock = ^{//即时通讯

        };
        
        [_predictView setOnlineText:@"付款提醒"];
    }
    return _predictView;
}

- (HPUserReceiveView *)receiveView
{
    if (!_receiveView) {
        kWEAKSELF
        _receiveView = [HPUserReceiveView new];
        _receiveView.noBlock = ^{
            [weakSelf.receiveView show:NO];
        };
    }
    return _receiveView;
}

- (void)clickManagerFunds:(UIButton *)button
{
//    if (self.payBlock) {
//        self.payBlock(button.tag);
//    }
    if ([button.currentTitle isEqualToString:@"确认接单"]) {
        [self getConfirmReceiveOrderApi];
    }else if([button.currentTitle isEqualToString:@"取消订单"]){
        kWEAKSELF
//        [self.contentView addSubview:weakSelf.quitView];
        self.quitView.textView.placeholder = @"  请填写取消此订单原因";
        
        [self.quitView show:YES];
        self.quitView.quitBlock = ^{
            HPLog(@"5555");
            [weakSelf.quitView show:NO];
            [weakSelf cancelOrder:weakSelf.model];
            
        };
    }else if([button.currentTitle isEqualToString:@"确认收货"]){
        [self getConfirmOrderApi];

    }
}


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

#pragma mark - 确认接单
- (void)getConfirmReceiveOrderApi
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isBoss"] = @([HPSingleton sharedSingleton].identifyTag);
    dic[@"orderId"] = _model.order.orderId;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/order/bossAcceptOrder" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self.predictView show:YES];
            [self.predictView.tipBtn setTitle:@"接单成功" forState:UIControlStateNormal];
            self.predictView.messageLabel.text = @"租客付款后请按预定给租客提供场地";
            //            [kNotificationCenter postNotificationName:confirmReceiveOrderMessage object:nil userInfo:@{@"model":self.model}];
        }else{
            [HPProgressHUD alertMessage:MSG];
            
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

//租客取消订单
- (void)cancelOrder:(HOOrderListModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cancelReason"] = self.quitView.signTextView.text;
    dic[@"orderId"] = model.order.orderId;
    
    [HPHTTPSever HPPostServerWithMethod:@"/v1/order/tenantCancel" paraments:dic needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
        }else{
            [HPProgressHUD alertMessage:MSG];
            
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

//确认收货
- (void)getConfirmOrderApi
{
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/order/confirm" isNeedToken:YES paraments:@{@"orderId":@(_model.order.orderId.integerValue)} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self.receiveView show:NO];
        }else{
            [HPProgressHUD alertMessage:MSG];
            
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setModel:(HOOrderListModel *)model
{
    _model = model;
    if (model.spaceDetail.shortName && ![model.spaceDetail.shortName isEqualToString:@""]) {
        self.shopNamebtn.text = model.spaceDetail.shortName;
    }else if(kObjectIsEmpty(model.spaceDetail.shortName)||[model.spaceDetail.shortName isEqualToString:@""]){
        self.shopNamebtn.image = ImageNamed(@"");
        [self.shopNamebtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    self.shopNameLabel.text = model.spaceDetail.title;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.spaceDetail.picture.url]];
    [self.shopIcon sd_setImageWithURL:url placeholderImage:ImageNamed(@"loading_logo_small")];
    if (kObjectIsEmpty(model.order.days)) {
        self.rentDuringLabel.text = [NSString stringWithFormat:@"租期:--"];
    }else{
        self.rentDuringLabel.text = [NSString stringWithFormat:@"租期:%@",model.order.days];
    }
    if (kObjectIsEmpty(model.order.remark)) {
        self.desLabel.text = [NSString stringWithFormat:@"拼租说明:--"];
    }else{
        self.desLabel.text = [NSString stringWithFormat:@"拼租说明:%@",model.order.remark];
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"合计：¥%@",model.order.totalFee];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_totalLabel.text];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_GRAY_666666 range:NSMakeRange(0, 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF1213 range:NSMakeRange(3, _totalLabel.text.length - 3)];
    _totalLabel.attributedText = attr;
    
    if ([HPSingleton sharedSingleton].identifyTag == 0) {
        [self.leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }else{

        [self.leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(getWidth(20.f));
            
        }];
    }
    
    if ([model.order.status integerValue] == 1) {
        self.waitingReceiveLabel.text = @"等待商家接单";

        [self.dustbinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.topayBtn setTitle:@"在线催单" forState:UIControlStateNormal];
            
        }else{
            [self.cancelBtn setTitle:@"放弃此单" forState:UIControlStateNormal];
            [self.topayBtn setTitle:@"确认接单" forState:UIControlStateNormal];
            
        }
    }
    HPLog(@"---:%ld",(long)[HPSingleton sharedSingleton].identifyTag);
    if ([model.order.status integerValue] == 2) {
        [self.dustbinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        
        self.waitingReceiveLabel.text = @"等待租客付款";

        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.topayBtn setTitle:@"立即支付" forState:UIControlStateNormal];

        }else{
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [self.topayBtn setTitle:@"付款提醒" forState:UIControlStateNormal];

        }
        
    }
    
    if ([model.order.status integerValue] == 3) {
        [self.dustbinBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        
        self.waitingReceiveLabel.text = @"待收货";

        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            [self.cancelBtn setTitle:@"订单投诉" forState:UIControlStateNormal];
            [self.topayBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        }else{
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            
            [self.topayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }
        

    }else if ([model.order.status integerValue] == 11) {
       
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            self.waitingReceiveLabel.text = @"已确认收货";

            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [self.topayBtn setTitle:@"查看评价" forState:UIControlStateNormal];
        }else{
            self.waitingReceiveLabel.text = @"交易已完成";
            [self.cancelBtn setTitle:@"评价此单" forState:UIControlStateNormal];
            
            [self.topayBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        }
    }else if ([model.order.status integerValue] == 12) {
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            [self.cancelBtn setTitle:@"查看原因" forState:UIControlStateNormal];
            self.waitingReceiveLabel.text = @"商家未同意接单";

            [self.topayBtn setTitle:@"重新下单" forState:UIControlStateNormal];
        }else{
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [self.topayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            
            self.waitingReceiveLabel.text = @"订单已拒绝";

        }
        
    }else if([model.order.status integerValue] == 13) {//隐藏按钮
        
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            self.waitingReceiveLabel.text = @"订单已取消";
            
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [self.topayBtn setTitle:@"重新下单" forState:UIControlStateNormal];
        }else{
            self.waitingReceiveLabel.text = @"租客已取消订单";
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            
            [self.topayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }
    }else if ([model.order.status integerValue] == 15){
        
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            self.waitingReceiveLabel.text = @"支付超时已关闭";
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            
            [self.topayBtn setTitle:@"重新下单" forState:UIControlStateNormal];
        }else{
            self.waitingReceiveLabel.text = @"支付超时已关闭";
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [self.topayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }
    }else if ([model.order.status integerValue] == 14){
        if ([HPSingleton sharedSingleton].identifyTag == 0) {
            self.waitingReceiveLabel.text = @"商家未同意接单";
            [self.cancelBtn setTitle:@"查看原因" forState:UIControlStateNormal];
            [self.topayBtn setTitle:@"重新下单" forState:UIControlStateNormal];
        }else{
            self.waitingReceiveLabel.text = @"支付超时已关闭";
            [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
            [self.topayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }
    }
    
}
@end
