//
//  HPShareDetailController.m
//  HPShareApp
//
//  Created by HP on 2018/11/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareDetailController.h"
#import "HPBannerView.h"
#import "HPCalendarView.h"
#import "HPPageControlFactory.h"
#import "HPTimeString.h"
#import "HPCommonData.h"
#import "HPShareDetailModel.h"
#import "HPTagView.h"
#import "HPCustomerServiceModalView.h"


@interface HPShareDetailController () <HPBannerViewDelegate>

@property (nonatomic, weak) HPBannerView *bannerView;

@property (nonatomic, weak) HPPageControl *pageControl;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *tagItems;

@property (nonatomic, weak) UILabel *releaseTimeLabel;

@property (nonatomic, weak) UILabel *addressLabel;

@property (nonatomic, weak) UILabel *tradeLabel;

@property (nonatomic, weak) UILabel *shareTimeLabel;

@property (nonatomic, weak) UILabel *areaLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UILabel *priceUnitLabel;

@property (nonatomic, weak) UILabel *remarkLabel;

@property (nonatomic, weak) UIImageView *portrait;

@property (nonatomic, weak) UILabel *userNameLabel;

@property (nonatomic, weak) HPCalendarView *calendarView;

/**
 共享租金
 */
@property (nonatomic, strong) UILabel *priceDescLabel;
/**
 共享面积
 */
@property (nonatomic, strong) UILabel *areaDescLabel;

@property (nonatomic, weak) HPCustomerServiceModalView *customerServiceModalView;

@property (nonatomic, weak) UIButton *keepBtn;

@end

@implementation HPShareDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tagItems = [[NSMutableArray alloc] init];
    
    [self setupUI];
    
    HPShareDetailModel *model = self.param[@"model"];
    NSString *spaceId = model.spaceId;
    if (spaceId) {
        [self getShareDetailInfoById:spaceId];
        [self addHistory:spaceId];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [_bannerView startAutoScrollWithInterval:2.0];
//    NSString *spaceId = self.param[@"spaceId"];
//    if (spaceId) {
//        [self getShareDetailInfoById:spaceId];
//    }
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

#pragma mark - SetupUI

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_WHITE_FAF9FE];
    UIView *navView = [self setupNavigationBarWithTitle:@"店铺共享"];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setBackgroundColor:COLOR_WHITE_FAF9FE];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60.f * g_rateWidth, 0));
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(navView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);

    }];
    
    HPBannerView *bannerView = [[HPBannerView alloc] init];
    [bannerView setBannerViewDelegate:self];
    [bannerView setImages:@[[UIImage imageNamed:@"shared_shop_details_background"]]];
    [bannerView setImageContentMode:UIViewContentModeScaleAspectFill];
    [bannerView setShowImagePagerEnabled:YES];
    [scrollView addSubview:bannerView];
    _bannerView = bannerView;
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.and.width.equalTo(scrollView);
        make.height.mas_equalTo(230.f * g_rateWidth);
    }];
    
//    UIImageView *backIcon = [[UIImageView alloc] init];
//    [backIcon setImage:[UIImage imageNamed:@"icon_back"]];
//    [scrollView addSubview:backIcon];
//    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(scrollView).with.offset(25.f * g_rateWidth);
//        make.top.equalTo(scrollView).with.offset(13.f);
//    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
//    [backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(scrollView);
        make.width.mas_equalTo(44.f);
        make.height.mas_equalTo(44.f);
    }];
    
    HPPageControl *pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleCircle];
    [pageControl setNumberOfPages:0];
//    [pageControl setCurrentPage:0];
    [scrollView addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.bottom.equalTo(bannerView);
    }];
    
    UIView *titleRegion = [[UIView alloc] init];
    [titleRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:titleRegion];
    [titleRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(bannerView.mas_bottom);
        make.height.mas_equalTo(127.f * g_rateWidth);
    }];
    [self setupTitleRegion:titleRegion];
    
    UIView *infoRegion = [[UIView alloc] init];
    [infoRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:infoRegion];
    [infoRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(titleRegion.mas_bottom).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(185.f * g_rateWidth);
    }];
    [self setupInfoRegion:infoRegion];
    
    UIView *shareDateRegion = [[UIView alloc] init];
    [shareDateRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:shareDateRegion];
    [shareDateRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(infoRegion.mas_bottom).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(360.f * g_rateWidth);
    }];
    [self setupShareDateRegion:shareDateRegion];
    
    UIView *remarkRegion = [[UIView alloc] init];
    [remarkRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:remarkRegion];
    [remarkRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(shareDateRegion.mas_bottom).with.offset(15.f * g_rateWidth);
        make.bottom.equalTo(scrollView).with.offset(-getWidth(80.f));
    }];
    [self setupRemarkRegion:remarkRegion];
    
    UIView *contactRegion = [[UIView alloc] init];
    [contactRegion setBackgroundColor:UIColor.whiteColor];
    [contactRegion.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [contactRegion.layer setShadowOffset:CGSizeMake(0.f, -2.f)];
    [contactRegion.layer setShadowOpacity:0.19f];
    [self.view addSubview:contactRegion];
    [contactRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(60.f * g_rateWidth);
        make.bottom.equalTo(self.view);
    }];
    [self setupContactRegion:contactRegion];
}

- (void)setTag:(NSArray *)tags {
    for (int i = 0; i < _tagItems.count; i++) {
        HPTagView *tagItem = _tagItems[i];
        if (i < tags.count) {
            if ([tags[i] isEqualToString:@""]) {
                continue;
            }
            [tagItem setHidden:NO];
            [tagItem setText:tags[i]];
        }
    }
}

- (void)setupTitleRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:19.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [self.view addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(26.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    for (int i = 0; i < 3; i ++) {
        HPTagView *tagView = [[HPTagView alloc] init];
        [view addSubview:tagView];
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(titleLabel);
                make.top.equalTo(titleLabel.mas_bottom).with.offset(10.f * g_rateWidth);
            }
            else {
                UIView *lastTagItem = self.tagItems[i - 1];
                make.left.equalTo(lastTagItem.mas_right).with.offset(5.f);
                make.centerY.equalTo(lastTagItem);
            }
        }];
        [tagView setHidden:YES];
        
        [_tagItems addObject:tagView];
    }
    
    UILabel *releaseTimeDescLabel = [[UILabel alloc] init];
    [releaseTimeDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [releaseTimeDescLabel setTextColor:COLOR_YELLOW_FFAF47];
    [releaseTimeDescLabel setText:@"发布时间"];
    [view addSubview:releaseTimeDescLabel];
    [releaseTimeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(27.f * g_rateWidth);
        make.right.equalTo(view).with.offset(-26.f * g_rateWidth);
        make.height.mas_equalTo(releaseTimeDescLabel.font.pointSize);
    }];
    
    UIImageView *clockIcon = [[UIImageView alloc] init];
    [clockIcon setImage:[UIImage imageNamed:@"shared_shop_details_time"]];
    [view addSubview:clockIcon];
    [clockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(releaseTimeDescLabel);
        make.right.equalTo(releaseTimeDescLabel.mas_left).with.offset(-4.f);
    }];
    
    UILabel *releaseTimeLabel = [[UILabel alloc] init];
    [releaseTimeLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [releaseTimeLabel setTextColor:COLOR_GRAY_999999];
    [view addSubview:releaseTimeLabel];
    _releaseTimeLabel = releaseTimeLabel;
    [releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(releaseTimeDescLabel);
        make.top.equalTo(releaseTimeDescLabel.mas_bottom).with.offset(14.f * g_rateWidth);
        make.height.mas_equalTo(releaseTimeLabel.font.pointSize);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_F8F8F8];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(((UIView *)self.tagItems[0]).mas_bottom).with.offset(15.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(325.f * g_rateWidth, 1.f));
    }];
    
    UIImageView *addressIcon = [[UIImageView alloc] init];
    [addressIcon setImage:[UIImage imageNamed:@"shared_shop_details_address"]];
    [view addSubview:addressIcon];
    [addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line);
        make.top.equalTo(line.mas_bottom).with.offset(14.f * g_rateWidth);
    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    [addressLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [addressLabel setTextColor:COLOR_BLACK_666666];
    [view addSubview:addressLabel];
    _addressLabel = addressLabel;
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressIcon.mas_right).with.offset(12.f);
        make.centerY.equalTo(addressIcon);
    }];
}

- (void)setupInfoRegion:(UIView *)view {
    UIView *verticalLine = [[UIView alloc] init];
    [verticalLine setBackgroundColor:COLOR_GRAY_F7F7F7];
    [view addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(194.f * g_rateWidth);
        make.top.and.bottom.equalTo(view);
        make.width.mas_equalTo(1.f);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    [view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(view);
        make.right.equalTo(verticalLine.mas_left);
    }];
    
    UIView *horizontalLine = [[UIView alloc] init];
    [horizontalLine setBackgroundColor:COLOR_GRAY_F7F7F7];
    [view addSubview:horizontalLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right);
        make.centerY.equalTo(view);
        make.right.equalTo(view);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView *rightUpView = [[UIView alloc] init];
    [view addSubview:rightUpView];
    [rightUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right);
        make.top.and.right.equalTo(view);
        make.bottom.equalTo(horizontalLine.mas_top);
    }];
    
    UIView *rightDownView = [[UIView alloc] init];
    [view addSubview:rightDownView];
    [rightDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(view);
        make.left.equalTo(verticalLine.mas_right);
        make.top.equalTo(horizontalLine.mas_bottom);
    }];
    
    UILabel *tradeDescLabel = [[UILabel alloc] init];
    [tradeDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [tradeDescLabel setTextColor:COLOR_GRAY_999999];
    [tradeDescLabel setText:@"经营行业"];
    [leftView addSubview:tradeDescLabel];
    [tradeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.top.equalTo(leftView).with.offset(26.f * g_rateWidth);
        make.height.mas_equalTo(tradeDescLabel.font.pointSize);
    }];
    
    UILabel *tradeLabel = [[UILabel alloc] init];
    [tradeLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [tradeLabel setTextColor:COLOR_RED_FF3C5E];
    [leftView addSubview:tradeLabel];
    _tradeLabel = tradeLabel;
    [tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tradeDescLabel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.centerX.equalTo(tradeDescLabel);
        make.height.mas_equalTo(tradeLabel.font.pointSize);
    }];
    
    UILabel *shareTimeDescLabel = [[UILabel alloc] init];
    [shareTimeDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [shareTimeDescLabel setTextColor:COLOR_GRAY_999999];
    [shareTimeDescLabel setText:@"共享时段"];
    [leftView addSubview:shareTimeDescLabel];
    [shareTimeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.top.equalTo(horizontalLine.mas_bottom).with.offset(28.f * g_rateWidth);
        make.height.mas_equalTo(shareTimeDescLabel.font.pointSize);
    }];
    
    UILabel *shareTimeLabel = [[UILabel alloc] init];
    [shareTimeLabel setFont:[UIFont fontWithName:FONT_BOLD size:17.f]];
    [shareTimeLabel setTextColor:COLOR_RED_FF3C5E];
    [leftView addSubview:shareTimeLabel];
    _shareTimeLabel = shareTimeLabel;
    [shareTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareTimeDescLabel);
        make.top.equalTo(shareTimeDescLabel.mas_bottom).with.offset(14.f * g_rateWidth);
        make.height.mas_equalTo(shareTimeLabel.font.pointSize);
    }];
    
    UILabel *areaDescLabel = [[UILabel alloc] init];
    [areaDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [areaDescLabel setTextColor:COLOR_GRAY_999999];
    [areaDescLabel setText:@"共享面积"];
    [rightUpView addSubview:areaDescLabel];
    _areaDescLabel = areaDescLabel;
    [areaDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightUpView);
        make.top.equalTo(rightUpView).with.offset(27.f * g_rateWidth);
        make.height.mas_equalTo(areaDescLabel.font.pointSize);
    }];
    
    UILabel *areaLabel = [[UILabel alloc] init];
    [areaLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [areaLabel setTextColor:COLOR_RED_FF3C5E];
    [rightUpView addSubview:areaLabel];
    _areaLabel = areaLabel;
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(areaDescLabel);
        make.top.equalTo(areaDescLabel.mas_bottom).with.offset(13.f * g_rateWidth);
        make.height.mas_equalTo(areaLabel.font.pointSize);
    }];
    
    UILabel *priceDescLabel = [[UILabel alloc] init];
    [priceDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [priceDescLabel setTextColor:COLOR_GRAY_999999];
    [priceDescLabel setText:@"共享租金"];
    [rightDownView addSubview:priceDescLabel];
    _priceDescLabel = priceDescLabel;
    [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightDownView).with.offset(27.f * g_rateWidth);
        make.centerX.equalTo(rightDownView);
        make.height.mas_equalTo(priceDescLabel.font.pointSize);
    }];
    
    UIView *centerView = [[UIView alloc] init];
    [rightDownView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceDescLabel.mas_bottom).with.offset(12.f);
        make.centerX.equalTo(rightDownView);
        make.height.mas_equalTo(17.f);
    }];
    
    UILabel *priceUnitLabel = [[UILabel alloc] init];
    [priceUnitLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [priceUnitLabel setTextColor:COLOR_RED_FF3C5E];
    [priceUnitLabel setText:@"/天"];
    [centerView addSubview:priceUnitLabel];
    _priceUnitLabel = priceUnitLabel;
    [priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView);
        make.centerY.equalTo(centerView);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
    [priceLabel setTextColor:COLOR_RED_FF3C5E];
    [centerView addSubview:priceLabel];
    _priceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(centerView);
        make.left.equalTo(centerView);
        make.right.equalTo(priceUnitLabel.mas_left);
    }];
}

- (void)setupShareDateRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"共享排期"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(26.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    HPCalendarView *calendarView = [[HPCalendarView alloc] init];
    [view addSubview:calendarView];
    _calendarView = calendarView;
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.width.mas_equalTo(325.f * g_rateWidth);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(22.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-27.f * g_rateWidth);
    }];
}

- (void)setupRemarkRegion:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"备注信息"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(26.f * g_rateWidth);
        make.top.equalTo(view).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    [remarkLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [remarkLabel setTextColor:COLOR_BLACK_666666];
    [remarkLabel setNumberOfLines:0];
    [view addSubview:remarkLabel];
    _remarkLabel = remarkLabel;
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(19.f * g_rateWidth);
        make.width.mas_equalTo(324.f * g_rateWidth);
        make.bottom.equalTo(view).with.offset(-20.f * g_rateWidth);
    }];
}

- (void)setupContactRegion:(UIView *)view {
    UIImageView *portrait = [[UIImageView alloc] init];
    [portrait.layer setMasksToBounds:YES];
    [portrait.layer setCornerRadius:20.f * g_rateWidth];
    portrait.userInteractionEnabled = YES;
    portrait.image = ImageNamed(@"shared_shop_details_head_portrait");
    [view addSubview:portrait];
    _portrait = portrait;
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(25.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(40.f * g_rateWidth, 40.f * g_rateWidth));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MyCardVC:)];
    [portrait addGestureRecognizer:tap];
    
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:18.f]];
    [phoneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"shared_shop_details_calendar_telephone"] forState:UIControlStateNormal];
    [phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, -6.f)];
    [phoneBtn setBackgroundColor:COLOR_ORANGE_F59C40];
    [phoneBtn setTitle:@"电话" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(makePhoneCall:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.equalTo(view);
        make.width.mas_equalTo(110.f * g_rateWidth);
    }];
    
    UIButton *keepBtn = [[UIButton alloc] init];
    [keepBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:18.f]];
    [keepBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [keepBtn setTitleColor:COLOR_RED_912D01 forState:UIControlStateSelected];
    [keepBtn setImage:[UIImage imageNamed:@"shared_shop_details_calendar_collection"] forState:UIControlStateNormal];
    [keepBtn setImage:ImageNamed(@"shared_shop_details_calendar_collection_selected") forState:UIControlStateSelected];
    [keepBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, -6.f)];
    [keepBtn setBackgroundColor:COLOR_RED_FE2A3B];
    [keepBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [keepBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [keepBtn setTitle:@"已收藏" forState:UIControlStateSelected|UIControlStateHighlighted];
    [view addSubview:keepBtn];
    _keepBtn = keepBtn;
    [keepBtn addTarget:self action:@selector(addOrCancelCollection:) forControlEvents:UIControlEventTouchUpInside];
    [keepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(view);
        make.right.equalTo(phoneBtn.mas_left);
        make.width.mas_equalTo(110.f * g_rateWidth);
    }];
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    [userNameLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [userNameLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    [_userNameLabel setText:@"高小薇"];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portrait.mas_right).with.offset(14.f * g_rateWidth);
        make.right.equalTo(keepBtn.mas_left);
        make.centerY.equalTo(view);
    }];
}

- (void)MyCardVC:(UITapGestureRecognizer *)tap
{
    HPShareDetailModel *model = self.param[@"model"];
    [self pushVCByClassName:@"HPMyCardController" withParam:@{@"userId":model.userId}];
}

#pragma mark - 拨打电话
- (void)makePhoneCall:(UIButton *)button{
    HPShareDetailModel *model = self.param[@"model"];

        if (_customerServiceModalView == nil) {
            HPCustomerServiceModalView *customerServiceModalView = [[HPCustomerServiceModalView alloc] initWithParent:self.parentViewController.view];
            customerServiceModalView.phone = model.contactMobile;
            [customerServiceModalView setPhoneString:model.contactMobile];
            _customerServiceModalView = customerServiceModalView;
        }
        
        [_customerServiceModalView show:YES];
        [self.parentViewController.view bringSubviewToFront:_customerServiceModalView];
}
#pragma mark - HPbannerViewDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - onClickBackBtn

- (void)onClickBackBtn {
    [self pop];
}

#pragma mark - NetWork
//获取详情数据
- (void)getShareDetailInfoById:(NSString *)spaceId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"spaceId"] = spaceId;
    
    [HPProgressHUD alertWithLoadingText:@"数据加载中"];
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/space/detail" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD hideHud];
            HPShareDetailModel *model = [HPShareDetailModel mj_objectWithKeyValues:DATA];
            NSDictionary *userCardCase = DATA[@"userCardCase"];
            if (![userCardCase isMemberOfClass:NSNull.class]) {
                model.avatarUrl = userCardCase[@"avatarUrl"];
            }
            [self loadData:model];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

//添加浏览历史
- (void)addHistory:(NSString *)spaceId {
    if (!spaceId) {
        return;
    }
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/browseHistory/add" isNeedToken:YES paraments:@{@"spaceId":spaceId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            HPLog(@"添加浏览历史成功");
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)addOrCancelCollection:(UIButton *)btn {
    if (btn.isSelected) {
        [self cancelCollection:btn];
    }
    else
        [self addCollection:btn];
}

//添加收藏
- (void)addCollection:(UIButton *)btn {
    HPShareDetailModel *model = self.param[@"model"];
    if (!model) {
        return;
    }
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/collection/add" isNeedToken:YES paraments:@{@"spaceId":model.spaceId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"收藏成功"];
            [btn setSelected:YES];
        }else
        {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

//取消收藏
- (void)cancelCollection:(UIButton *)btn {
    HPShareDetailModel *model = self.param[@"model"];
    if (!model) {
        return;
    }
    
    [HPHTTPSever HPGETServerWithMethod:@"/v1/collection/cancel" isNeedToken:YES paraments:@{@"spaceId":model.spaceId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:@"取消收藏"];
            [btn setSelected:NO];
        }else
        {
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

#pragma mark - LoadData

- (void)loadData:(HPShareDetailModel *)model {
    [_titleLabel setText:model.title];
    
    if (model.tag) {
        NSArray *tags = [model.tag componentsSeparatedByString:@","];
        [self setTag:tags];
    }
    
    [_releaseTimeLabel setText:[model.createTime componentsSeparatedByString:@" "][0]];
    
    if (model.type == 1) {//业主
        [_addressLabel setText:[NSString stringWithFormat:@"店铺地址:%@",model.address]];
        [_priceDescLabel setText:@"共享租金"];
        [_areaDescLabel setText:@"共享面积"];

    }
    else if (model.type == 2) { //创客
        NSString *areaName = [HPCommonData getAreaNameById:model.areaId];
        NSString *districeName = [HPCommonData getDistrictNameByAreaId:model.areaId districtId:model.districtId];
        [_addressLabel setText:[NSString stringWithFormat:@"期望区域:%@-%@", areaName, districeName]];
        [_priceDescLabel setText:@"期望租金"];
        [_areaDescLabel setText:@"期望面积"];

    }
    
    NSString *industry = [HPCommonData getIndustryNameById:model.industryId];
    NSString *subIndustry = [HPCommonData getIndustryNameById:model.subIndustryId];
    [_tradeLabel setText:[NSString stringWithFormat:@"%@·%@", industry, subIndustry]];
    
    if (model.shareTime && ![model.shareTime isEqualToString:@""]) {
        [_shareTimeLabel setText:model.shareTime];
    }
    else {
        [_shareTimeLabel setText:@"面议"];
    }
    
    if (model.area && ![model.area isEqualToString:@"0"]) {
        [_areaLabel setText:[NSString stringWithFormat:@"%@ ㎡", model.area]];
    }
    else
        [_areaLabel setText:@"面议"];
    
    if (model.rent && ![model.rent isEqualToString:@"0"]) {
        [_priceLabel setText:model.rent];
        [_priceUnitLabel setText:model.rentType == 1 ? @"元/小时":@"元/天"];
    }
    else {
        [_priceLabel setText:@"面议"];
        [_priceUnitLabel setHidden:YES];
    }
    
    if (!model.remark || [model.remark isEqualToString:@""]) {
        [_remarkLabel setText:@"用户很懒，什么也没有填写～"];
    }
    else {
        [_remarkLabel setText:model.remark];
    }
    
    if (model.avatarUrl) {
        [_portrait sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"shared_shop_details_head_portrait"]];
    }
    
    [_userNameLabel setText:model.contact];
    
    if (model.collected == 1) {
        [_keepBtn setSelected:YES];
    }
    else
        [_keepBtn setSelected:NO];
    
    if (model.shareDays) {
        NSArray *shareDays = [model.shareDays componentsSeparatedByString:@","];
        [_calendarView setSelectedDateStrs:shareDays];
    }
    
    NSArray *testArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1545372618&di=fbb49adbf37d75ac8c940efd63eaa08e&imgtype=jpg&er=1&src=http%3A%2F%2Fimg0.ph.126.net%2FgIQutohTMU2i3AkVS-6tOg%3D%3D%2F6630732414655186356.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544759503783&di=09a39857f77718ec68b74e9995c4ebfa&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fe%2Fe7%2Fe1f1827994.jpg%3Fdown",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544777936230&di=dc7dcbb7fc819adbc886667b4dbb0f1d&imgtype=0&src=http%3A%2F%2Fimg.79tao.com%2Fdata%2Fattachment%2Fforum%2F201804%2F14%2F001701vaash2sgdl8qchnh.jpg",
                           @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544778024308&di=400579aeb71c396c1b84f9eea507bdbd&imgtype=jpg&src=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D2527094628%2C3273654962%26fm%3D214%26gp%3D0.jpg"];
    
    if (model.pictures && model.pictures.count > 0) {
        if (model.pictures.count > 1) {
            [_pageControl setNumberOfPages:model.pictures.count];
            [_pageControl setCurrentPage:0];
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (HPPictureModel *picModel in model.pictures) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.url] placeholderImage:ImageNamed(@"shared_shop_details_background")];
            [array addObject:imageView];
        }
        
        [_bannerView setImageViews:array];
        if (model.pictures.count > 1) {
            [_bannerView startAutoScrollWithInterval:2.0];
        }
    }
}

@end
