//
//  HPMyCardController.m
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMyCardController.h"
#import "HPShareListCell.h"

@interface HPMyCardController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIImageView *portraitView;

@property (nonatomic, weak) UILabel *phoneNumLabel;

@property (nonatomic, weak) UILabel *companyLabel;

@property (nonatomic, weak) UILabel *signatureLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HPMyCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [_phoneNumLabel setText:@"18342804321"];
    [_companyLabel setText:@"深圳市宝创汽车服务有限公司"];
    [_signatureLabel setText:@"有朋自远方来，不亦乐乎。"];
    [_descLabel setText:@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"];
    
    _dataArray = @[@{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"}];
    [_tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_GRAY_F6F6F6];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"my_business_card_background_map"]];
    [scrollView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(scrollView).with.offset(-g_statusBarHeight);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back"]];
    [scrollView addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).with.offset(25.f * g_rateWidth);
        make.top.equalTo(scrollView).with.offset(15.f);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView);
        make.top.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"我的名片"];
    [scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.centerY.equalTo(backIcon);
    }];
    
    UIView *cardPanel = [[UIView alloc] init];
    [cardPanel.layer setCornerRadius:5.f];
    [cardPanel.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [cardPanel.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [cardPanel.layer setShadowOpacity:0.07f];
    [cardPanel.layer setShadowRadius:16.f];
    [cardPanel setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:cardPanel];
    [cardPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backIcon.mas_bottom).with.offset(33.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 215.f * g_rateWidth));
    }];
    [self setupCardPanel:cardPanel];
    
    UIView *infoRegion = [[UIView alloc] init];
    [infoRegion.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [infoRegion.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [infoRegion.layer setShadowOpacity:0.07f];
    [infoRegion.layer setShadowRadius:16.f];
    [infoRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:infoRegion];
    [infoRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(cardPanel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(225.f * g_rateWidth);
    }];
    [self setupInfoRegion:infoRegion];
    
    UIView *releaseRegion = [[UIView alloc] init];
    [releaseRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:releaseRegion];
    [releaseRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoRegion.mas_bottom).with.offset(15.f * g_rateWidth);
        make.left.and.width.equalTo(scrollView);
        make.height.mas_equalTo(476.f * g_rateWidth);
        make.bottom.equalTo(scrollView);
    }];
    [self setupReleaseRegion:releaseRegion];
}

- (void)setupCardPanel:(UIView *)view {
    UIImageView *portraitView = [[UIImageView alloc] init];
    [portraitView.layer setCornerRadius:63.f * g_rateWidth * 0.5];
    [portraitView.layer setMasksToBounds:YES];
    [portraitView setImage:[UIImage imageNamed:@"my_business_card_default_head_image"]];
    [view addSubview:portraitView];
    _portraitView = portraitView;
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(17.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
    }];
    
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    [phoneNumLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [phoneNumLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:phoneNumLabel];
    _phoneNumLabel = phoneNumLabel;
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitView.mas_right).with.offset(13.f * g_rateWidth);
        make.top.equalTo(portraitView).with.offset(12.f * g_rateWidth);
        make.height.mas_equalTo(phoneNumLabel.font.pointSize);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [companyLabel setTextColor:COLOR_BLACK_666666];
    [view addSubview:companyLabel];
    _companyLabel = companyLabel;
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumLabel);
        make.top.equalTo(phoneNumLabel.mas_bottom).with.offset(13.f * g_rateWidth);
        make.height.mas_equalTo(phoneNumLabel.font.pointSize);
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.layer setCornerRadius:9.f];
    [editBtn.layer setMasksToBounds:YES];
    [editBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:10.f]];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *dic = (NSDictionary *)account.userInfo;
    if ([self.param[@"userId"] intValue] == [dic[@"userId"] intValue]) {
        [editBtn setTitle:@"编辑名片" forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editPersonalInfo:) forControlEvents:UIControlEventTouchUpInside];

    }else{
        [editBtn setTitle:@"关注" forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(focusSBToFansList:) forControlEvents:UIControlEventTouchUpInside];

    }
    [editBtn setBackgroundColor:COLOR_RED_FF3455];
    [view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(8.f);
        make.centerY.equalTo(phoneNumLabel);
        make.size.mas_equalTo(CGSizeMake(55.f, 19.f));
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portraitView.mas_bottom).with.offset(18.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(301.f * g_rateWidth, 1.f));
    }];
    
    UIImageView *signatureIcon = [[UIImageView alloc] init];
    [signatureIcon setImage:[UIImage imageNamed:@"my_business_card_leaf"]];
    [view addSubview:signatureIcon];
    [signatureIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.top.equalTo(line.mas_bottom).with.offset(20.f * g_rateWidth);
    }];
    
    UILabel *signatureLabel = [[UILabel alloc] init];
    [signatureLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [signatureLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:signatureLabel];
    _signatureLabel = signatureLabel;
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureIcon.mas_right).with.offset(8.f);
        make.centerY.equalTo(signatureIcon);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setNumberOfLines:0];
    [view addSubview:descLabel];
    _descLabel = descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureLabel);
        make.top.equalTo(signatureIcon.mas_bottom).with.offset(15.f * g_rateWidth);
        make.width.mas_equalTo(271.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(- 10.f * g_rateWidth);
    }];
}
#pragma mark - 关注某人
- (void)focusSBToFansList:(UIButton *)button
{
    HPLoginModel *account = [HPUserTool account];
    NSDictionary *dic = (NSDictionary *)account.userInfo;
    [HPHTTPSever HPPostServerWithMethod:@"/v1/fans/add" paraments:@{@"userId":dic[@"userId"],@"followedId":self.param[@"followedId"]} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
#pragma mark - 编辑个人信息界面
- (void)editPersonalInfo:(UIButton *)button
{
    [self pushVCByClassName:@"HPEditPersonOInfoController"];
}
- (void)setupInfoRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"认证信息"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UIControl *creditCtrl = [[UIControl alloc] init];
    [creditCtrl.layer setBorderWidth:1.f];
    [creditCtrl.layer setBorderColor:COLOR_GRAY_EEEEEE.CGColor];
    [creditCtrl setBackgroundColor:UIColor.whiteColor];
    [view addSubview:creditCtrl];
    [creditCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 65.f * g_rateWidth));
    }];
    [self setupCreditCtrl:creditCtrl];
    
    UIControl *verifiedCtrl = [[UIControl alloc] init];
    [verifiedCtrl.layer setBorderWidth:1.f];
    [verifiedCtrl.layer setBorderColor:COLOR_GRAY_EEEEEE.CGColor];
    [verifiedCtrl setBackgroundColor:UIColor.whiteColor];
    [view addSubview:verifiedCtrl];
    [verifiedCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(creditCtrl.mas_bottom).with.offset(15.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(335.f * g_rateWidth, 65.f * g_rateWidth));
    }];
    [self setupVerifiedCtrl:verifiedCtrl];
}

- (void)setupCreditCtrl:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:[UIImage imageNamed:@"my_business_card_sesame_credit"]];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"芝麻信用"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.left.equalTo(iconView.mas_right).with.offset(12.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setText:@"芝麻信用还未授权"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:@"select_the_arrow"]];
    [view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-23.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *gotoLabel = [[UILabel alloc] init];
    [gotoLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [gotoLabel setTextColor:COLOR_RED_FF3455];
    [gotoLabel setText:@"去授权"];
    [view addSubview:gotoLabel];
    [gotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left).with.offset(-6.f);
        make.centerY.equalTo(arrow);
    }];
}

- (void)setupVerifiedCtrl:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:[UIImage imageNamed:@"my_business_card_real_name_authentication"]];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"实名认证"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(16.f * g_rateWidth);
        make.left.equalTo(iconView.mas_right).with.offset(12.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setText:@"未实名认证"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:@"select_the_arrow"]];
    [view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-23.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *gotoLabel = [[UILabel alloc] init];
    [gotoLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [gotoLabel setTextColor:COLOR_RED_FF3455];
    [gotoLabel setText:@"去认证"];
    [view addSubview:gotoLabel];
    [gotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.mas_left).with.offset(-6.f);
        make.centerY.equalTo(arrow);
    }];
}

- (void)setupReleaseRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"共享发布"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(9.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-19.f * g_rateWidth);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 137.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell_%ld", (long)indexPath.row];
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSDictionary *dict = _dataArray[indexPath.row];
        
        cell = [[HPShareListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setTitle:dict[@"title"]];
        [cell setTrade:dict[@"trade"]];
        [cell setRentTime:dict[@"rentTime"]];
        [cell setArea:dict[@"area"]];
        [cell setPrice:dict[@"price"]];
        
        if ([dict[@"type"] isEqualToString:@"startup"]) {
            [cell setTagType:HPShareListCellTypeStartup];
        }
        else if ([dict[@"type"] isEqualToString:@"owner"]) {
            [cell setTagType:HPShareListCellTypeOwner];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


#pragma mark - OnClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
