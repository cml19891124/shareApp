//
//  HPHowToPlayController.m
//  HPShareApp
//
//  Created by HP on 2018/11/23.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPWhatIsShareSpaceController.h"

@interface HPWhatIsShareSpaceController () <UIScrollViewDelegate>

@end

@implementation HPWhatIsShareSpaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
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
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"idea_detail_bg"]];
    [scrollView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(-g_statusBarHeight);
        make.left.and.and.width.equalTo(scrollView);
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
    [titleLabel setText:@"什么是共享空间?"];
    [scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.centerY.equalTo(backBtn);
    }];
    
    UIView *topicPanel = [[UIView alloc] init];
    [topicPanel.layer setCornerRadius:5.f];
    [topicPanel.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [topicPanel.layer setShadowOffset:CGSizeMake(0.f, 7.f)];
    [topicPanel.layer setShadowRadius:14.f];
    [topicPanel.layer setShadowOpacity:0.1f];
    [topicPanel setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:topicPanel];
    [topicPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).with.offset(-31.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(336.f * g_rateWidth, 84.f * g_rateWidth));
    }];
    [self setupTopicPanel:topicPanel];
    
    UIImageView *typeCategoryView = [self setupCategoryViewWithTitle:@"共享类型"];
    [scrollView addSubview:typeCategoryView];
    [typeCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicPanel.mas_bottom).with.offset(19.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(141.f, 41.f));
    }];
    
    UIView *typeView = [[UIView alloc] init];
    [typeView.layer setCornerRadius:5.f];
    [typeView.layer setShadowColor:COLOR_GRAY_C4C4C4.CGColor];
    [typeView.layer setShadowOffset:CGSizeMake(0.f, 5.f)];
    [typeView.layer setShadowRadius:8.f];
    [typeView.layer setShadowOpacity:0.38f];
    [typeView setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(typeCategoryView.mas_bottom).with.offset(7.f * g_rateWidth);
        make.width.mas_equalTo(345.f * g_rateWidth);
    }];
    [self setupTypeView:typeView];
    
    UIView *ruleCategoryView = [self setupCategoryViewWithTitle:@"共享匹配规则"];
    [scrollView addSubview:ruleCategoryView];
    [ruleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeView.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(141.f, 41.f));
    }];
    
    UIView *ruleView = [[UIView alloc] init];
    [ruleView.layer setCornerRadius:5.f];
    [ruleView.layer setShadowColor:COLOR_GRAY_C4C4C4.CGColor];
    [ruleView.layer setShadowOffset:CGSizeMake(0.f, 5.f)];
    [ruleView.layer setShadowRadius:8.f];
    [ruleView.layer setShadowOpacity:0.38f];
    [ruleView setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:ruleView];
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(ruleCategoryView.mas_bottom).with.offset(7.f * g_rateWidth);
        make.width.mas_equalTo(345.f * g_rateWidth);
    }];
    [self setupRuleView:ruleView];
    
    UIView *sortCategoryView = [self setupCategoryViewWithTitle:@"共享匹配规则"];
    [scrollView addSubview:sortCategoryView];
    [sortCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ruleView.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(141.f, 41.f));
    }];
    
    UIView *sortView = [[UIView alloc] init];
    [sortView.layer setCornerRadius:5.f];
    [sortView.layer setShadowColor:COLOR_GRAY_C4C4C4.CGColor];
    [sortView.layer setShadowOffset:CGSizeMake(0.f, 5.f)];
    [sortView.layer setShadowRadius:8.f];
    [sortView.layer setShadowOpacity:0.38f];
    [sortView setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:sortView];
    [sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(sortCategoryView.mas_bottom).with.offset(7.f * g_rateWidth);
        make.width.mas_equalTo(345.f * g_rateWidth);
    }];
    [self setupSortView:sortView];
    
    UIImageView *footerView = [[UIImageView alloc] init];
    [footerView setImage:[UIImage imageNamed:@"shenmeshi_hepai"]];
    [scrollView addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sortView.mas_bottom).with.offset(22.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
        make.bottom.equalTo(scrollView).with.offset(-16.f * g_rateWidth);
    }];
}

- (void)setupTopicPanel:(UIView *)view {
    UILabel *questionLabel = [[UILabel alloc] init];
    [questionLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [questionLabel setTextColor:COLOR_BLACK_4A4A4B];
    [questionLabel setText:@"共享经济已死？"];
    [view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(18.f * g_rateWidth);
        make.top.equalTo(view).with.offset(13.f);
        make.height.mas_equalTo(questionLabel.font.pointSize);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [answerLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [answerLabel setTextColor:COLOR_RED_FF4562];
    [answerLabel setText:@"NO !!!"];
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
    [descLabel setText:@"共享空间告诉你什么才是共享的正确打开方式！"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionLabel.mas_bottom).with.offset(11.f * g_rateWidth);
        make.left.equalTo(questionLabel);
        make.width.mas_equalTo(181.f);
    }];
}

- (void)setupTypeView:(UIView *)view {
    UIView *timeShareTitleView = [self setupQuestionTitleViewWithIndex:@"01" title:@"时间型共享"];
    [view addSubview:timeShareTitleView];
    [timeShareTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(27.f * g_rateWidth);
        make.top.equalTo(view).with.offset(18.f * g_rateWidth);
    }];
    
    UILabel *timeShareDescLabel = [[UILabel alloc] init];
    [timeShareDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [timeShareDescLabel setTextColor:COLOR_BLACK_666666];
    [timeShareDescLabel setNumberOfLines:0];
    [timeShareDescLabel setText:@"同一空间（店铺），因使用时段不同，而产的空置时间。将店铺空置时间进行出租，获取收益。将利益最大化"];
    [view addSubview:timeShareDescLabel];
    [timeShareDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeShareTitleView);
        make.top.equalTo(timeShareTitleView.mas_bottom).with.offset(12.f * g_rateWidth);
        make.width.mas_equalTo(293.f * g_rateWidth);
    }];
    
    UIView *timeShareExampleView = [self setupExampleViewWithText:@"例：酒吧、早餐店等经营时段固定的场所"];
    [view addSubview:timeShareExampleView];
    [timeShareExampleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeShareDescLabel.mas_bottom).with.offset(12.f * g_rateWidth);
        make.left.and.width.equalTo(view);
    }];
    
    UIView *spaceShareTitleView = [self setupQuestionTitleViewWithIndex:@"02" title:@"空间型共享"];
    [view addSubview:spaceShareTitleView];
    [spaceShareTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeShareTitleView);
        make.top.equalTo(timeShareExampleView.mas_bottom).with.offset(18.f * g_rateWidth);
    }];
    
    UILabel *spaceShareDescLabel = [[UILabel alloc] init];
    [spaceShareDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [spaceShareDescLabel setTextColor:COLOR_BLACK_666666];
    [spaceShareDescLabel setNumberOfLines:0];
    [spaceShareDescLabel setText:@"将同一空间内，空余闲置的空间进行出租，获取收益。"];
    [view addSubview:spaceShareDescLabel];
    [spaceShareDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(spaceShareTitleView);
        make.top.equalTo(spaceShareTitleView.mas_bottom).with.offset(12.f * g_rateWidth);
        make.width.mas_equalTo(293.f * g_rateWidth);
    }];
    
    UIView *spaceShareExampleView = [self setupExampleViewWithText:@"例：健身房、洗车店等店铺经营面积较大，闲置空间较多的场所"];
    [view addSubview:spaceShareExampleView];
    [spaceShareExampleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spaceShareDescLabel.mas_bottom).with.offset(12.f);
        make.left.and.width.equalTo(view);
        make.bottom.equalTo(view).with.offset(-19.f * g_rateWidth);
    }];
}

- (void)setupRuleView:(UIView *)view {
    UIView *productFitTitleView = [self setupQuestionTitleViewWithIndex:@"01" title:@"产品、服务匹配"];
    [view addSubview:productFitTitleView];
    [productFitTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(27.f * g_rateWidth);
        make.top.equalTo(view).with.offset(18.f * g_rateWidth);
    }];
    
    UILabel *productFitDescLabel = [[UILabel alloc] init];
    [productFitDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [productFitDescLabel setTextColor:COLOR_BLACK_666666];
    [productFitDescLabel setNumberOfLines:0];
    [productFitDescLabel setText:@"租赁双方的产品或服务具有关联性，可以促进产品销售或服务升级"];
    [view addSubview:productFitDescLabel];
    [productFitDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(productFitTitleView);
        make.top.equalTo(productFitTitleView.mas_bottom).with.offset(12.f * g_rateWidth);
        make.width.mas_equalTo(293.f * g_rateWidth);
    }];
    
    UIView *productFitExampleView = [self setupExampleViewWithText:@"例：健身房与素食馆、轻食餐厅；咖啡馆、奶茶店与书店等"];
    [view addSubview:productFitExampleView];
    [productFitExampleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productFitDescLabel.mas_bottom).with.offset(12.f * g_rateWidth);
        make.left.and.width.equalTo(view);
    }];
    
    UIView *customerFitTitleView = [self setupQuestionTitleViewWithIndex:@"02" title:@"人群、客流匹配"];
    [view addSubview:customerFitTitleView];
    [customerFitTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(productFitTitleView);
        make.top.equalTo(productFitExampleView.mas_bottom).with.offset(18.f * g_rateWidth);
    }];
    
    UILabel *customerFitDescLabel = [[UILabel alloc] init];
    [customerFitDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [customerFitDescLabel setTextColor:COLOR_BLACK_666666];
    [customerFitDescLabel setNumberOfLines:0];
    [customerFitDescLabel setText:@"租赁方与承租方拥有相似的客群画像，可以共享客群流量"];
    [view addSubview:customerFitDescLabel];
    [customerFitDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customerFitTitleView);
        make.top.equalTo(customerFitTitleView.mas_bottom).with.offset(12.f * g_rateWidth);
        make.width.mas_equalTo(293.f * g_rateWidth);
    }];
    
    UIView *customerFitExampleView = [self setupExampleViewWithText:@"例：客流较大区域，地铁口附近，CBD附近等"];
    [view addSubview:customerFitExampleView];
    [customerFitExampleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customerFitDescLabel.mas_bottom).with.offset(12.f);
        make.left.and.width.equalTo(view);
        make.bottom.equalTo(view).with.offset(-19.f * g_rateWidth);
    }];
}

- (void)setupSortView:(UIView *)view {
    UIView *row_0 = [[UIView alloc] init];
    [view addSubview:row_0];
    [row_0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.width.equalTo(view);
        make.height.mas_equalTo(50.f * g_rateWidth);
    }];
    
    UIView *rowFirstTitleView = [self setupQuestionTitleViewWithIndex:@"01" title:@"有场地，找货源，找人"];
    [row_0 addSubview:rowFirstTitleView];
    [rowFirstTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row_0);
        make.left.equalTo(row_0).with.offset(27.f * g_rateWidth);
    }];
    
    UIView *row_1 = [[UIView alloc] init];
    [row_1 setBackgroundColor:COLOR_GRAY_F8FAFC];
    [view addSubview:row_1];
    [row_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row_0.mas_bottom);
        make.left.and.width.equalTo(view);
        make.height.mas_equalTo(50.f * g_rateWidth);
    }];
    
    UIView *rowSecondTitleView = [self setupQuestionTitleViewWithIndex:@"02" title:@"有货源，找场地，找人"];
    [row_1 addSubview:rowSecondTitleView];
    [rowSecondTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row_1);
        make.left.equalTo(row_1).with.offset(27.f * g_rateWidth);
    }];
    
    UIView *row_2 = [[UIView alloc] init];
    [view addSubview:row_2];
    [row_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row_1.mas_bottom);
        make.left.and.width.equalTo(view);
        make.height.mas_equalTo(50.f * g_rateWidth);
        make.bottom.equalTo(view);
    }];
    
    UIView *rowThirdTitleView = [self setupQuestionTitleViewWithIndex:@"03" title:@"找货源，找场地"];
    [row_2 addSubview:rowThirdTitleView];
    [rowThirdTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row_2);
        make.left.equalTo(row_2).with.offset(27.f * g_rateWidth);
    }];
}



#pragma mark - setupCommonUI

- (UIImageView *)setupCategoryViewWithTitle:(NSString *)title {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"shenmeshi_dikaung"]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:title];
    [imageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView).with.offset(8.f);
        make.centerX.equalTo(imageView);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    return imageView;
}

- (UIView *)setupQuestionTitleViewWithIndex:(NSString *)index title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"shenmeshi_shuzi"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.bottom.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(23.f, 22.f));
    }];
    
    UILabel *indexLabel = [[UILabel alloc] init];
    [indexLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [indexLabel setTextColor:UIColor.whiteColor];
    [indexLabel setText:index];
    [imageView addSubview:indexLabel];
    [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView).with.offset(5.f);
        make.centerX.equalTo(imageView).with.offset(-1.f);
        make.height.mas_equalTo(indexLabel.font.pointSize);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setNumberOfLines:0];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(10.f);
        make.centerY.equalTo(imageView);
        make.right.equalTo(view);
    }];
    
    return view;
}

- (UIView *)setupExampleViewWithText:(NSString *)text {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:COLOR_GRAY_F8FAFC];
    
    UILabel *textLabel = [[UILabel alloc] init];
    [textLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [textLabel setTextColor:COLOR_BLUE_74A1BA];
    [textLabel setNumberOfLines:0];
    [textLabel setText:text];
    [view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(28.f * g_rateWidth);
        make.right.equalTo(view).with.offset(-24.f * g_rateWidth);
        make.top.equalTo(view).with.offset(7.f);
        make.bottom.equalTo(view).with.offset(-7.f);
    }];
    
    return view;
}

#pragma mark - onClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
