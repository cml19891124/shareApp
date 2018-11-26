//
//  HPHowToPlayShareSpaceController.m
//  HPShareApp
//
//  Created by HP on 2018/11/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHowToPlayShareSpaceController.h"
#import "HPIdeaExampleItem.h"
#import "HPHowToPlayDetailController.h"

@interface HPHowToPlayShareSpaceController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation HPHowToPlayShareSpaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    NSArray *exampleData = @[@{@"title":@"健身房与轻食店", @"type":@"铺位共享", @"desc":@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。", @"photos":@[[UIImage imageNamed:@"anli_photo1"], [UIImage imageNamed:@"anli_photo2"], [UIImage imageNamed:@"anli_photo3"]]},
                             @{@"title":@"健身房与轻食店", @"type":@"铺位共享", @"desc":@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。", @"photos":@[[UIImage imageNamed:@"anli_photo1"], [UIImage imageNamed:@"anli_photo2"], [UIImage imageNamed:@"anli_photo3"]]},
                             @{@"title":@"健身房与轻食店", @"type":@"铺位共享", @"desc":@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。", @"photos":@[[UIImage imageNamed:@"anli_photo1"], [UIImage imageNamed:@"anli_photo2"], [UIImage imageNamed:@"anli_photo3"]]}];
    
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setClipsToBounds:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exampleTitleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(296.f * g_rateWidth);
        make.right.equalTo(self.view);
    }];
    
    UIImageView *footerView = [[UIImageView alloc] init];
    [footerView setImage:[UIImage imageNamed:@"shenmeshi_hepai"]];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom).with.offset(25.f * g_rateWidth);
        make.centerX.equalTo(scrollView);
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
    for (int i = 0; i < data.count; i ++) {
        NSDictionary *dict = data[i];
        NSString *title = dict[@"title"];
        NSString *type = dict[@"type"];
        NSString *desc = dict[@"desc"];
        NSArray *photos = dict[@"photos"];
        
        HPIdeaExampleItem *item = [[HPIdeaExampleItem alloc] init];
        [item setTitle:title];
        [item setType:type];
        [item setDesc:desc];
        [item loadPhotoWithImages:photos];
        [item.detailBtn addTarget:self action:@selector(onClickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.scrollView).with.offset(20.f * g_rateWidth);
            }
            else {
                UIView *lastItem = self.scrollView.subviews[i - 1];
                make.left.equalTo(lastItem.mas_right).with.offset(15.f * g_rateWidth);
            }
            
            make.top.equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(297.f * g_rateWidth, 296.f * g_rateWidth));
            
            if (i == data.count - 1) {
                make.right.equalTo(self.scrollView).with.offset(-20.f * g_rateWidth);
            }
        }];
    }
}

#pragma mark - onClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDetailBtn:(UIButton *)btn {
    HPHowToPlayDetailController *vc = [[HPHowToPlayDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
