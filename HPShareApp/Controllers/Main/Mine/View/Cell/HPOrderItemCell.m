//
//  HPOrderItemCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderItemCell.h"

#import "HPAlignCenterButton.h"

@implementation HPOrderItemCell

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
        self.contentView.backgroundColor = COLOR_GRAY_f9fafd;
        
        self.orderImageArray = @[@"business_receive_order",@"business_topay",@"business_torent",@"business_to_comment",@"business_refunds"];

        self.orderArray = @[@"待接单",@"待付款",@"待拼租",@"待评价",@"退款/售后"];


        [self setUpCellSubviews];
        
        [self setUpCellSubviewsMasonry];
    }
    return self;
}

- (void)setUpCellSubviews
{
    [self.contentView addSubview:self.orderView];
    
    [self.orderView addSubview:self.orderLabel];
    
    [self.orderView addSubview:self.allOrderBtn];
    self.allOrderBtn.tag = 4405;
    
    for (int j = 0; j < self.orderArray.count; j ++) {
        HPAlignCenterButton *busiBtn = [[HPAlignCenterButton alloc] initWithImage:ImageNamed(self.orderImageArray[j])];
        [busiBtn setText:self.orderArray[j]];
        busiBtn.tag = 4400 + j;
        [busiBtn addTarget:self action:@selector(onClickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.orderView addSubview:busiBtn];
        [busiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(20.f) + j * getWidth(67.f));
            make.width.height.mas_equalTo(getWidth(40.f));
            make.top.mas_equalTo(self.orderLabel.mas_bottom).offset(getWidth(30.f));
            make.bottom.mas_equalTo(getWidth(-20.f));
            
        }];
    }
}

- (void)setUpCellSubviewsMasonry
{
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(kScreenWidth/2);
        make.top.mas_equalTo(getWidth(13.f));
        make.height.mas_equalTo(self.orderLabel.font.pointSize);
    }];
    
    [self.allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.left.mas_equalTo(self.orderLabel.mas_right);
        make.height.mas_equalTo(self.allOrderBtn.titleLabel.font.pointSize);
    }];
}

- (UIView *)orderView
{
    if (!_orderView) {
        _orderView = [UIView new];
        _orderView.backgroundColor = COLOR_GRAY_FFFFFF;
        _orderView.layer.cornerRadius = 2.f;
        _orderView.layer.masksToBounds = YES;
    }
    return _orderView;
}


- (UILabel *)orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.text = @"我的订单";
        _orderLabel.textColor = COLOR_BLACK_333333;
        _orderLabel.textAlignment = NSTextAlignmentLeft;
        _orderLabel.font = kFont_Bold(16.f);
    }
    return _orderLabel;
}

- (UIButton *)allOrderBtn
{
    if (!_allOrderBtn) {
        _allOrderBtn = [UIButton new];
        [_allOrderBtn setTitle:@"全部订单" forState:UIControlStateNormal];
        [_allOrderBtn setTitleColor:COLOR_GRAY_666666 forState:UIControlStateNormal];;
        _allOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_allOrderBtn addTarget:self action:@selector(onClickedOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        _allOrderBtn.titleLabel.font = kFont_Medium(14.f);
    }
    return _allOrderBtn;
}

- (void)onClickedOrderBtn:(UIButton *)button
{
    if (self.returnBlock) {
        self.returnBlock(button.tag);
    }
}

@end
