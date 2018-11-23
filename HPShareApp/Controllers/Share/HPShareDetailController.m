//
//  HPShareDetailController.m
//  HPShareApp
//
//  Created by HP on 2018/11/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareDetailController.h"
#import "HPBanner.h"
#import "HPCalendarView.h"

@interface HPShareDetailController () <HPBannerDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *tagItems;

@property (nonatomic, weak) UILabel *releaseTimeLabel;

@property (nonatomic, weak) UILabel *addressLabel;

@property (nonatomic, weak) UILabel *tradeLabel;

@property (nonatomic, weak) UILabel *shareTimeLabel;

@property (nonatomic, weak) UILabel *areaLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UILabel *remarkLabel;

@property (nonatomic, weak) UIImageView *portrait;

@property (nonatomic, weak) UILabel *userNameLabel;

@property (nonatomic, weak) HPCalendarView *calendarView;

@end

@implementation HPShareDetailController

- (instancetype)init {
    self = [super init];
    if (self) {
        _tagItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [_titleLabel setText:@"金嘉味黄金铺位共享"];
    
    NSArray *tags = @[@"品牌连锁", @"百年老店", @"街角旺铺"];
    for (int i = 0; i < _tagItems.count; i++) {
        UIView *tagItem = _tagItems[i];
        if (i < tags.count) {
            UILabel *tagLabel = tagItem.subviews[0];
            [tagLabel setText:tags[i]];
        }
        else
            [tagItem setHidden:NO];
    }
    
    [_releaseTimeLabel setText:@"2018.11.20"];
    [_addressLabel setText:@"南山区科技园文化广场科兴路10号汇景豪苑群楼"];
    [_tradeLabel setText:@"餐饮·中餐厅"];
    [_shareTimeLabel setText:@"13:00-18:00"];
    [_areaLabel setText:@"不限"];
    [_priceLabel setText:@"650"];
    [_remarkLabel setText:@"入驻本店需要事先准备相关质检材料，入店时需要确认，三无产品请绕道。根据实际情况（包括但不只仅限于品牌需求、公司经营状况、服务水平等因素）决定是否可以入驻。提供的材料必须真实有效，如果产品出现质量问题，后果自负。"];
    [_portrait setImage:[UIImage imageNamed:@"shared_shop_details_head_portrait"]];
    [_userNameLabel setText:@"高小薇"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date_1 = [dateFormatter dateFromString:@"2018-8-10"];
    NSDate *date_2 = [dateFormatter dateFromString:@"2018-11-15"];
    NSDate *date_3 = [dateFormatter dateFromString:@"2018-11-23"];
    NSDate *date_4 = [dateFormatter dateFromString:@"2018-12-25"];
    NSDate *date_5 = [dateFormatter dateFromString:@"2019-02-02"];
    
    NSArray *selectedDates = @[date_1, date_2, date_3, date_4, date_5];
    [_calendarView setSelectedDates:selectedDates];
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
    [self.view setBackgroundColor:COLOR_WHITE_FAF9FE];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    HPBanner *banner = [[HPBanner alloc] init];
    [banner setDelegate:self];
    [banner setImageArray:@[[UIImage imageNamed:@"shared_shop_details_background"], [UIImage imageNamed:@"shared_shop_details_background"], [UIImage imageNamed:@"shared_shop_details_background"]]];
    [scrollView addSubview:banner];
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(-g_statusBarHeight);
        make.left.and.width.equalTo(scrollView);
        make.height.mas_equalTo(230.f * g_rateWidth);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] init];
    [backIcon setImage:[UIImage imageNamed:@"icon_back"]];
    [scrollView addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).with.offset(25.f * g_rateWidth);
        make.top.equalTo(scrollView).with.offset(13.f);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView);
        make.left.equalTo(scrollView);
        make.width.mas_equalTo(44.f);
        make.height.mas_equalTo(44.f);
    }];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setPageIndicatorTintColor:[UIColor.whiteColor colorWithAlphaComponent:0.5f]];
    [pageControl setCurrentPageIndicatorTintColor:UIColor.whiteColor];
    [pageControl setNumberOfPages:3];
    [pageControl setCurrentPage:0];
    [scrollView addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(scrollView).with.offset(172.f * g_rateWidth);
    }];
    
    UIView *titleRegion = [[UIView alloc] init];
    [titleRegion setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:titleRegion];
    [titleRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(scrollView);
        make.top.equalTo(banner.mas_bottom);
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
        make.height.mas_equalTo(180.f * g_rateWidth);
    }];
    [self setupRemarkRegion:remarkRegion];
    
    UIView *contactRegion = [[UIView alloc] init];
    [contactRegion setBackgroundColor:UIColor.whiteColor];
    [contactRegion.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [contactRegion.layer setShadowOffset:CGSizeMake(0.f, -2.f)];
    [contactRegion.layer setShadowOpacity:0.19f];
    [scrollView addSubview:contactRegion];
    [contactRegion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkRegion.mas_bottom).with.offset(60.f * g_rateWidth);
        make.left.and.width.equalTo(scrollView);
        make.height.mas_equalTo(60.f * g_rateWidth);
        make.bottom.equalTo(scrollView);
    }];
    [self setupContactRegion:contactRegion];
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
        UIView *tagItem = [[UIView alloc] init];
        [tagItem.layer setCornerRadius:4.f];
        [tagItem setBackgroundColor:COLOR_GREEN_EFF3F6];
        [view addSubview:tagItem];
        [tagItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(54.f, 17.f));
            
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
        
        UILabel *tagLabel = [[UILabel alloc] init];
        [tagLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
        [tagLabel setTextColor:COLOR_GREEN_7B929F];
        [tagItem addSubview:tagLabel];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(tagItem);
        }];
        
        [_tagItems addObject:tagItem];
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
    [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightDownView).with.offset(27.f * g_rateWidth);
        make.centerX.equalTo(rightDownView);
        make.height.mas_equalTo(priceDescLabel.font.pointSize);
    }];
    
    UILabel *priceUnitLabel = [[UILabel alloc] init];
    [priceUnitLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [priceUnitLabel setTextColor:COLOR_RED_FF3C5E];
    [priceUnitLabel setText:@"/天"];
    [rightDownView addSubview:priceUnitLabel];
    [priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceDescLabel).with.offset(3.f);
        make.top.equalTo(priceDescLabel.mas_bottom).with.offset(12.f);
        make.height.mas_equalTo(priceUnitLabel.font.pointSize);
        make.width.mas_equalTo(25.f * g_rateWidth);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:17.f]];
    [priceLabel setTextColor:COLOR_RED_FF3C5E];
    [rightDownView addSubview:priceLabel];
    _priceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceUnitLabel);
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
    }];
}

- (void)setupContactRegion:(UIView *)view {
    UIImageView *portrait = [[UIImageView alloc] init];
    [portrait.layer setMasksToBounds:YES];
    [portrait.layer setCornerRadius:20.f * g_rateWidth];
    [view addSubview:portrait];
    _portrait = portrait;
    [portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(25.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(40.f * g_rateWidth, 40.f * g_rateWidth));
    }];
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    [userNameLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [userNameLabel setTextColor:COLOR_BLACK_333333];
    [view addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portrait.mas_right).with.offset(14.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:18.f]];
    [phoneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"shared_shop_details_calendar_telephone"] forState:UIControlStateNormal];
    [phoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, -6.f)];
    [phoneBtn setBackgroundColor:COLOR_ORANGE_F59C40];
    [phoneBtn setTitle:@"电话" forState:UIControlStateNormal];
    [view addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.and.bottom.equalTo(view);
        make.width.mas_equalTo(110.f * g_rateWidth);
    }];
    
    UIButton *keepBtn = [[UIButton alloc] init];
    [keepBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:18.f]];
    [keepBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [keepBtn setImage:[UIImage imageNamed:@"shared_shop_details_calendar_collection"] forState:UIControlStateNormal];
    [keepBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 6.f, 0.f, -6.f)];
    [keepBtn setBackgroundColor:COLOR_RED_FE2A3B];
    [keepBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [view addSubview:keepBtn];
    [keepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(view);
        make.right.equalTo(phoneBtn.mas_left);
        make.width.mas_equalTo(110.f * g_rateWidth);
    }];
}

#pragma mark - HPBannerDelegate

- (void)banner:(HPBanner *)banner didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}

#pragma mark - onClickBackBtn

- (void)onClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
