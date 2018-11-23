//
//  HPInteractiveController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPInteractiveController.h"
#import "HPStartUpCardDefineController.h"
#import "HPOwnerCardDefineController.h"
#import "HPMyCardController.h"

@interface HPInteractiveController ()

@end

@implementation HPInteractiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn_0 = [[UIButton alloc] init];
    [btn_0 setTag:0];
    [btn_0 setTitle:@"创客定制名片" forState:UIControlStateNormal];
    [btn_0 setTitleColor:COLOR_BLACK_444444 forState:UIControlStateNormal];
    [btn_0 addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_0];
    [btn_0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(200.f * g_rateWidth);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *btn_1 = [[UIButton alloc] init];
    [btn_1 setTag:1];
    [btn_1 setTitle:@"业主定制名片" forState:UIControlStateNormal];
    [btn_1 setTitleColor:COLOR_BLACK_444444 forState:UIControlStateNormal];
    [btn_1 addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_1];
    [btn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn_0.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton *btn_2 = [[UIButton alloc] init];
    [btn_2 setTag:2];
    [btn_2 setTitle:@"我的名片" forState:UIControlStateNormal];
    [btn_2 setTitleColor:COLOR_BLACK_444444 forState:UIControlStateNormal];
    [btn_2 addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_2];
    [btn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn_1.mas_bottom).with.offset(20.f * g_rateWidth);
        make.centerX.equalTo(self.view);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onClickBtn:(UIButton *)btn {
    UIViewController *vc;
    
    if (btn.tag == 0) {
        vc = [[HPStartUpCardDefineController alloc] init];
    }
    else if (btn.tag == 1) {
        vc = [[HPOwnerCardDefineController alloc] init];
    }
    else if (btn.tag == 2) {
        vc = [[HPMyCardController alloc] init];
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
