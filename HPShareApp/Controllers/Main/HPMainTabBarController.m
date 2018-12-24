//
//  HPMainTabBarController.m
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMainTabBarController.h"
//#import "HPShareController.h"
#import "HPIdeaController.h"
#import "HPInteractiveController.h"
#import "HPMyController.h"
#import "HPReleaseModalView.h"
#import "HPOwnerCardDefineController.h"
#import "HPStartUpCardDefineController.h"
#import "HPJudgingLoginView.h"
#import "HPLoginController.h"
#import "LLShoppingViewController.h"
@interface HPMainTabBarController ()

@property (nonatomic, weak) HPReleaseModalView *releaseModalView;
@property (nonatomic, strong) HPJudgingLoginView *judgelogin;

@end

@implementation HPMainTabBarController

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

#pragma mark - SetupUI

- (void)setupUI {
    [self.tabBar setShadowImage:[UIImage new]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setBarTintColor:UIColor.whiteColor];
    [self.tabBar setBackgroundColor:UIColor.whiteColor];
    self.tabBar.tintColor = COLOR_RED_FF3C5E;
    
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = COLOR_BLACK_333333;
    }
    
    self.tabBar.layer.shadowColor = COLOR_GRAY_E6E5E5.CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBar.layer.shadowOpacity = 0.82f;
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"LLShoppingViewController" bundle:nil];
    LLShoppingViewController * shareController = sb.instantiateInitialViewController;
//    LLShoppingViewController *shareController = [[LLShoppingViewController alloc] init];
    shareController.tabBarItem.title = @"共享";
    shareController.tabBarItem.image = [UIImage imageNamed:@"share_unchecked"];
    shareController.tabBarItem.selectedImage = [UIImage imageNamed:@"share_checked"];
    [shareController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-5.f * g_rateWidth, -3.f)];
    [self addChildViewController:shareController];
    
    HPIdeaController *ideaController = [[HPIdeaController alloc] init];
    ideaController.tabBarItem.title = @"享法";
    ideaController.tabBarItem.image = [UIImage imageNamed:@"method_unchecked"];
    ideaController.tabBarItem.selectedImage = [UIImage imageNamed:@"method_checked"];
    [ideaController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-25.f * g_rateWidth, -3.f)];
    ideaController.view.backgroundColor = UIColor.whiteColor;
    [self addChildViewController:ideaController];
    
    HPInteractiveController *interactiveController = [[HPInteractiveController alloc] init];
    interactiveController.tabBarItem.title = @"互动";
    interactiveController.tabBarItem.image = [UIImage imageNamed:@"interaction_unchecked"];
    interactiveController.tabBarItem.selectedImage = [UIImage imageNamed:@"interaction_checked"];
    [interactiveController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(25.f * g_rateWidth, -3.f)];
    interactiveController.view.backgroundColor = UIColor.whiteColor;
    [self addChildViewController:interactiveController];
    
    HPMyController *myController = [[HPMyController alloc] init];
    myController.tabBarItem.title = @"我的";
    myController.tabBarItem.image = [UIImage imageNamed:@"my_unchecked"];
    myController.tabBarItem.selectedImage = [UIImage imageNamed:@"my_checked"];
    [myController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(5.f * g_rateWidth, -3.f)];
    myController.view.backgroundColor = UIColor.whiteColor;
    [self addChildViewController:myController];
    
    UIButton *plusBtn = [[UIButton alloc] init];
    [plusBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"customizing_business_cards_close_button"] forState:UIControlStateSelected];
    [plusBtn addTarget:self action:@selector(onClickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusBtn];
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop).with.offset(-6.f);
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    UIViewController *viewController = self.navigationController.topViewController;
    
    if ([viewController isMemberOfClass:HPMainTabBarController.class]) {
        return NO;
    }
    else if ([viewController isKindOfClass:HPBaseViewController.class]) {
        HPBaseViewController *baseViewController = (HPBaseViewController *)viewController;
        
        if (baseViewController.isPopGestureRecognize) {
            NSInteger count = self.navigationController.viewControllers.count;
            
            if (count < 2) {
                return NO;
            }
            
            UIViewController *lastVC = self.navigationController.viewControllers[count - 2];
            
            if ([lastVC isKindOfClass:HPBaseViewController.class]) {
                HPBaseViewController *lastBaseVC = (HPBaseViewController *)lastVC;
                lastBaseVC.isPop = YES;
            }
            
            return YES;
        }
        else
            return NO;
    }
    
    return NO;
}

#pragma mark - OnClick

/**
 点击 TabBar 中间的按钮回调。

 @param btn btn
 */
- (void)onClickPlusBtn:(UIButton *)btn {
    if (btn.isSelected) {
        [btn setSelected:NO];
        
        [_releaseModalView show:NO];
    }
    else {
        [btn setSelected:YES];
        
        if (_releaseModalView == nil) {
            HPReleaseModalView *releaseModalView = [[HPReleaseModalView alloc] initWithParent:self.view];
            _releaseModalView = releaseModalView;
            __weak UINavigationController *navigatorController = self.navigationController;
            kWeakSelf(weakSelf);
            [releaseModalView setCallBack:^(HPReleaseCardType type) {
                [btn setSelected:NO];
                UIViewController *vc;
                HPLoginModel *account = [HPUserTool account];
                if (account.token) {
                    if (type == HPReleaseCardTypeOwner) {
                        vc = [[HPOwnerCardDefineController alloc] init];
                    }
                    else if (type == HPReleaseCardTypeStartup) {
                        vc = [[HPStartUpCardDefineController alloc] init];
                    }
                    
                    [navigatorController pushViewController:vc animated:YES];
                }else{
                    HPJudgingLoginView *judgelogin = [[HPJudgingLoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    [judgelogin setConfirmCallback:^{
                        [weakSelf.navigationController pushViewController:[HPLoginController new] animated:YES];
                    }];
                    [kAppdelegateWindow addSubview:judgelogin];
                    self.judgelogin = judgelogin;
                    [judgelogin setViewTapClickCallback:^{
                        [weakSelf.judgelogin removeFromSuperview];
                    }];
                }
                
            }];
            _releaseModalView = releaseModalView;
            [self.view bringSubviewToFront:btn];
        }
        
        [_releaseModalView show:YES];
    }
}

@end
