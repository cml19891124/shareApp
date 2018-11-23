//
//  HPHowToPlayController.m
//  HPShareApp
//
//  Created by HP on 2018/11/23.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHowToPlayController.h"

@interface HPHowToPlayController ()

@end

@implementation HPHowToPlayController

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
        make.height.mas_equalTo(173.f * g_rateWidth);
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

#pragma mark - onClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
