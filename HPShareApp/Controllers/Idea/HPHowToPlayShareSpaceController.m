//
//  HPHowToPlayShareSpaceController.m
//  HPShareApp
//
//  Created by HP on 2018/11/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHowToPlayShareSpaceController.h"
#import "HPIdeaExampleItem.h"
#import "HPPageView.h"
#import "iCarousel.h"
#import "HPShareIdeaModel.h"

@interface HPHowToPlayShareSpaceController () <HPPageViewDelegate,iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong) NSMutableArray *exampleData;

//@property(nonatomic,strong) iCarousel *carousel;

@property (nonatomic, weak) HPPageView *pageView;

@end

@implementation HPHowToPlayShareSpaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    NSArray *exampleData = @[@{@"title":@"健身房与轻食店", @"type":@"铺位共享", @"desc":@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。", @"photos":@[[UIImage imageNamed:@"anli_photo1"], [UIImage imageNamed:@"anli_photo2"], [UIImage imageNamed:@"anli_photo3"]]},
                             @{@"title":@"健身房与轻食店", @"type":@"铺位共享", @"desc":@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。", @"photos":@[[UIImage imageNamed:@"anli_photo1"], [UIImage imageNamed:@"anli_photo2"], [UIImage imageNamed:@"anli_photo3"]]},
                             @{@"title":@"健身房与轻食店", @"type":@"铺位共享", @"desc":@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。", @"photos":@[[UIImage imageNamed:@"anli_photo1"], [UIImage imageNamed:@"anli_photo2"], [UIImage imageNamed:@"anli_photo3"]]}];
    
    HPShareIdeaModel *model_1 = [HPShareIdeaModel new];
    [model_1 setTitle:@"健身房与轻食店"];
    [model_1 setType:@"铺位共享"];
    [model_1 setDesc:@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。"];
    [model_1 setPhotos:@[[UIImage imageNamed:@"anli_photo1"], [UIImage imageNamed:@"anli_photo2"], [UIImage imageNamed:@"anli_photo3"]]];
    [model_1 setFirstPlace:@"健身房"];
    [model_1 setSecondPlace:@"轻食店"];
    [model_1 setBeforeFirstDesc:@""];
    
    [self loadExampleItemWithData:exampleData];
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
    [self.view setBackgroundColor:UIColor.whiteColor];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"idea_detail_bg"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.and.width.equalTo(self.view);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] init];
    [backIcon setImage:[UIImage imageNamed:@"icon_back"]];
    [self.view addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16.f * g_rateWidth);
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 9.f * g_rateWidth);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(g_statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"共享空间怎么玩?"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(backBtn);
    }];
    
    UIView *topicPanel = [[UIView alloc] init];
    [topicPanel.layer setCornerRadius:5.f];
    [topicPanel.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [topicPanel.layer setShadowOffset:CGSizeMake(0.f, 7.f)];
    [topicPanel.layer setShadowRadius:14.f];
    [topicPanel.layer setShadowOpacity:0.1f];
    [topicPanel setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:topicPanel];
    [topicPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).with.offset(-31.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(336.f * g_rateWidth, 84.f * g_rateWidth));
    }];
    [self setupTopicPanel:topicPanel];
    
    UILabel *exampleTitleLabel = [[UILabel alloc] init];
    [exampleTitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [exampleTitleLabel setTextColor:COLOR_BLACK_333333];
    [exampleTitleLabel setText:@"精选玩法"];
    [self.view addSubview:exampleTitleLabel];
    [exampleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicPanel.mas_bottom).with.offset(45.f * g_rateWidth);
        make.left.equalTo(topicPanel);
        make.height.mas_equalTo(exampleTitleLabel.font.pointSize);
    }];
    
//    iCarousel * carousel = [[iCarousel alloc] init];
//    carousel.dataSource = self;
//    carousel.bounces = NO;
//    carousel.pagingEnabled = YES;
//    carousel.delegate = self;
//    carousel.type  = iCarouselTypeLinear;
//    [self.view addSubview:carousel];
//    self.carousel = carousel;
//    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(exampleTitleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
//        make.left.equalTo(self.view).with.offset(20.f * g_rateWidth);
//        make.width.mas_equalTo(297.f * g_rateWidth);
//        make.height.mas_equalTo(296.f * g_rateWidth);
//    }];
    
    HPPageView *pageView = [[HPPageView alloc] init];
    [pageView setDelegate:self];
    [pageView setPageMarginLeft:getWidth(20.f)];
    [pageView setPageSpace:getWidth(20.f)];
    [pageView setPageWidth:getWidth(297.f)];
    [pageView setPageItemSize:CGSizeMake(getWidth(297.f), getWidth(296.f))];
    [self.view addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exampleTitleLabel.mas_bottom);
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(336.f * g_rateWidth);
    }];
    
    UIImageView *footerView = [[UIImageView alloc] init];
    [footerView setImage:[UIImage imageNamed:@"shenmeshi_hepai"]];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pageView.mas_bottom).with.offset(4.f * g_rateWidth);
        make.centerX.equalTo(self.view);
    }];
}

- (void)setupTopicPanel:(UIView *)view {
    UILabel *questionLabel = [[UILabel alloc] init];
    [questionLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [questionLabel setTextColor:COLOR_BLACK_4A4A4B];
    [questionLabel setText:@"概念太抽象？"];
    [view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(18.f * g_rateWidth);
        make.top.equalTo(view).with.offset(13.f);
        make.height.mas_equalTo(questionLabel.font.pointSize);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [answerLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [answerLabel setTextColor:COLOR_RED_FF4562];
    [answerLabel setText:@"莫慌 !!!"];
    [view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(questionLabel.mas_right).with.offset(5.f);
        make.centerY.equalTo(questionLabel);
        make.height.mas_equalTo(answerLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setNumberOfLines:0];
    [descLabel setText:@"不怕你不会玩，就怕你玩不过来！我们一起“享”未来！"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionLabel.mas_bottom).with.offset(11.f * g_rateWidth);
        make.left.equalTo(questionLabel);
        make.width.mas_equalTo(181.f);
    }];
}

- (void)loadExampleItemWithData:(NSArray *)data {
    _exampleData = [[NSMutableArray alloc] initWithArray:data];
//    [_carousel reloadData];
}

#pragma mark - HPPageViewDelegate

- (UIView *)pageView:(HPPageView *)pageView viewAtPageIndex:(NSInteger)index {
    NSDictionary *dict = _exampleData[index];
    NSString *title = dict[@"title"];
    NSString *type = dict[@"type"];
    NSString *desc = dict[@"desc"];
    NSArray *photos = dict[@"photos"];
    
    HPIdeaExampleItem *item = [[HPIdeaExampleItem alloc] init];
    [item setTitle:title];
    [item setType:type];
    [item setDesc:desc];
    [item loadPhotoWithImages:photos];
//    [item.detailBtn addTarget:self action:@selector(onClickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (NSInteger)pageNumberOfPageView:(HPPageView *)pageView {
    return _exampleData.count;
}

- (void)pageView:(HPPageView *)pageView didClickPageItem:(UIView *)item atIndex:(NSInteger)index {
    [self pushVCByClassName:@"HPHowToPlayDetailController"];
}

#pragma mark - onClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDetailBtn:(UIButton *)btn {
    [self pushVCByClassName:@"HPHowToPlayDetailController"];
}

//#pragma mark - iCarouselDataSource
//- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
//{
//    return _exampleData.count;
//}

//- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
//{
//    if (view == nil)
//    {
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,297.f * g_rateWidth, 296.f * g_rateWidth)];
//        NSDictionary *dict = _exampleData[index];
//        NSString *title = dict[@"title"];
//        NSString *type = dict[@"type"];
//        NSString *desc = dict[@"desc"];
//        NSArray *photos = dict[@"photos"];
//
//        HPIdeaExampleItem *item = [[HPIdeaExampleItem alloc] init];
//        [item setTitle:title];
//        [item setType:type];
//        [item setDesc:desc];
//        [item loadPhotoWithImages:photos];
//        [item.detailBtn addTarget:self action:@selector(onClickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:item];
//        [item mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.mas_equalTo(view);
//            make.width.mas_equalTo(297.f * g_rateWidth);
//            make.height.mas_equalTo(296.f * g_rateWidth);
//        }];
//    }
//    return view;
//
//}
//
//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
//{
//    if (option == iCarouselOptionSpacing)
//    {
//        return value * 1.03;
//    }
//    return value;
//}
//
//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
//{
//    [self pushVCByClassName:@"HPMyCardController"];
//}
@end
