//
//  HPBaseViewController.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"

@interface HPBaseViewController ()

@end

@implementation HPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isPopGestureRecognize = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)setupStatusbar {
    UIView *statusBar = [[UIView alloc] init];
    [statusBar setBackgroundColor:COLOR_RED_FF3C5E];
    [self.view addSubview:statusBar];
    [statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(g_statusBarHeight);
    }];
    
    return statusBar;
}

- (UIView *)setupNavigationBarWithTitle:(NSString *)title {
    UIView *statusBar = [self setupStatusbar];
    
    UIView *navigationBar = [[UIView alloc] init];
    [navigationBar setBackgroundColor:COLOR_RED_FF3C5E];
    [self.view addSubview:navigationBar];
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(statusBar.mas_bottom);
        make.height.mas_equalTo(44.f);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back"]];
    [navigationBar addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationBar).with.offset(25.f * g_rateWidth);
        make.centerY.equalTo(navigationBar);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:title];
    [navigationBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(navigationBar);
    }];
    
    [self setupBackBtn];
    
    return navigationBar;
}

- (void)setupBackBtn {
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(44.f);
        make.height.mas_equalTo(44.f);
    }];
}

- (void)onClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushVCByClassName:(NSString *)name {
    [self pushVCByClassName:name withParam:nil];
}

- (void)pushVCByClassName:(NSString *)name withParam:(NSDictionary *)param {
    Class class = NSClassFromString(name);
    
    if (class) {
        NSObject *object = [class alloc];
        
        if ([object isKindOfClass:HPBaseViewController.class]) {
            HPBaseViewController *baseVC = (HPBaseViewController *)object;
            baseVC = [baseVC init];
            [baseVC setParam:param];
            [self.navigationController pushViewController:baseVC animated:YES];
        }
        else if ([object isKindOfClass:UIViewController.class]) {
            UIViewController *vc = (UIViewController *)object;
            vc = [vc init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
