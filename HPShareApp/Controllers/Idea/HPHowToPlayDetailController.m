//
//  HPHowToPlayDetailController.m
//  HPShareApp
//
//  Created by HP on 2018/11/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHowToPlayDetailController.h"
#import "HPBannerView.h"
#import "HPImageUtil.h"
#import "HPPageControlFactory.h"

@interface HPHowToPlayDetailController () <HPBannerViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) HPBannerView *bannerView;

@property (nonatomic, weak) HPPageControl *pageControl;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *typeLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UILabel *theoryLabel;

@property (nonatomic, weak) UILabel *beforeFirstPlaceLabel;

@property (nonatomic, weak) UILabel *beforeFirstDescLabel;

@property (nonatomic, weak) UILabel *beforeSecondPlaceLabel;

@property (nonatomic, weak) UILabel *beforeSecondDescLabel;

@property (nonatomic, weak) UILabel *afterFirstPlaceLabel;

@property (nonatomic, weak) UILabel *afterFirstDescLabel;

@property (nonatomic, weak) UILabel *afterSecondPlaceLabel;

@property (nonatomic, weak) UILabel *afterSecondDescLabel;

@end

@implementation HPHowToPlayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [_titleLabel setText:@"健身房与轻食店"];
    [_typeLabel setText:@"铺位共享"];
    [_descLabel setText:@"健身房优化设备布局，能将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。"];
    [_theoryLabel setText:@"健身房在选择共享合作店铺的时候，采用了产品或服务匹配的原理。将轻食店的简餐、减脂套餐作为健身运动的互补产品进行合作，通过运动与饮食相结合的方式，完善了自身健身服务，增加用户的粘性与忠诚度。\n\n\n轻食店在选择共享时，采用了人群、客流匹配的原理。轻食店的产品主要以素食、减肥餐、健身餐等食品为主。客户群体也多为健身或者是减肥等对饮食摄入要求较高的用户。这类客户群体与健身房的用户群体完全吻合。轻食店可以共享健身房的客群流量，来给店铺增加稳定的客流。"];
    [_beforeFirstPlaceLabel setText:@"健身房"];
    [_beforeFirstDescLabel setText:@"健身房的经营面积一般都较大，需要放置很多的健身设备，这就导致了会有许多的空间是闲置的，没有有效的利用起来。健身房的客户群体多以高收入人群为主，他们追求健康生活方式。注重运动，饮食。大量的运动过后，需要健康的饮食和营养品来进行补充。"];
    [_beforeSecondPlaceLabel setText:@"轻食店"];
    [_beforeSecondDescLabel setText:@"轻食店也属于普通餐馆的一种，需要在人流较大的地区开设店铺，导致店铺租金成本较高。但轻食店的目标群体并不是所有客户，而是部分以追求健康生活方式的人群为主。会提供一些低热量、低卡路里的减肥餐或者健身餐。所以客户较少。"];
    [_afterFirstPlaceLabel setText:@"健身房"];
    [_afterFirstDescLabel setText:@"健身房优化布局后，将闲置空间出租，换取收益，降低了店铺租金成本。轻食店的入驻，完善了健身房的整个生态链条，为健身房增加部分流量，增加了用户粘性。"];
    [_afterSecondPlaceLabel setText:@"轻食店"];
    [_afterSecondDescLabel setText:@"轻食店入驻健身房后，减少了店铺租金的压力。健身房给轻食店带来了大量稳定的客流，客户匹配程度非常高，增加了销售，带来收益。"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_bannerView startAutoScrollWithInterval:2.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_bannerView stopAutoScroll];
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
    [scrollView setDelegate:self];
    
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSArray *images = @[[UIImage imageNamed:@"jingxuanwanfa_banner"], [UIImage imageNamed:@"jingxuanwanfa_banner"], [UIImage imageNamed:@"jingxuanwanfa_banner"]];
    
    HPBannerView *bannerView = [[HPBannerView alloc] init];
    [bannerView setImages:images];
    [bannerView setBannerViewDelegate:self];
    [scrollView addSubview:bannerView];
    _bannerView = bannerView;
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(- g_statusBarHeight);
        make.left.and.width.equalTo(scrollView);
        make.height.mas_equalTo(225.f * g_rateWidth);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] init];
    [backIcon setImage:[UIImage imageNamed:@"icon_back"]];
    [scrollView addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).with.offset(16.f * g_rateWidth);
        make.top.equalTo(scrollView).with.offset(9.f * g_rateWidth);
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
    [titleLabel setText:@"共享空间怎么玩?"];
    [scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.centerY.equalTo(backBtn);
    }];
    
    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
    [pageControl setNumberOfPages:3];
    [pageControl setCurrentPage:0];
    [scrollView addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.bottom.equalTo(bannerView).with.offset(-22.f * g_rateWidth);
    }];
    
    UIView *topicView = [[UIView alloc] init];
    [topicView setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:topicView];
    [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView.mas_bottom);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupTopicView:topicView];
    
    UIView *theoryView = [[UIView alloc] init];
    [theoryView setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:theoryView];
    [theoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicView.mas_bottom).with.offset(10.f * g_rateWidth);
        make.left.and.width.equalTo(scrollView);
    }];
    [self setupTheoryView:theoryView];
    
    UIView *compareView = [[UIView alloc] init];
    [compareView setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:compareView];
    [compareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(theoryView.mas_bottom);
        make.left.and.width.equalTo(scrollView);
        make.bottom.equalTo(scrollView);
    }];
    [self setupCompareView:compareView];
}

- (void)setupTopicView:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    [typeLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [typeLabel setTextColor:COLOR_GRAY_999999];
    [view addSubview:typeLabel];
    _typeLabel = typeLabel;
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(7.f * g_rateWidth);
        make.centerX.equalTo(titleLabel);
        make.height.mas_equalTo(typeLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setNumberOfLines:0];
    [view addSubview:descLabel];
    _descLabel = descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).with.offset(18.f * g_rateWidth);
        make.width.mas_equalTo(336.f * g_rateWidth);
        make.centerX.equalTo(view);
        make.bottom.equalTo(view).with.offset(-19.f * g_rateWidth);
    }];
}

- (void)setupTheoryView:(UIView *)view {
    UIView *titleView = [self setupFirstTitleViewWithTitle:@"共享原理"];
    [view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(15.f * g_rateWidth);
        make.left.equalTo(view).with.offset(15.f * g_rateWidth);
    }];
    
    UIView *descView = [self setupDescViewWithText:@""];
    [view addSubview:descView];
    _theoryLabel = descView.subviews[0];
    [descView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.top.equalTo(titleView.mas_bottom).with.offset(10.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(- getWidth(10.f));
    }];
}

- (void)setupCompareView:(UIView *)view {
    UIView *beforeTitleView = [self setupFirstTitleViewWithTitle:@"共享前"];
    [view addSubview:beforeTitleView];
    [beforeTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(15.f * g_rateWidth);
        make.left.equalTo(view).with.offset(15.f * g_rateWidth);
    }];
    
    UIView *lineView_0 = [[UIView alloc] init];
    [lineView_0 setBackgroundColor:COLOR_GRAY_EBEBEB];
    [view addSubview:lineView_0];
    [lineView_0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beforeTitleView);
        make.right.equalTo(view);
        make.top.equalTo(beforeTitleView.mas_bottom).with.offset(11.f * g_rateWidth);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView *beforeFirstPlace = [self setupSecondTitleViewWithTitle:@""];
    [view addSubview:beforeFirstPlace];
    _beforeFirstPlaceLabel = beforeFirstPlace.subviews[1];
    [beforeFirstPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView_0.mas_bottom).with.offset(14.f * g_rateWidth);
        make.left.equalTo(beforeTitleView);
    }];
    
    UIView *beforeFirstDesc = [self setupDescViewWithText:@""];
    [view addSubview:beforeFirstDesc];
    _beforeFirstDescLabel = beforeFirstDesc.subviews[0];
    [beforeFirstDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beforeTitleView);
        make.top.equalTo(beforeFirstPlace.mas_bottom).with.offset(10.f * g_rateWidth);
    }];
    
    UIView *beforeSecondPlace = [self setupSecondTitleViewWithTitle:@""];
    [view addSubview:beforeSecondPlace];
    _beforeSecondPlaceLabel = beforeSecondPlace.subviews[1];
    [beforeSecondPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beforeFirstDesc.mas_bottom).with.offset(17.f * g_rateWidth);
        make.left.equalTo(beforeTitleView);
    }];
    
    UIView *beforeSecondDesc = [self setupDescViewWithText:@""];
    [view addSubview:beforeSecondDesc];
    _beforeSecondDescLabel = beforeSecondDesc.subviews[0];
    [beforeSecondDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beforeTitleView);
        make.top.equalTo(beforeSecondPlace.mas_bottom).with.offset(10.f * g_rateWidth);
    }];
    
    UIView *afterTitleView = [self setupFirstTitleViewWithTitle:@"共享后"];
    [view addSubview:afterTitleView];
    [afterTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beforeSecondDesc.mas_bottom).with.offset(21.f * g_rateWidth);
        make.left.equalTo(beforeTitleView);
    }];
    
    UIView *lineView_1 = [[UIView alloc] init];
    [lineView_1 setBackgroundColor:COLOR_GRAY_EBEBEB];
    [view addSubview:lineView_1];
    [lineView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beforeTitleView);
        make.right.equalTo(view);
        make.top.equalTo(afterTitleView.mas_bottom).with.offset(11.f * g_rateWidth);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView *afterFirstPlace = [self setupSecondTitleViewWithTitle:@""];
    [view addSubview:afterFirstPlace];
    _afterFirstPlaceLabel = afterFirstPlace.subviews[1];
    [afterFirstPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView_1.mas_bottom).with.offset(14.f * g_rateWidth);
        make.left.equalTo(afterTitleView);
    }];
    
    UIView *afterFirstDesc = [self setupDescViewWithText:@""];
    [view addSubview:afterFirstDesc];
    _afterFirstDescLabel = afterFirstDesc.subviews[0];
    [afterFirstDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beforeTitleView);
        make.top.equalTo(afterFirstPlace.mas_bottom).with.offset(10.f * g_rateWidth);
    }];
    
    UIView *afterSecondPlace = [self setupSecondTitleViewWithTitle:@""];
    [view addSubview:afterSecondPlace];
    _afterSecondPlaceLabel = afterSecondPlace.subviews[1];
    [afterSecondPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(afterFirstDesc.mas_bottom).with.offset(15.f * g_rateWidth);
        make.left.equalTo(afterTitleView);
    }];
    
    UIView *afterSecondDesc = [self setupDescViewWithText:@""];
    [view addSubview:afterSecondDesc];
    _afterSecondDescLabel = afterSecondDesc.subviews[0];
    [afterSecondDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(afterTitleView);
        make.top.equalTo(afterSecondPlace.mas_bottom).with.offset(10.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-34.f * g_rateWidth);
    }];
}

#pragma mark - setupCommonUI

- (UIView *)setupFirstTitleViewWithTitle:(NSString *)title {
    UIView *titleView = [[UIView alloc] init];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:COLOR_RED_FF3C5E];
    [titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(3.f, 17.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:title];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right).with.offset(10.f);
        make.right.equalTo(titleView);
    }];
    
    return titleView;
}

- (UIView *)setupSecondTitleViewWithTitle:(NSString *)title {
    UIView *titleView = [[UIView alloc] init];
    
    UIView *circleView = [[UIView alloc] init];
    [circleView setBackgroundColor:COLOR_GRAY_999999];
    [circleView.layer setCornerRadius:2.f];
    [titleView addSubview:circleView];
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.centerY.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(4.f, 4.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:title];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).with.offset(8.f);
        make.top.and.bottom.equalTo(titleView);
        make.height.mas_equalTo(titleLabel.font.pointSize);
        make.right.equalTo(titleView);
    }];
    
    return titleView;
}

- (UIView *)setupDescViewWithText:(NSString *)text {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:COLOR_GRAY_F8F8F8];
    
    UILabel *textLabel = [[UILabel alloc] init];
    [textLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [textLabel setTextColor:COLOR_BLACK_666666];
    [textLabel setNumberOfLines:0];
    [textLabel setText:text];
    [view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(11.f * g_rateWidth);
        make.top.equalTo(view).with.offset(19.f * g_rateWidth);
        make.width.mas_equalTo(324.f * g_rateWidth);
        make.right.equalTo(view).with.offset(-11.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-18.f * g_rateWidth);
    }];
    
    return view;
}

#pragma mark - HPBannerDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - onClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self pop];
}

#pragma mark - 取消下拉  允许上拉

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.y < -g_statusBarHeight) {
        offset.y = -g_statusBarHeight;
        scrollView.contentOffset = offset;
    }
}

@end
