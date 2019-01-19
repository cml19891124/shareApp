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

- (instancetype)init {
    self = [super init];
    if (self) {
        _isPopGestureRecognize = YES;
        _isPop = NO;
        _param = [NSMutableDictionary dictionary];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [statusBar setBackgroundColor:COLOR_RED_EA0000];
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
    [navigationBar setBackgroundColor:COLOR_RED_EA0000];
    [self.view addSubview:navigationBar];
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(statusBar.mas_bottom);
        make.height.mas_equalTo(44.f);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back"]];
    if (self.navigationController.childViewControllers.count) {
        backIcon.hidden = NO;
    }else{
        backIcon.hidden = YES;
    }
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
    [self setupRightBarbuttonBtn:@""];
    return navigationBar;
}

- (void)setupBackBtn{
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

- (void)setupRightBarbuttonBtn:(NSString *)text {
    UIButton *rightBarbuttonBtn = [[UIButton alloc] init];
    if (text.length > 0) {
        rightBarbuttonBtn.hidden = NO;
    }else{
        rightBarbuttonBtn.hidden = YES;

    }
    [rightBarbuttonBtn addTarget:self action:@selector(onClickRightButtonBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat textW = BoundWithSize(text, kScreenWidth, 15).size.width;
    [rightBarbuttonBtn setTitle:text forState:UIControlStateNormal];
    [rightBarbuttonBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
    rightBarbuttonBtn.titleLabel.font = kFont_Medium(15);
    rightBarbuttonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:rightBarbuttonBtn];
    
    [rightBarbuttonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight);
        make.right.equalTo(self.view).offset(getWidth(-15.f));
        make.width.mas_equalTo(textW);
        make.height.mas_equalTo(44.f);
    }];
}

- (void)setupLeftBarbuttonBtn:(NSString *)text {
    UIButton *leftBarbuttonBtn = [[UIButton alloc] init];
    [leftBarbuttonBtn setImage:ImageNamed(@"createConversation") forState:UIControlStateNormal];
    [leftBarbuttonBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(15.f), 0, getWidth(-20.f), 0)];
    if (text.length > 0) {
        leftBarbuttonBtn.hidden = NO;
    }else{
        leftBarbuttonBtn.hidden = YES;
        
    }
    [leftBarbuttonBtn addTarget:self action:@selector(onClickleftBarbuttonBtn:) forControlEvents:UIControlEventTouchUpInside];
    leftBarbuttonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:leftBarbuttonBtn];
    
    [leftBarbuttonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(g_statusBarHeight);
        make.left.equalTo(self.view).offset(getWidth(15.f));
        
    }];
    [leftBarbuttonBtn sizeToFit];
}


- (void)onClickleftBarbuttonBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickLeftButtonToHandle:)]) {
        [self.delegate clickLeftButtonToHandle:button];
    }
}

- (void)onClickRightButtonBtn
{
    if ([self.delegate respondsToSelector:@selector(clickRightButtonToHandle)]) {
        [self.delegate clickRightButtonToHandle];
    }
}
- (void)onClickBackBtn {
    [self pop];
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
            
            if (param) {
                [baseVC.param addEntriesFromDictionary:param];
            }
            
            [self.navigationController pushViewController:baseVC animated:YES];
        }
        else if ([object isKindOfClass:UIViewController.class]) {
            UIViewController *vc = (UIViewController *)object;
            vc = [vc init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)popWithParam:(NSDictionary *)param {
    NSInteger count = self.navigationController.viewControllers.count;
    
    if (count < 2) {
        return;
    }
    
    UIViewController *lastVC = self.navigationController.viewControllers[count - 2];
    
    if ([lastVC isKindOfClass:HPBaseViewController.class]) {
        HPBaseViewController *lastBaseVC = (HPBaseViewController *)lastVC;
        lastBaseVC.isPop = YES;
        
        if (param) {
            [lastBaseVC.param addEntriesFromDictionary:param];
        }
    }
    else if ([lastVC isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabBarController = (UITabBarController *)lastVC;
        
        if ([tabBarController.selectedViewController isKindOfClass:HPBaseViewController.class]) {
            HPBaseViewController *lastBaseVC = (HPBaseViewController *)tabBarController.selectedViewController;
            lastBaseVC.isPop = YES;
            
            if (param) {
                [lastBaseVC.param addEntriesFromDictionary:param];
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pop {
    [self popWithParam:nil];
}

@end
