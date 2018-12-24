//
//  HPShareController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareController.h"
#import "HPBannerView.h"
#import "HPPageControlFactory.h"
#import "HPCommonData.h"
#import "HPImageButton.h"

typedef NS_ENUM(NSInteger, HPShareBtn) {
    HPShareBtnShop = 0,
    HPShareBtnGoods,
    HPShareBtnHuman,
    HPShareBtnMap
};

@interface HPShareController () <HPBannerViewDelegate>

@property (nonatomic, weak) HPPageControl *pageControl;

@property (nonatomic, weak) HPBannerView *bannerView;


@end

@implementation HPShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HPCommonData getAreaData];
    [HPCommonData getIndustryData];
    
    [self setupUI];
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
    
    HPBannerView *bannerView = [[HPBannerView alloc] init];
    [bannerView setImages:@[[UIImage imageNamed:@"shouye_banner1"], [UIImage imageNamed:@"shouye_banner2"]]];
    [bannerView setBannerViewDelegate:self];
    [self.view addSubview:bannerView];
    _bannerView = bannerView;
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(225.f * g_rateWidth);
    }];
    
    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
    [pageControl setNumberOfPages:2];
    [pageControl setCurrentPage:0];
    [self.view addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(bannerView).with.offset(-42.f * g_rateWidth);
    }];
    
    UIView *portalPanel = [[UIView alloc] init];
    [portalPanel.layer setCornerRadius:4.f];
    [portalPanel.layer setShadowColor:COLOR_GRAY_B2B2B2.CGColor];
    [portalPanel.layer setShadowOffset:CGSizeMake(0.f, 5.f)];
    [portalPanel.layer setShadowRadius:10.f];
    [portalPanel.layer setShadowOpacity:0.3f];
    [portalPanel setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:portalPanel];
    [portalPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(pageControl.mas_bottom).with.offset(getWidth(26.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(345.f), getWidth(385.f)));
    }];
    [self setupPortalPanel:portalPanel];
}

- (void)setupPortalPanel:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:kFont_Bold(18.f)];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"合店站，享未来"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(getWidth(21.f));
        make.top.equalTo(view).with.offset(getWidth(30.f));
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:kFont_Medium(12.f)];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setText:@"人货场信息共享的新零售平台。"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(getWidth(15.f));
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:[UIImage imageNamed:@"homepage_pic"]];
    [view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-getWidth(30.f));
        make.top.equalTo(view).with.offset(getWidth(23.f));
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_F8F8F8];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).with.offset(getWidth(30.f));
        make.centerX.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(getWidth(300.f), 1.f));
    }];
    
    UIView *centerView = [[UIView alloc] init];
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(getWidth(20.f));
        make.centerX.equalTo(view);
    }];
    
    HPImageButton *shareShopBtn = [[HPImageButton alloc] init];
    [shareShopBtn setTag:HPShareBtnShop];
    [shareShopBtn setImage:[UIImage imageNamed:@"store_share"] forState:UIControlStateNormal];
    [centerView addSubview:shareShopBtn];
    [shareShopBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareShopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(getWidth(160.f), getWidth(165.f)));
    }];
    
    UILabel *storeInfoLabel = [[UILabel alloc] init];
    [storeInfoLabel setFont:kFont_Heavy(15.f)];
    [storeInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [storeInfoLabel setText:@"店铺共享"];
    [shareShopBtn addSubview:storeInfoLabel];
    [storeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(shareShopBtn).with.offset(getWidth(15.f));
        make.height.mas_equalTo(storeInfoLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(kScreenWidth/2));
    }];
    
    UILabel *storeSBInfoLabel = [[UILabel alloc] init];
    [storeSBInfoLabel setFont:kFont_Medium(10.f)];
    [storeSBInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [storeSBInfoLabel setText:@"让每平米空间增值"];
    [shareShopBtn addSubview:storeSBInfoLabel];
    [storeSBInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareShopBtn).with.offset(getWidth(15.f));
        make.top.equalTo(storeInfoLabel.mas_bottom).with.offset(getWidth(10.f));
        make.height.mas_equalTo(storeSBInfoLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(kScreenWidth/2));
    }];
    
    HPImageButton *shareGoodsBtn = [[HPImageButton alloc] init];
    [shareGoodsBtn setTag:HPShareBtnGoods];
    [shareGoodsBtn setImage:[UIImage imageNamed:@"goods_share"] forState:UIControlStateNormal];
    [centerView addSubview:shareGoodsBtn];
    [shareGoodsBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareShopBtn.mas_right).with.offset(6.f);
        make.top.equalTo(centerView);
        make.right.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(getWidth(161.f), getWidth(80.f)));
    }];
    
    UILabel *goodInfoLabel = [[UILabel alloc] init];
    [goodInfoLabel setFont:kFont_Heavy(15.f)];
    [goodInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [goodInfoLabel setText:@"货品共享"];
    [shareGoodsBtn addSubview:goodInfoLabel];
    [goodInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(shareGoodsBtn).with.offset(getWidth(15.f));
        make.height.mas_equalTo(goodInfoLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(kScreenWidth/2));
    }];
    
    UILabel *goodSBInfoLabel = [[UILabel alloc] init];
    [goodSBInfoLabel setFont:kFont_Medium(10.f)];
    [goodSBInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [goodSBInfoLabel setText:@"去掉中间商的货品"];
    [shareGoodsBtn addSubview:goodSBInfoLabel];
    [goodSBInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareGoodsBtn).with.offset(getWidth(15.f));
        make.top.equalTo(goodInfoLabel.mas_bottom).with.offset(getWidth(10.f));
        make.height.mas_equalTo(goodSBInfoLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(kScreenWidth/2));
    }];
    
    HPImageButton *shareHumanBtn = [[HPImageButton alloc] init];
    [shareHumanBtn setTag:HPShareBtnHuman];
    [shareHumanBtn setImage:[UIImage imageNamed:@"human_share"] forState:UIControlStateNormal];
    [centerView addSubview:shareHumanBtn];
    [shareHumanBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareHumanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareGoodsBtn);
        make.top.equalTo(shareGoodsBtn.mas_bottom).with.offset(6.f);
        make.size.mas_equalTo(CGSizeMake(getWidth(161.f), getWidth(80.f)));
    }];
    
    UILabel *manInfoLabel = [[UILabel alloc] init];
    [manInfoLabel setFont:kFont_Heavy(15.f)];
    [manInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [manInfoLabel setText:@"人力共享"];
    [shareHumanBtn addSubview:manInfoLabel];
    [manInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(shareHumanBtn).with.offset(getWidth(15.f));
        make.height.mas_equalTo(manInfoLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(kScreenWidth/2));
    }];
    
    UILabel *manSBInfoLabel = [[UILabel alloc] init];
    [manSBInfoLabel setFont:kFont_Medium(10.f)];
    [manSBInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [manSBInfoLabel setText:@"人手不足随时找"];
    [shareHumanBtn addSubview:manSBInfoLabel];
    [manSBInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareHumanBtn).with.offset(getWidth(15.f));
        make.top.equalTo(manInfoLabel.mas_bottom).with.offset(getWidth(10.f));
        make.height.mas_equalTo(manSBInfoLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(kScreenWidth/2));
    }];
    
    HPImageButton *shareMapBtn = [[HPImageButton alloc] init];
    [shareMapBtn setTag:HPShareBtnMap];
    [shareMapBtn setImage:[UIImage imageNamed:@"share_map"] forState:UIControlStateNormal];
    [centerView addSubview:shareMapBtn];
    [shareMapBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareMapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareShopBtn.mas_bottom).with.offset(6.f);
        make.left.and.width.equalTo(centerView);
        make.bottom.equalTo(centerView);
        make.size.mas_equalTo(CGSizeMake(getWidth(327.f), getWidth(79.f)));
    }];
    
    UILabel *mapInfoLabel = [[UILabel alloc] init];
    [mapInfoLabel setFont:kFont_Heavy(14.f)];
    [mapInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [mapInfoLabel setText:@"共享地图"];
    [shareMapBtn addSubview:mapInfoLabel];
    [mapInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareMapBtn).with.offset(getWidth(42.f));
        make.top.equalTo(shareMapBtn).with.offset(getWidth(20.f));
        make.height.mas_equalTo(mapInfoLabel.font.pointSize);
        make.width.mas_equalTo(getWidth(kScreenWidth/2));
    }];
    
    UILabel *mapSBInfoLabel = [[UILabel alloc] init];
    [mapSBInfoLabel setFont:kFont_Medium(10.f)];
    [mapSBInfoLabel setTextColor:COLOR_GRAY_FFFFFF];
    [mapSBInfoLabel setText:@"查询附近共享信息，更方便、更精准。"];
    [shareMapBtn addSubview:mapSBInfoLabel];
    [mapSBInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareMapBtn).with.offset(getWidth(24.f));
        make.top.equalTo(mapInfoLabel.mas_bottom).with.offset(getWidth(15.f));
        make.height.mas_equalTo(mapSBInfoLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

#pragma mark - HPBannerViewDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - OnClick

- (void)onClickShareBtn:(UIButton *)btn {
    switch (btn.tag) {
        case HPShareBtnShop:
            [self pushVCByClassName:@"HPShareShopListController"];
            break;
            
        case HPShareBtnGoods:
            [self pushVCByClassName:@"HPShareTempGoodsController"];
            break;
            
        case HPShareBtnHuman:
            [self pushVCByClassName:@"HPShareTempHumanController"];
            break;
            
        case HPShareBtnMap:
            [self pushVCByClassName:@"HPShareMapController"];
            break;
            
        default:
            break;
    }
}

@end
