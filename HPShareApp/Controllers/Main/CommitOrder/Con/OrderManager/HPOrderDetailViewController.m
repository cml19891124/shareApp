//
//  HPOrderDetailViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/27.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderDetailViewController.h"

#import "HPShareDetailModel.h"

@interface HPOrderDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *warningBtn;


/**
 联系商家的view
 */
@property (nonatomic, strong) UIView *communicateView;

@property (nonatomic, strong) UIImageView *thumbView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *rentDaysLabel;

@property (nonatomic, strong) UILabel *duringDayslabel;

@property (nonatomic, strong) UIView *contactLine;

@property (nonatomic, strong) UIButton *consumerBtn;

@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) HPShareDetailModel *model;

@end

@implementation HPOrderDetailViewController


- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        
        self.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        
    }
    [self.view setBackgroundColor:COLOR_GRAY_F9FAFD];
    
    self.model = self.param[@"order"];

    [self setUpCommitSubviews];
    
    [self setUpCommitSubviewsMasonry];
    
    [self loadData];

}

- (void)loadData
{
    [self.thumbView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:ImageNamed(@"loading_logo_small")];

    self.nameLabel.text = _model.title;
    
    //    self.locationLabel.text = _model.address;
    //
    //    self.spaceInfoLabel.text = _model.address;
    
    self.addressLabel.text = _model.address;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"小女当家场地拼租";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = kFont_Medium(16.f);
        _nameLabel.textColor = COLOR_BLACK_333333;
    }
    return _nameLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.text = @"地址：南山科苑粤兴四道中科纳大厦";
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.font = kFont_Medium(12.f);
        _addressLabel.textColor = COLOR_GRAY_999999;
    }
    return _addressLabel;
}

- (void)setUpCommitSubviews
{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.headerView];
    
    [self.scrollView addSubview:self.backBtn];
    
    [self.scrollView addSubview:self.titleLabel];
    
    [self.scrollView addSubview:self.warningBtn];

    [self.scrollView addSubview:self.communicateView];

    [self.communicateView addSubview:self.thumbView];

    [self.communicateView addSubview:self.nameLabel];

    [self.communicateView addSubview:self.rentDaysLabel];

    [self.communicateView addSubview:self.duringDayslabel];
    
    [self.communicateView addSubview:self.addressLabel];
    
    [self.communicateView addSubview:self.contactLine];

    [self.communicateView addSubview:self.consumerBtn];
    
    [self.communicateView addSubview:self.phoneBtn];

}

-(void)setUpCommitSubviewsMasonry
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(g_bottomSafeAreaHeight + getWidth(60.f));
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(107.f));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(16.f));
        make.width.height.mas_equalTo(getWidth(13.f));
        make.top.mas_equalTo(g_statusBarHeight + 15.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.warningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(getWidth(25.f));
    }];
    
    [self.communicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(getWidth(345.f));
        make.height.mas_equalTo(getWidth(133.f));
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(getWidth(65.f));
        make.top.left.mas_equalTo(getWidth(15.f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(18.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.left.mas_equalTo(self.thumbView.mas_right).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));

    }];
    
    CGFloat rentW = BoundWithSize(self.rentDaysLabel.text, kScreenWidth, 12.f).size.width;
    [self.rentDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.rentDaysLabel.font.pointSize);
        make.left.mas_equalTo(self.nameLabel);
        make.width.mas_equalTo(rentW);
    }];
    
    [self.duringDayslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(self.duringDayslabel.font.pointSize);
        make.left.mas_equalTo(self.rentDaysLabel.mas_right).offset(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.contactLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.thumbView.mas_bottom).offset(getWidth(13.f));
        make.height.mas_equalTo(1);
        make.right.left.mas_equalTo(self.communicateView);
    }];
    
    [self.consumerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contactLine.mas_bottom).offset(getWidth(15.f));
        make.height.mas_equalTo(getWidth(30.f));
        make.left.mas_equalTo(getWidth(40.f));
        make.width.mas_equalTo(getWidth(345.f)/4);

    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.communicateView.mas_bottom).offset(getWidth(-15.f));
        make.height.mas_equalTo(getWidth(30.f));
        make.right.mas_equalTo(getWidth(40.f));
        make.width.mas_equalTo(getWidth(345.f)/4);
    }];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.image = ImageNamed(@"order_head");
        
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
        _titleLabel.text = @"订单详情";
    }
    return _titleLabel;
}

- (UIButton *)warningBtn
{
    if (!_warningBtn) {
        _warningBtn = [UIButton new];
        [_warningBtn setImage:ImageNamed(@"laba") forState:UIControlStateNormal];
        [_warningBtn setTitle:@"商家已接单，付款后即可准备拼租" forState:UIControlStateNormal];
        [_warningBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_warningBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(5.f), 0, 0)];
        _warningBtn.titleLabel.font = kFont_Medium(14.f);
        [_warningBtn addTarget:self action:@selector(onClickLoundBtn:) forControlEvents:UIControlEventTouchUpInside];
        _warningBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _warningBtn;
}

- (UIView *)communicateView
{
    if (!_communicateView) {
        _communicateView = [UIView new];
        _communicateView.backgroundColor = COLOR_GRAY_FFFFFF;
        _communicateView.layer.cornerRadius = 2.f;
        _communicateView.layer.masksToBounds = YES;
    }
    return _communicateView;
}

- (UIImageView *)thumbView
{
    if (!_thumbView ) {
        _thumbView = [UIImageView new];
        _thumbView.image = ImageNamed(@"");
    }
    return _thumbView;
}

- (UILabel *)rentDaysLabel
{
    if (!_rentDaysLabel) {
        _rentDaysLabel = [UILabel new];
        _rentDaysLabel.textColor = COLOR_GRAY_999999;
        _rentDaysLabel.textAlignment = NSTextAlignmentLeft;
        _rentDaysLabel.font = kFont_Medium(12.f);
        _rentDaysLabel.text = @"租期：7天";
    }
    return _rentDaysLabel;
}


- (UILabel *)duringDayslabel
{
    if (!_duringDayslabel) {
        _duringDayslabel = [UILabel new];
        _duringDayslabel.textColor = COLOR_GRAY_999999;
        _duringDayslabel.textAlignment = NSTextAlignmentLeft;
        _duringDayslabel.font = kFont_Medium(12.f);
        _duringDayslabel.text = @"入离店：09:00-18:00";
    }
    return _duringDayslabel;
}

- (UIView *)contactLine
{
    if (!_contactLine) {
        _contactLine = [UIView new];
        _contactLine.backgroundColor = COLOR_GRAY_EEEEEE;
    }
    return _contactLine;
}

- (UIButton *)consumerBtn
{
    if (!_consumerBtn) {
        _consumerBtn = [UIButton new];
        [_consumerBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_consumerBtn setImage:ImageNamed(@"communicate_serve") forState:UIControlStateNormal];
        [_consumerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(6.f), 0, 0)];
        [_consumerBtn addTarget:self action:@selector(onClickConsumerBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _consumerBtn;
}

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton new];
        [_phoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
        [_phoneBtn setImage:ImageNamed(@"call_phone") forState:UIControlStateNormal];
        [_phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, getWidth(6.f), 0, 0)];
        [_phoneBtn addTarget:self action:@selector(onClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (void)onClickPhoneBtn:(UIButton *)button
{
    
}

- (void)onClickConsumerBtn:(UIButton *)button
{
    
}

- (void)onClickLoundBtn:(UIButton *)button
{
    
}
@end
