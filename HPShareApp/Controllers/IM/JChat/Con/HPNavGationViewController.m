//
//  HPNavGationViewController.m
//  HPShareApp
//
//  Created by HP on 2019/1/22.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPNavGationViewController.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "HPImageUtil.h"

@interface HPNavGationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation HPNavGationViewController

+ (void)initialize
{
    UINavigationBar *navgationBar = [UINavigationBar appearance];
    [navgationBar setShadowImage:[UIImage new]];//设置阴影图片
    navgationBar.tintColor = [UIColor whiteColor];//设置导航条颜色
//    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
    [navgationBar setBackgroundImage:[HPImageUtil createImageWithColor:COLOR_RED_EA0000] forBarMetrics:UIBarMetricsDefault];//设置背景图片和颜色
    [navgationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_GRAY_FFFFFF}];//设置文字颜色
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate =self;//设置自身的代理方法
    self.interactivePopGestureRecognizer.delegate = self;
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated//重写push的代理方法
{
    if ([self.viewControllers count] > 0) {
        viewController.hidesBottomBarWhenPushed =YES;
    }
    [super pushViewController:viewController animated:animated];
    if ([self.viewControllers count] > 1 && !viewController.navigationItem.leftBarButtonItem) {//判断是否会根视图
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"icon_back"]forState:UIControlStateNormal];//设置返回按钮图片
        backButton.bounds =CGRectMake(0,0,12,22);
        [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

- (void)backToPageAction//设置返回按钮
{
    [self popViewControllerAnimated:YES];
}

@end
