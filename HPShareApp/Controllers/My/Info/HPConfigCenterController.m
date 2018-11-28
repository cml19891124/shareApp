//
//  HPConfigCenterController.m
//  HPShareApp
//
//  Created by HP on 2018/11/28.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPConfigCenterController.h"

@interface HPConfigCenterController ()

@end

@implementation HPConfigCenterController

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
    [self.view setBackgroundColor:COLOR_GRAY_F7F7F7];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"设置中心"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
    }];
    
    UILabel *personInfoLabel = [[UILabel alloc] init];
    [personInfoLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [personInfoLabel setTextColor:COLOR_BLACK_333333];
    [personInfoLabel setText:@"个人信息"];
    [scrollView addSubview:personInfoLabel];
    [personInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).with.offset(19.f * g_rateWidth);
        make.left.equalTo(scrollView).with.offset(15.f * g_rateWidth);
        make.height.mas_equalTo(personInfoLabel.font.pointSize);
    }];
    
    UIView *personInfoPanel = [[UIView alloc] init];
    [personInfoPanel.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [personInfoPanel.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [personInfoPanel.layer setShadowRadius:15.f];
    [personInfoPanel.layer setShadowOpacity:0.19f];
    [personInfoPanel.layer setCornerRadius:15.f];
    [personInfoPanel setBackgroundColor:UIColor.whiteColor];
    [scrollView addSubview:personInfoPanel];
    [personInfoPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(personInfoLabel.mas_bottom).with.offset(15.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 200.f * g_rateWidth));
    }];
}

@end
