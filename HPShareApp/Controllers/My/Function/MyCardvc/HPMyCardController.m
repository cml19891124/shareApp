//
//  HPMyCardController.m
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMyCardController.h"
#import "HPShareListCell.h"

#import "HPCardDetailsModel.h"
#import "HPShareListParam.h"
#import "HPParentScrollView.h"
#import "HPSubTableView.h"
#import "HPGradientUtil.h"

typedef NS_ENUM(NSInteger, HPMyCardType) {
    HPMyCardTypeEdit = 20,
    HPMyCardTypeFocus,
    HPMyCardTypeCancelFocus,
};

#define CELL_ID @"HPShareListCell"

@interface HPMyCardController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIImageView *portraitView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *companyLabel;

@property (nonatomic, weak) UILabel *signatureLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *editBtn;

@property (nonatomic, weak) HPParentScrollView *scrollView;

@property (nonatomic, weak) HPSubTableView *tableView;

@property (nonatomic, assign) CGFloat lastContentOffsetY;

@property (nonatomic, strong) HPShareListParam *shareListParam;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HPMyCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.param[@"userId"]) {
        [self getCardInfoDetailByUserId:self.param[@"userId"]];
        
        _shareListParam = [HPShareListParam new];
        [_shareListParam setUserId:self.param[@"userId"]];
        [_shareListParam setPage:1];
        [self getShareListData:_shareListParam reload:YES];
    }
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
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGest:)];
    
    HPParentScrollView *scrollView = [[HPParentScrollView alloc] init];
    [scrollView setBounces:NO];
    [scrollView setDelegate:self];
    [scrollView addGestureRecognizer:panGest];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
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
    [portraitView setContentMode:UIViewContentModeScaleAspectFill];
    [view addSubview:portraitView];
    _portraitView = portraitView;
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(17.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(getWidth(63.f), getWidth(63.f)));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [nameLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:nameLabel];
    _nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitView.mas_right).with.offset(13.f * g_rateWidth);
        make.top.equalTo(portraitView).with.offset(12.f * g_rateWidth);
        make.height.mas_equalTo(nameLabel.font.pointSize);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [companyLabel setTextColor:COLOR_BLACK_666666];
    [view addSubview:companyLabel];
    _companyLabel = companyLabel;
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(13.f * g_rateWidth);
        make.height.mas_equalTo(nameLabel.font.pointSize);
    }];
    
    CGSize btnSize = CGSizeMake(55.f, 19.f);
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(btnSize.width, 0.f) endPoint:CGPointMake(0.f, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR_ORANGE_FF9B5E endColor:COLOR_RED_FF3455];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.layer setCornerRadius:9.f];
    [editBtn.layer setMasksToBounds:YES];
    [editBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:10.f]];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑名片" forState:UIControlStateNormal];
    [editBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(onClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:editBtn];
    _editBtn = editBtn;
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(8.f);
        make.centerY.equalTo(nameLabel);
        make.size.mas_equalTo(btnSize);
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
    [titleLabel setText:@"拼租发布"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(21.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    HPSubTableView *tableView = [[HPSubTableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(9.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-19.f * g_rateWidth);
    }];
    
    [self loadTableViewFreshUI];
}

- (void)loadTableViewFreshUI {
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.shareListParam.page ++;
        [self getShareListData:self.shareListParam reload:NO];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        if (cell.model) {
            [self pushVCByClassName:@"HPShareDetailController" withParam:@{@"model":cell.model}];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 137.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    HPShareListModel *model = _dataArray[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        if (!_scrollView.canScroll) {
            _scrollView.contentOffset = CGPointMake(0.f, _lastContentOffsetY);
        }
        else {
            _lastContentOffsetY = _scrollView.contentOffset.y;
        }
    }
    else if (scrollView == _tableView) {
        if (_tableView.contentOffset.y <= 0.5f) {
            
            _tableView.canScroll = NO;
            _tableView.contentOffset = CGPointMake(0.f, 0.5f);
            _scrollView.canScroll = YES;//到顶通知父视图改变状态
        }
        else if (_tableView.contentOffset.y >= _tableView.contentHeight - 1.f) {
            _scrollView.canScroll = YES;
        }
        else {
            _scrollView.canScroll = NO;
        }
    }
}

#pragma mark - UIGestureRecognizer

- (void)onPanGest:(UIPanGestureRecognizer *)panGest {
    _scrollView.canScroll = YES;
}


#pragma mark - OnClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onClickEditBtn:(UIButton *)btn {
    switch (btn.tag) {
        case HPMyCardTypeEdit:
            [self pushVCByClassName:@"HPEditPersonOInfoController"];
            break;
        case HPMyCardTypeFocus:
            [self focusByUserId:self.param[@"userId"]];
            break;
        case HPMyCardTypeCancelFocus:
            [self cancelFocusByUserId:self.param[@"userId"]];
            break;
        default:
            break;
    }
}

#pragma mark - NetWorker

- (void)getCardInfoDetailByUserId:(NSString *)userId {
    HPLoginModel *account = [HPUserTool account];
    NSMutableDictionary *detaildic = [NSMutableDictionary dictionary];
    detaildic[@"followedId"] = userId;
    detaildic[@"userId"] = account.userInfo.userId;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/user/cardDetails" isNeedToken:YES paraments:detaildic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            HPCardDetailsModel *cardDetailsModel = [HPCardDetailsModel mj_objectWithKeyValues:DATA[@"cardInfo"]];
            [self.nameLabel setText:cardDetailsModel.realName.length >0 ?cardDetailsModel.realName:@"未填写"];
            [self.companyLabel setText:cardDetailsModel.company.length >0 ?cardDetailsModel.company:@"未填写"];
            [self.descLabel setText:cardDetailsModel.signature.length >0 ?cardDetailsModel.signature:@"未填写"];
            [self.signatureLabel setText:cardDetailsModel.title.length > 0?cardDetailsModel.title:@"未填写"];
            
            if (cardDetailsModel.avatarUrl && ![cardDetailsModel.avatarUrl isEqualToString:@""]) {
                [self.portraitView sd_setImageWithURL:[NSURL URLWithString:cardDetailsModel.avatarUrl] placeholderImage:ImageNamed(@"my_business_card_default_head_image")];
            }
            
            if ([userId intValue] == [account.userInfo.userId intValue]) {
                [self.editBtn setTitle:@"编辑名片" forState:UIControlStateNormal];
                [self.editBtn setTag:HPMyCardTypeEdit];
            }else{
                if([cardDetailsModel.fans isEqualToString:@"0"]){
                    [self.editBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.editBtn setTag:HPMyCardTypeFocus];
                }else {
                    [self.editBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    [self.editBtn setTag:HPMyCardTypeCancelFocus];
                }
            }
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet;
    }];
}

- (void)getShareListData:(HPShareListParam *)param reload:(BOOL)isReload {
    NSMutableDictionary *dict = param.mj_keyValues;
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/myList" isNeedToken:YES paraments:dict complete:^(id  _Nonnull responseObject) {
        NSArray<HPShareListModel *> *models = [HPShareListModel mj_objectArrayWithKeyValuesArray:DATA[@"list"]];
        
        if (models.count < self.shareListParam.pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        if (isReload) {
            self.dataArray = [NSMutableArray arrayWithArray:models];
        }
        else {
            [self.dataArray addObjectsFromArray:models];
        }
        
        if (self.dataArray.count == 0) {
            [HPProgressHUD alertMessage:@"暂无数据"];
            //            self.tableView.loadErrorType = YYLLoadErrorTypeNoData;
            //            self.tableView.refreshNoDataView.tipImageView.image = ImageNamed(@"list_default_page");
            //            self.tableView.refreshNoDataView.tipLabel.text = @"店铺拼租，你是第一个吃螃蟹的人！！";
            //            [self.tableView.refreshNoDataView.tipBtn setTitle:@"立即发布" forState:UIControlStateNormal];
            //            self.tableView.refreshNoDataView.delegate = self;
        }
        //        else {
        //            self.tableView.loadErrorType = YYLLoadErrorTypeDefalt;
        //        }
        
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)focusByUserId:(NSString *)userId {
    [HPHTTPSever HPPostServerWithMethod:@"/v1/fans/add" paraments:@{@"userId":[HPUserTool account].userInfo.userId,@"followedId":userId} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"已关注"];
            [self.editBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            [self.editBtn setTag:HPMyCardTypeCancelFocus];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)cancelFocusByUserId:(NSString *)userId {
    [HPHTTPSever HPPostServerWithMethod:@"/v1/fans/cancel" paraments:@{@"userId":[HPUserTool account].userInfo.userId,@"followedId":userId} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"取消关注"];
            [self.editBtn setTitle:@"关注" forState:UIControlStateNormal];
            [self.editBtn setTag:HPMyCardTypeFocus];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

@end
