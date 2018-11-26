//
//  HPShareController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareController.h"
#import "HPShareRecommendCard.h"
#import "HPImageUtil.h"
#import "HPBanner.h"
#import "HPShareListController.h"
#import "StyledPageControl.h"
#import "HPAlignCenterButton.h"
#import "HPSharePersonCard.h"

@interface HPShareController () <HPBannerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) StyledPageControl *pageControl;

@property (nonatomic, weak) HPBanner *baner;

@property (nonatomic, weak) HPShareRecommendCard *shareCard_1;

@property (nonatomic, weak) HPShareRecommendCard *shareCard_2;

@property (nonatomic, weak) UIScrollView *shareRecommendScrollView;

@end

@implementation HPShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [_shareCard_1 setTitle:@"金嘉味黄金铺位共享"];
    [_shareCard_1 setTrade:@"餐饮"];
    [_shareCard_1 setRentTime:@"面议"];
    [_shareCard_1 setArea:@"30"];
    [_shareCard_1 setPrice:@"30"];
    [_shareCard_1 setTagType:HPShareRecommendCardTypeOwner];
    
    [_shareCard_2 setTitle:@"全聚德北京烤鸭店急求90家共享铺位"];
    [_shareCard_2 setTrade:@"服饰"];
    [_shareCard_2 setRentTime:@"短租"];
    [_shareCard_2 setArea:@"18"];
    [_shareCard_2 setPrice:@"80"];
    [_shareCard_2 setTagType:HPShareRecommendCardTypeStartup];
    
    NSArray *sharePersonData = @[@{@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"},
                                 @{@"portrait":[UIImage imageNamed:@"share_person_portrait"], @"userName":@"董晓丽", @"company":@"深圳大兴大宝汽车有限公司", @"signature":@"有朋自远方来，不亦乐乎。", @"desc":@"我们4S汽车店专注于服务与品质，我们欢迎一切专注于服务客户的品牌商、创业者加入我们。我们共享的不只是空间，也是资源、信息与服务的共享。"}];
    [self reloadShareRecommendRegionWithDate:sharePersonData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_baner stopAutoScroll];
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
    
    HPBanner *banner = [[HPBanner alloc] init];
    [banner setImageArray:@[[UIImage imageNamed:@"shouye_banner"], [UIImage imageNamed:@"shouye_banner"], [UIImage imageNamed:@"shouye_banner"]]];
    [banner setDelegate:self];
    [scrollView addSubview:banner];
    _baner = banner;
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(-g_statusBarHeight);
        make.left.and.width.equalTo(scrollView);
        make.height.mas_equalTo(225.f * g_rateWidth);
    }];
    
    UIImage *pageCurrentImage = [HPImageUtil getRectangleByStrokeColor:UIColor.whiteColor fillColor:UIColor.whiteColor borderWidth:1.f cornerRadius:2.f inRect:CGRectMake(0.f, 0.f, 9.f, 4.f)];
    UIImage *pageImage = [HPImageUtil getRectangleByStrokeColor:UIColor.whiteColor fillColor:[UIColor.whiteColor colorWithAlphaComponent:0.5f] borderWidth:0.f cornerRadius:2.f inRect:CGRectMake(0.f, 0.f, 4.f, 4.f)];
    
    StyledPageControl *pageControl = [[StyledPageControl alloc] init];
    [pageControl setNumberOfPages:3];
    [pageControl setCurrentPage:0];
    [pageControl setCoreNormalColor:[UIColor.whiteColor colorWithAlphaComponent:0.5f]];
    [pageControl setPageControlStyle:PageControlStyleThumb];
    [pageControl setSelectedThumbImage:pageCurrentImage];
    [pageControl setThumbImage:pageImage];
    [pageControl setGapWidth:2.5f];
    [banner addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(banner);
        make.bottom.equalTo(banner).with.offset(-42.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(80.f, 5.f));
    }];
    
    UIView *searchView = [[UIView alloc] init];
    [searchView.layer setCornerRadius:4.f];
    [searchView.layer setMasksToBounds:YES];
    [searchView setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.35f]];
    [scrollView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(scrollView).with.offset(5.f * g_rateHeight);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 35.f * g_rateWidth));
    }];
    [self setupSearchView:searchView];
    
    UIView *menuPanel = [[UIView alloc] init];
    [menuPanel.layer setCornerRadius:4.f];
    [menuPanel.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [menuPanel.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [menuPanel.layer setShadowRadius:6.f];
    [menuPanel.layer setShadowOpacity:0.2f];
    [menuPanel setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:menuPanel];
    [menuPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(banner).with.offset(67.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 105.f * g_rateWidth));
    }];
    [self setupMenuPanel:menuPanel];
    
    UIView *todayShareRegion = [[UIView alloc] init];
    [scrollView addSubview:todayShareRegion];
    [todayShareRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuPanel.mas_bottom);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupTodayShareRegion:todayShareRegion];
    
    UIView *nearbyShareRegion = [[UIView alloc] init];
    [scrollView addSubview:nearbyShareRegion];
    [nearbyShareRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(todayShareRegion.mas_bottom);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupNearbyShareRegion:nearbyShareRegion];
    
    UIView *shareRecommendRegion = [[UIView alloc] init];
    [scrollView addSubview:shareRecommendRegion];
    [shareRecommendRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nearbyShareRegion.mas_bottom);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupShareRecommendRegion:shareRecommendRegion];
    
    UIView *shareProcessRegion = [[UIView alloc] init];
    [scrollView addSubview:shareProcessRegion];
    [shareProcessRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareRecommendRegion.mas_bottom);
        make.left.and.width.equalTo(scrollView);
        make.bottom.equalTo(scrollView).with.offset(-25.f * g_rateWidth);
    }];
    [self setupShareProcessRegion:shareProcessRegion];
}

- (void)setupSearchView:(UIView *)view {
    UIButton *locationBtn = [[UIButton alloc] init];
    [locationBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [locationBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [locationBtn setTitle:@"深圳" forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"shouye_xiala"] forState:UIControlStateNormal];
    [locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -12.f, 0.f, 12.f)];
    [locationBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 30.f, 0.f, -30.f)];
    [view addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.width.mas_equalTo(63.f * g_rateWidth);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.6f]];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationBtn.mas_right);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(1.f, 16.f * g_rateWidth));
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"shouye_sousuo"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"输入关键字进行搜索" forState:UIControlStateNormal];
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 10.f, 0.f, -10.f)];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 16.f, 0.f, -16.f)];
    [view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right);
        make.top.and.bottom.and.right.equalTo(view);
    }];
}

- (void)setupMenuPanel:(UIView *)view {
    UIView *centerView = [[UIView alloc] init];
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).with.offset(17.f * g_rateWidth);
    }];
    
    HPAlignCenterButton *shopBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"share_shop"]];
    [shopBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [shopBtn setTextColor:COLOR_BLACK_333333];
    [shopBtn setText:@"共享店铺"];
    [centerView addSubview:shopBtn];
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
    }];
    
    HPAlignCenterButton *spaceBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"share_space"]];
    [spaceBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [spaceBtn setTextColor:COLOR_BLACK_333333];
    [spaceBtn setText:@"共享空间"];
    [centerView addSubview:spaceBtn];
    [spaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopBtn.mas_right).with.offset(26.f * g_rateWidth);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
    }];
    
    HPAlignCenterButton *goodBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"share_good"]];
    [goodBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [goodBtn setTextColor:COLOR_BLACK_333333];
    [goodBtn setText:@"共享货品"];
    [centerView addSubview:goodBtn];
    [goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spaceBtn.mas_right).with.offset(26.f * g_rateWidth);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
    }];
    
    HPAlignCenterButton *mapBtn = [[HPAlignCenterButton alloc] initWithImage:[UIImage imageNamed:@"share_map"]];
    [mapBtn setTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [mapBtn setTextColor:COLOR_BLACK_333333];
    [mapBtn setText:@"共享地图"];
    [centerView addSubview:mapBtn];
    [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodBtn.mas_right).with.offset(26.f * g_rateWidth);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(55.f, 69.f));
        make.bottom.equalTo(centerView);
        make.right.equalTo(centerView);
    }];
}

- (void)setupTodayShareRegion:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"今日共享" ofRegion:view];
    
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [moreBtn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"shouye_gengduo"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 52.f, 0.f, -52.f)];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -6.f, 0.f, 6.f)];
    [moreBtn addTarget:self action:@selector(onClickMoreView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
    }];
    
    HPShareRecommendCard *shareCard_1 = [[HPShareRecommendCard alloc] init];
    [shareCard_1.layer setCornerRadius:7.f];
    [shareCard_1.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [shareCard_1.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [shareCard_1.layer setShadowRadius:6.f];
    [shareCard_1.layer setShadowOpacity:0.2f];
    [view addSubview:shareCard_1];
    _shareCard_1 = shareCard_1;
    [shareCard_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 115.f * g_rateWidth));
    }];
    
    HPShareRecommendCard *shareCard_2 = [[HPShareRecommendCard alloc] init];
    [shareCard_2.layer setCornerRadius:7.f];
    [shareCard_2.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [shareCard_2.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [shareCard_2.layer setShadowRadius:6.f];
    [shareCard_2.layer setShadowOpacity:0.2f];
    [view addSubview:shareCard_2];
    _shareCard_2 = shareCard_2;
    [shareCard_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareCard_1.mas_bottom).with.offset(15.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 115.f * g_rateWidth));
        make.bottom.equalTo(view).with.offset(-5.f * g_rateWidth);
    }];
}

- (void)setupNearbyShareRegion:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"附近共享" ofRegion:view];
    
    UIView *mapView = [[UIView alloc] init];
    [mapView.layer setCornerRadius:5.f];
    [mapView setBackgroundColor:COLOR_GRAY_999999];
    [view addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 121.f * g_rateWidth));
        make.bottom.equalTo(view).with.offset(-5.f * g_rateWidth);
    }];
}

- (void)setupShareRecommendRegion:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"共享人推荐" ofRegion:view];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setClipsToBounds:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [view addSubview:scrollView];
    _shareRecommendScrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.height.mas_equalTo(187.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-5.f * g_rateWidth);
    }];
}

- (void)reloadShareRecommendRegionWithDate:(NSArray *)data {
    for (int i = 0; i < data.count; i ++) {
        NSDictionary *dict = data[i];
        
        HPSharePersonCard *sharePersonCard;
        
        if (_shareRecommendScrollView.subviews.count > i) {
            sharePersonCard = _shareRecommendScrollView.subviews[i];
        }
        else {
            sharePersonCard = [[HPSharePersonCard alloc] init];
            [_shareRecommendScrollView addSubview:sharePersonCard];
            [sharePersonCard mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.shareRecommendScrollView);
                make.width.mas_equalTo(291.f * g_rateWidth);
                make.height.mas_equalTo(187.f * g_rateWidth);
                
                if (i == 0) {
                    make.left.equalTo(self.shareRecommendScrollView).with.offset(15.f * g_rateWidth);
                }
                else {
                    UIView *lastShareCard = self.shareRecommendScrollView.subviews[i - 1];
                    make.left.equalTo(lastShareCard.mas_right).with.offset(15.f * g_rateWidth);
                }
                
                if (i == data.count - 1) {
                    make.right.equalTo(self.shareRecommendScrollView).with.offset(-15.f * g_rateWidth);
                }
            }];
        }
        
        [sharePersonCard setPortrait:dict[@"portrait"]];
        [sharePersonCard setUserName:dict[@"userName"]];
        [sharePersonCard setCompany:dict[@"company"]];
        [sharePersonCard setSignature:dict[@"signature"]];
        [sharePersonCard setDescription:dict[@"desc"]];
    }
}

- (void)setupShareProcessRegion:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"共享流程" ofRegion:view];
    
    UIView *processView = [[UIView alloc] init];
    [processView setBackgroundColor:UIColor.whiteColor];
    [processView.layer setCornerRadius:4.f];
    [processView.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [processView.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [processView.layer setShadowRadius:6.f];
    [processView.layer setShadowOpacity:0.2f];
    [view addSubview:processView];
    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15.f);
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 124.f * g_rateWidth));
        make.bottom.equalTo(view);
    }];
    
    UIImageView *processIcon = [[UIImageView alloc] init];
    [processIcon setImage:[UIImage imageNamed:@"share_process"]];
    [processView addSubview:processIcon];
    [processIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(processView).with.offset(31.f * g_rateWidth);
        make.top.equalTo(processView).with.offset(20.f * g_rateWidth);
    }];
    
    UILabel *processLabel = [[UILabel alloc] init];
    [processLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [processLabel setTextColor:COLOR_BLACK_333333];
    [processLabel setText:@"共享的正确打开方式"];
    [processView addSubview:processLabel];
    [processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(processIcon.mas_right).with.offset(10.f);
        make.centerY.equalTo(processIcon);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [processView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processIcon.mas_bottom).with.offset(17.f * g_rateWidth);
        make.centerX.equalTo(processView);
        make.size.mas_equalTo(CGSizeMake(285.f * g_rateWidth, 1.f));
    }];
    
    UIView *centerView = [[UIView alloc] init];
    [processView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(processView);
        make.centerX.equalTo(processView);
    }];
    
    UIView *releaseProcess = [self setupProcessItemWithIndex:@"1" icon:[UIImage imageNamed:@"share_release"] title:@"发布信息"];
    [centerView addSubview:releaseProcess];
    [releaseProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.centerY.equalTo(centerView);
    }];
    
    UIView *contactProcess = [self setupProcessItemWithIndex:@"2" icon:[UIImage imageNamed:@"share_contact"] title:@"线上沟通"];
    [centerView addSubview:contactProcess];
    [contactProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(releaseProcess.mas_right).with.offset(31.f * g_rateWidth);
        make.centerY.equalTo(centerView);
    }];
    
    UIView *surveyProcess = [self setupProcessItemWithIndex:@"3" icon:[UIImage imageNamed:@"share_survey"] title:@"线下实勘"];
    [centerView addSubview:surveyProcess];
    [surveyProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactProcess.mas_right).with.offset(31.f * g_rateWidth);
        make.centerY.equalTo(centerView);
    }];
    
    UIView *successProcess = [self setupProcessItemWithIndex:@"4" icon:[UIImage imageNamed:@"share_success"] title:@"成功共享"];
    [centerView addSubview:successProcess];
    [successProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surveyProcess.mas_right).with.offset(31.f * g_rateWidth);
        make.centerY.equalTo(centerView);
        make.right.equalTo(centerView);
    }];
}

#pragma mark - setupCommonUI

- (UILabel *)setupTitle:(NSString *)title ofRegion:(UIView *)view {
    UIView *line = [[UIView alloc] init];
    [line.layer setCornerRadius:1.f];
    [line setBackgroundColor:COLOR_RED_FF4562];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(15.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(3.f, 20.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:21.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line);
        make.left.equalTo(line.mas_right).with.offset(10.f);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    return titleLabel;
}

- (UIView *)setupProcessItemWithIndex:(NSString *)index icon:(UIImage *)icon title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:icon];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    UILabel *indexLabel = [[UILabel alloc] init];\
    [indexLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [indexLabel setTextColor:COLOR_BLACK_666666];
    [indexLabel setText:index];
    [view addSubview:indexLabel];
    [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(iconView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [titleLabel setTextColor:COLOR_BLACK_666666];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).with.offset(10.f);
        make.left.and.right.equalTo(view);
        make.height.mas_equalTo(titleLabel.font.pointSize);
        make.bottom.equalTo(view);
    }];
    
    return view;
}


#pragma mark - HPBannerDelegate

- (void)banner:(HPBanner *)banner didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - onClick

- (void)onClickMoreView:(UIView *)view {
    [_baner stopAutoScroll];
    
    HPShareListController *shareListController = [[HPShareListController alloc] init];
    [self.navigationController pushViewController:shareListController animated:YES];
}

@end
