//
//  HPMyController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMyController.h"

@interface HPMyController ()

@end

@implementation HPMyController

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
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"my_bg"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.width.equalTo(self.view);
    }];
    
    UIImageView *configIcon = [[UIImageView alloc] init];
    [configIcon setImage:[UIImage imageNamed:@"personal_center_set_up"]];
    [self.view addSubview:configIcon];
    [configIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 15.f * g_rateWidth);
        make.right.equalTo(self.view).with.offset(-20.f * g_rateWidth);
    }];
    
    UIButton *configBtn = [[UIButton alloc] init];
    [configBtn addTarget:self action:@selector(onClickConfigBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:configBtn];
    [configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50.f * g_rateWidth, 50.f * g_rateWidth));
    }];
    
    UIButton *portraitBtn = [[UIButton alloc] init];
    [portraitBtn.layer setCornerRadius:36.f * g_rateWidth];
    [portraitBtn setImage:[UIImage imageNamed:@"personal_center_not_login_head"] forState:UIControlStateNormal];
    [self.view addSubview:portraitBtn];
    [portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 48.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(72.f * g_rateWidth, 72.f * g_rateWidth));
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portraitBtn.mas_bottom).with.offset(15.f);
        make.centerX.equalTo(portraitBtn);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [descLabel setTextColor:COLOR_PINK_FFC5C4];
    [descLabel setText:@"登录即可免费发布共享信息"];
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(11.f * g_rateWidth);
        make.centerX.equalTo(loginBtn);
    }];
}

#pragma mark - OnClick

- (void)onClickConfigBtn:(UIButton *)btn {
    
}

@end
