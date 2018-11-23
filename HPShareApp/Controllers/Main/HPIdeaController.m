//
//  HPIdeaController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdeaController.h"
#import "HPHowToPlayController.h"

@interface HPIdeaController ()

@end

@implementation HPIdeaController

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
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"idea_bg"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(self.view);
        make.height.mas_equalTo(290.f * g_rateWidth);
    }];
    
    UIView *searchView = [[UIView alloc] init];
    [searchView.layer setCornerRadius:5.f];
    [searchView setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.35f]];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 8.f * g_rateHeight);
        make.size.mas_equalTo(CGSizeMake(345.f, 39.f));
    }];
    [self setupSearchView:searchView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:27.f]];;
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"享法"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 84.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *sloganLabel = [[UILabel alloc] init];
    [sloganLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [sloganLabel setTextColor:UIColor.whiteColor];
    [sloganLabel setText:@"“享”你所想，“享”未来！"];
    [self.view addSubview:sloganLabel];
    [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(13.f * g_rateWidth);
        make.centerX.equalTo(titleLabel);
    }];
    
    UIControl *whatIsShareSpace = [[UIControl alloc] init];
    [whatIsShareSpace.layer setCornerRadius:7.f];
    [whatIsShareSpace.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [whatIsShareSpace.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [whatIsShareSpace.layer setShadowRadius:15.f];
    [whatIsShareSpace.layer setShadowOpacity:0.3f];
    [whatIsShareSpace setBackgroundColor:UIColor.whiteColor];
    [whatIsShareSpace setTag:0];
    [whatIsShareSpace addTarget:self action:@selector(onClickShareSpaceCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whatIsShareSpace];
    [whatIsShareSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).with.offset(-21.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 150.f * g_rateWidth));
    }];
    [self setupWhatIsShareSpace:whatIsShareSpace];
    
    UIControl *howToPlayShareSpace = [[UIControl alloc] init];
    [howToPlayShareSpace.layer setCornerRadius:7.f];
    [howToPlayShareSpace.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [howToPlayShareSpace.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [howToPlayShareSpace.layer setShadowRadius:15.f];
    [howToPlayShareSpace.layer setShadowOpacity:0.3f];
    [howToPlayShareSpace setBackgroundColor:UIColor.whiteColor];
    [howToPlayShareSpace setTag:1];
    [howToPlayShareSpace addTarget:self action:@selector(onClickShareSpaceCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:howToPlayShareSpace];
    [howToPlayShareSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whatIsShareSpace.mas_bottom).with.offset(15.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 150.f * g_rateWidth));
    }];
    [self setupHowToPlayShareSpace:howToPlayShareSpace];
}

- (void)setupSearchView:(UIView *)view {
    UIImageView *searchIcon = [[UIImageView alloc] init];
    [searchIcon setImage:[UIImage imageNamed:@"shouye_sousuo"]];
    [view addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(13.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [searchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [searchBtn setTitle:@"输入关键字获取共享空间的更多玩法" forState:UIControlStateNormal];
    [view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).with.offset(27.f * g_rateWidth);
        make.top.and.bottom.equalTo(view);
        make.right.equalTo(view);
    }];
}

- (void)setupWhatIsShareSpace:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"什么是共享空间?" ofView:view];
    UIImageView *iconView = [self setupIcon:[UIImage imageNamed:@"idea_what_is_share_space"] ofView:view];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    [questionLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [questionLabel setTextColor:COLOR_BLACK_4A4A4B];
    [questionLabel setText:@"共享经济已死？"];
    [view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(questionLabel.font.pointSize);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [answerLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [answerLabel setTextColor:COLOR_RED_FF4562];
    [answerLabel setText:@"NO !!!"];
    [view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(questionLabel.mas_right).with.offset(5.f * g_rateWidth);
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
        make.left.equalTo(titleLabel);
        make.right.equalTo(iconView.mas_left).with.offset(11.f * g_rateWidth);
        make.top.equalTo(questionLabel.mas_bottom).with.offset(15.f * g_rateWidth);
    }];
}

- (void)setupHowToPlayShareSpace:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"共享空间怎么玩?" ofView:view];
    UIImageView *iconView = [self setupIcon:[UIImage imageNamed:@"idea_how_to_play_share_space"] ofView:view];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    [questionLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [questionLabel setTextColor:COLOR_BLACK_4A4A4B];
    [questionLabel setText:@"概念太抽象？"];
    [view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(questionLabel.font.pointSize);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [answerLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [answerLabel setTextColor:COLOR_RED_FF4562];
    [answerLabel setText:@"莫慌 !!!"];
    [view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(questionLabel.mas_right).with.offset(5.f * g_rateWidth);
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
        make.left.equalTo(titleLabel);
        make.right.equalTo(iconView.mas_left).with.offset(11.f * g_rateWidth);
        make.top.equalTo(questionLabel.mas_bottom).with.offset(15.f * g_rateWidth);
    }];
}

#pragma mark - setupCommonUI

- (UILabel *)setupTitle:(NSString *)title ofView:(UIView *)view {
    UIView *line = [[UIView alloc] init];
    [line.layer setCornerRadius:1.f];
    [line setBackgroundColor:COLOR_RED_FF4562];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(18.f * g_rateWidth);
        make.top.equalTo(view).with.offset(21.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(3.f, 16.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).with.offset(9.f);
        make.centerY.equalTo(line);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    return titleLabel;
}

- (UIImageView *)setupIcon:(UIImage *)icon ofView:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:icon];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-15.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(110.f * g_rateWidth, 110.f * g_rateWidth));
    }];
    
    return iconView;
}

#pragma mark - OnClick

- (void)onClickShareSpaceCtrl:(UIControl *)ctrl {
    UIViewController *vc;
    
    if (ctrl.tag == 0) {
        vc = [[HPHowToPlayController alloc] init];
    }
    else if (ctrl.tag == 1) {
        
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
